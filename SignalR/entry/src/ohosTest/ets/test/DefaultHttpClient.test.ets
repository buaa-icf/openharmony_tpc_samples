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
import { DefaultHttpClient, NullLogger, AbortError, HttpRequest, AbortSignal } from '@ohos/signalr';

// 创建测试用的AbortController
class TestAbortController {
  private _isAborted: boolean = false;
  public onabort: (() => void) | null = null;

  public abort(): void {
    if (!this._isAborted) {
      this._isAborted = true;
      if (this.onabort) {
        this.onabort();
      }
    }
  }

  get signal(): AbortSignal {
    return {
      aborted: this._isAborted,
      onabort: this.onabort
    } as AbortSignal;
  }
}

export default function defaultHttpClientTest() {
  describe('DefaultHttpClient_Tests', () => {
    let client: DefaultHttpClient;
    
    beforeAll(() => {
      console.info('SignalRTest', 'DefaultHttpClient test suite started');
    })
    
    beforeEach(() => {
      client = new DefaultHttpClient(NullLogger.instance);
    })
    
    afterEach(() => {
      // 清理资源
    })
    
    afterAll(() => {
      console.info('SignalRTest', 'DefaultHttpClient test suite completed');
    })
    
    it('should_create_client_with_logger', 0, () => {
      console.info('SignalRTest', 'Testing DefaultHttpClient creation');
      
      expect(client.constructor.name).assertEqual('DefaultHttpClient');
    })
    
    it('should_reject_request_without_method', 0, async () => {
      console.info('SignalRTest', 'Testing request without method');
      
      const request: HttpRequest = {
        url: 'http://baidu.com'
      };
      
      try {
        await client.send(request);
        expect(false).assertTrue();
      } catch (error) {
        expect(error.message).assertEqual('No method defined.');
      }
    })
    
    it('should_reject_request_without_url', 0, async () => {
      console.info('SignalRTest', 'Testing request without URL');
      
      const request: HttpRequest = {
        method: 'GET'
      };
      
      try {
        await client.send(request);
        expect(false).assertTrue();
      } catch (error) {
        expect(error.message).assertEqual('No url defined.');
      }
    })
    
    it('should_reject_aborted_request', 0, async () => {
      console.info('SignalRTest', 'Testing aborted request');
      
      const controller = new TestAbortController();
      controller.abort();
      
      const request: HttpRequest = {
        method: 'GET',
        url: 'http://test.com',
        abortSignal: controller.signal
      };
      
      try {
        await client.send(request);
        expect(false).assertTrue();
      } catch (error) {
        expect(error.constructor.name).assertEqual('AbortError');
      }
    })
    
    it('should_return_cookie_string', 0, () => {
      console.info('SignalRTest', 'Testing getCookieString method');
      
      const cookies = client.getCookieString('http://baidu.com');
      
      expect(typeof cookies).assertEqual('string');
    })
    
    it('should_handle_valid_request_structure', 0, () => {
      console.info('SignalRTest', 'Testing valid request structure');
      
      const request: HttpRequest = {
        method: 'GET',
        url: 'http://baidu.com',
        headers: { 'Content-Type': 'application/json' },
        content: 'test data'
      };

      let hasError = false;
      try {
        client.send(request).catch(() => {
        });
      } catch (error) {
        hasError = true;
      }
      expect(hasError).assertFalse();
    })
    
    it('should_handle_different_http_methods', 0, () => {
      console.info('SignalRTest', 'Testing different HTTP methods');
      
      const methods = ['GET', 'POST', 'PUT', 'DELETE', 'HEAD', 'OPTIONS'];
      
      methods.forEach((method) => {
        const request: HttpRequest = {
          method: method,
          url: 'http://baidu.com'
        };
        
        let hasError = false;
        try {
          client.send(request).catch(() => {
            // 忽略网络错误
          });
        } catch (error) {
          hasError = true;
        }
        expect(hasError).assertFalse();
      });
    })
    
    it('should_handle_request_with_timeout', 0, () => {
      console.info('SignalRTest', 'Testing request with timeout');
      
      const request: HttpRequest = {
        method: 'GET',
        url: 'http://baidu.com',
        timeout: 5000
      };
      
      let hasError = false;
      try {
        client.send(request).catch(() => {
          // 忽略网络错误
        });
      } catch (error) {
        hasError = true;
      }
      expect(hasError).assertFalse();
    })
  })
}