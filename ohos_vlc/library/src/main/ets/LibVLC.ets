import { hilog } from '@kit.PerformanceAnalysisKit';

import { Vlc } from 'libvlc_napi.so';
import ArrayList from '@ohos.util.ArrayList';

export class LibVLC {
  private vlc: Vlc;

  constructor(stringArray: ArrayList<string>, homePath: string) {
    hilog.info(0x0000, 'testTag', 'vlcdebug new libvlc');
    this.vlc = new Vlc(stringArray, homePath)
  }

  public getVLC(): Vlc {
    return this.vlc;
  }
}