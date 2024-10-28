/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import Cookie from './Cookie';
import type { ServerResponse } from '../response/ServerResponse';

const NUM_TWO: number = 2;
const DEFAULT_EXPIRE: number = -30;

/**
 * 提供对Cookie的基本支持。不支持'path'、'secure'和'httpOnly'。随意改进它和/或添加不支持的功能。
 */
export default class CookieHandler {
	private cookies: Map<string, string> = new Map<string, string>();
	private queue: Array<Cookie> = new Array<Cookie>();

	/**
	 * httpHeaders：请求头中Cookie信息
	 * */
	constructor(httpHeaders: Record<string, string>) {
		const { cookie: raw } = httpHeaders;
		if (Boolean(raw)) {
			const tokens: string[] = raw.split(';');
			for (const item of tokens) {
				const data: string[] = item.trim().split('=');
				if (data.length === NUM_TWO) {
					const [key, value] = data;
					this.cookies.set(key, value);
				}
			}
		}
	}

	/**
	 * 设置一个cookie的过期日期从一个月前，有效地删除它在客户端
	 * 
	 * @param name cookie的名字.
	 */
	public delete(name: string): void {
		this.set(name, '-delete', DEFAULT_EXPIRE);
	}

	/**
	 * 从HTTP Headers中读取cookie
	 *
	 * @param name cookie的名字
	 * @return Cookie的值（如果存在），否则为null
	 */
	public read(name: string): string | undefined {
		return this.cookies.get(name);
	}

	/**
	 * 设置一个cookie.
	 *
	 * @param name cookie的名字.
	 * @param value cookie的值.
	 * @param expires cookie过期前的天数
	 */
	public set(name: string | Cookie, value?: string, expires?: number): void {
		if (typeof name === 'string') {
			this.queue.push(new Cookie(name, value, expires));
		} else {
			this.queue.push(name);
		}
	}

	/**
	 * 在内部由Web服务器使用，用于将所有排队的cookie添加到响应的HTTP标头中。
	 *
	 * @param response 队列中的Cookie将添加到的标头的Response对象.
	 */
	public unloadQueue(response: ServerResponse): void {
		for (const cookie of this.queue) {
			response.addCookieHeader(cookie.getHTTPHeader());
		}
	}
}