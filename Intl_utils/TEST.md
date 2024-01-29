# intl_utils单元测试用例

该测试用例基于OpenHarmony系统下，进行单元测试

单元测试用例覆盖情况

|                                                                                    接口名                                                                                     | 是否通过	 | 备注  |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-----:|:---:|
|                                                   selectUnit(from: Date , to?: Date , thresholds?: Partial<Thresholds>)                                                    | pass  |     |
|                                             defaultNumberOption(val: any, min: number, max: number, fallback: number): number                                              | pass  |     |
|                                                           getAliasesByLang(lang: string): Record<string, string>                                                           | pass  |     |
|                                               getInternalSlot(map: WeakMap<Instance, Internal>, pl: Instance, field: Field)                                                | pass  |     |
|                                         getMultiInternalSlots(map: WeakMap<Instance, Internal>, pl: Instance, ...fields: Field[])                                          | pass  |     |
|                                        getNumberOption(options: T, property: K, minimum: number, maximum: number, fallback: number)                                        | pass  |     |
|                                                     getOption(opts: T, prop: K, type: string, values: T, fallback: F)                                                      | pass  |     |
|                                                        getParentLocalesByLang(lang: string): Record<string, string>                                                        | pass  |     |
|                                                            isLiteralPart(patternPart: LiteralPart): patternPart                                                            | pass  |     |
|                                                                     partitionPattern(pattern: string)                                                                      | pass  |     |
|                             setInternalSlot(map: WeakMap<Instance, Internal>, pl: Instance, field: Field, value: NonNullable<Internal>[Field])                             | pass  |     |
|                    setMultiInternalSlots(map: WeakMap<Instance, Internal>, pl: Instance, props: Pick<NonNullable<Internal>, K>): Record<string, string>                    | pass  |     |
| setNumberFormatDigitOptions(internalSlotMap: WeakMap<TObject, TInternalSlots>, intlObj: TObject, opts: NumberFormatDigitOptions, mnfdDefault: number, mxfdDefault: number) | pass  |     |
