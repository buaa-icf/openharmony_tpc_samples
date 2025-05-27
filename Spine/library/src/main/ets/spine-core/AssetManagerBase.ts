/******************************************************************************
 * Spine Runtimes License Agreement
 * Last updated July 28, 2023. Replaces all prior versions.
 *
 * Copyright (c) 2013-2023, Esoteric Software LLC
 *
 * Integration of the Spine Runtimes into software or otherwise creating
 * derivative works of the Spine Runtimes is permitted under the terms and
 * conditions of Section 2 of the Spine Editor License Agreement:
 * http://esotericsoftware.com/spine-editor-license
 *
 * Otherwise, it is permitted to integrate the Spine Runtimes into software or
 * otherwise create derivative works of the Spine Runtimes (collectively,
 * "Products"), provided that each user of the Products must obtain their own
 * Spine Editor license and redistribution of the Products in any form must
 * include this license and copyright notice.
 *
 * THE SPINE RUNTIMES ARE PROVIDED BY ESOTERIC SOFTWARE LLC "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL ESOTERIC SOFTWARE LLC BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES,
 * BUSINESS INTERRUPTION, OR LOSS OF USE, DATA, OR PROFITS) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THE
 * SPINE RUNTIMES, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************/

import { Texture } from "./Texture";
import { TextureAtlas } from "./TextureAtlas";
import { Disposable, StringMap, LogUtil } from "./Utils";
import image from '@ohos.multimedia.image';
import util from '@ohos.util';
import http from '@ohos.net.http';
import fs from '@ohos.file.fs';

export class AssetManagerBase implements Disposable {
	private pathPrefix: string = "";
	private textureLoader: (image: image.PixelMap) => Texture;
	private downloader: Downloader;
	private assets: StringMap<any> = {};
	private errors: StringMap<string> = {};
	private toLoad = 0;
	private loaded = 0;

	constructor (textureLoader: (image: image.PixelMap) => Texture, pathPrefix: string = "", downloader: Downloader = new Downloader()) {
		this.textureLoader = textureLoader;
		this.pathPrefix = pathPrefix;
		this.downloader = downloader;
	}

	private start (path: string): string {
		this.toLoad++;
		return this.pathPrefix + path;
	}

	private success (callback: (path: string, data: any) => void, path: string, asset: any) {
		this.toLoad--;
		this.loaded++;
		this.assets[path] = asset;
		if (callback) callback(path, asset);
	}

	private error (callback: (path: string, message: string) => void, path: string, message: string) {
		this.toLoad--;
		this.loaded++;
		this.errors[path] = message;
		if (callback) callback(path, message);
	}

	loadAll () {
		let promise = new Promise((resolve: (assetManager: AssetManagerBase) => void, reject: (errors: StringMap<string>) => void) => {
			let check = () => {
				if (this.isLoadingComplete()) {
					resolve(this);
				}else{
					setTimeout(check,20);
				}
			};
			check();
		});
		return promise;
	}

	setRawDataURI (path: string, data: string) {
		this.downloader.rawDataUris[this.pathPrefix + path] = data;
	}

	loadBinary (path: string,
		success: (path: string, binary: Uint8Array) => void = () => { },
		error: (path: string, message: string) => void = () => { }) {
		path = this.start(path);

		this.downloader.downloadBinary(path, (data: Uint8Array): void => {
			this.success(success, path, data);
		}, (status: number, responseText: string): void => {
			this.error(error, path, `Couldn't load binary ${path}: status ${status}, ${responseText}`);
		});
	}

	loadText (path: string,
		success: (path: string, text: string) => void = () => { },
		error: (path: string, message: string) => void = () => { }) {
		path = this.start(path);

		this.downloader.downloadText(path, (data: string): void => {
			this.success(success, path, data);
		}, (status: number, responseText: string): void => {
			this.error(error, path, `Couldn't load text ${path}: status ${status}, ${responseText}`);
		});
	}

	loadJson (path: string,
		success: (path: string, object: object) => void = () => { },
		error: (path: string, message: string) => void = () => { }) {
		path = this.start(path);

		this.downloader.downloadJson(path, (data: object): void => {
			this.success(success, path, data);
		}, (status: number, responseText: string): void => {
			this.error(error, path, `Couldn't load JSON ${path}: status ${status}, ${responseText}`);
		});
	}

