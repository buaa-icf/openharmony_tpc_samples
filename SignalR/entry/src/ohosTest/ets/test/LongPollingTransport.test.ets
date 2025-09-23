// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  HttpClient,
  HttpRequest,
  HttpResponse,
  ILogger,
  LogLevel,
  TransferFormat
} from '@ohos/signalr';
import { AbortController, AbortSignal } from '@ohos/signalr/src/main/ets/src/AbortController';
import { AccessTokenHttpClient } from '@ohos/signalr/src/main/ets/src/AccessTokenHttpClient';
import { LongPollingTransport } from '@ohos/signalr/src/main/ets/src/LongPollingTransport';

// Mock VerifyLogger for HarmonyOS
class VerifyLogger {
  static async run(callback: (logger: ILogger) => Promise<void>): Promise<void> {
    const logger: ILogger = {
      log: (logLevel: LogLevel, message: string) => console.info( 'SignalRTest', `[${LogLevel[logLevel]}] ${message}`)
    };
    await callback(logger);
  }
}

// Test message interface
interface TestMessage {
  message: string;
}

// Test headers interface - using Record type instead of indexed signature
type TestHeaders = Record<string, string>;

// Promise utility classes for HarmonyOS
class PromiseSource<T = void> {
  private _promise: Promise<T>;
  private _resolve!: (value: T | PromiseLike<T>) => void;
  private _reject!: (reason?: Error) => void;

  constructor() {
    this._promise = new Promise<T>((resolve, reject) => {
      this._resolve = resolve;
      this._reject = reject;
    });
  }

  get promise(): Promise<T> {
    return this._promise;
  }

  resolve(value?: T | PromiseLike<T>): void {
    this._resolve(value as T);
  }

  reject(reason?: Error): void {
    this._reject(reason);
  }
}

class SyncPoint {
  private _waitForSyncPoint: PromiseSource<void> = new PromiseSource<void>();
  private _waitToContinue: PromiseSource<void> = new PromiseSource<void>();
  private _signaled: boolean = false;

  async waitForSyncPoint(): Promise<void> {
    return this._waitForSyncPoint.promise;
  }

  async waitToContinue(): Promise<void> {
    return this._waitToContinue.promise;
  }

  continue(): void {
    this._waitToContinue.resolve();
  }

  // Called by the code under test to signal it has reached the sync point
  signal(): void {
    if (!this._signaled) {
      this._signaled = true;
      this._waitForSyncPoint.resolve();
    }
  }
}

// Test HttpClient implementation
class TestHttpClient extends HttpClient {
  private _handlers: Map<string, (request: HttpRequest) => Promise<HttpResponse> | HttpResponse> = new Map();

  on(method: string, handler: (request: HttpRequest) => Promise<HttpResponse> | HttpResponse): TestHttpClient {
    this._handlers.set(method, handler);
    return this;
  }

  async send(request: HttpRequest): Promise<HttpResponse> {
    const method = request.method || 'GET';
    const handler = this._handlers.get(method);
    if (handler) {
      const result = handler(request);
      return result instanceof Promise ? await result : result;
    }
    return new HttpResponse(404);
  }

  async get(url: string, options?: HttpRequest): Promise<HttpResponse> {
    const request: HttpRequest = {
      method: 'GET',
      url: url,
      content: options?.content,
      headers: options?.headers,
      responseType: options?.responseType,
      abortSignal: options?.abortSignal,
      timeout: options?.timeout,
      withCredentials: options?.withCredentials
    };
    return this.send(request);
  }

  async post(url: string, options?: HttpRequest): Promise<HttpResponse> {
    const request: HttpRequest = {
      method: 'POST',
      url: url,
      content: options?.content,
      headers: options?.headers,
      responseType: options?.responseType,
      abortSignal: options?.abortSignal,
      timeout: options?.timeout,
      withCredentials: options?.withCredentials
    };
    return this.send(request);
  }

  async delete(url: string, options?: HttpRequest): Promise<HttpResponse> {
    const request: HttpRequest = {
      method: 'DELETE',
      url: url,
      content: options?.content,
      headers: options?.headers,
      responseType: options?.responseType,
      abortSignal: options?.abortSignal,
      timeout: options?.timeout,
      withCredentials: options?.withCredentials
    };
    return this.send(request);
  }
}



