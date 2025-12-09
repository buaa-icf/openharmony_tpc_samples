import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { LibVLC, MediaPlayer, Media, MediaPlayerListener, MediaListener } from '@ohos/vlc'
import { ArrayList } from '@kit.ArkTS';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('test_base', 0, () => {
      let vlc: LibVLC = new LibVLC(new ArrayList<string>(), "");
      let mediaPlayer: MediaPlayer = new MediaPlayer(vlc);
      let path = "file://" + getContext().resourceDir + "/5.mp4";
      let media: Media = new Media(vlc, path)

      expect(media.parse()).assertEqual(0)
    })

    it('test_Characteristics', 0, () => {
      let vlc: LibVLC = new LibVLC(new ArrayList<string>(), "");
      let mediaPlayer: MediaPlayer = new MediaPlayer(vlc);
      let path = "file://" + getContext().resourceDir + "/5.mp4";
      let media: Media = new Media(vlc, path)
      let parsed: boolean = false;
      media.addListener({
        onMediaParsedChanged: () => {
          parsed = true
        }
      })
      expect(media.parse()).assertEqual(0)
      expect(media.getDuration()).assertEqual(-1)
    })

    it('test3_value', 0, () => {
      let vlc: LibVLC = new LibVLC(new ArrayList<string>(), "");
      let mediaPlayer: MediaPlayer = new MediaPlayer(vlc);
      let path = "file://" + getContext().resourceDir + "/5.mp4";
      let media: Media = new Media(vlc, path)

      expect(mediaPlayer.getLength()).assertEqual(-1)
      expect(mediaPlayer.getState()).assertEqual(0)
      expect(mediaPlayer.getRate()).assertEqual(1)
    })
  })
}