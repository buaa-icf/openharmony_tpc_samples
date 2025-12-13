import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'

interface RectF {
  left: number;
  top: number;
  right: number;
  bottom: number;
}

interface PointF {
  x: number;
  y: number;
}

interface anyNumber {
  x: number;
}

interface FitTestCase {
  name: string;
  value: number;
  expected: PointF;
}

interface alignmentTestCase {
  name: string;
  value: number;
  touchPoint: PointF;
  expected: PointF;
}

interface aspectRatioTestCase {
  name: string;
  touchRect: RectF;
  artboardRect: RectF;
  touchPoint: PointF;
  fitValue: number;
  alignmentValue: number;
  expected: PointF;
}

interface edgePointTestCase {
  name: string;
  point: PointF;
  expected: PointF;
}

interface scaleFactorTestCase {
  value: number;
  expected: PointF;
}

interface precisionTestCase {
  name: string;
  fitValue: number;
  touchPoint: PointF;
  expected: PointF;
}

enum Fit {
  NONE,
  FILL,
  CONTAIN,
  COVER,
  FIT_WIDTH,
  FIT_HEIGHT,
  SCALE_DOWN,
  LAYOUT
};

enum Alignment {
  TOP_LEFT,
  TOP_CENTER,
  TOP_RIGHT,
  CENTER_LEFT,
  CENTER,
  CENTER_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_CENTER,
  BOTTOM_RIGHT
};

function isCloseRelative(a: number, b: number, tolerance: number = 1e-5): boolean {
  if (a === b) return true; // 处理 0 的情况
  const diff = Math.abs(a - b);
  const max = Math.max(Math.abs(a), Math.abs(b));
  return diff / max < tolerance;
}

