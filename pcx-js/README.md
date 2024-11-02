# pcx-js

## Introduction

This library uses the open-source [pcx-js](https://github.com/warpdesign/pcx-js) to provide the PCX image decoding capability in OpenHarmony.

## How to Install

```shell
ohpm install pcx-js
ohpm install @types/pcx-js --save-dev
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use

### PCX Decoding

```typescript
import image from '@ohos.multimedia.image';
import util from '@ohos.util';
import PCX from 'pcx-js';

typedArrayToBuffer(array: Uint8ClampedArray): ArrayBuffer {
  return array.buffer.slice(array.byteOffset, array.byteLength + array.byteOffset)
}
        
getContext(this).resourceManager.getMediaContent($r("app.media.thimbleweed").id).then((uint8Array) => {
	let pcxDecoder = new PCX(uint8Array.buffer);
    // Obtain the pixel data of the decoded PCX image. The default value is RGBA.
	let decodeData = pcxDecoder.decode();
    // Convert the format to BGRA.
	this.RBGA2BGRA(decodeData.pixelArray)
	// Convert the image into a pixel map.
    image.createPixelMap(this.typedArrayToBuffer(decodeData.pixelArray), {
		'size': {
		'width':  decodeData.width,
		'height':  decodeData.height
		}
	}).then((pixels) => {
		this.p1Pixels = pixels;
		})
	})
```

## Available APIs
| API              |                 Parameter                |Description|
|:-------------------|:----------------------------------:| -----:|
| new PCX(buffer)    | **Buffer**: buffer for decoding PCX data.|Creates a PCX decoder instance.|
| decode             |                                    |Decodes a PCX image.|

## Constraints

This project has been verified in the following version:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.1Canary2 (4.1.3.322), SDK: API11 (4.1.0.36)

## Directory Structure

```

/entry/src/
- main/ets/     
    - pages                        # List of test pages
       - index.ets                 # APIs for PCX image decoding.
```

For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/pcx-js/TEST.md).

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

The project is licensed under MIT License.
