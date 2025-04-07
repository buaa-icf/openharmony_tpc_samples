# utilCode

## Introduction

**UtilCode** provides common utilities and demos for OpenHarmony development, including temperature conversion, regular expression verification, image processing, coordinate conversion, and color-related operations. The following table lists the utilities provided.

| Utility| Description | Dependency Library |
| :----------- |:---------------|:---------------|
| Temperature| Converts temperature between degrees Celsius and Fahrenheit.|None|
| [Coordinate](https://github.com/star-nodejs/gcoord)| Converts coordinates to solve the problem of inconsistent coordinate systems used by different Internet maps.|ohpm install gcoord|
| [Country code](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-sim.md#simgetisocountrycodeforsim) | Obtains the country code.|None|
| [Color](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/arkui-ts/ts-universal-attributes-opacity.md)|Obtains the color.   |ohpm install randomcolor|
| [HAP](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-bundleManager-bundleInfo.md#reqpermissiondetail) |Obtains and manipulates HAPs.    |None|
| [Regular expression](https://github.com/validatorjs/validator.js)|Validates regular expressions.    |ohpm install validator |
| [Memory cache](https://github.com/ptarjan/node-cache)|Reads and writes data in the cache.    | ohpm install memory-cache |
|Time|Formats date and time.    | ohpm i time-ampm <br>ohpm i leap-year |
| [Data type](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/arkui-ts/ts-pixel-units.md)|Converts between basic data types.    |None|
| [Image](https://gitcode.com/openharmony-tpc/ImageKnife)|Processes images.    |ohpm install @ohos/imageknife <br> ohpm i imtype |

## How to Install
```shell
ohpm install randomcolor
ohpm install @types/randomcolor --save-dev // Install @types/randomcolor to prevent import syntax errors due to missing type declarations in the randomcolor package.

ohpm install memory-cache
ohpm install @types/memory-cache --save-dev // Install @types/memory-cache to prevent import syntax errors due to missing type declarations in the @types/memory-cache package.


ohpm install imtype
ohpm install @types/imtype@1.0.0  // Install @types/imtype@1.0.0 to prevent import syntax errors due to missing type declarations in the imtype package.


```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).


## How to Use

### Temperature Utility

#### Converting Fahrenheit to Celsius

``` javascript
import { TempUtils} from '@ohos/util_code'
TempUtils.F2C(89.6)
```

#### Converting Celsius to Fahrenheit

``` javascript
import { TempUtils} from '@ohos/util_code'
TempUtils.C2F(89.6)
```

### Coordinate Utility

This module is developed based on [gcoord](https://github.com/star-nodejs/gcoord).

#### Converting BD09 Coordinates to GCJ02 Coordinates

``` javascript
	import gcoord from 'gcoord'
	
	gcoord.transform(
              [116.403988, 39.914266], // Longitude and latitude coordinates.
            gcoord.BD09, // Current coordinate system.
            gcoord.GCJ02 // Target coordinate system.
            );
```

#### Converting GCJ02 Coordinates to BD09 Coordinates

``` javascript
	import gcoord from 'gcoord'
	
	gcoord.transform(
              [116.403988, 39.914266], // Longitude and latitude coordinates.
            gcoord.GCJ02, // Current coordinate system.
            gcoord.BD09// Target coordinate system
            );
```

#### Converting GCJ02 Coordinates to WGS84 Coordinates

``` javascript
	import gcoord from 'gcoord'
	
	gcoord.transform(
              [116.403988, 39.914266], // Longitude and latitude coordinates.
            gcoord.GCJ02, // Current coordinate system.
            gcoord.WGS84 // Target coordinate system.
            );
```

#### Converting WGS84 Coordinates to GCJ02 Coordinates

``` javascript
	import gcoord from 'gcoord'
	
	gcoord.transform(
              [116.403988, 39.914266], // Longitude and latitude coordinates.
            gcoord.WGS84, // Current coordinate system.
            gcoord.GCJ02 // Target coordinate system.
            );
```

#### Converting BD09 Coordinates to WGS84 Coordinates

``` javascript
	import gcoord from 'gcoord'
	
	gcoord.transform(
              [116.403988, 39.914266], // Longitude and latitude coordinates.
            gcoord.BD09, // Current coordinate system.
            gcoord.WGS84 // Target coordinate system.
            );
```

#### Converting WGS84 Coordinates to BD09 Coordinates

``` javascript
	import gcoord from 'gcoord'
	
	gcoord.transform(
              [116.403988, 39.914266], // Longitude and latitude coordinates.
            gcoord.WGS84, // Current coordinate system.
            gcoord.BD09// Target coordinate system
            );
```

### Country Code Utility

#### Obtaining the ISO Country Code Based on the SIM

[getISOCountryCodeForSim(slotId: number, callback: AsyncCallback<string>): void](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/zh-cn/application-dev/reference/apis/js-apis-sim.md#simgetisocountrycodeforsim
)

Obtains the ISO country code of the SIM card in the specified slot. This API uses an asynchronous callback to return the result.

``` javascript
	import sim from '@ohos.telephony.sim';
	
        sim.getISOCountryCodeForSim(0, (err, data) => {
            console.log(`callback: err->${JSON.stringify(err)}, data->${JSON.stringify(data)}`);
        });
```

#### Obtaining the System Region

[static getSystemRegion(): string](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/zh-cn/application-dev/reference/apis/js-apis-i18n.md#getsystemregion9)

Obtains the system region. For details about the region, see the **Locale** instance.

**System capability**: SystemCapability.Global.I18n

``` javascript
import I18n from '@ohos.i18n';
try {
  let systemRegion = I18n.System.getSystemRegion(); // Obtain the current system region.
} catch(error) {
  console.error(`call System.getSystemRegion failed, error code: ${error.code}, message: ${error.message}.`);
}
```

#### Obtaining the Country Code by Language

``` javascript
import { CountryUtils} from '@ohos/util_code'
 CountryUtils.getCountryCodeByLanguage() // Return the country code (international dialing prefix).
```

#### Obtaining the Dialing Prefix Based on the SIM Card

``` javascript
import { CountryUtils} from '@ohos/util_code'
 CountryUtils.getCountryCodeByLanguage() // Return the country code (international dialing prefix).
```

#### Obtaining the Country Code

``` javascript
import {CountryUtils} from '@ohos/util_code'
CountryUtils.getCountryCode('CN')
```

### Color Utility

This module is developed based on [randomcolor](https://github.com/davidmerfield/randomColor).

#### Obtaining Random Colors

You can pass in an option object to determine the type of color to obtain. The option object can hold the following properties.

|                                            Name|Description   |
| :----------- |:---------------|
| hue      | Base color. You can pass in a string representing the color name, such as **red**, **orange**, **yellow**, **green**, **blue**, **purple**, or **pink** or monochrome. If you pass in a hexadecimal color string such as **#00FFFF**, **randomColor** extracts its hue value and generates a color based on it.|
| luminosity      | Brightness of the color to generate. You can pass in a string, such as **dark** or **light**.|
| count      | Number of random colors to generate.|
| seed      | An integer or string that allows **randomColor** to return the same sequence of colors.|
| format      | Format of the color to generate. The value can be **rgb**, **rgba**, **rgbArray**, **hsl**, **hsla**, **hslArray**, or **hex** (default). |
| alphargba      | Opacity level of the color when formats that support alpha channels are used. It is a decimal between 0 and 1. It is a random value by default. |

``` javascript
// @ts-ignore
import randomColor from 'randomcolor';

// Returns a hex code for an attractive color
randomColor(); 

// Returns an array of ten green colors
randomColor({
   count: 10,
   hue: 'green'
});

// Returns a hex code for a light blue
randomColor({
   luminosity: 'light',
   hue: 'blue'
});

// Returns a hex code for a 'truly random' color
randomColor({
   luminosity: 'random',
   hue: 'random'
});

// Returns a bright color in RGB
randomColor({
   luminosity: 'bright',
   format: 'rgb' // e.g. 'rgb(225,200,20)'
});

// Returns a dark RGB color with random alpha
randomColor({
   luminosity: 'dark',
   format: 'rgba' // e.g. 'rgba(9, 1, 107, 0.6482447960879654)'
});

// Returns a dark RGB color with specified alpha
randomColor({
   luminosity: 'dark',
   format: 'rgba',
   alpha: 0.5 // e.g. 'rgba(9, 1, 107, 0.5)',
});

// Returns a light HSL color with random alpha
randomColor({
   luminosity: 'light',
   format: 'hsla' // e.g. 'hsla(27, 88.99%, 81.83%, 0.6450211517512798)'
});

```

#### Obtaining Colors

You can use **$r('sys.type.resource_id')** to [reference a system resource](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/zh-cn/application-dev/quick-start/resource-categories-and-access.md#%E7%B3%BB%E7%BB%9F%E8%B5%84%E6%BA%90). 

- **sys** indicates a system resource. 
- **type** specifies the resource type, which can be **color**, **float**, **string**, or **media**. 
- **resource_id** specifies the resource ID.  

``` javascript
Text($r('app.string.message_arrive', "five of the clock"))
  .fontColor($r('app.color.color_hello'))
  .fontSize($r('app.float.font_hello'))
```

#### Setting the Color Opacity

For details, see [Opacity](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/arkui-ts/ts-universal-attributes-opacity.md).

**Properties**

| Name     | Type                                    | Description                                      |
| ------- | ---------------------------------------- | ---------------------------------------- |
| opacity | number I [Resource](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/arkui-ts/ts-types.md#resource)| Opacity of the color, which ranges from 0 to 1.<br/>The value **1** means opaque, and **0** means completely transparent. When being completely transparent, the component is hidden but still takes up space in the layout.<br>Default value: **1**<br/>**NOTE**<br>A component can inherit the opacity setting from its parent component.<br>This API can be used in ArkTS widgets since API version 9. |

``` ts
// xxx.ets
@Entry
@Component
struct OpacityExample {
  build() {
    Column({ space: 5 }) {
      Text('opacity(1)').fontSize(9).width('90%').fontColor(0xCCCCCC)
      Text().width('90%').height(50).opacity(1).backgroundColor(0xAFEEEE)
      Text('opacity(0.7)').fontSize(9).width('90%').fontColor(0xCCCCCC)
      Text().width('90%').height(50).opacity(0.7).backgroundColor(0xAFEEEE)
      Text('opacity(0.4)').fontSize(9).width('90%').fontColor(0xCCCCCC)
      Text().width('90%').height(50).opacity(0.4).backgroundColor(0xAFEEEE)
      Text('opacity(0.1)').fontSize(9).width('90%').fontColor(0xCCCCCC)
      Text().width('90%').height(50).opacity(0.1).backgroundColor(0xAFEEEE)
      Text('opacity(0)').fontSize(9).width('90%').fontColor(0xCCCCCC)
      Text().width('90%').height(50).opacity(0).backgroundColor(0xAFEEEE)
    }
    .width('100%')
    .padding({ top: 5 })
  }
}
```

#### Obtaining Colors Red, Green, and Blue

For details, see [Color](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/arkui-ts/ts-appendix-enums.md).


| Color                | Value  | Illustration                                                    |
| ------------------------ | -------- | ------------------------------------------------------------ |
| Black                    | 0x000000 | ![img.png](img/img.png)|
| Blue                     | 0x0000ff | ![img_1.png](img/img_1.png) |
| Brown                    | 0xa52a2a | ![img_2.png](img/img_2.png)|
| Gray                     | 0x808080 | ![img_3.png](img/img_3.png) |
| Grey                     | 0x808080 | ![img_4.png](img/img_4.png) |
| Green                    | 0x008000 | ![img_5.png](img/img_5.png) |
| Orange                   | 0xffa500 | ![img_6.png](img/img_6.png) |
| Pink                     | 0xffc0cb | ![img_7.png](img/img_7.png) |
| Red                      | 0xff0000 | ![img_8.png](img/img_8.png)|
| White                    | 0xffffff |![img_9.png](img/img_9.png)|
| Yellow                   | 0xffff00 | ![img_10.png](img/img_10.png) |
| Transparent<sup>9+</sup> | rgba(0,0,0,0)  |  Transparent                                                                  |

 

### HAP Utility

#### Listening for Application Transition from Foreground to Background

[onBackground(): void;](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-app-ability-uiAbility.md#uiabilityonbackground)

Called when this ability is switched from the foreground to the background.

``` javascript
import Ability from '@ohos.app.ability.UIAbility';
class myAbility extends Ability {
    onBackground() {
        console.log('onBackground');
    }
}
```

#### Listening for Application Transition from Background to Foreground

[onForeground(): void;](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-app-ability-uiAbility.md#uiabilityonforeground)

Called when this ability is switched from the background to the foreground.

``` javascript
import Ability from '@ohos.app.ability.UIAbility';
class myAbility extends Ability {
    onForeground() {
        console.log('onForeground');
    }
}
}
```


#### Checking Application Status

[onForeground(): void;](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-app-ability-uiAbility.md#uiabilityonforeground)

Called when this ability is switched from the background to the foreground. 

**System capability**: SystemCapability.Ability.AbilityRuntime.AbilityCore

If **onForeground()**  is called, the application is in the foreground.

``` javascript
import Ability from '@ohos.app.ability.UIAbility';
class myAbility extends Ability {
    onForeground() {
        console.log('onForeground');
    }
}
}
```

#### Starting an Ability

[startAbility(want: Want, callback: AsyncCallback<void>): void;](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-inner-application-uiAbilityContext.md#uiabilitycontextstartability)

Starts an ability. This API uses an asynchronous callback to return the result.

Observe the following when using this API:

- If an application running in the background needs to call this API to start an ability, it must have the **ohos.permission.START_ABILITIES_FROM_BACKGROUND** permission.

- If **exported** of the target ability is **false**, the caller must have the **ohos.permission.START_INVISIBLE_ABILITY** permission.

- For details about the startup rules for the components in the stage model, see **Component Startup Rules (Stage Model)**.


**System capability**: SystemCapability.Ability.AbilityRuntime.Core

``` javascript
import common from '@ohos.app.ability.common';
let want = {
  bundleName: 'com.example.myapp',
  abilityName: 'MyAbility'
};

try {
  this.context.startAbility(want, (error) => {
    if (error.code) {
      // Process service logic errors.
      console.log('startAbility failed, error.code: ' + JSON.stringify(error.code) +
        ' error.message: ' + JSON.stringify(error.message));
      return;
    }
    // Carry out normal service processing.
    console.log('startAbility succeed');
  });
} catch (paramError) {
  // Process input parameter errors.
  console.log('error.code: ' + JSON.stringify(paramError.code) +
    ' error.message: ' + JSON.stringify(paramError.message));
}
```

#### Terminating an Ability

[terminateSelf(callback: AsyncCallback<void>): void;](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-inner-application-uiAbilityContext.md#uiabilitycontextterminateself)

Terminates this ability. This API uses an asynchronous callback to return the result.

**System capability**: SystemCapability.Ability.AbilityRuntime.Core

``` javascript
import common from '@ohos.app.ability.common';
this.context.terminateSelf((error) => {
  if (error.code) {
    // Process service logic errors.
    console.log('terminateSelf failed, error.code: ' + JSON.stringify(error.code) +
      ' error.message: ' + JSON.stringify(error.message));
    return;
  }
  // Carry out normal service processing.
  console.log('terminateSelf succeed');
}); error.message: ' + JSON.stringify(paramError.message));
}
```

#### Obtaining Ability Information

[queryAbilityInfo(want: Want, abilityFlags: number, userId: number, callback: AsyncCallback<Array<AbilityInfo>>): void;](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-bundleManager.md#bundlemanagerqueryabilityinfo)

Obtains an array of ability information based on the given want, ability flags, and user ID. This API uses an asynchronous callback to return the result.

**System API**: This is a system API.

**Required permissions**: ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO

**System capability**: SystemCapability.BundleManager.BundleFramework.Core

[AbilityInfo](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-bundleManager-abilityInfo.md)


**System capability**: SystemCapability.BundleManager.BundleFramework.Core

| Name                 | Type                                                    | Readable| Writable| Description                                     |
| --------------------- | -------------------------------------------------------- | ---- | ---- | ------------------------------------------ |
| bundleName            | string                                                   | Yes  | No  | Bundle name.                           |
| moduleName            | string                                                   | Yes  | No  | Name of the HAP file to which the ability belongs.                   |
| name                  | string                                                   | Yes  | No  | Ability name.                              |
| label                 | string                                                   | Yes  | No  | Ability name visible to users.                  |
| labelId               | number                                                   | Yes  | No  | ID of the ability label.                      |
| description           | string                                                   | Yes  | No  | Ability description.                            |
| descriptionId         | number                                                   | Yes  | No  | ID of the ability description.                      |
| icon                  | string                                                   | Yes  | No  | Index of the ability icon resource file.                |
| iconId                | number                                                   | Yes  | No  | ID of the ability icon.                      |
| process               | string                                                   | Yes  | No  | Process in which the ability runs. If this parameter is not set, the bundle name is used.|
| exported             | boolean                                                  | Yes  | No  | Whether the ability can be called by other bundles.        |
| type                  | AbilityType     | Yes  | No  | Ability type.<br>This property can be used only in the FA model.|
| orientation           | DisplayOrientation  | Yes  | No  | Ability display orientation.                        |
| launchType            | LaunchType      | Yes  | No  | Ability launch type.                        |
| permissions           | Array\<string>                                           | Yes  | No  | Permissions required for other applications to call the ability. The permissions can be obtained by calling **bundleManager.queryAbilityInfo** with **GET_ABILITY_INFO_WITH_PERMISSION** passed in. |
| readPermission        | string                                                   | Yes  | No  | Permission required for reading the ability data.<br>This property can be used only in the FA model.|
| writePermission       | string                                                   | Yes  | No  | Permission required for writing data to the ability.<br>This property can be used only in the FA model.|
| uri                   | string                                                   | Yes  | No  | URI of the ability.<br>This property can be used only in the FA model.|
| deviceTypes           | Array\<string>                                           | Yes  | No  | Device types supported by the ability.                    |
| applicationInfo       | ApplicationInfo    | Yes  | No  | Application information, which can be obtained by calling **bundleManager.queryAbilityInfo** with **GET_ABILITY_INFO_WITH_APPLICATION** passed in. |
| metadata              | Array\[Metadata>           | Yes  | No  | Metadata of ability, which can be obtained by calling **bundleManager.queryAbilityInfo** with **GET_ABILITY_INFO_WITH_METADATA** passed in. |
| enabled               | boolean                                                  | Yes  | No  | Whether the ability is enabled.                          |
| supportWindowModes    | Array\<SupportWindowMode> | Yes  | No  | Window modes supported by the ability.                     |
| windowSize|WindowSize                                           |    Yes  | No  | Window size.|

``` javascript
import bundleManager from '@ohos.bundle.bundleManager';
import hilog from '@ohos.hilog';
let abilityFlags = bundleManager.AbilityFlag.GET_ABILITY_INFO_DEFAULT;
let userId = 100;
let want = {
    bundleName : "com.example.myapplication",
    abilityName : "com.example.myapplication.MainAbility"
};

try {
    bundleManager.queryAbilityInfo(want, abilityFlags, userId, (err, data) => {
        if (err) {
            hilog.error(0x0000, 'testTag', 'queryAbilityInfo failed: %{public}s', err.message);
        } else {
            hilog.info(0x0000, 'testTag', 'queryAbilityInfo successfully: %{public}s', JSON.stringify(data));
        }
    });
} catch (err) {
    hilog.error(0x0000, 'testTag', 'queryAbilityInfo failed: %{public}s', err.message);
}
```

#### Obtaining HAP Information

[getBundleInfo(bundleName: string, bundleFlags: number, userId: number, callback: AsyncCallback<BundleInfo>): void;](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-bundleManager.md#/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-bundleManager-bundleInfo.md)

Obtains the bundle information based on the given bundle name, bundle flags, and user ID. This API uses an asynchronous callback to return the result.

No permission is required for obtaining the caller's own information.

**System API**: This is a system API.

**Required permissions**: ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO

**System capability**: SystemCapability.BundleManager.BundleFramework.Core

[BundleInfo](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-bundleManager-bundleInfo.md)


**System capability**: SystemCapability.BundleManager.BundleFramework.Core

| Name                             | Type                                                        | Readable| Writable| Description                                                        |
| --------------------------------- | ------------------------------------------------------------ | ---- | ---- | ------------------------------------------------------------ |
| name                              | string                                                       | Yes  | No  | Bundle name.                                              |
| vendor                            | string                                                       | Yes  | No  | Vendor of the bundle.                                              |
| versionCode                       | number                                                       | Yes  | No  | Version number of the bundle.                                             |
| versionName                       | string                                                       | Yes  | No  | Version description of the bundle.                                    |
| minCompatibleVersionCode          | number                                                       | Yes  | No  | Earliest version compatible with the bundle in the distributed scenario.                          |
| targetVersion                     | number                                                       | Yes  | No  | Target API version required for running the bundle.                               |
| appInfo                           | ApplicationInfo       | Yes  | No  | Application information, which can be obtained by calling **bundleManager.getBundleInfo** with **GET_BUNDLE_INFO_WITH_APPLICATION** passed in. |
| hapModulesInfo                    | ArrayHapModuleInfo   | Yes  | No  | Module configuration information, which can be obtained calling **GET_BUNDLE_INFO_WITH_HAP_MODULE** with **GET_BUNDLE_INFO_WITH_HAP_MODULE** passed in.                                                |
| reqPermissionDetails     | Array  | Yes  | No  | Detailed information of the permissions to request from the system. The information can be obtained by calling **bundleManager.getBundleInfo** with **GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION** passed in.|
| permissionGrantStates        | ArrayPermissionGrantState | Yes  | No  | Permission grant state, which can be obtained by calling **bundleManager.getBundleInfo** with **GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION** passed in.                    |
| signatureInfo          |SignatureInfo                                 | Yes  | No  | App package signature information, which is obtained by calling **bundleManager.getBundleInfo** with **GET_BUNDLE_INFO_WITH_SIGNATURE_INFO** passed in.                       |
| installTime                       | number                                                       | Yes  | No  | Time when the bundle was installed.                                         |
| updateTime                        | number                                                       | Yes  | No  | Time when the bundle was updated.                                           |

``` javascript
// Obtain the bundle information with the application and signature information.
import bundleManager from '@ohos.bundle.bundleManager';
import hilog from '@ohos.hilog';
let bundleName = 'com.example.myapplication';
let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION | bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO;
let userId = 100;

try {
    bundleManager.getBundleInfo(bundleName, bundleFlags, userId).then((data) => {
        hilog.info(0x0000, 'testTag', 'getBundleInfo successfully. Data: %{public}s', JSON.stringify(data));
    }).catch(err => {
        hilog.error(0x0000, 'testTag', 'getBundleInfo failed. Cause: %{public}s', err.message);
    });
} catch (err) {
    hilog.error(0x0000, 'testTag', 'getBundleInfo failed. Cause: %{public}s', err.message);
}
```

#### Obtaining HAP Signature Information

[BundleInfo](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-bundleManager-bundleInfo.md) includes [SignatureInfo](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-bundleManager-bundleInfo.md), which can be obtained by **getBundleInfo**.

**System capability**: SystemCapability.BundleManager.BundleFramework.Core

| Name     | Type          | Readable| Writable| Description                       |
| --------- | -------------- | ---- | ---- | --------------------------- |
| appId     | string         | Yes  | No  | Application ID.                |
|fingerprint| string         | Yes  | No  | Fingerprint information of the bundle.           |

``` javascript
// Obtain the bundle information with the application and signature information.
import bundleManager from '@ohos.bundle.bundleManager';
import hilog from '@ohos.hilog';
let bundleName = 'com.example.myapplication';
let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION | bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO;
let userId = 100;

try {
    bundleManager.getBundleInfo(bundleName, bundleFlags, userId).then((data) => {
        hilog.info(0x0000, 'testTag', 'getBundleInfo successfully. Data: %{public}s', JSON.stringify(data));
    }).catch(err => {
        hilog.error(0x0000, 'testTag', 'getBundleInfo failed. Cause: %{public}s', err.message);
    });
} catch (err) {
    hilog.error(0x0000, 'testTag', 'getBundleInfo failed. Cause: %{public}s', err.message);
}
```

#### Obtaining Information about All Installed HAPs

getAllBundleInfo(bundleFlags: number, userId: number, callback: AsyncCallback<Array<BundleInfo>>): void;

Obtains information about all bundles based on the given bundle flags and user ID. This API uses an asynchronous callback to return the result.

**System API**: This is a system API.

**Required permissions**: ohos.permission.GET_BUNDLE_INFO_PRIVILEGED

**System capability**: SystemCapability.BundleManager.BundleFramework.Core

[BundleInfo](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-bundleManager-bundleInfo.md)

``` javascript
import bundleManager from '@ohos.bundle.bundleManager';
import hilog from '@ohos.hilog';
let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;

try {
    bundleManager.getAllBundleInfo(bundleFlags, (err, data) => {
        if (err) {
            hilog.error(0x0000, 'testTag', 'getAllBundleInfo failed: %{public}s', err.message);
        } else {
            hilog.info(0x0000, 'testTag', 'getAllBundleInfo successfully: %{public}s', JSON.stringify(data));
        }
    });
} catch (err) {
    hilog.error(0x0000, 'testTag', 'getAllBundleInfo failed: %{public}s', err.message);
}
```

### Regular Expression Utility

See [validator](https://github.com/validatorjs/validato).

### Memory Cache Utility

This module is developed based on [node-cache](https://github.com/ptarjan/node-cache).

#### Importing a Memory Cache Instance

Obtain an object for memory cache operations.

``` javascript
// @ts-ignore
import cache from 'memory-cache';
```

#### Writing Data to the Cache

put = function(key, value, time, timeoutCallback)

Writes data.

``` javascript
// @ts-ignore
import cache from 'memory-cache';
cache.put('foo', 'bar');
```

#### Reading Data from the Cache

get = function(key)

Reads data from the cache based on the given key.

``` javascript
// @ts-ignore
import cache from 'memory-cache';
cache.get('foo')
```

#### Removing Data from the Cache

del = function(key)

Removes the value of the given key.

``` javascript
// @ts-ignore
import cache from 'memory-cache';
cache.del('foo')
```

#### Clearing Cache Data

Clears all data from the cache.

``` javascript
// @ts-ignore
import cache from 'memory-cache';
cache.clear()
```

#### Obtaining Cache Data Volume

size = function()

Returns the number of entries in the cache.

``` javascript
// @ts-ignore
import cache from 'memory-cache';;
cache.size();
```

#### Obtaining Cache Size

memsize = function()

Returns the memory occupied by the data in the cache.

``` javascript
// @ts-ignore
import cache from 'memory-cache';
cache.memsize();
```

### Time Utility

This module is developed based on [leap-year](https://github.com/sindresorhus/leap-year) [time-ampm](https://github.com/ipostol/time-ampm).

#### Converts Date to a String

JS

``` javascript
const date = new Date();
const isoString = date.toISOString();
console.log(isoString); // Output a string similar to 2023-04-26T03:36:41.839Z.
```

#### Converting Date to a Timestamp

JS

``` javascript
const date = new Date();
const timestamp = date.getTime(); // Output a timestamp like 1630198499637.
```

#### Converting a Timestamp to Date

JS

``` javascript
const timestamp = 1646112000000; // Timestamp for 2022-03-01 00:00:00.
const date = new Date(timestamp);
console.log(date); // Output Tue Mar 01 2022 00:00:00 GMT+0800 (China Standard Time)
```

#### Obtaining the Current Date

JS

``` javascript
new Date()
```

#### Converting Time Between 12-Hour and 24-Hour Formats

Use **get12()** to convert a 24-hour time to a 12-hour time with AM/PM notation. 

Use **get24()** to convert a 12-hour time to a 24-hour time.

``` javascript
import { get12, get24 } from 'time-ampm';

const t1 = 0;
console.log(get12(t1)); // '12 am';

const t2 = '10 pm';
console.log(get24(t2)); // '22';

```

#### Checking for Leap Year

Use **isLeapYear()** to check whether the give year is a leap year.

``` javascript
import isLeapYear from 'leap-year';

isLeapYear(2014);// Check whether the year 2014 is a leap year.
//=> false

isLeapYear(2016);
//=> true

```

### Type Utility

#### Converting a number to a Hexadecimal String

JS

``` javascript
//number.tostring(radix);
// radix can be 2n36. If it is not specified, it is a decimal number.
var num = 255;
console.log(num.tostring(16));// Convert the number 255 to its hexadecimal (base 16) representation.
console.log(num.tostring(16).toupperCase());// Convert the lowercase hexadecimal string to uppercase.
```

#### Converting a Hexadecimal String to a Number

JS

``` javascript
//parseInt(string, radix)
// radix can be 2n36. If it is not specified, it is a decimal number.
var str = "FF";
console.1og(parseInt(str, 16));// Convert the string FF to an integer using base 16 (hexadecimal).
var str1 = "12";
console.log(parseInt(str1));// Convert the string 12 to an integer using the default base 10 (decimal).
```

#### Pixel Unit Utility

[Pixel Unit Conversion](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/arkui-ts/ts-pixel-units.md/#%E5%83%8F%E7%B4%A0%E5%8D%95%E4%BD%8D%E8%BD%AC%E6%8D%A2)

| Name  | Description                                      |
| ---- | ---------------------------------------- |
| px   | Physical pixel unit of the screen.                               |
| vp   | Pixel unit specific to the screen density. Pixels in this unit are converted into physical pixels of the screen based on the screen pixel density. This unit is used for values whose unit is not specified.|
| fp   | Font pixel, which is similar to vp and varies according to the system font size.         |
| lpx  | Logical pixel unit of the window. It is the ratio of the actual screen width to the logical width (configured by **designWidth**). For example, if **designWidth** is set to **720** (default value), then 1 lpx is equal to 2 px for a screen with an actual width of 1440 physical pixels.|

| API                                               | Description                                                        |
| --------------------------------------------------- | ------------------------------------------------------------ |
| vp2px(value&nbsp;:&nbsp;number)&nbsp;:&nbsp;number  | Converts a value in units of vp to a value in units of px.<br>This API can be used in ArkTS widgets since API version 9.|
| px2vp(value&nbsp;:&nbsp;number)&nbsp;:&nbsp;number  | Converts a value in units of px to a value in units of vp.<br>This API can be used in ArkTS widgets since API version 9.|
| fp2px(value&nbsp;:&nbsp;number)&nbsp;:&nbsp;number  | Converts a value in units of fp to a value in units of px.<br>This API can be used in ArkTS widgets since API version 9.|
| px2fp(value&nbsp;:&nbsp;number)&nbsp;:&nbsp;number  | Converts a value in units of px to a value in units of fp.<br>This API can be used in ArkTS widgets since API version 9.|
| lpx2px(value&nbsp;:&nbsp;number)&nbsp;:&nbsp;number | Converts a value in units of lpx to a value in units of px.<br>This API can be used in ArkTS widgets since API version 9.|
| px2lpx(value&nbsp;:&nbsp;number)&nbsp;:&nbsp;number | Converts a value in units of px to a value in units of lpx.<br>This API can be used in ArkTS widgets since API version 9.|

```ts
// xxx.ets
@Entry
@Component
struct Example {
  build() {
    Column() {
      Flex({ wrap: FlexWrap.Wrap }) {
        Column() {
          Text("width(220)")
            .width(220).height(40).backgroundColor(0xF9CF93)
            .textAlign(TextAlign.Center).fontColor(Color.White).fontSize('12vp')
        }.margin(5)
        Column() {
          Text("width('220px')")
            .width('220px').height(40).backgroundColor(0xF9CF93)
            .textAlign(TextAlign.Center).fontColor(Color.White)
        }.margin(5)
        Column() {
          Text("width('220vp')")
            .width('220vp').height(40).backgroundColor(0xF9CF93)
            .textAlign(TextAlign.Center).fontColor(Color.White).fontSize('12vp')
        }.margin(5)
        Column() {
          Text("width('220lpx') designWidth:720")
            .width('220lpx').height(40).backgroundColor(0xF9CF93)
            .textAlign(TextAlign.Center).fontColor(Color.White).fontSize('12vp')
        }.margin(5)
        Column() {
          Text("width(vp2px(220) + 'px')")
            .width(vp2px(220) + 'px').height(40).backgroundColor(0xF9CF93)
            .textAlign(TextAlign.Center).fontColor(Color.White).fontSize('12vp')
        }.margin(5)
        Column() {
          Text("fontSize('12fp')")
            .width(220).height(40).backgroundColor(0xF9CF93)
            .textAlign(TextAlign.Center).fontColor(Color.White).fontSize('12fp')
        }.margin(5)
      }.width('100%')
    }
  }
}
```

### Image Utility

This module is developed based on [ImageKnife](https://gitcode.com/openharmony-tpc/ImageKnife) [imtype](https://github.com/fatelei/imagetype).

#### Converting a PixelMap to an ArrayBuffer

[readPixelsToBuffer(dst: ArrayBuffer): Promise<void>](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-image.md#readpixelstobuffer7)

Reads the image pixel data and writes the data to an ArrayBuffer. This API uses a promise to return the result. If the pixel map is created in the BGRA_8888 format, the data read is the same as the original data.

``` javascript
const readBuffer = new ArrayBuffer(96);  // 96 is the size of the pixel map buffer to create. The value is calculated as follows: height x width x 4.
pixelmap.readPixelsToBuffer(readBuffer).then(() => {
    console.log('Succeeded in reading image pixel data.'); // The operation is successful.
}).catch(error => {
    console.log('Failed to read image pixel data.');  // The operation fails.
})
```

#### Converting an ArrayBuffer to a PixelMap

``` javascript
const color = new ArrayBuffer(96);  // 96 is the size of the pixel map buffer to create. The value is calculated as follows: height x width x 4.
let bufferArr = new Uint8Array(color);
let opts = { editable: true, pixelFormat: 3, size: { height: 4, width: 6 } }
image.createPixelMap(color, opts)
    .then( pixelmap => {
        if (pixelmap == undefined) {
            console.info('createPixelMap failed.');
        }
        const area = { pixels: new ArrayBuffer(8),
            offset: 0,
            stride: 8,
            region: { size: { height: 1, width: 2 }, x: 0, y: 0 }
        }
        let bufferArr = new Uint8Array(area.pixels);
        for (var i = 0; i < bufferArr.length; i++) {
            bufferArr[i] = i + 1;
        }

        pixelmap.writePixels(area).then(() => {
		    console.info('Succeeded to write pixelmap into the specified area.');
        })
    }).catch(error => {
        console.log('error: ' + error);
    })
```

#### Obtaining a PixelMap

[writePixels(area: PositionArea): Promise<void>](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-image.md#writepixels7)

Writes the pixels to an area. This API uses a promise to return the result.

``` javascript
const area = {
    pixels: new ArrayBuffer(8),
    offset: 0,
    stride: 8,
    region: { size: { height: 1, width: 2 }, x: 0, y: 0 }
}
pixelmap.readPixels(area).then(() => {
    console.log('Succeeded in reading the image data in the area.'); // The operation is successful.
}).catch(error => {
    console.log('Failed to read the image data in the area.'); // The operation fails.
})
```

#### Resizing an Image

[scale(x: number, y: number, callback: AsyncCallback<void>): void](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-image.md#scale9)

Scales this image based on a given scaling multiple of the width and height. This API uses an asynchronous callback to return the result.

``` javascript
async function Demo() {
	await pixelmap.scale(2.0, 1.0);
}
```

#### Cropping an Image

[crop(region: Region, callback: AsyncCallback<void>): void](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-image.md#crop9)

Crops this image based on a given size. This API uses an asynchronous callback to return the result.

``` javascript
async function Demo() {
	await pixelmap.crop({ x: 0, y: 0, size: { height: 100, width: 100 } });
}
```

#### Rotating an Image

[rotate(angle: number, callback: AsyncCallback<void>): void](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-image.md#rotate9)

Rotates this image based on a given angle. This API uses an asynchronous callback to return the result.

``` javascript
var angle = 90.0;
pixelmap.rotate(angle, (err) => {
	if (err) {
        console.error("Failed to set rotation.");
        return;
    } else {
        console.log("Succeeded in setting rotation.");
	}
})
```

#### Cropping an Image into a Circular Shape

[Crop an image into a circular shape](https://gitcode.com/openharmony-tpc/ImageKnife#%E5%9B%BE%E7%89%87%E5%8F%98%E6%8D%A2%E7%9B%B8%E5%85%B3).

``` javascript
import AbilityStage from "@ohos.application.AbilityStage"
import {ImageKnife} from '@ohos/imageknife'

export default class MyAbilityStage extends AbilityStage {
    onCreate() {
        // Call ImageKnife.with(this.context) in AbilityStage.ts to initialize the ImageKnife instance globally. This allows ImageKnife to be used throughout the application.
        globalThis.ImageKnife = ImageKnife.with(this.context)
    }
 }
Type:CropCircleTransformation
request.cropCircle()
```

#### Applying Rounded Corners to an Image

[Apply rounded corners to an image](https://gitcode.com/openharmony-tpc/ImageKnife#%E5%9B%BE%E7%89%87%E5%8F%98%E6%8D%A2%E7%9B%B8%E5%85%B3).

``` javascript
import AbilityStage from "@ohos.application.AbilityStage"
import {ImageKnife} from '@ohos/imageknife'

export default class MyAbilityStage extends AbilityStage {
    onCreate() {
        // Call ImageKnife.with(this.context) in AbilityStage.ts to initialize the ImageKnife instance globally. This allows ImageKnife to be used throughout the application.
        globalThis.ImageKnife = ImageKnife.with(this.context)
    }
 }
Type:RoundedCornersTransformation
request.roundedCorners()
```

#### Adding Rounded Borders

[Add rounded borders](https://gitcode.com/openharmony-tpc/ImageKnife#1%E5%8A%A0%E8%BD%BD%E6%99%AE%E9%80%9A%E5%9B%BE%E7%89%87).

``` javascript
import {ImageKnifeComponent} from '@ohos/imageknife'
import {ImageKnifeOption} from '@ohos/imageknife'
import {ImageKnifeDrawFactory} from '@ohos/imageknife'
@Entry
@Component
struct Index {
  @State imageKnifeOption1: ImageKnifeOption =
    { // (Mandatory) Load a local JPG file.
      loadSrc: $r('app.media.jpgSample'),
      // (Mandatory) Set the component width to 300 and height to 300.
      size: { width: '300', height: '300' },
      // (Optional) Use the local icon_loading as the placeholder image shown while the main image is loading.
      placeholderSrc: $r('app.media.icon_loading'),
      // (Optional) Use the local icon_failed as the image shown if the loading fails.
      errorholderSrc: $r('app.media.icon_failed'),
      // (Optional) Draw an image, which has rounded corners with a radius of 5 pixels, a border color of magenta (#ff00ff), and a border width of 30 pixels.
      drawLifeCycle:ImageKnifeDrawFactory.createRoundLifeCycle(5,"#ff00ff",30)
    };


  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        ImageKnifeComponent({ imageKnifeOption: this.imageKnifeOption1 })
      }
    }
    .width('100%')
    .height('100%')
  }
}
```

#### Applying a Grayscale Effect to an Image

[Apply grayscale transformation to an image](https://gitcode.com/openharmony-tpc/ImageKnife#%E5%9B%BE%E7%89%87%E5%8F%98%E6%8D%A2%E7%9B%B8%E5%85%B3).

``` javascript
import AbilityStage from "@ohos.application.AbilityStage"
import {ImageKnife} from '@ohos/imageknife'

export default class MyAbilityStage extends AbilityStage {
    onCreate() {
        // Call ImageKnife.with(this.context) in AbilityStage.ts to initialize the ImageKnife instance globally. This allows ImageKnife to be used throughout the application.
        globalThis.ImageKnife = ImageKnife.with(this.context)
    }
 }
Type:GrayscaleTransformation
request.grayscale()
```

#### Blurring an Image

[Blur an image](https://gitcode.com/openharmony-tpc/ImageKnife#%E5%9B%BE%E7%89%87%E5%8F%98%E6%8D%A2%E7%9B%B8%E5%85%B3).

``` javascript
import AbilityStage from "@ohos.application.AbilityStage"
import {ImageKnife} from '@ohos/imageknife'

export default class MyAbilityStage extends AbilityStage {
    onCreate() {
        // Call ImageKnife.with(this.context) in AbilityStage.ts to initialize the ImageKnife instance globally. This allows ImageKnife to be used throughout the application.
        globalThis.ImageKnife = ImageKnife.with(this.context)
    }
 }
Type: BlurTransformation
request.blur()
```

#### Packing Images

Provides APIs to pack images. Before calling any API in **ImagePacker**, you must use **createImagePacker** to create an **ImagePacker** instance. The image formats JPEG and WebP are supported.

``` javascript
import image from '@ohos.multimedia.image';
const imageSourceApi = image.createImageSource(0);
let packOpts = { format:"image/jpeg", quality:98 };
imagePackerApi.packing(imageSourceApi, packOpts, data => {})
```

#### Obtaining Image Size

[Image](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-image.md#image9) provides APIs for basic image operations, including obtaining image information and reading and writing image data. The image is returned when **readNextImage** or **readLatestImage** is called.

**System capability**: SystemCapability.Multimedia.Image.Core

| Name    | Type              | Readable| Writable| Description                                              |
| -------- | ------------------ | ---- | ---- | -------------------------------------------------- |
| clipRect | [Region](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-image.md#region7) | Yes  | Yes  | Image area to be cropped.                                |
| size     | [Size](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-image.md#size)      | Yes  | No  | Image size.                                        |
| format   | number             | Yes  | No  | Image format. For details, see [PixelMapFormat](https://gitcode.com/openharmony/docs/blob/OpenHarmony-3.2-Release/en/application-dev/reference/apis/js-apis-image.md#pixelmapformat7). |

``` javascript
import image from '@ohos.multimedia.image';
img.getComponent(4, (err, component) => {
    if(err) {
        console.log('getComponent failed.');
    } else {
        console.log('getComponent succeeded.');
    }
})
```

#### Determining an Image

Check whether the given object is an image. Currently, jpeg, png, gif, tiff, and bmp are supported.

``` javascript
    import imtype from 'imtype';
   globalThis.context.resourceManager.getMedia($r("app.media.bmp"))
      .then(data => {
        this.bmp = imtype.isBMP(new Uint8Array(data))
      })
      .catch(err => {
        console.log('addFileToDisk err=' + err)
      })
```

## Directory Structure

```
/util_code # Source code of the third-party library
├── entry      # Demo
│   └── src
│       └── main
│   	    └── ets      # Demo code
│               └── entryability    # entryability
│               └── pages    # Demo pages
│                   ├── CachePage.ets    # Memory cache demo page
│                   ├── ColorDemo.ets    # Color demo page
│                   ├── GcoordPage.ets   # Coordinate conversion demo page
│                   ├── Index.ets        # Main page demo
│                   ├── PicturePage.ets  # Image demo page
│                   └──  TimePage.ets    # Time demo page
├── library      # Code
│   └── src
│       └── main
│           └── utilcode  # utilcode code
│               ├─ CountryUtils.ts  # Country code utility
│               ├─ TempUtil.ts      # Temperature utility
│               └── basic.ts        # APIs
```

## Constraints

This project has been verified in the following versions:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)
- DevEco Studio: 3.1 Beta1 (3.1.0.200), OpenHarmony SDK: API9 (3.2.10.6)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [Apache License 2.0](https://gitcode.com/zdy09/openharmony_tpc_samples/blob/master/utilCode/LICENSE).