	loadTexture (path: string,
		success: (path: string, texture: Texture) => void = () => { },
		error: (path: string, message: string) => void = () => { }) {
		path = this.start(path);

		if (path.startsWith('http')) {
			let httpRequest = http.createHttp();
			let jsonData: Array<ArrayBuffer> = new Array();
			httpRequest.on("dataReceive", (data) => {
				jsonData.push(data);
			});
			let promise = httpRequest.requestInStream(path, {
				method: http.RequestMethod.GET,
				expectDataType: http.HttpDataType.ARRAY_BUFFER,
				connectTimeout: 60000,
				readTimeout: 60000,
			});

			promise.then(async (data) => {
				if (data == 200 || data == 206 || data == 204) {
					let resBuf = combineArrayBuffers(jsonData)
					let image_source = image.createImageSource(resBuf);
					//piexlmap改成不可编辑状态，优化图形图像端读取速度
					let opts = {
						editable: false,
						desiredPixelFormat: image.PixelMapFormat.RGBA_8888
					};
					//创建pixel_map
					let pixel_map = image_source?.createPixelMapSync(opts);
					this.success(success, path, this.textureLoader(pixel_map));
				} else { //todo
					this.error(error, path, `Couldn't load image: ${path}`);
				}
				httpRequest.off('dataReceive');
				httpRequest.destroy();
			}).catch((err) => {
				httpRequest.off('dataReceive');
				httpRequest.destroy();
				this.error(error, path, `Couldn't load image: ${path}`);
			});

		} else {
			try {
				let filePath = getContext()?.filesDir + '/' + path;
				let isExist = fs.accessSync(filePath); //判断图片资源是否存在
				if (isExist) {
					let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
					let stat = fs.statSync(filePath);
					let arrayBuffer = new ArrayBuffer(stat.size);
					fs.readSync(file.fd, arrayBuffer);
					let image_source = image.createImageSource(arrayBuffer);
					//piexlmap改成不可编辑状态，优化图形图像端读取速度
					let opts = {
						editable: false,
						desiredPixelFormat: image.PixelMapFormat.RGBA_8888
					};
					//创建pixel_map
					let pixel_map = image_source?.createPixelMapSync(opts);
					this.success(success, path, this.textureLoader(pixel_map));
					fs.close(file);
				} else {
					try {
						let data = getContext()?.resourceManager.getRawFileContentSync(path);
						let image_source = image.createImageSource(data.buffer);
						//piexlmap改成不可编辑状态，优化图形图像端读取速度
						let opts = {
							editable: false,
							desiredPixelFormat: image.PixelMapFormat.RGBA_8888
						};
						//创建pixel_map
						let pixel_map = image_source?.createPixelMapSync(opts);
						this.success(success, path, this.textureLoader(pixel_map));
					} catch (e) {
						this.error(error, path, `Couldn't load image: ${path}`);
					}
				}
			} catch (err) {
				LogUtil.error(`Couldn't load image: ${path}`);
			}
		}
	}

	loadTextureAtlas (path: string,
		success: (path: string, atlas: TextureAtlas) => void = () => { },
		error: (path: string, message: string) => void = () => { },
		fileAlias?: { [keyword: string]: string }
	) {
		let index = path.lastIndexOf("/");
		let parent = index >= 0 ? path.substring(0, index + 1) : "";
		path = this.start(path);

		this.downloader.downloadText(path, (atlasText: string): void => {
			try {
				let atlas = new TextureAtlas(atlasText);
				let toLoad = atlas.pages.length, abort = false;
				for (let page of atlas.pages) {
					this.loadTexture(!fileAlias ? parent + page.name : fileAlias[page.name!],
						(imagePath: string, texture: Texture) => {
							if (!abort) {
								page.setTexture(texture);
								if (--toLoad == 0) this.success(success, path, atlas);
							}
						},
						(imagePath: string, message: string) => {
							if (!abort) this.error(error, path, `Couldn't load texture atlas ${path} page image: ${imagePath}`);
							abort = true;
						}
					);
				}
			} catch (e) {
				this.error(error, path, `Couldn't parse texture atlas ${path}: ${(e as any).message}`);
			}
		}, (status: number, responseText: string): void => {
			this.error(error, path, `Couldn't load texture atlas ${path}: status ${status}, ${responseText}`);
		});
	}

	get (path: string) {
		return this.assets[this.pathPrefix + path];
	}

