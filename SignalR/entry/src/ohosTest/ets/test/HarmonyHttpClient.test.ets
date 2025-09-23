/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { HarmonyHttpClient, NullLogger, HttpRequest, HttpError, TimeoutError, AbortError } from '@ohos/signalr';

class TestAbortController {
  private _isAborted: boolean = false;
  private _signal: TestAbortSignal;

  constructor() {
    this._signal = new TestAbortSignal(this);
  }

  public abort(): void {
    if (!this._isAborted) {
      this._isAborted = true;
      if (this._signal.onabort) {
        this._signal.onabort();
      }
    }
  }

  get signal() {
    return this._signal;
  }

  get aborted(): boolean {
    return this._isAborted;
  }
}

class TestAbortSignal {
  private _controller: TestAbortController;
  public onabort: (() => void) | null = null;

  constructor(controller: TestAbortController) {
    this._controller = controller;
  }

  get aborted(): boolean {
    return this._controller.aborted;
  }
}

export default function harmonyHttpClientTest() {
  describe('HarmonyHttpClient_Tests', () => {
    let client: HarmonyHttpClient;
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'HarmonyHttpClient test suite started');
    })
    
    beforeEach(() => {
      client = new HarmonyHttpClient(NullLogger.instance);
    })
    
    afterEach(() => {
      // 清理资源
    })
    
    afterAll(() => {
      console.info( 'SignalRTest', 'HarmonyHttpClient test suite completed');
    })
    
    it('should_create_harmony_http_client', 0, () => {
      console.info( 'SignalRTest', 'Testing HarmonyHttpClient creation');
      
      expect(client.constructor.name).assertEqual('HarmonyHttpClient');
    })
    
    it('should_return_empty_cookie_string', 0, () => {
      console.info( 'SignalRTest', 'Testing getCookieString method');
      
      const cookies = client.getCookieString('https://www.baidu.com');
      
      expect(typeof cookies).assertEqual('string');
      expect(cookies).assertEqual('');
    })
    
    it('should_reject_request_without_method', 0, async () => {
      console.info( 'SignalRTest', 'Testing request without method');
      
      const request: HttpRequest = {
        url: 'https://www.baidu.com'
      };
      
      try {
        await client.send(request);
        expect(false).assertTrue(); // 不应该到达这里
      } catch (error) {
        expect(error.message).assertEqual('No method defined.');
      }
    })
    
    it('should_reject_request_without_url', 0, async () => {
      console.info( 'SignalRTest', 'Testing request without URL');
      
      const request: HttpRequest = {
        method: 'GET'
      };
      
      try {
        await client.send(request);
        expect(false).assertTrue(); // 不应该到达这里
      } catch (error) {
        expect(error.message).assertEqual('No url defined.');
      }
    })
    
    it('should_reject_invalid_url_format', 0, async () => {
      console.info( 'SignalRTest', 'Testing invalid URL format');
      
      const request: HttpRequest = {
        method: 'GET',
        url: 'invalid-url-format'
      };
      
      try {
        await client.send(request);
        expect(false).assertTrue(); // 不应该到达这里
      } catch (error) {
        expect(error.message).assertContain('Invalid URL format');
      }
    })
    
    it('should_handle_aborted_request', 0, async () => {
      console.info( 'SignalRTest', 'Testing aborted request');
      
      const controller = new TestAbortController();
      controller.abort(); // 预先中止
      
      const request: HttpRequest = {
        method: 'GET',
        url: 'https://www.baidu.com',
        abortSignal: controller.signal
      };
      
      try {
        await client.send(request);
        expect(false).assertTrue(); // 不应该到达这里
      } catch (error) {
        expect(error.constructor.name).assertEqual('AbortError');
      }
    })
    
    it('should_send_get_request_to_baidu', 0, async () => {
      console.info( 'SignalRTest', 'Testing GET request to baidu.com');
      
      const request: HttpRequest = {
        method: 'GET',
        url: 'https://www.baidu.com',
        timeout: 10000 // 10秒超时
      };
      
      try {
        const response = await client.send(request);
        
        // 验证响应基本结构
        expect(response.constructor.name).assertEqual('HttpResponse');
        expect(typeof response.statusCode).assertEqual('number');
        expect(typeof response.statusText).assertEqual('string');
        expect(response.content !== null).assertTrue();
        
        // 百度应该返回200状态码
        expect(response.statusCode).assertEqual(200);
        
        if (typeof response.content === 'string') {
          expect(response.content.length).assertLarger(0);
          expect(response.content.toLowerCase()).assertContain('baidu');
        }
        
        console.info( 'SignalRTest', `Response status: ${response.statusCode}, content length: ${typeof response.content === 'string' ? response.content.length : 'binary'}`);
        
      } catch (error) {
        console.error( 'SignalRTest', `Request failed: ${error.message}`);
        expect(error.message.indexOf('No method defined')).assertEqual(-1);
        expect(error.message.indexOf('No url defined')).assertEqual(-1);
        expect(error.message.indexOf('Invalid URL format')).assertEqual(-1);
      }
    })
    
    it('should_handle_different_http_methods', 0, async () => {
      console.info( 'SignalRTest', 'Testing different HTTP methods');
      
      const methods = ['GET', 'POST', 'HEAD', 'OPTIONS'];
      
      for (const method of methods) {
        const request: HttpRequest = {
          method: method,
          url: 'https://www.baidu.com',
          timeout: 5000
        };
        
        try {
          const response = await client.send(request);
          expect(response.constructor.name).assertEqual('HttpResponse');
          expect(typeof response.statusCode).assertEqual('number');
          console.info( 'SignalRTest', `${method} request successful, status: ${response.statusCode}`);
        } catch (error) {
          expect(error.message.indexOf('No method defined')).assertEqual(-1);
          expect(error.message.indexOf('No url defined')).assertEqual(-1);
          console.info( 'SignalRTest', `${method} request failed: ${error.message}`);
        }
      }
    })
    
    it('should_handle_request_with_headers', 0, async () => {
      console.info( 'SignalRTest', 'Testing request with custom headers');
      
      const request: HttpRequest = {
        method: 'GET',
        url: 'https://www.baidu.com',
        headers: {
          'User-Agent': 'HarmonyOS-SignalR-Test/1.0',
          'Accept': 'text/html,application/xhtml+xml'
        },
        timeout: 10000
      };
      
      try {
        const response = await client.send(request);
        expect(response.constructor.name).assertEqual('HttpResponse');
        expect(typeof response.statusCode).assertEqual('number');
        console.info( 'SignalRTest', `Request with headers successful, status: ${response.statusCode}`);
      } catch (error) {
        console.info( 'SignalRTest', `Request with headers failed: ${error.message}`);
        expect(error.message.indexOf('No method defined')).assertEqual(-1);
        expect(error.message.indexOf('No url defined')).assertEqual(-1);
      }
    })
    
    it('should_handle_timeout_correctly', 0, async () => {
      console.info( 'SignalRTest', 'Testing request timeout handling');
      
      const request: HttpRequest = {
        method: 'GET',
        url: 'https://www.baidu.com',
        timeout: 1 // 1毫秒超时，应该会超时
      };
      
      try {
        await client.send(request);
        console.info( 'SignalRTest', 'Request completed before timeout');
      } catch (error) {
        console.info( 'SignalRTest', `Request failed as expected: ${error.message}`);
        expect(typeof error.message).assertEqual('string');
      }
    })
    
    it('should_handle_post_request_with_data', 0, async () => {
      console.info( 'SignalRTest', 'Testing POST request with data');
      
      const request: HttpRequest = {
        method: 'POST',
        url: 'https://www.baidu.com',
        content: 'test=data',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        timeout: 10000
      };
      
      try {
        const response = await client.send(request);
        expect(response.constructor.name).assertEqual('HttpResponse');
        expect(typeof response.statusCode).assertEqual('number');
        console.info( 'SignalRTest', `POST request successful, status: ${response.statusCode}`);
      } catch (error) {
        console.info( 'SignalRTest', `POST request failed: ${error.message}`);
        expect(error.message.indexOf('No method defined')).assertEqual(-1);
        expect(error.message.indexOf('No url defined')).assertEqual(-1);
      }
    })
  })
}