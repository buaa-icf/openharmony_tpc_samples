import { hilog } from '@kit.PerformanceAnalysisKit';
import { LibVLC  } from './LibVLC';
import { VlcMedia, MediaEventCB, libvlc_event_e } from 'libvlc_napi.so';

export interface MediaListener {
  onMediaParsedChanged?: () => void;
}

export class Media {
  private media: VlcMedia;
  private eventListener: MediaListener | undefined = undefined;
  private mediaEventcb: MediaEventCB = {
    onMediaEventCallback: (type: number) => {
      if (type == libvlc_event_e.libvlc_MediaParsedChanged) {
        if (this.eventListener?.onMediaParsedChanged) {
          this.eventListener.onMediaParsedChanged()
        }
      }
    }
  }

  public constructor(vlc: LibVLC, mediaURL: string) {
    hilog.info(0x0000, 'vlcdebug', 'new media');
    this.media = new VlcMedia(vlc.getVLC(), mediaURL);
    this.media.addListener(this.mediaEventcb);
  }

  addListener(listener: MediaListener): void {
    this.eventListener = listener;
  }


  getMedia(): VlcMedia {
    return this.media;
  }

  getDuration(): number {
    return this.media.getDuration();
  }

  parse(): number {
    return this.media.parse();
  }
}