# Yoga

## Overview

Yoga is a cross-platform layout engine that implements Flexbox. It enables building responsive user interfaces that work consistently across different platforms and screen sizes. This OpenHarmony port adds ArkTS bindings via NAPI, making it easy to use Yoga's powerful layout capabilities in OpenHarmony applications.

## Key Features
- Cross-language Property Transfer: Supports passing layout properties between different programming languages;
- Layout Calculation: Supports basic layout computation functionality;
- Flexbox Container Rules: Complete implementation of Flexbox container layout rules;
- Tree Node Management: Supports management and operations of tree-structured nodes;
- Dimension Measurement: Supports precise measurement and calculation of component dimensions.

## How to Install

```shell
ohpm install @ohos/yoga
```
For details, see [Installing an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

1. Import the Yoga library.

```typescript
import { Yoga, YogaNode, YogaFlexDirection, YogaJustify } from '@ohos/yoga';
```

2. Create a Yoga node.

```typescript
const root = Yoga.createNode();
```

3. Configure layout properties.

```typescript
// Set width and height
root.setWidth(200);
root.setHeight(200);
// Set flex direction
root.setFlexDirection(YogaFlexDirection.ROW);
// Set justifyContent
root.setJustifyContent(YogaJustify.SPACE_BETWEEN);
```

4. Create child nodes.

```typescript
const child = Yoga.createNode();
child.setWidth(100);
child.setHeight(100);
root.insertChild(child, 0);
```

5. Calculate layout.

```typescript
root.calculateLayout(500, 300);
```

6. Get layout results.

```typescript
console.log("Root layout - Width:", root.getLayoutWidth(), "Height:", root.getLayoutHeight());
console.log("Child layout - X:", child.getLayoutX(), "Y:", child.getLayoutY());
```

## Available APIs

For detailed API implementation, please refer to:
- [YogaNode](./library/src/main/ets/yogaNode.ets) - Main Yoga node API implementation
- [YogaConfig](./library/src/main/ets/yogaConfig.ets) - Configuration API implementation
- [YogaEnum](./library/src/main/ets/yogaEnum.ets) - Yoga constants definitions

## Source Code Downloading
1. This project depends on the **yoga** library, which is introduced through `git submodule`. You need to add the `--recursive` parameter when downloading code.
  ```
  git clone --recursive https://gitcode.com/openharmony-tpc/openharmony_tpc_samples.git
  ```
2. Start project building.

## Constraints
Yoga has been verified in the following versions:

- IDE: DevEco Studio 5.1.0 Release - 5.1.0.849, SDK: API12.

## Directory Structure
````
|---- yoga
|     |---- entry  # Sample code
|     |---- library  # Yoga library
|           |---- cpp # Native C++ implementation
|                 |---- core # Core Yoga C++ library
|                 |---- thirdparty # Third-party dependencies
|                 |---- utils # Utility functions
|                 |---- napi_init.cpp # NAPI initialization
|                 |---- yoga_napi.cpp # NAPI bindings implementation
|           |---- ets # ArkTS APIs
|                 |---- Yoga.ets # Main static API entry point
|                 |---- YogaConfig.ets # Configuration implementation
|                 |---- yogaEnum.ets # Enumerations and constants
|                 |---- yogaNode.ets # Node implementation
|     |---- README.md  # Readme                   
````