// 定义ArkTS接口
export class PjsipApp {
  constructor()

  init: () => number;
  modifyAccount: (idUri: string, registrarUri: string, userName: string, pwd: string,) => number;
  addInCallingListener: (callback: Function) => void;
  addInCallStateListener: (callback: Function) => void;
  acceptCall: () => void;
  handUpCall: () => void;
  makeCall: (url:string) => void;
  setSurfaceId: (surfaceId: string) => void;
  destroy: () => void;
}