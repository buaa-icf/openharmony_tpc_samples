

## d3.js easing Functions

## Introduction

The library is a UI animation component. The easing function is used to describe a change rate of a value. The value may be an attribute value such as a width, a height, transparency, rotation, or scaling of an animation object. The change rate may be represented by a function curve, to produce a UI animation effect that is more intuitive, makes the animation look more realistic. Below are the implemented functions.

![preview1](preview/preview1.gif)
![preview2](preview/preview2.gif)


## How to Install

```javascript
ohpm install d3-ease
```

For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage_en.md).


## How to Use

```
import * as Easing from 'd3-ease';
```

Example

### Step 1: Create an animation as required.

  ```javascript
import Animator, { AnimatorResult } from '@ohos.animator';

backAnimator: AnimatorResult = Animator.create({
    duration: 1000,
    easing: 'linear',
    direction: 'normal',
    iterations: 1,
    delay: 0,
    fill: 'none',
    begin: 0,
    end: 1
});
  ```

### Step 2: Implement the **onframe** method and call the function method for calculation (example of ball animation).

```javascript

  ballBeginX = 30;
  ballEndX = 320;
  @State ballAnimateValue: number = 30;

  this.animator.onframe = (normalizedTime) => {
      const distance = this.ballEndX - this.ballBeginX;
      this.ballAnimateValue = this.ballBeginX + Easing.Linear(normalizedTime) * distance;
  }

  build() {
        Column() {
              Stack({alignContent: Alignment.TopStart}) {
                  // The ball animation is applied to the **margin left** attribute.
                  Column(){}.width(28).height(28)
                      .backgroundColor('#ff0991ec')
                      .borderRadius(14)
                      .margin({left: this.ballAnimateValue, top: 14});
              }
        }
  }
```

## Available APIs

### Easing

| API             | Type  | Return Value Type | Description                  |
|------------------|--------|--------|----------------------|
| easeBackIn       | number | number | Anticipatory easing, similar to a dancer bending their knees before jumping. The overshoot is configurable. If not specified, it defaults to 1.70158.              |
| easeBackOut      | number | number | Reverse anticipatory easing; equivalent to `1 - backIn(1 - t)`.              |
| easeBackInOut    | number | number | Symmetric anticipatory easing; uses `backIn` when `t` is in `[0, 0.5]` and `backOut` when `t` is in `[0.5, 1]`.              |
| easeBounceIn     | number | number | Bounce easing, like a rubber ball.              |
| easeBounceOut    | number | number | Reverse Bounce easing, equivalent to `1 - bounceIn(1 - t)`.              |
| easeBounceInOut  | number | number | Symmetric Bounce easing; uses `bounceIn` when `t` is in `[0, 0.5]` and `bounceOut` when `t` is in `[0.5, 1]`.              |
| easeCircleIn     | number | number | Circular easing.             |
| easeCircleOut    | number | number | Reverse Circular easing, equivalent to `1 - circleIn(1 - t)`.             |
| easeCircleInOut  | number | number | Symmetric Circular easing; uses `circleIn` when `t` is in `[0, 0.5]` and `circleOut` when `t` is in `[0.5, 1]`.             |
| easeCubicIn      | number | number | Cubic easing; equivalent to `polyIn.exponent(3)`.            |
| easeCubicOut     | number | number | Reverse cubic easing; equivalent to `1 - cubicIn(1 - t)`. Also equivalent to `polyOut.exponent(3)`.            |
| easeCubicInOut   | number | number | Symmetric cubic easing; uses `cubicIn` when `t` is in `[0, 0.5]` and `cubicOut` when `t` is in `[0.5, 1]`. Also equivalent to `poly.exponent(3)`.            |
| easeElasticIn    | number | number | Elastic easing, like a bouncing rubber band. The amplitude and period of the oscillation are configurable; if not specified, they default to 1 and 0.3, respectively.             |
| easeElasticOut   | number | number | Reverse elastic easing, equivalent to `1 - elasticIn(1 - t)`.             |
| easeElasticInOut | number | number | Symmetric elastic easing; uses `elasticIn` when `t` is in `[0, 0.5]` and `elasticOut` when `t` is in `[0.5, 1]`.             |
| easeExpIn        | number | number | Exponential easing; maps to `2^(10 * (t - 1))`.            |
| easeExpOut       | number | number | Reverse exponential easing, equivalent to `1 - expIn(1 - t)`.            |
| easeExpInOut     | number | number | Symmetric exponential easing; uses `expIn` when `t` is in `[0, 0.5]` and `expOut` when `t` is in `[0.5, 1]`.            |
| easeQuadIn       | number | number | Quadratic easing; equivalent to `polyIn.exponent(2)`.            |
| easeQuadOut      | number | number | Reverse quadratic easing; equivalent to `1 - quadIn(1 - t)`. Also equivalent to `polyOut.exponent(2)`.            |
| easeQuadInOut    | number | number | Symmetric quadratic easing; uses `quadIn` when `t` is in `[0, 0.5]` and `quadOut` when `t` is in `[0.5, 1]`. Also equivalent to `poly.exponent(2)`.            |
| easePolyIn       | number | number | Polynomial easing; raises `t` to the power of `exponent`. If the exponent is not specified, it defaults to 3, equivalent to `cubicIn`.            |
| easePolyOut      | number | number | Reverse polynomial easing; equivalent to `1 - polyIn(1 - t)`. If the exponent is not specified, it defaults to 3, equivalent to `cubicOut`.            |
| easePolyInOut    | number | number | Symmetric polynomial easing; uses `polyIn` when `t` is in `[0, 0.5]` and `polyOut` when `t` is in `[0.5, 1]`. If the exponent is not specified, it defaults to 3, equivalent to `cubic`.            |
| easeSinIn        | number | number | Sinusoidal easing; returns `sin(t)`.            |
| easeSinOut       | number | number | Reverse sinusoidal easing; equivalent to `1 - sinIn(1 - t)`.            |
| easeSinInOut     | number | number | Symmetric sinusoidal easing; uses `sinIn` when `t` is in `[0, 0.5]` and `sinOut` when `t` is in `[0.5, 1]`.            |
| easeLinear   | number | number | Linear easing. The identity function, `linear(t)` returns `t`.              |


## Constraints

This project has been verified in the following version:
- DevEco Studio: NEXT Release(5.0.3.900), SDK: API12 (5.0.0.71)
- DevEco Studio: NEXT Developer Beta3(5.0.3.524), SDK: API12 (5.0.0.25)
- DevEco Studio: 4.1 Canary(4.1.3.500), OpenHarmony SDK: API11 (4.1.3.1)

## Directory Structure

```javascript
|---- animationFunction  
|     |---- entry  # Sample code
|     |---- README.MD  # Readme                  
```

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [BSD 3-Clause License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/d3JsEasingDemo/LICENSE).
