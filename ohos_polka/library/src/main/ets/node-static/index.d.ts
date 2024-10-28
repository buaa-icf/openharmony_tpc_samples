import { EventEmitter } from "../common/util/event-emitter";
import { Mime } from "./mime";
import fs from "@ohos.file.fs";
import common from "@ohos.app.ability.common";
import { IncomingMessage, ServerResponse } from "../polka";

export interface Headers {
  [k: string]: any;
}

export interface Error {
  status?: number
}

export type Finish = (status: number, headers?: Headers) => void;
export type Callback = (e: Error) => void;

export interface Options {
  headers?: Headers | undefined;
  indexFile?: string | undefined;
  cache?: number | boolean | undefined;
  serverInfo?: string | undefined;
  server?: string | undefined; // change
  "cache-control"?: string | undefined;
  gzip?: boolean
}

export interface ByteRange {
  from: number;
  to: number;
  valid: boolean;
}

export declare namespace statik {

  class Server {
    root: string;
    options: Options;
    cache: number | boolean;
    defaultHeaders: Headers;
    serverInfo: string;

    constructor(context: common.UIAbilityContext, root: string, options?: Options);

    serveDir: (pathname: string, req: IncomingMessage, res: ServerResponse, finish: Finish) => void;
    serveFile: (
      pathname: string,
      status: number,
      headers: Headers,
      req: IncomingMessage,
      res: ServerResponse,
    ) => EventEmitter;
    finish: (
      status: number,
      headers: Headers,
      req: IncomingMessage,
      res: ServerResponse,
      promise: EventEmitter,
      callback: Callback,
    ) => void;
    servePath: (
      pathname: string,
      status: number,
      headers: Headers,
      req: IncomingMessage,
      res: ServerResponse,
      finish: Finish,
    ) => EventEmitter;
    resolve: (pathname: string) => string;
    serve: (req: IncomingMessage, res: ServerResponse, callback?: Callback) => EventEmitter;
    gzipOk: (req: IncomingMessage, contentType: string) => boolean;
    respondGzip: (
      pathname: string,
      status: number,
      contentType: string,
      _headers: Headers,
      files: string[],
      stat: fs.Stat,
      req: IncomingMessage,
      res: ServerResponse,
      finish: Finish,
    ) => void;
    parseByteRange: (req: IncomingMessage, stat: fs.Stat) => ByteRange;
    respondNoGzip: (
      pathname: string,
      status: number,
      contentType: string,
      _headers: Headers,
      files: string[],
      stat: fs.Stat,
      req: IncomingMessage,
      res: ServerResponse,
      finish: Finish,
    ) => void;
    respond: (
      pathname: string,
      status: number,
      _headers: Headers,
      files: string[],
      stat: fs.Stat,
      req: IncomingMessage,
      res: ServerResponse,
      finish: Finish,
    ) => void;
    stream: (
      pathname: string,
      files: string[],
      length: number,
      startByte: number,
      res: ServerResponse,
      callback: Callback,
    ) => void;
  }

  export let mime: Mime
}