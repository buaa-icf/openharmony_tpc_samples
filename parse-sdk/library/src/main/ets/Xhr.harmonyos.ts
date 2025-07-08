import http from '@ohos.net.http';
class XhrHarmony {
  UNSENT: number;
  OPENED: number;
  HEADERS_RECEIVED: number;
  LOADING: number;
  DONE: number;
  header: Record<string, string>;
  readyState: number;
  status: number;
  response: string | object | ArrayBuffer | undefined;
  responseType: string;
  responseText: string;
  responseHeader: Object;
  method: string;
  url: string;
  onabort: () => void;
  onprogress: (event: { loaded: number; total: number }) => void;
  onerror: (err: Error) => void;
  onreadystatechange: () => void;
  httpRequest: http.HttpRequest | null;

  constructor() {
    this.UNSENT = 0;
    this.OPENED = 1;
    this.HEADERS_RECEIVED = 2;
    this.LOADING = 3;
    this.DONE = 4;

    this.header = {};
    this.readyState = this.DONE;
    this.status = 0;
    this.response = '';
    this.responseType = '';
    this.responseText = '';
    this.responseHeader = {};
    this.method = '';
    this.url = '';
    this.onabort = () => {};
    this.onprogress = () => {};
    this.onerror = () => {};
    this.onreadystatechange = () => {};
    this.httpRequest = null;
  }

  getAllResponseHeaders(): string {
    let header = '';
    for (const key in this.responseHeader) {
      header += key + ': ' + this.getResponseHeader(key) + '\r\n';
    }
    return header;
  }

  getResponseHeader(key: string): string {
    return this.responseHeader[key];
  }

  setRequestHeader(key: string, value: string): void {
    this.header[key] = value;
  }

  open(method: string, url: string): void {
    this.method = method.toUpperCase();
    this.url = url;
  }

  abort(): void {
    if (!this.httpRequest) {
      return;
    }
    this.httpRequest.destroy();
    this.httpRequest = null;
    this.status = 0;
    this.response = undefined;
    this.onabort();
    this.onreadystatechange();
  }

  send(data?: string | object | ArrayBuffer): void {
    this.httpRequest = http.createHttp();

    const requestOptions: http.HttpRequestOptions = {
      expectDataType: http.HttpDataType.STRING,
      method: http.RequestMethod[this.method],
      extraData: data,
      header: this.header,
      readTimeout: 60000,
      connectTimeout: 60000,
    };

    if (this.responseType === 'arraybuffer') {
      requestOptions.expectDataType = http.HttpDataType.ARRAY_BUFFER;
    } else if (this.responseType === 'json') {
      requestOptions.expectDataType = http.HttpDataType.OBJECT;
    } else {
      requestOptions.expectDataType = http.HttpDataType.STRING;
    }

    this.httpRequest.request(
      this.url,
      requestOptions,
      (err, data) => {
        if (err) {
          this.httpRequest?.destroy();
          this.httpRequest = null;
          this.onerror(err);
          return;
        }

        this.status = data.responseCode;
        this.responseHeader = data.header;

        if (requestOptions.expectDataType === http.HttpDataType.OBJECT) {
          this.response = data.result;
          this.responseText = JSON.stringify(data.result);
        } else {
          this.response = data.result.toString();
          this.responseText = data.result.toString();
        }

        this.onreadystatechange();
        this.httpRequest?.destroy();
        this.httpRequest = null;
      }
    );

    this.httpRequest.on('dataReceiveProgress', (progress) => {
      const event = {
        lengthComputable: progress.totalSize !== 0,
        loaded: progress.receiveSize,
        total: progress.totalSize,
      };
      this.onprogress(event);
    });

  }
}

export default XhrHarmony;