export default function longPollingTransportTest() {
  describe("LongPollingTransport", () => {
    beforeAll(() => {
      console.info( 'SignalRTest', 'LongPollingTransport test suite started');
    });

    afterAll(() => {
      console.info( 'SignalRTest', 'LongPollingTransport test suite completed');
    });

    it("shuts down polling by aborting in-progress request", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        let firstPoll = true;
        const pollCompleted = new PromiseSource<void>();
        const client = new TestHttpClient()
          .on("GET", async (r: HttpRequest) => {
            if (firstPoll) {
              firstPoll = false;
              return new HttpResponse(200);
            } else {
              // Turn 'onabort' into a promise.
              const abort = new Promise<void>((resolve) => {
                if (r.abortSignal!.aborted) {
                  resolve();
                } else {
                  r.abortSignal!.onabort = resolve;
                }
              });
              await abort;

              // Signal that the poll has completed.
              pollCompleted.resolve();

              return new HttpResponse(200);
            }
          })
          .on("DELETE", () => new HttpResponse(202));
        
        const transport = new LongPollingTransport(client, logger, { 
          logMessageContent: false, 
          withCredentials: true, 
          headers: {} 
        });

        await transport.connect("http://example.com", TransferFormat.Text);
        const stopPromise = transport.stop();

        await pollCompleted.promise;
        await stopPromise;
      });
    });



    it("sends DELETE on stop after polling has finished", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        let firstPoll = true;
        let deleteSent = false;
        const pollingPromiseSource = new PromiseSource<void>();
        const deleteSyncPoint = new SyncPoint();
        const httpClient = new TestHttpClient()
          .on("GET", async () => {
            if (firstPoll) {
              firstPoll = false;
              return new HttpResponse(200);
            } else {
              await pollingPromiseSource.promise;
              return new HttpResponse(204);
            }
          })
          .on("DELETE", async () => {
            deleteSent = true;
            deleteSyncPoint.signal();
            await deleteSyncPoint.waitToContinue();
            return new HttpResponse(202);
          });

        const transport = new LongPollingTransport(httpClient, logger, { 
          logMessageContent: false, 
          withCredentials: true, 
          headers: {} 
        });

        await transport.connect("http://tempuri.org", TransferFormat.Text);

        // Begin stopping transport
        const stopPromise = transport.stop();

        // Delete will not be sent until polling is finished
        expect(deleteSent).assertEqual(false);

        // Allow polling to complete
        pollingPromiseSource.resolve();

        // Wait for delete to be called
        await deleteSyncPoint.waitForSyncPoint();

        expect(deleteSent).assertEqual(true);

        deleteSyncPoint.continue();

        // Wait for stop to complete
        await stopPromise;
      });
    });

    it("user agent header set on sends and polls", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        let firstPoll = true;
        let firstPollUserAgent = "";
        let secondPollUserAgent = "";
        let deleteUserAgent = "";
        const pollingPromiseSource = new PromiseSource<void>();
        const httpClient = new TestHttpClient()
          .on("GET", async (r: HttpRequest) => {
            if (firstPoll) {
              firstPoll = false;
              firstPollUserAgent = r.headers!['X-SignalR-User-Agent'] || "";
              return new HttpResponse(200);
            } else {
              secondPollUserAgent = r.headers!['X-SignalR-User-Agent'] || "";
              await pollingPromiseSource.promise;
              return new HttpResponse(204);
            }
          })
          .on("DELETE", async (r: HttpRequest) => {
            deleteUserAgent = r.headers!['X-SignalR-User-Agent'] || "";
            return new HttpResponse(202);
          });

        const transport = new LongPollingTransport(httpClient, logger, { 
          logMessageContent: false, 
          withCredentials: true, 
          headers: {} 
        });

        await transport.connect("http://tempuri.org", TransferFormat.Text);

        // Begin stopping transport
        const stopPromise = transport.stop();

        // Allow polling to complete
        pollingPromiseSource.resolve();

        // Wait for stop to complete
        await stopPromise;

        // Log the actual user agent for debugging
        console.info( 'SignalRTest', `First poll X-SignalR-User-Agent: "${firstPollUserAgent}"`);
        console.info( 'SignalRTest', `Delete X-SignalR-User-Agent: "${deleteUserAgent}"`);
        console.info( 'SignalRTest', `Second poll X-SignalR-User-Agent: "${secondPollUserAgent}"`);
        
        // Verify SignalR User-Agent headers are set correctly
        expect(firstPollUserAgent).assertContain("Microsoft SignalR");
        expect(firstPollUserAgent).assertContain("HarmonyOS");
        expect(deleteUserAgent).assertContain("Microsoft SignalR");
        expect(deleteUserAgent).assertContain("HarmonyOS");
        expect(secondPollUserAgent).assertContain("Microsoft SignalR");
        expect(secondPollUserAgent).assertContain("HarmonyOS");
      });
    });

    it("overwrites library headers with user headers", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        const headers: TestHeaders = { "User-Agent": "Custom Agent", "X-HEADER": "VALUE" };
        let firstPoll = true;
        let firstPollUserAgent = "";
        let firstUserHeader = "";
        let secondPollUserAgent = "";
        let secondUserHeader = "";
        let deleteUserAgent = "";
        let deleteUserHeader = "";
        const pollingPromiseSource = new PromiseSource<void>();
        const httpClient = new TestHttpClient()
          .on("POST", async (r: HttpRequest) => {
            const expectedContent: TestMessage = { message: "hello" };
            expect(r.content).assertDeepEquals(expectedContent);
            // Check specific headers instead of deep equals due to auto-added headers
            expect(r.headers!["User-Agent"]).assertEqual("Custom Agent");
            expect(r.headers!["X-HEADER"]).assertEqual("VALUE");
            expect(r.method).assertEqual("POST");
            expect(r.url).assertEqual("http://tempuri.org");
            return new HttpResponse(200);
          })
          .on("GET", async (r: HttpRequest) => {
            if (firstPoll) {
              firstPoll = false;
              firstPollUserAgent = r.headers!["User-Agent"] || "";
              firstUserHeader = r.headers!["X-HEADER"] || "";
              return new HttpResponse(200);
            } else {
              secondPollUserAgent = r.headers!["User-Agent"] || "";
              secondUserHeader = r.headers!["X-HEADER"] || "";
              await pollingPromiseSource.promise;
              return new HttpResponse(204);
            }
          })
          .on("DELETE", async (r: HttpRequest) => {
            deleteUserAgent = r.headers!["User-Agent"] || "";
            deleteUserHeader = r.headers!["X-HEADER"] || "";
            return new HttpResponse(202);
          });

        const transport = new LongPollingTransport(httpClient, logger, { 
          logMessageContent: false, 
          withCredentials: true, 
          headers 
        });

        await transport.connect("http://tempuri.org", TransferFormat.Text);

        const testMessage: TestMessage = { message: "hello" };
        await transport.send(testMessage);

        // Begin stopping transport
        const stopPromise = transport.stop();

        // Allow polling to complete
        pollingPromiseSource.resolve();

        // Wait for stop to complete
        await stopPromise;

        expect(firstPollUserAgent).assertEqual("Custom Agent");
        expect(deleteUserAgent).assertEqual("Custom Agent");
        expect(secondPollUserAgent).assertEqual("Custom Agent");
        expect(firstUserHeader).assertEqual("VALUE");
        expect(secondUserHeader).assertEqual("VALUE");
        expect(deleteUserHeader).assertEqual("VALUE");
      });
    });

    it("sets timeout on requests", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        let firstPoll = true;
        const pollingPromiseSource = new PromiseSource<void>();
        const httpClient = new TestHttpClient()
          .on("GET", async (r: HttpRequest) => {
            expect(r.timeout).assertEqual(100000);
            if (firstPoll) {
              firstPoll = false;
              return new HttpResponse(200);
            } else {
              await pollingPromiseSource.promise;
              return new HttpResponse(204);
            }
          })
          .on("POST", (r: HttpRequest) => {
            expect(r.timeout).assertEqual(123);
            return new HttpResponse(200);
          })
          .on("DELETE", (r: HttpRequest) => {
            expect(r.timeout).assertEqual(123);
            return new HttpResponse(202);
          });

        const transport = new LongPollingTransport(httpClient, logger, {
          logMessageContent: false, 
          withCredentials: true, 
          headers: {}, 
          timeout: 123 
        });

        await transport.connect("http://tempuri.org", TransferFormat.Text);

        await transport.send("test");

        // Begin stopping transport
        const stopPromise = transport.stop();

        // Allow polling to complete
        pollingPromiseSource.resolve();

        // Wait for stop to complete
        await stopPromise;
      });
    });

    it("removes Authorization header when accessTokenFactory returns empty", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        let firstPoll = true;
        let secondPoll = false;
        let firstAuthHeader = "";
        let secondAuthHeader = "";
        let deleteAuthHeader = "";
        const accessTokenFactory = () => {
          if (firstAuthHeader) {
            return "";
          }
          return "value";
        };
        const pollingPromiseSource = new PromiseSource<void>();
        const readyToStopPromiseSource = new PromiseSource<void>();
        const httpClient = new AccessTokenHttpClient(new TestHttpClient()
          .on("GET", async (r: HttpRequest) => {
            if (firstPoll) {
              firstPoll = false;
              secondPoll = true;
              firstAuthHeader = r.headers!.Authorization || "";
              return new HttpResponse(200);
            } else if (secondPoll) {
              secondPoll = false;
              // force a retry so the access token factory is called again
              return new HttpResponse(401);
            } else {
              readyToStopPromiseSource.resolve();
              secondAuthHeader = r.headers!.Authorization || "";
              await pollingPromiseSource.promise;
              return new HttpResponse(204);
            }
          })
          .on("DELETE", async (r: HttpRequest) => {
            deleteAuthHeader = r.headers!.Authorization || "";
            return new HttpResponse(202);
          }), accessTokenFactory);

        const transport = new LongPollingTransport(httpClient, logger, { 
          logMessageContent: false, 
          withCredentials: true, 
          headers: {} 
        });

        await transport.connect("http://tempuri.org", TransferFormat.Text);

        await readyToStopPromiseSource.promise;

        // Begin stopping transport
        const stopPromise = transport.stop();

        // Allow polling to complete
        pollingPromiseSource.resolve();

        // Wait for stop to complete
        await stopPromise;

        expect(firstAuthHeader).assertEqual("Bearer value");
        expect(deleteAuthHeader).assertEqual("");
        expect(secondAuthHeader).assertEqual("");
      });
    });

    it("keeps user provided Authorization header when no accessTokenFactory", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        let firstPoll = true;
        let firstAuthHeader = "";
        let secondAuthHeader = "";
        let deleteAuthHeader = "";
        const pollingPromiseSource = new PromiseSource<void>();
        const httpClient = new AccessTokenHttpClient(new TestHttpClient()
          .on("GET", async (r: HttpRequest) => {
            if (firstPoll) {
              firstPoll = false;
              firstAuthHeader = r.headers!.Authorization || "";
              return new HttpResponse(200);
            } else {
              secondAuthHeader = r.headers!.Authorization || "";
              await pollingPromiseSource.promise;
              return new HttpResponse(204);
            }
          })
          .on("DELETE", async (r: HttpRequest) => {
            deleteAuthHeader = r.headers!.Authorization || "";
            return new HttpResponse(202);
          }), undefined);

        const transport = new LongPollingTransport(httpClient, logger, { 
          logMessageContent: false, 
          withCredentials: true,
          headers: { Authorization: "Basic test" } 
        });

        await transport.connect("http://tempuri.org", TransferFormat.Text);

        // Begin stopping transport
        const stopPromise = transport.stop();

        // Allow polling to complete
        pollingPromiseSource.resolve();

        // Wait for stop to complete
        await stopPromise;

        expect(firstAuthHeader).assertEqual("Basic test");
        expect(deleteAuthHeader).assertEqual("Basic test");
        expect(secondAuthHeader).assertEqual("Basic test");
      });
    });
  });
}