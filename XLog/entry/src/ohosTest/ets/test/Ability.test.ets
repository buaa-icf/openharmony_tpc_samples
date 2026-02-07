import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { XLogConfig, Xlog, XLoggerInfo } from '@ohos/xlog/Index';

export default function abilityTest() {
  let logPath: string = '/data/storage/el2/base/haps/entry_test/files/xlog_unit';
  let cachePath: string = '/data/storage/el2/base/haps/entry_test/cache/xlog_unit';
  let nameprefix: string = 'xlog_prefix';
  let log: Xlog = new Xlog();
  let created: boolean = false;

  let xlogConfig: XLogConfig = {
    level: Xlog.LEVEL_DEBUG,
    mode: Xlog.APPENDER_MODE_ASYNC,
    logdir: logPath,
    nameprefix: nameprefix,
    pubkey: 'PUBKEY',
    compressmode: Xlog.ZLIB_MODE,
    compresslevel: Xlog.COMPRESS_LEVEL1,
    cachedir: cachePath,
    cachedays: 0
  };

  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      created = log.createXlog(xlogConfig)
    })
    beforeEach(() => {

    })
    afterEach(() => {
      created = false;
    })
    afterAll(() => {
      log.release();
    })

    it('createXLog', 0, () => {
      expect(created).assertTrue();
    })

    it('getLogLevel', 0, () => {
      log?.setLogLevel(Xlog.LEVEL_ERROR)
      expect(log?.getLogLevel()).assertEqual(Xlog.LEVEL_ERROR);
      log?.setLogLevel(Xlog.LEVEL_NONE)
      expect(log?.getLogLevel()).assertEqual(Xlog.LEVEL_NONE);
      log?.setLogLevel(Xlog.LEVEL_DEBUG)
      expect(log?.getLogLevel()).assertEqual(Xlog.LEVEL_DEBUG);
    })
    it('setAppenderMode', 0, () => {
      try {
        expect(log?.setAppenderMode(Xlog.APPENDER_MODE_SYNC)).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })
    it('setConsoleLogOpen', 0, () => {
      try {
        expect(log?.setConsoleLogOpen(true)).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })
    it('logWrite2', 0, () => {
      try {
        let ret = log?.logWrite2(Xlog.LEVEL_DEBUG, 'unit_xlog', 'uint.ets', 'logWrite2', 73, -1, -1, -1, 'unit log')
        expect(ret).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })

    it('logV', 0, () => {
      try {
        log?.logV('unit_xlog', 'uint.ets', 'logWrite2', 83, 'unit log')
        expect(true).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })
    it('logD', 0, () => {
      try {
        log?.logD('unit_xlog', 'uint.ets', 'logWrite2', 83, 'unit log')
        expect(true).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })
    it('logI', 0, () => {
      try {
        log?.logI('unit_xlog', 'uint.ets', 'logWrite2', 98, 'unit log')
        expect(true).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })
    it('logE', 0, () => {
      try {
        log?.logE('unit_xlog', 'uint.ets', 'logWrite2', 106, 'unit log')
        expect(true).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })
    it('logF', 0, () => {
      try {
        log?.logF('unit_xlog', 'uint.ets', 'logWrite2', 114, 'unit log')
        expect(true).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })

    it('appenderOpen', 0, () => {
      try {
        let ret = Xlog.appenderOpen(xlogConfig)
        expect(ret).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })

    it('appenderClose', 0, () => {
      try {
        Xlog.appenderClose();
        expect(true).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })

    it('logWrite', 0, () => {
      try {
        let logInfo: XLoggerInfo = {
          level: Xlog.LEVEL_DEBUG,
          tag: 'static_xlog_unit',
          filename: 'xlog_unit.cpp',
          funcname: 'xlog_write',
          line: 337,
          pid: 0,
          tid: 377,
          maintid: 377,
        }
        Xlog.logWrite(logInfo, 'hello, static logWrite')
        expect(true).assertTrue();
      }catch (e) {
        expect(true).assertFalse();
      }
    })
  })
}