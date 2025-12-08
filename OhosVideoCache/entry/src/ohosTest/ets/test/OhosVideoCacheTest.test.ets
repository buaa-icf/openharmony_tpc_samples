/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import {
  CacheListener,
  DiskUsage,
  FileNameGenerator,
  HeaderInjector,
  HttpProxyCacheServer,
  HttpProxyCacheServerBuilder,
  StorageUtils,
  TotalCountLruDiskUsage,
  TotalSizeLruDiskUsage
} from '@ohos/video-cache';
import GlobalProxyServer from '../../../main/ets/GlobalProxyServer';
import fs from '@ohos.file.fs';
import http from '@ohos.net.http';
import CryptoJS from '@ohos/crypto-js';
import HashMap from '@ohos.util.HashMap';
import buffer from '@ohos.buffer';
import GetRequest from '@ohos/video-cache/src/main/ets/GetRequest';

const BASE_COUNT = 1

function getExtension(url: string): string {
  let dotIndex = url.lastIndexOf('.');
  let slashIndex = url.lastIndexOf('/');
  return dotIndex != -1 && dotIndex > slashIndex && dotIndex + 2 + 4 > url.length ?
  url.substring(dotIndex + 1, url.length) : "";
}

export default function OhosVideoCacheTest() {
  let testUrl: string = 'https://www.w3school.com.cn/i/movie.mp4';
  let cacheFolder: string;
  let server: HttpProxyCacheServer;
  let context: Context;
  describe('OhosVideoCacheTest', () => {
    beforeAll(() => {
      try {
        context = GlobalProxyServer.getInstance().getContext()
        cacheFolder = StorageUtils.getIndividualCacheDirectory(context)
        if (fs.accessSync(cacheFolder)) {
          fs.rmdirSync(cacheFolder);
        }
        fs.mkdirSync(cacheFolder);
      } catch (err) {
      }
      try {
        server = new HttpProxyCacheServerBuilder(context).build();
      } catch (err) {
      }

    })
    beforeEach(() => {
      try {
        let files = fs.listFileSync(cacheFolder)
        for (let i = 0; i < files.length; i++) {
          let allPath = cacheFolder + '/' + files[i];
          if (fs.statSync(allPath).isDirectory()) {
            fs.rmdirSync(allPath);
          } else {
            fs.unlinkSync(allPath);
          }
        }
      } catch (err) {
      }
    })
    afterEach(() => {

    })
    afterAll(() => {

    })
    it('getProxyUrl', 0, async () => {
      let expectUrl = `http://127.0.0.1:${server.getProxyPort()}/${testUrl}`
      let proxyUrl = await server.getProxyUrl(testUrl);
      expect(expectUrl).assertEqual(proxyUrl);
    })
    it('registerCacheListener', 0, async () => {
      let client = http.createHttp();
      try {
        class TestListener implements CacheListener {
          onCacheAvailable(cacheFilePath: string, url: string, percentsAvailable: number) {
            expect(1).assertEqual(1);
          }
        }

        let listener: TestListener = new TestListener();
        server.registerCacheListener(listener, testUrl);
        let proxyUrl = await server.getProxyUrl(testUrl);
        let header: http.HttpRequestOptions = {
          method: http.RequestMethod.GET,
          header: {
            "Content-Type": 'application/json',
            "Connection": 'Keep-Alive',
            "Range": 'bytes=0-'
          },
          connectTimeout: 10000,
          readTimeout: 0,
          usingProtocol: http.HttpProtocol.HTTP1_1
        }
        client.requestInStream(proxyUrl, header)
      } catch (err) {
        expect(1).assertEqual(2);
      }
    })
    it('cacheDirectory', 0, async () => {
      let client = http.createHttp();
      try {
        let directory = context?.cacheDir + "/hahaha"
        let server = new HttpProxyCacheServerBuilder(context)
          .cacheDirectory(directory ? directory : '')
          .build()
        let cacheRoot = server.getConfig()?.cacheRoot ? server.getConfig()?.cacheRoot : ""
        expect(cacheRoot).assertEqual(context?.cacheDir + "/hahaha")
        let proxyUrl = await server.getProxyUrl(testUrl) ? await server.getProxyUrl(testUrl) : testUrl;
        let header: http.HttpRequestOptions = {
          method: http.RequestMethod.GET,
          header: {
            "Content-Type": 'application/json',
            "Connection": 'Keep-Alive',
            "Range": 'bytes=0-'
          },
          connectTimeout: 10000,
          readTimeout: 0,
          usingProtocol: http.HttpProtocol.HTTP1_1
        }
        client.requestInStream(proxyUrl, header).then(() => {
          let extension = getExtension(testUrl)
          let name: string = CryptoJS.MD5(testUrl).toString();
          let filePath: string = directory + '/' + name + "." + extension;
          if (fs.accessSync(filePath)) {
            expect(1).assertEqual(1)
          } else {
            expect(1).assertEqual(2)
          }

        }).catch((err: Error) => {
          expect(1).assertEqual(2)
        })
      } catch (err) {
        expect(1).assertEqual(2);
      } finally {
      }
    })

    it('setFileNameGenerator', 0, async () => {
      let client = http.createHttp();
      try {
        class MyFileNameGenerator implements FileNameGenerator {
          generate(url: string): string {
            return '123456.mp4'
          }
        }

        let server = new HttpProxyCacheServerBuilder(context)
          .setFileNameGenerator(new MyFileNameGenerator())
          .build()
        let fileNameGenerator = server.getConfig()?.fileNameGenerator;
        expect(fileNameGenerator instanceof MyFileNameGenerator).assertTrue();
        let proxyUrl = await server.getProxyUrl(testUrl) ? await server.getProxyUrl(testUrl) : testUrl;
        let header: http.HttpRequestOptions = {
          method: http.RequestMethod.GET,
          header: {
            "Content-Type": 'application/json',
            "Connection": 'Keep-Alive',
            "Range": 'bytes=0-'
          },
          connectTimeout: 10000,
          readTimeout: 0,
          usingProtocol: http.HttpProtocol.HTTP1_1
        }
        client.requestInStream(proxyUrl, header)
        let filePath: string = cacheFolder + "/123456.mp4";
        if (fs.accessSync(filePath)) {
          expect(1).assertEqual(1)
        } else {
          expect(1).assertEqual(1)
        }
      } catch (err) {
        expect(1).assertEqual(2);
      }
    })

    it('maxCacheSize', 0, async () => {
      try {
        let server = new HttpProxyCacheServerBuilder(context)
          .maxCacheSize(50 * 1024 * 1024)
          .build()
        let diskUsage = server?.getConfig()?.diskUsage
        expect(diskUsage instanceof TotalSizeLruDiskUsage).assertTrue();
        expect((diskUsage as TotalSizeLruDiskUsage).maxSize).assertEqual(50 * 1024 * 1024);
      } catch (err) {
        expect(1).assertEqual(2);
      }
    })
    it('maxCacheFilesCount', 0, async () => {
      try {
        let server = new HttpProxyCacheServerBuilder(context)
          .maxCacheFilesCount(10)
          .build()
        let diskUsage = server?.getConfig()?.diskUsage
        expect(diskUsage instanceof TotalCountLruDiskUsage).assertTrue();
        expect((diskUsage as TotalCountLruDiskUsage).maxCount).assertEqual(10);
      } catch (err) {
        expect(1).assertEqual(2);
      }
    })
    it('setDiskUsage', 0, async () => {
      try {
        class MyDiskUsage implements DiskUsage {
          touch(filePath: string) {
          }
        }

        let server = new HttpProxyCacheServerBuilder(context)
          .setDiskUsage(new MyDiskUsage())
          .build()
        let diskUsage = server?.getConfig()?.diskUsage
        expect(diskUsage instanceof MyDiskUsage).assertTrue();
      } catch (err) {
        expect(1).assertEqual(2);
      }
    })
    it('setHeaderInjector', 0, async () => {
      try {
        class MyHeaderInjector implements HeaderInjector {
          addHeaders(url: string): HashMap<string, string> {
            let header = new HashMap<string, string>()
            header.set("name", "abc")
            header.set("sex", "男")
            return header;
          }
        }

        let server = new HttpProxyCacheServerBuilder(context)
          .setHeaderInjector(new MyHeaderInjector())
          .build()
        let headerInjector = server?.getConfig()?.headerInjector
        expect(headerInjector instanceof MyHeaderInjector).assertTrue();
        let result = (headerInjector as MyHeaderInjector).addHeaders(testUrl)
        expect(result.get('name')).assertEqual("abc");
        expect(result.get('sex')).assertEqual("男");
      } catch (err) {
        expect(1).assertEqual(2);
      }
    })
    it('build', 0, async () => {
      try {
        let server = new HttpProxyCacheServerBuilder(context)
          .build()
        expect(server instanceof HttpProxyCacheServer).assertTrue();
        expect(server instanceof HttpProxyCacheServerBuilder).assertFalse();
      } catch (err) {
        expect(1).assertEqual(2);
      }
    })
    it('unregisterCacheListener', 0, async () => {
      let client = http.createHttp();
      try {
        let isUnRegisterSuccess: boolean = true;
        let isRequestSuccess: boolean = true;

        class UnRegisterListener implements CacheListener {
          onCacheAvailable(cacheFilePath: string, url: string, percentsAvailable: number) {
            isUnRegisterSuccess = false;
          }
        }

        let listener: UnRegisterListener = new UnRegisterListener();
        server.registerCacheListener(listener, testUrl);
        server.unregisterCacheListener(listener, testUrl);
        let proxyUrl = await server.getProxyUrl(testUrl);
        let header: http.HttpRequestOptions = {
          method: http.RequestMethod.GET,
          header: {
            "Content-Type": 'application/json',
            "Connection": 'Keep-Alive',
            "Range": 'bytes=0-'
          },
          connectTimeout: 10000,
          readTimeout: 0,
          usingProtocol: http.HttpProtocol.HTTP1_1
        }
        client.once("headersReceive", (headers: Object) => {
          isRequestSuccess = true;
        })
        client.on("dataReceive", (headers: Object) => {
          isRequestSuccess = true;
        })

        client.requestInStream(proxyUrl, header).then((respondCode: number) => {
          if (isUnRegisterSuccess && isRequestSuccess) {
            expect(1).assertEqual(1);
          } else {
            expect(1).assertEqual(2);
          }
        }).catch((err: Error) => {
          expect(1).assertEqual(2);
        })
      } catch (err) {
        expect(1).assertEqual(2);
      } finally {
      }
    })
    it('shutdown', 0, async () => {
      let client = http.createHttp();
      try {
        let proxyUrl =
          await server.getProxyUrl('http://1251017968.vod2.myqcloud.com/3eb04eefvodtransgzp1251017968/8782b1285285890810009576163/v.f30.mp4');
        server?.shutdown();
        let header: http.HttpRequestOptions = {
          method: http.RequestMethod.GET,
          header: {
            "Content-Type": 'application/json',
            "Connection": 'Keep-Alive',
            "Range": 'bytes=0-'
          },
          connectTimeout: 10000,
          readTimeout: 6000,
          usingProtocol: http.HttpProtocol.HTTP1_1
        }

        client.requestInStream(proxyUrl, header).then(() => {
          expect(1).assertEqual(2)
        }).catch((err: Error) => {
          expect(1).assertEqual(1)
        })

      } catch (err) {
        expect(1).assertEqual(2);
      }
    })

    // GetRequest 测试用例
    describe('GetRequestTest', () => {
      it('parseGETRequest', 0, () => {
        try {
          let requestStr = "GET /test%20url HTTP/1.1\r\nHost: example.com\r\nRange: bytes=1024-\r\n\r\n";
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          
          expect(request.method).assertEqual("GET");
          expect(request.uri).assertEqual("test%20url");
          expect(request.rangeOffset).assertEqual(1024);
          expect(request.partial).assertTrue();
        } catch (err) {
          expect(1).assertEqual(2);
        }
      })

      it('parseHEADRequest', 0, () => {
        try {
          let requestStr = "HEAD /test%20url HTTP/1.1\r\nHost: example.com\r\nRange: bytes=2048-\r\n\r\n";
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          
          expect(request.method).assertEqual("HEAD");
          expect(request.uri).assertEqual("test%20url");
          expect(request.rangeOffset).assertEqual(2048);
          expect(request.partial).assertTrue();
        } catch (err) {
          expect(1).assertEqual(2);
        }
      })

      it('parseGETRequestWithoutRange', 0, () => {
        try {
          let requestStr = "GET /test%20url HTTP/1.1\r\nHost: example.com\r\n\r\n";
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          
          expect(request.method).assertEqual("GET");
          expect(request.uri).assertEqual("test%20url");
          expect(request.rangeOffset).assertEqual(0);
          expect(request.partial).assertFalse();
        } catch (err) {
          expect(1).assertEqual(2);
        }
      })

      it('parseHEADRequestWithoutRange', 0, () => {
        try {
          let requestStr = "HEAD /test%20url HTTP/1.1\r\nHost: example.com\r\n\r\n";
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          
          expect(request.method).assertEqual("HEAD");
          expect(request.uri).assertEqual("test%20url");
          expect(request.rangeOffset).assertEqual(0);
          expect(request.partial).assertFalse();
        } catch (err) {
          expect(1).assertEqual(2);
        }
      })

      it('parseGETRequestWithComplexUrl', 0, () => {
        try {
          let encodedUrl = "https://example.com/video.mp4";
          let requestStr = `GET /${encodedUrl} HTTP/1.1\r\nHost: 127.0.0.1\r\nRange: bytes=512-\r\n\r\n`;
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          
          expect(request.method).assertEqual("GET");
          expect(request.uri).assertEqual(encodedUrl);
          expect(request.rangeOffset).assertEqual(512);
          expect(request.partial).assertTrue();
        } catch (err) {
          expect(1).assertEqual(2);
        }
      })

      it('parseHEADRequestWithComplexUrl', 0, () => {
        try {
          let encodedUrl = "https://example.com/video.mp4";
          let requestStr = `HEAD /${encodedUrl} HTTP/1.1\r\nHost: 127.0.0.1\r\nRange: bytes=1024-\r\n\r\n`;
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          
          expect(request.method).assertEqual("HEAD");
          expect(request.uri).assertEqual(encodedUrl);
          expect(request.rangeOffset).assertEqual(1024);
          expect(request.partial).assertTrue();
        } catch (err) {
          expect(1).assertEqual(2);
        }
      })

      it('parseGETRequestWithRangeHeaderCaseInsensitive', 0, () => {
        try {
          let requestStr = "GET /test%20url HTTP/1.1\r\nHost: example.com\r\nrange: bytes=256-\r\n\r\n";
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          
          expect(request.method).assertEqual("GET");
          expect(request.uri).assertEqual("test%20url");
          expect(request.rangeOffset).assertEqual(256);
          expect(request.partial).assertTrue();
        } catch (err) {
          expect(1).assertEqual(2);
        }
      })

      it('parseHEADRequestWithRangeHeaderCaseInsensitive', 0, () => {
        try {
          let requestStr = "HEAD /test%20url HTTP/1.1\r\nHost: example.com\r\nRANGE: bytes=512-\r\n\r\n";
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          
          expect(request.method).assertEqual("HEAD");
          expect(request.uri).assertEqual("test%20url");
          expect(request.rangeOffset).assertEqual(512);
          expect(request.partial).assertTrue();
        } catch (err) {
          expect(1).assertEqual(2);
        }
      })

      it('parseGETRequestWithZeroRange', 0, () => {
        try {
          let requestStr = "GET /test%20url HTTP/1.1\r\nHost: example.com\r\nRange: bytes=0-\r\n\r\n";
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          
          expect(request.method).assertEqual("GET");
          expect(request.uri).assertEqual("test%20url");
          expect(request.rangeOffset).assertEqual(0);
          expect(request.partial).assertTrue();
        } catch (err) {
          expect(1).assertEqual(2);
        }
      })

      it('parseHEADRequestWithZeroRange', 0, () => {
        try {
          let requestStr = "HEAD /test%20url HTTP/1.1\r\nHost: example.com\r\nRange: bytes=0-\r\n\r\n";
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          
          expect(request.method).assertEqual("HEAD");
          expect(request.uri).assertEqual("test%20url");
          expect(request.rangeOffset).assertEqual(0);
          expect(request.partial).assertTrue();
        } catch (err) {
          expect(1).assertEqual(2);
        }
      })

      it('parseInvalidRequestThrowsError', 0, () => {
        try {
          let requestStr = "POST /test%20url HTTP/1.1\r\nHost: example.com\r\n\r\n";
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          // 如果到达这里，说明没有抛出异常，测试失败
          expect(1).assertEqual(2);
        } catch (err) {
          // 期望抛出异常
          expect(1).assertEqual(1);
        }
      })

      it('parseMalformedRequestThrowsError', 0, () => {
        try {
          let requestStr = "INVALID REQUEST\r\n\r\n";
          let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
          let request = GetRequest.read(requestBuffer);
          // 如果到达这里，说明没有抛出异常，测试失败
          expect(1).assertEqual(2);
        } catch (err) {
          // 期望抛出异常
          expect(1).assertEqual(1);
        }
      })
    })
  })
}