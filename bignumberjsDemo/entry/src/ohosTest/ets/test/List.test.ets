/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import BigNumberJs from './BigNumber'
import absoluteValue from './absoluteValue'
import close from './close'
import comparedTo from './comparedTo'
import config from './config'
import decimalPlaces from './decimalPlaces'
import dividedBy from './dividedBy'
import dividedToIntegerBy from './dividedToIntegerBy'
import exponentiatedBy from './exponentiatedBy'
import integerValue from './integerValue'
import isBigNumber from './isBigNumber'
import isMethods from './isMethods'
import minmax from './minmax'
import minus from './minus'
import modulo from './modulo'
import multipliedBy from './multipliedBy'
import negated from './negated'
import plus from './plus'
import precision from './precision'
import random from './random'
import shiftedBy from './shiftedBy'
import squareRoot from './squareRoot'
import sum from './sum'
import toExponential from './toExponential'
import toFixed from './toFixed'
import toFormat from './toFormat'
import toFraction from './toFraction'
import toNumber from './toNumber'
import toPrecision from './toPrecision'
import toString from './toString'

export default function testsuite() {
  BigNumberJs()
  absoluteValue()
  close()
  comparedTo()
  config()
  decimalPlaces()
  dividedBy()
  dividedToIntegerBy()
  exponentiatedBy()
  integerValue()
  isBigNumber()
  isMethods()
  minmax()
  minus()
  modulo()
  multipliedBy()
  negated()
  plus()
  precision()
  random()
  shiftedBy()
  squareRoot()
  sum()
  toExponential()
  toFixed()
  toFormat()
  toFraction()
  toNumber()
  toPrecision()
  toString()
}