/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
let value = 456;
let valueLong = 100020003008;
let valueChar = "hello world";
let valueDouble = 1.76589;
let valueBool = true;

function test() {
  console.log("testtag, 这里是动态加载的TestTs.ets接口,test函数触发");
}

class CClassTest {
   static testFunc():void {
    console.log("testtag, 这里是动态加载类的testFunc接口");
  }

  static testClassFuncAdd(a:number, b:number):number {
    console.log("testtag, 这里是动态加载类的testAdd1接口");
    return a+b
  }
}

 export { value, test, valueLong, valueChar, valueDouble, valueBool , CClassTest};