	require (path: string) {
		path = this.pathPrefix + path;
		let asset = this.assets[path];
		if (asset) return asset;
		let error = this.errors[path];
		throw Error("Asset not found: " + path + (error ? "\n" + error : ""));
	}

	remove (path: string) {
		path = this.pathPrefix + path;
		let asset = this.assets[path];
		if ((<any>asset).dispose) (<any>asset).dispose();
		delete this.assets[path];
		return asset;
	}

	removeAll () {
		for (let key in this.assets) {
			let asset = this.assets[key];
			if ((<any>asset).dispose) (<any>asset).dispose();
		}
		this.assets = {};
	}

	isLoadingComplete (): boolean {
		return this.toLoad == 0;
	}

	getToLoad (): number {
		return this.toLoad;
	}

	getLoaded (): number {
		return this.loaded;
	}

	dispose () {
		this.removeAll();
	}

	hasErrors () {
		return Object.keys(this.errors).length > 0;
	}

	getErrors () {
		return this.errors;
	}
}

export class Downloader {
	private callbacks: StringMap<Array<Function>> = {};
	rawDataUris: StringMap<string> = {};

	dataUriToString (dataUri: string) {
		if (!dataUri.startsWith("data:")) {
			LogUtil.error('Downloader  Not a data URI.');
			return;
		}

		let base64Idx = dataUri.indexOf("base64,");
		if (base64Idx != -1) {
			base64Idx += "base64,".length;
			return base64Idx;
		} else {
			return dataUri.substr(dataUri.indexOf(",") + 1);
		}
	}

	base64ToUint8Array (base64: string) {
		var binary_string = base64;
		// var binary_string = window.atob(base64);
		var len = binary_string.length;
		var bytes = new Uint8Array(len);
		for (var i = 0; i < len; i++) {
			bytes[i] = binary_string.charCodeAt(i);
		}
		return bytes;
	}

	dataUriToUint8Array (dataUri: string) {
		if (!dataUri.startsWith("data:")) {
			LogUtil.error('Downloader  Not a data URI.');
			return;
		}

		let base64Idx = dataUri.indexOf("base64,");
		if (base64Idx == -1){
			LogUtil.error('Downloader  Not a binary data URI.');
			return;

		}
		base64Idx += "base64,".length;
		return this.base64ToUint8Array(dataUri.substr(base64Idx));
	}