export default function convertToArtboardSpaceTest() {
  describe('ConvertToArtboardSpaceTest', () => {
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
    })

    /**
     * 测试Fit枚举的所有类型
     */
    it('ConvertToArtboardSpace_fit_enum_types', 0, async (done: Function) => {
      const touchSpaceRectF: RectF = {
        left: 0,
        top: 0,
        right: 400,
        bottom: 400
      };
      const touchSpacePointF: PointF = {
        x: 200,
        y: 200
      };
      const artboardSpaceRectF: RectF = {
        left: 0,
        top: 0,
        right: 200,
        bottom: 200
      };
      const alignmentValue = Alignment.CENTER;
      const scaleFactor = 1.0;
      // 测试所有Fit枚举类型
      const fitTestCases: FitTestCase[] = [
        { name: "FILL", value: Fit.FILL, expected: { x: 100, y: 100 } },
        { name: "CONTAIN", value: Fit.CONTAIN, expected: { x: 100, y: 100 } },
        { name: "COVER", value: Fit.COVER, expected: { x: 100, y: 100 } },
        { name: "FIT_WIDTH", value: Fit.FIT_WIDTH, expected: { x: 100, y: 100 } },
        { name: "FIT_HEIGHT", value: Fit.FIT_HEIGHT, expected: { x: 100, y: 100 } },
        { name: "NONE", value: Fit.NONE, expected: { x: 100, y: 100 } },
        { name: "SCALE_DOWN", value: Fit.SCALE_DOWN, expected: { x: 100, y: 100 } },
        { name: "LAYOUT", value: Fit.LAYOUT, expected: { x: 200, y: 200 } }
      ];
      for (let testCase of fitTestCases) {
        try {
          hilog.info(0x0000, 'testTag', `ConvertToArtboardSpace Fit ${testCase.name} (${testCase.value})`);
          const resultPoint: object = rive.Napi_Helper_cppConvertToArtboardSpace(
            touchSpaceRectF,
            touchSpacePointF,
            testCase.value,
            alignmentValue,
            artboardSpaceRectF,
            scaleFactor
          );
          expect(resultPoint == null).assertFalse();
          expect(resultPoint == undefined).assertFalse();
          const point = resultPoint as PointF;
          expect(typeof point.x).assertEqual('number');
          expect(typeof point.y).assertEqual('number');
          expect(isFinite(point.x)).assertTrue();
          expect(isFinite(point.y)).assertTrue();
          expect(isCloseRelative(point.x, testCase.expected.x)).assertTrue();
          expect(isCloseRelative(point.y, testCase.expected.y)).assertTrue();
          hilog.info(0x0000, 'testTag', `ConvertToArtboardSpace Fit ${testCase.name} (${testCase.value}) result: x=${point.x}, y=${point.y}`);
        } catch (error) {
          hilog.error(0x0000, 'testTag', 'ConvertToArtboardSpace Fit %s error: %{public}s', testCase.name, error.message);
          expect().message(`ConvertToArtboardSpace with fit ${testCase.name} should not throw error`);
        }
      }
      done();
    });

    /**
     * 测试Alignment枚举的所有类型
     */
    it('ConvertToArtboardSpace_alignment_enum_types', 0, async (done: Function) => {
      const touchSpaceRectF: RectF = {
        left: 0,
        top: 0,
        right: 400,
        bottom: 400
      };
      const artboardSpaceRectF: RectF = {
        left: 0,
        top: 0,
        right: 200,
        bottom: 200
      };
      const fitValue = Fit.CONTAIN;
      const scaleFactor = 1.0;
      // 测试常见Alignment值
      const alignmentTestCases: alignmentTestCase[] = [
        { name: "TOP_LEFT", value: Alignment.TOP_LEFT, touchPoint: { x: 0, y: 0 }, expected: { x: 0, y: 0 } },
        { name: "TOP_CENTER", value: Alignment.TOP_CENTER, touchPoint: { x: 200, y: 0 }, expected: { x: 100, y: 0 } },
        { name: "TOP_RIGHT", value: Alignment.TOP_RIGHT, touchPoint: { x: 400, y: 0 }, expected: { x: 200, y: 0 } },
        { name: "CENTER_LEFT", value: Alignment.CENTER_LEFT, touchPoint: { x: 0, y: 200 }, expected: { x: 0, y: 100 } },
        { name: "CENTER", value: Alignment.CENTER, touchPoint: { x: 200, y: 200 }, expected: { x: 100, y: 100 } },
        { name: "CENTER_RIGHT", value: Alignment.CENTER_RIGHT, touchPoint: { x: 400, y: 200 }, expected: { x: 200, y: 100 } },
        { name: "BOTTOM_LEFT", value: Alignment.BOTTOM_LEFT, touchPoint: { x: 0, y: 400 }, expected: { x: 0, y: 200 } },
        { name: "BOTTOM_CENTER", value: Alignment.BOTTOM_CENTER, touchPoint: { x: 200, y: 400 }, expected: { x: 100, y: 200 } },
        { name: "BOTTOM_RIGHT", value: Alignment.BOTTOM_RIGHT, touchPoint: { x: 400, y: 400 }, expected: { x: 200, y: 200 } }
      ];
      for (let testCase of alignmentTestCases) {
        try {
          const resultPoint : object = rive.Napi_Helper_cppConvertToArtboardSpace(
            touchSpaceRectF,
            testCase.touchPoint,
            fitValue,
            testCase.value,
            artboardSpaceRectF,
            scaleFactor
          );
          expect(resultPoint == null).assertFalse();
          expect(resultPoint == undefined).assertFalse();
          const point = resultPoint as PointF;
          expect(typeof point.x).assertEqual('number');
          expect(typeof point.y).assertEqual('number');
          expect(isFinite(point.x)).assertTrue();
          expect(isFinite(point.y)).assertTrue();
          expect(isCloseRelative(point.x, testCase.expected.x)).assertTrue();
          expect(isCloseRelative(point.y, testCase.expected.y)).assertTrue();
          hilog.info(0x0000, 'testTag', `ConvertToArtboardSpace Alignment ${testCase.name} (${testCase.value}) touch(${testCase.touchPoint.x},${testCase.touchPoint.y}) -> result: x=${point.x}, y=${point.y}`);
        } catch (error) {
          hilog.error(0x0000, 'testTag', 'ConvertToArtboardSpace Alignment %s error: %{public}s', testCase.name, error.message);
          expect().message(`ConvertToArtboardSpace with alignment ${testCase.name} should not throw error`);
        }
      }

      done();
    });

    /**
     * 测试不同宽高比的情况
     */
    it('ConvertToArtboardSpace_aspect_ratio_variations', 0, async (done: Function) => {
      const scaleFactor = 1.0;
      // 测试不同宽高比的情况，包括不同的fit和alignment组合
      const aspectRatioTestCases : aspectRatioTestCase[] = [
      // 1. 宽触摸区域，高艺术板区域
        {
          name: "Wide touch, tall artboard with CONTAIN and CENTER",
          touchRect: { left: 0, top: 0, right: 800, bottom: 400 },
          artboardRect: { left: 0, top: 0, right: 200, bottom: 400 },
          touchPoint: { x: 400, y: 200 },
          fitValue: Fit.CONTAIN,
          alignmentValue: Alignment.CENTER,
          expected: { x: 100, y: 200 }
        },
        {
          name: "Wide touch, tall artboard with FILL and TOP_LEFT",
          touchRect: { left: 0, top: 0, right: 800, bottom: 400 },
          artboardRect: { left: 0, top: 0, right: 200, bottom: 400 },
          touchPoint: { x: 400, y: 200 },
          fitValue: Fit.FILL,
          alignmentValue: Alignment.TOP_LEFT,
          expected: { x: 100, y: 200 }
        },
        // 2. 高触摸区域，宽艺术板区域
        {
          name: "Tall touch, wide artboard with CONTAIN and CENTER",
          touchRect: { left: 0, top: 0, right: 400, bottom: 800 },
          artboardRect: { left: 0, top: 0, right: 400, bottom: 200 },
          touchPoint: { x: 200, y: 400 },
          fitValue: Fit.CONTAIN,
          alignmentValue: Alignment.CENTER,
          expected: { x: 200, y: 100 }
        },
        {
          name: "Tall touch, wide artboard with COVER and BOTTOM_RIGHT",
          touchRect: { left: 0, top: 0, right: 400, bottom: 800 },
          artboardRect: { left: 0, top: 0, right: 400, bottom: 200 },
          touchPoint: { x: 200, y: 400 },
          fitValue: Fit.COVER,
          alignmentValue: Alignment.BOTTOM_RIGHT,
          expected: { x: 350, y: 100 }
        },
        // 3. 相同宽高比
        {
          name: "Same aspect ratio with CONTAIN and CENTER",
          touchRect: { left: 0, top: 0, right: 400, bottom: 400 },
          artboardRect: { left: 0, top: 0, right: 200, bottom: 200 },
          touchPoint: { x: 200, y: 200 },
          fitValue: Fit.CONTAIN,
          alignmentValue: Alignment.CENTER,
          expected: { x: 100, y: 100 }
        },
        {
          name: "Same aspect ratio with NONE and TOP_LEFT",
          touchRect: { left: 0, top: 0, right: 400, bottom: 400 },
          artboardRect: { left: 0, top: 0, right: 200, bottom: 200 },
          touchPoint: { x: 200, y: 200 },
          fitValue: Fit.NONE,
          alignmentValue: Alignment.TOP_LEFT,
          expected: { x: 200, y: 200 }
        },
        // 4. 极端宽高比
        {
          name: "Very wide touch, narrow artboard with CONTAIN and CENTER",
          touchRect: { left: 0, top: 0, right: 1000, bottom: 100 },
          artboardRect: { left: 0, top: 0, right: 200, bottom: 400 },
          touchPoint: { x: 500, y: 50 },
          fitValue: Fit.CONTAIN,
          alignmentValue: Alignment.CENTER,
          expected: { x: 100, y: 200 }
        },
        {
          name: "Very narrow touch, tall artboard with COVER and CENTER_LEFT",
          touchRect: { left: 0, top: 0, right: 100, bottom: 1000 },
          artboardRect: { left: 0, top: 0, right: 400, bottom: 200 },
          touchPoint: { x: 50, y: 500 },
          fitValue: Fit.COVER,
          alignmentValue: Alignment.CENTER_LEFT,
          expected: { x: 10, y: 100 }
        },
        // 5. 不同对齐方式
        {
          name: "Wide touch, tall artboard with CONTAIN and TOP_LEFT",
          touchRect: { left: 0, top: 0, right: 800, bottom: 400 },
          artboardRect: { left: 0, top: 0, right: 200, bottom: 400 },
          touchPoint: { x: 0, y: 0 },
          fitValue: Fit.CONTAIN,
          alignmentValue: Alignment.TOP_LEFT,
          expected: { x: 0, y: 0 }
        },
        {
          name: "Wide touch, tall artboard with CONTAIN and BOTTOM_RIGHT",
          touchRect: { left: 0, top: 0, right: 800, bottom: 400 },
          artboardRect: { left: 0, top: 0, right: 200, bottom: 400 },
          touchPoint: { x: 800, y: 400 },
          fitValue: Fit.CONTAIN,
          alignmentValue: Alignment.BOTTOM_RIGHT,
          expected: { x: 200, y: 400 }
        },
        // 6. FIT模式测试
        {
          name: "Tall touch, wide artboard with FIT_WIDTH and CENTER",
          touchRect: { left: 0, top: 0, right: 400, bottom: 800 },
          artboardRect: { left: 0, top: 0, right: 400, bottom: 200 },
          touchPoint: { x: 200, y: 400 },
          fitValue: Fit.FIT_WIDTH,
          alignmentValue: Alignment.CENTER,
          expected: { x: 200, y: 100 }
        },
        {
          name: "Wide touch, tall artboard with FIT_HEIGHT and CENTER",
          touchRect: { left: 0, top: 0, right: 800, bottom: 400 },
          artboardRect: { left: 0, top: 0, right: 200, bottom: 400 },
          touchPoint: { x: 400, y: 200 },
          fitValue: Fit.FIT_HEIGHT,
          alignmentValue: Alignment.CENTER,
          expected: { x: 100, y: 200 }
        }
      ];
      for (let testCase of aspectRatioTestCases) {
        try {
          const resultPoint: object = rive.Napi_Helper_cppConvertToArtboardSpace(
            testCase.touchRect,
            testCase.touchPoint,
            testCase.fitValue,
            testCase.alignmentValue,
            testCase.artboardRect,
            scaleFactor
          );
          expect(resultPoint == null).assertFalse();
          expect(resultPoint == undefined).assertFalse();
          const point = resultPoint as PointF;
          expect(typeof point.x).assertEqual('number');
          expect(typeof point.y).assertEqual('number');
          expect(isFinite(point.x)).assertTrue();
          expect(isFinite(point.y)).assertTrue();
          expect(isCloseRelative(point.x, testCase.expected.x)).assertTrue();
          expect(isCloseRelative(point.y, testCase.expected.y)).assertTrue();
          hilog.info(0x0000, 'testTag', `ConvertToArtboardSpace ${testCase.name} result: x=${point.x}, y=${point.y}`);
        } catch (error) {
          hilog.error(0x0000, 'testTag', `ConvertToArtboardSpace ${testCase.name} test error: ${error.message}`);
          expect().message(`${testCase.name} test should not throw error`);
        }
      }
      done();
    });

    /**
     * 测试边界坐标点
     */
    it('ConvertToArtboardSpace_boundary_coordinates', 0, async (done: Function) => {
      const touchSpaceRectF: RectF = {
        left: 0,
        top: 0,
        right: 400,
        bottom: 400
      };
      const artboardSpaceRectF: RectF = {
        left: 0,
        top: 0,
        right: 200,
        bottom: 200
      };
      const fitValue = Fit.CONTAIN;
      const alignmentValue = Alignment.CENTER;
      const scaleFactor = 1.0;
      // 测试边缘坐标点
      const edgePoints: edgePointTestCase[] = [
        { name: "Top-left corner", point: { x: 0, y: 0 }, expected: { x: 0, y: 0 } },
        { name: "Top-right corner", point: { x: 400, y: 0 }, expected: { x: 200, y: 0 } },
        { name: "Bottom-left corner", point: { x: 0, y: 400 }, expected: { x: 0, y: 200 } },
        { name: "Bottom-right corner", point: { x: 400, y: 400 }, expected: { x: 200, y: 200 } },
        { name: "Top center", point: { x: 200, y: 0 }, expected: { x: 100, y: 0 } },
        { name: "Left center", point: { x: 0, y: 200 }, expected: { x: 0, y: 100 } },
        { name: "Right center", point: { x: 400, y: 200 }, expected: { x: 200, y: 100 } },
        { name: "Bottom center", point: { x: 200, y: 400 }, expected: { x: 100, y: 200 } }
      ];
      for (let edgePoint of edgePoints) {
        try {
          const resultPoint : object = rive.Napi_Helper_cppConvertToArtboardSpace(
            touchSpaceRectF,
            edgePoint.point,
            fitValue,
            alignmentValue,
            artboardSpaceRectF,
            scaleFactor
          );
          expect(resultPoint == null).assertFalse();
          expect(resultPoint == undefined).assertFalse();
          const point = resultPoint as PointF;
          expect(typeof point.x).assertEqual('number');
          expect(typeof point.y).assertEqual('number');
          expect(isFinite(point.x)).assertTrue();
          expect(isFinite(point.y)).assertTrue();
          expect(isCloseRelative(point.x, edgePoint.expected.x)).assertTrue();
          expect(isCloseRelative(point.y, edgePoint.expected.y)).assertTrue();
          hilog.info(0x0000, 'testTag', `ConvertToArtboardSpace ${edgePoint.name} (${edgePoint.point.x}, ${edgePoint.point.y}) -> (${point.x}, ${point.y})`);
        } catch (error) {
          hilog.error(0x0000, 'testTag', `ConvertToArtboardSpace ${edgePoint.name} test error: ${error.message}`);
          expect().message(`ConvertToArtboardSpace ${edgePoint.name} test should not throw error`);
        }
      }
      done();
    });

    /**
     * 测试不同缩放因子
     */
    it('ConvertToArtboardSpace_scale_factor_variations', 0, async (done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'ConvertToArtboardSpace_scale_factor_variations begin');
      const touchSpaceRectF: RectF = {
        left: 0,
        top: 0,
        right: 400,
        bottom: 400
      };
      const touchSpacePointF: PointF = {
        x: 200,
        y: 200
      };
      const artboardSpaceRectF: RectF = {
        left: 0,
        top: 0,
        right: 200,
        bottom: 200
      };
      const fitValue = Fit.LAYOUT;
      const alignmentValue = Alignment.CENTER;
      // 测试不同缩放因子
      const scaleFactors : scaleFactorTestCase[] = [
        { value: 0.5, expected: { x: 400, y: 400 } },
        { value: 1.0, expected: { x: 200, y: 200 } },
        { value: 2.0, expected: { x: 100, y: 100 } },
        { value: 0.1, expected: { x: 2000, y: 2000 } }
      ];
      for (let scaleFactorTest of scaleFactors) {
        try {
          const resultPoint : object = rive.Napi_Helper_cppConvertToArtboardSpace(
            touchSpaceRectF,
            touchSpacePointF,
            fitValue,
            alignmentValue,
            artboardSpaceRectF,
            scaleFactorTest.value
          );
          expect(resultPoint == null).assertFalse();
          expect(resultPoint == undefined).assertFalse();
          const point = resultPoint as PointF;
          expect(typeof point.x).assertEqual('number');
          expect(typeof point.y).assertEqual('number');
          expect(isFinite(point.x)).assertTrue();
          expect(isFinite(point.y)).assertTrue();
          expect(isCloseRelative(point.x, scaleFactorTest.expected.x)).assertTrue();
          expect(isCloseRelative(point.y, scaleFactorTest.expected.y)).assertTrue();
          hilog.info(0x0000, 'testTag', `ConvertToArtboardSpace Scale factor ${scaleFactorTest.value} -> x=${point.x}, y=${point.y}`);
        } catch (error) {
          hilog.error(0x0000, 'testTag', `ConvertToArtboardSpace Scale factor ${scaleFactorTest.value} test error: ${error.message}`);
          expect().message(`ConvertToArtboardSpace Scale factor ${scaleFactorTest.value} test should not throw error`);
        }
      }
      done();
    });

    /**
     * 测试特殊Fit模式的精确坐标
     */
    it('ConvertToArtboardSpace_fit_mode_precision', 0, async (done: Function) => {
      const touchSpaceRectF : RectF = {
        left: 0,
        top: 0,
        right: 400,
        bottom: 400
      };
      const artboardSpaceRectF : RectF = {
        left: 0,
        top: 0,
        right: 200,
        bottom: 100  // 不同比例
      };
      const alignmentValue = Alignment.CENTER;
      const scaleFactor = 1.0;
      // 测试特定Fit模式的精确坐标
      const precisionTestCases : precisionTestCase[] = [
        {
          name: "FILL mode",
          fitValue: Fit.FILL,
          touchPoint: { x: 200, y: 200 },
          expected: { x: 100, y: 50 }
        },
        {
          name: "CONTAIN mode",
          fitValue: Fit.CONTAIN,
          touchPoint: { x: 200, y: 200 },
          expected: { x: 100, y: 50 }
        },
        {
          name: "COVER mode",
          fitValue: Fit.COVER,
          touchPoint: { x: 200, y: 200 },
          expected: { x: 100, y: 50 }
        },
        {
          name: "NONE mode",
          fitValue: Fit.NONE,
          touchPoint: { x: 100, y: 50 },
          expected: { x: 0, y: -100 }
        }
      ];
      for (let testCase of precisionTestCases) {
        try {
          const resultPoint : object = rive.Napi_Helper_cppConvertToArtboardSpace(
            touchSpaceRectF,
            testCase.touchPoint,
            testCase.fitValue,
            alignmentValue,
            artboardSpaceRectF,
            scaleFactor
          );
          expect(resultPoint == null).assertFalse();
          expect(resultPoint == undefined).assertFalse();
          const point = resultPoint as PointF;
          expect(typeof point.x).assertEqual('number');
          expect(typeof point.y).assertEqual('number');
          expect(isFinite(point.x)).assertTrue();
          expect(isFinite(point.y)).assertTrue();
          expect(isCloseRelative(point.x, testCase.expected.x)).assertTrue();
          expect(isCloseRelative(point.y, testCase.expected.y)).assertTrue();
          hilog.info(0x0000, 'testTag', `ConvertToArtboardSpace ${testCase.name} touch(${testCase.touchPoint.x},${testCase.touchPoint.y}) -> result: x=${point.x}, y=${point.y}`);
        } catch (error) {
          hilog.error(0x0000, 'testTag', `ConvertToArtboardSpace ${testCase.name} test error: ${error.message}`);
          expect().message(`ConvertToArtboardSpace ${testCase.name} test should not throw error`);
        }
      }
      done();
    });

    /**
     * 测试无效输入参数的情况
     */
    it('ConvertToArtboardSpace_invalid_input_handling', 0, async (done: Function) => {
      const touchSpaceRectF : RectF = {
        left: 0,
        top: 0,
        right: 400,
        bottom: 400
      };
      const artboardSpaceRectF : RectF = {
        left: 0,
        top: 0,
        right: 200,
        bottom: 200
      };
      const fitValue = Fit.CONTAIN;
      const alignmentValue = Alignment.CENTER;
      const scaleFactor = 1.0;
      // 测试缺少必要属性的情况 缺少 y 属性
      const incompleteTouchPoint: anyNumber = {
        x: 100
      };
      try {
        const resultPoint : object = rive.Napi_Helper_cppConvertToArtboardSpace(
          touchSpaceRectF,
          incompleteTouchPoint,
          fitValue,
          alignmentValue,
          artboardSpaceRectF,
          scaleFactor
        );
        expect(resultPoint == null).assertTrue();
      } catch (error) {
        hilog.info(0x0000, 'testTag', `ConvertToArtboardSpace Invalid input correctly threw exception: ${error.message}`);
      }
      done();
    });

    /**
     * 测试浮点数精度
     */
    it('ConvertToArtboardSpace_float_precision_test', 0, async (done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'ConvertToArtboardSpace_float_precision_test begin');
      const touchSpaceRectF : RectF = {
        left: 0,
        top: 0,
        right: 400,
        bottom: 400
      };
      const touchSpacePointF : PointF = {
        x: 200.5,
        y: 200.7
      };
      const artboardSpaceRectF : RectF = {
        left: 0,
        top: 0,
        right: 200,
        bottom: 200
      };
      const fitValue = Fit.CONTAIN;
      const alignmentValue = Alignment.CENTER;
      const scaleFactor = 1.5;
      try {
        const resultPoint : object = rive.Napi_Helper_cppConvertToArtboardSpace(
          touchSpaceRectF,
          touchSpacePointF,
          fitValue,
          alignmentValue,
          artboardSpaceRectF,
          scaleFactor
        );
        expect(resultPoint == null).assertFalse();
        expect(resultPoint == undefined).assertFalse();
        const point = resultPoint as PointF;
        expect(typeof point.x).assertEqual('number');
        expect(typeof point.y).assertEqual('number');
        expect(isFinite(point.x)).assertTrue();
        expect(isFinite(point.y)).assertTrue();
        expect(isCloseRelative(point.x, 100.25)).assertTrue();
        expect(isCloseRelative(point.y, 100.35)).assertTrue();
        hilog.info(0x0000, 'testTag', `ConvertToArtboardSpace Float precision test result: x=${point.x}, y=${point.y}`);
      } catch (error) {
        hilog.error(0x0000, 'testTag', 'ConvertToArtboardSpace Float precision test error: %{public}s', error.message);
        expect().message('ConvertToArtboardSpace Float precision test should not throw error');
      }
      done();
    });
  })
}