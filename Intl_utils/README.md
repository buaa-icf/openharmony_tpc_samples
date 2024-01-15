# intl_utils

## 简介

> intl_utils是一个用于处理国际化（i18n）的JavaScript工具库。

## 下载安装

```shell
ohpm install @f-fjs/intl-utils@2.2.1
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony har 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

1. 导入依赖库

```typescript
import * as intl_utils from '@ohos/intl_utils'
```

2. 按需使用相关接口

```typescript
Button('selectUnit测试').fontSize(24).onClick(() => {
          let diffResult = intl_utils.selectUnit(Date.now(), 0, {});
          if (diffResult.unit == 'year' && diffResult.value + 1970 == 2023) {
            setData('测试成功', this.dialogController)
          }
        })
```

## 接口说明

- 选择地区设置

```typescript
createResolveLocale<K extends string,D extends {[k in K]: any}>(getDefaultLocale: () => string)
```

- 国际化对象（Intl.Locale）转换为 JavaScript 对象

```typescript
toObject<T>(arg: T): T extends null ? never : T extends undefined ? never : T
```

- 支持哪些国际化地区

```typescript
supportedLocales(availableLocales: string[],requestedLocales: string[],options?: {localeMatcher?: 'best fit' | 'lookup'}): string[]
```

- 获取规范化语言标签列表

```typescript
getCanonicalLocales(locales?: string | string[]): string[]
```

- 设置国际化对象的插槽值

```typescript
setInternalSlot<
  Instance extends object,
  Internal extends object,
  Field extends keyof Internal
>(
  map: WeakMap<Instance, Internal>,
  pl: Instance,
  field: Field,
  value: NonNullable<Internal>[Field]
)
```

- 设置国际化对象的多个插槽值
```typescript
setMultiInternalSlots<
  Instance extends object,
  Internal extends object,
  K extends keyof Internal
>(
  map: WeakMap<Instance, Internal>,
  pl: Instance,
  props: Pick<NonNullable<Internal>, K>
)
```

- 获取国际化对象的多个插槽值
```typescript
getMultiInternalSlots<
  Instance extends object,
  Internal extends object,
  Field extends keyof Internal
>(
  map: WeakMap<Instance, Internal>,
  pl: Instance,
  ...fields: Field[]
): Pick<Internal, Field>
```

- 获取选项值
```typescript
getOption<T extends object, K extends keyof T, F>(
  opts: T,
  prop: K,
  type: 'string' | 'boolean',
  values: T[K][] | undefined,
  fallback: F
): Exclude<T[K], undefined> | F
```

- 获取指定插槽值
```typescript
getInternalSlot<
  Instance extends object,
  Internal extends object,
  Field extends keyof Internal
>(
  map: WeakMap<Instance, Internal>,
  pl: Instance,
  field: Field
): Internal[Field]
```

- 设置数字格式化的选项
```typescript
setNumberFormatDigitOptions<
  TObject extends object,
  TInternalSlots extends NumberFormatDigitInternalSlots
>(
  internalSlotMap: WeakMap<TObject, TInternalSlots>,
  intlObj: TObject,
  opts: NumberFormatDigitOptions,
  mnfdDefault: number,
  mxfdDefault: number
)
```

- 运行时检查
```typescript
invariant(condition: boolean,message: string,Err: any = Error)
```

- 比较两个对象是否相等
```typescript
objectIs(x: any, y: any)
```

- 数据解压缩
```typescript
unpackData<T extends Record<string, any>>(
  locale: string,
  localeData: LocaleData<T>,
  /** By default shallow merge the dictionaries. */
  reducer: (all: T, d: T) => T = (all, d) => ({...all, ...d})
): T
```

- 字符串分割
```typescript
partitionPattern(pattern: string)
```

- 验证货币代码是否有效
```typescript
isWellFormedCurrencyCode(currency: string): boolean
```

## 约束与限制

在下述版本验证通过：适配DevEco Studio:4.1 Canary(4.1.3.317)，OpenHarmony SDK:API version 11 (4.1.0.36).

## 目录结构
````
|---- Intl_utils  
|     |---- entry  # 示例代码文件夹
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [MIT LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Intl_utils/LICENSE) ，请自由地享受和参与开源。

  

