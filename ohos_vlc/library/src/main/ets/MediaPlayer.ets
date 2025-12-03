import { LibVLC } from './LibVLC'
import { Media } from './Media';
import { VlcMediaPlayer, MediaPlayerEventCB, libvlc_event_e } from 'libvlc_napi.so';


export interface MediaPlayerListener {
  onMediaPlayerMediaChanged?: () => void;
  onMediaPlayerOpening?: () => void;
  onMediaPlayerBuffering?: (para: number) => void;
  onMediaPlayerPlaying?: () => void;
  onMediaPlayerPaused?: () => void;
  onMediaPlayerStopped?: () => void;
  onMediaPlayerEndReached?: () => void
  onMediaPlayerEncounteredError?: () => void;
  onMediaPlayerTimeChanged?: (para: number) => void;
  onMediaPlayerPositionChanged?: (para: number) => void;
  onMediaPlayerVout?: () => void;
  onMediaPlayerESAdded?: (para1: number, para2: number) => void;
  onMediaPlayerESDeleted?: (para1: number, para2: number) => void;
  onMediaPlayerESSelected?: (para1: number, para2: number) => void;
  onMediaPlayerSeekableChanged?: (para1: number) => void;
  onMediaPlayerPausableChanged?: (para1: number) => void;
  onMediaPlayerLengthChanged?: (para1: number) => void;
}

export class MediaPlayer {
  private mediaPlayer: VlcMediaPlayer;
  private eventListener: MediaPlayerListener | undefined = undefined;
  private mediaEventcb: MediaPlayerEventCB = {
    onMediaPlayerEventCallback: (type: number, para1: number, para2: number, para3: number) => {
      console.info(`type: ${type}, para1: ${para1} para2: ${para2} para3: ${para3} `);
      if (type == libvlc_event_e.libvlc_MediaPlayerOpening) {
        this.eventListener?.onMediaPlayerOpening?.();
      } else if (type == libvlc_event_e.libvlc_MediaPlayerBuffering) {
        this.eventListener?.onMediaPlayerBuffering?.(para3);
      } else if (type == libvlc_event_e.libvlc_MediaPlayerPlaying) {
        this.eventListener?.onMediaPlayerPlaying?.();
      } else if (type == libvlc_event_e.libvlc_MediaPlayerPaused) {
        this.eventListener?.onMediaPlayerPaused?.();
      } else if (type == libvlc_event_e.libvlc_MediaPlayerStopped) {
        this.eventListener?.onMediaPlayerStopped?.();
      } else if (type == libvlc_event_e.libvlc_MediaPlayerESAdded) {
        this.eventListener?.onMediaPlayerESAdded?.(para1, para2);
      } else if (type == libvlc_event_e.libvlc_MediaPlayerESDeleted) {
        this.eventListener?.onMediaPlayerESDeleted?.(para1, para2);
      } else if (type == libvlc_event_e.libvlc_MediaPlayerESSelected) {
        this.eventListener?.onMediaPlayerESSelected?.(para1, para2);
      } else if (type == libvlc_event_e.libvlc_MediaPlayerTimeChanged) {
        this.eventListener?.onMediaPlayerTimeChanged?.(para1);
      } else if (type == libvlc_event_e.libvlc_MediaPlayerPositionChanged) {
        this.eventListener?.onMediaPlayerPositionChanged?.(para3);
      } else if (type == libvlc_event_e.libvlc_MediaPlayerMediaChanged) {
        this.eventListener?.onMediaPlayerMediaChanged?.();
      } else if (type == libvlc_event_e.libvlc_MediaPlayerEndReached) {
        this.eventListener?.onMediaPlayerEndReached?.();
      } else if (type == libvlc_event_e.libvlc_MediaPlayerEncounteredError) {
        this.eventListener?.onMediaPlayerEncounteredError?.();
      } else if (type == libvlc_event_e.libvlc_MediaPlayerVout) {
        this.eventListener?.onMediaPlayerVout?.();
      } else if (type == libvlc_event_e.libvlc_MediaPlayerSeekableChanged) {
        this.eventListener?.onMediaPlayerSeekableChanged?.(para1);
      } else if (type == libvlc_event_e.libvlc_MediaPlayerPausableChanged) {
        this.eventListener?.onMediaPlayerPausableChanged?.(para1);
      } else if (type == libvlc_event_e.libvlc_MediaPlayerLengthChanged) {
        this.eventListener?.onMediaPlayerLengthChanged?.(para1);
      }
    }
  }

  public constructor(vlc: LibVLC) {
    this.mediaPlayer = new VlcMediaPlayer(vlc.getVLC());
    this.mediaPlayer.setEventCallback(this.mediaEventcb);
  }

  setMedia(media: Media) {
    this.mediaPlayer.setMedia(media.getMedia());
  }

  play() {
    this.mediaPlayer.play();
  }

  setVideoOut(id: string) {
    this.mediaPlayer.setVideoOut(id);
  }

  addSlave(type: number, path: string, select: boolean): boolean {
    return this.mediaPlayer.addSlave(type, path, select);
  }

  addListener(listener: MediaPlayerListener): void {
    this.eventListener = listener;
  }

  pause() {
    this.mediaPlayer.pause();
  }

  stop() {
    this.mediaPlayer.stop();
  }

  getLength(): number {
    return this.mediaPlayer.getLength();
  }

  getVolume(): number {
    return this.mediaPlayer.getVolume();
  }

  setVolume(volume: number): number {
    return this.mediaPlayer.setVolume(volume);
  }

  getState(): number {
    return this.mediaPlayer.getState();
  }

  setScale(factor: number) {
    this.mediaPlayer.setScale(factor);
  }

  isPlaying(): boolean {
    return this.mediaPlayer.isPlaying();
  }

  isSeekable(): boolean {
    return this.mediaPlayer.isSeekable();
  }

  setTime(time: number): void {
    this.mediaPlayer.setTime(time);
  }

  getTime(): number {
    return this.mediaPlayer.getTime();
  }

  setPosition(pos: number): void {
    this.mediaPlayer.setPosition(pos);
  }

  getPosition(): number {
    return this.mediaPlayer.getPosition();
  }

  getRate(): number {
    return this.mediaPlayer.getRate();
  }

  setRate(rate: number): number {
    return this.mediaPlayer.setRate(rate);
  }
}