	downloadText (url: string, success: (data: string) => void, error: (status: number, responseText: string) => void) {
		if (this.start(url, success, error)) return;
		if (this.rawDataUris[url]) {
			try {
				let dataUri = this.rawDataUris[url];
				this.finish(url, 200, this.dataUriToString(dataUri));
			} catch (e) {
				this.finish(url, 400, JSON.stringify(e));
			}
			return;
		}
		if(url.startsWith('http')){
			let httpRequest = http.createHttp();
			let jsonData: Array<ArrayBuffer> = new Array();
			httpRequest.on("dataReceive", (data) => {
				jsonData.push(data);
			});
			let promise = httpRequest.requestInStream(url, {
				method: http.RequestMethod.GET,
				expectDataType: http.HttpDataType.ARRAY_BUFFER,
				connectTimeout: 60000,
				readTimeout: 60000,
			});

			promise.then(async (data) => {
				if (data == 200 || data == 206 || data == 204) {
					let resStr = util.TextDecoder.create('utf-8',{ignoreBOM: true});
					let resBuf = combineArrayBuffers(jsonData)
					let fileStr = resStr.decodeToString(new Uint8Array(resBuf));
					this.finish(url, 200, fileStr);
				} else { //todo
					this.finish(url, 400, `Couldn't load file: ${url}`);
				}
				httpRequest.off('dataReceive');
				httpRequest.destroy();
			}).catch((err) => {
				httpRequest.off('dataReceive');
				httpRequest.destroy();
				this.finish(url, 400, `Couldn't load file: ${url}`);
			});
		} else {
			try {
				let filePath = getContext()?.filesDir + '/' + url;
				let isExist = fs.accessSync(filePath); //判断资源是否存在
				if (isExist) {
					let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
					let stat = fs.statSync(filePath);
					let arrayBuffer = new ArrayBuffer(stat.size);
					fs.readSync(file.fd, arrayBuffer);
					let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true });
					let fileStr = resStr.decodeToString(new Uint8Array(arrayBuffer));
					this.finish(url, 200, fileStr);
					fs.close(file);
				} else {
					try {
						let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true });
						let datas = getContext()?.resourceManager.getRawFileContentSync(url);
						let fileStr = resStr.decodeToString(new Uint8Array(datas.buffer));
						this.finish(url, 200, fileStr);
					} catch (e) {
						this.finish(url, 400, JSON.stringify(e));
					}
				}
			} catch (err) {
				this.finish(url, 400, JSON.stringify(err));
			}
		}
	}

	downloadJson (url: string, success: (data: object) => void, error: (status: number, responseText: string) => void) {
		this.downloadText(url, (data: string): void => {
			success(JSON.parse(data));
		}, error);
	}

	downloadBinary (url: string, success: (data: Uint8Array) => void, error: (status: number, responseText: string) => void) {
		if (this.start(url, success, error)) return;
		if (this.rawDataUris[url]) {
			try {
				let dataUri = this.rawDataUris[url];
				this.finish(url, 200, this.dataUriToUint8Array(dataUri));
			} catch (e) {
				this.finish(url, 400, JSON.stringify(e));
			}
			return;
		}

		if(url.startsWith('http')){
			let httpRequest = http.createHttp();
			let jsonData: Array<ArrayBuffer> = new Array();
			httpRequest.on("dataReceive", (data) => {
				jsonData.push(data);
			});
			let promise = httpRequest.requestInStream(url, {
				method: http.RequestMethod.GET,
				expectDataType: http.HttpDataType.ARRAY_BUFFER,
				connectTimeout: 60000,
				readTimeout: 60000,
			});

			promise.then(async (data) => {
				if (data == 200 || data == 206 || data == 204) {
					let resBuf = combineArrayBuffers(jsonData)
					this.finish(url, 200, new Uint8Array(resBuf));
				} else { //todo
					this.finish(url, 400, `Couldn't load file: ${url}`);
				}
				httpRequest.off('dataReceive');
				httpRequest.destroy();
			}).catch((err) => {
				httpRequest.off('dataReceive');
				httpRequest.destroy();
				this.finish(url, 400, `Couldn't load file: ${url}`);
			});
		} else {
			try {
				let filePath = getContext()?.filesDir + '/' + url;
				let isExist = fs.accessSync(filePath); //判断资源是否存在
				if (isExist) {
					let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
					let stat = fs.statSync(filePath);
					let arrayBuffer = new ArrayBuffer(stat.size);
					fs.readSync(file.fd, arrayBuffer);
					this.finish(url, 200, new Uint8Array(arrayBuffer));
					fs.close(file);
				} else {
					try {
						let datas = getContext()?.resourceManager.getRawFileContentSync(url);
						this.finish(url, 200, new Uint8Array(datas.buffer));
					} catch (e) {
						this.finish(url, 400, `Couldn't load file: ${url}`);
					}
				}
			} catch (err) {
				this.finish(url, 400, `Couldn't load file: ${url}`);
			}
		}
	}

	private start (url: string, success: any, error: any) {
		let callbacks = this.callbacks[url];
		try {
			if (callbacks) return true;
			this.callbacks[url] = callbacks = [];
		} finally {
			callbacks.push(success, error);
		}
	}

	private finish (url: string, status: number, data: any) {
		let callbacks = this.callbacks[url];
		delete this.callbacks[url];
		let args = status == 200 || status == 0 ? [data] : [status, data];
		for (let i = args.length - 1, n = callbacks.length; i < n; i += 2)
			callbacks[i].apply(null, args);
	}
}
export function combineArrayBuffers(arrayBuffers: ArrayBuffer[]): ArrayBuffer {
	// 计算多个ArrayBuffer的总字节大小
	let totalByteLength = 0;
	for (const arrayBuffer of arrayBuffers) {
		totalByteLength += arrayBuffer.byteLength;
	}
	// 创建一个新的ArrayBuffer
	const combinedArrayBuffer = new ArrayBuffer(totalByteLength);
	// 创建一个Uint8Array来操作新的ArrayBuffer
	const combinedUint8Array = new Uint8Array(combinedArrayBuffer);
	// 依次复制每个ArrayBuffer的内容到新的ArrayBuffer中
	let offset = 0;
	for (const arrayBuffer of arrayBuffers) {
		const sourceUint8Array = new Uint8Array(arrayBuffer);
		combinedUint8Array.set(sourceUint8Array, offset);
		offset += sourceUint8Array.length;
	}
	return combinedArrayBuffer;
}


