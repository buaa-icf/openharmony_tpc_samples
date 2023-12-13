import common from '@ohos.app.ability.common';
import { HttpProxyCacheServer } from '@ohos/video-cache';

export default class GlobalProxyServer {
  private CONTEXT_STR: string = 'getContext';
  private SERVER_STR: string = 'getServer';
  private static instance: GlobalProxyServer;
  private _objects: Map<string, Object | null> = new Map<string, Object | null>();

  private constructor() {
  }

  public static getInstance(): GlobalProxyServer {
    if (!GlobalProxyServer.instance) {
      GlobalProxyServer.instance = new GlobalProxyServer()
    }
    return GlobalProxyServer.instance;
  }

  getContext(): common.UIAbilityContext | null {
    return this._objects?.get(this.CONTEXT_STR) ? this._objects?.get(this.CONTEXT_STR) as common.UIAbilityContext : null
  }

  setContext(objectClass: common.UIAbilityContext | null) {
    this._objects?.set(this.CONTEXT_STR, objectClass);
  }

  getServer(): HttpProxyCacheServer | null {
    return this._objects?.get(this.SERVER_STR) ? this._objects?.get(this.SERVER_STR) as HttpProxyCacheServer : null
  }

  setServer(objectClass: HttpProxyCacheServer | null) {
    this._objects?.set(this.SERVER_STR, objectClass);
  }
}