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
import {gameControl} from '../common/ts/index'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { harNAPI } from '@ohos/luaarkts';

export function UnitTest(context:CanvasRenderingContext2D, canvasWidth:number, canvasHeight:number, pathLuaMain:string){
    hilog.info(0x0000, 'testTag', '0.触发har包init接口');

    hilog.info(0x0000, 'testTag', '1.初始化canvas环境');
    gameControl.Instance = new gameControl(context, canvasWidth, canvasHeight)

    hilog.info(0x0000, 'testTag', '2.arkts->c++, 测试har包中napi接口及返回值TestHelloWorld');
    let strHello: string = harNAPI.TestHelloWorld("testTag, helloWorld");
    hilog.info(0x0000, 'testTag', '2.测试har包中napi接口及返回值=%{public}s', strHello);

    hilog.info(0x0000, 'testTag', '3.初始化lua环境');
    harNAPI.InitLuaEnv(pathLuaMain);
    hilog.info(0x0000, 'testTag', '3.lua环境初始化完成');

    hilog.info(0x0000, 'testTag', '4.arkts->lua,测试函数调用testLuaHelloWorld');
    harNAPI.T2lCallFunction("testLuaHelloWorld");

    hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lSetVarInt');
    harNAPI.T2lSetVarInt("testValInt", 12);
    hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lGetVarInt,获取lua中testValInt值');
    let tmpValInt: number = harNAPI.T2lGetVarInt("testValInt");
    hilog.info(0x0000, 'testTag', '5.1返回值 =%{public}d', tmpValInt);

    hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lSetVarLong');
    harNAPI.T2lSetVarLong("testValLong", 1234567890);
    hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lGetVarLong,获取lua中testValLong值');
    let tmpValLong: number = harNAPI.T2lGetVarLong("testValLong");
    hilog.info(0x0000, 'testTag', '5.2返回值 =%{public}d', tmpValLong);

    hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lSetVarDouble');
    harNAPI.T2lSetVarDouble("testValDouble", 3.13456);
    hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lGetVarDouble,获取lua中testValDouble值');
    let tmpValDouble: number = harNAPI.T2lGetVarDouble("testValDouble");
    console.info(`testTag, 5.3返回值 =${tmpValDouble}`);

    hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lSetVarChar');
    harNAPI.T2lSetVarChar("testValChar", "hello world123");
    hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lGetVarChar,获取lua中testValChar值');
    let tmpValChar: number = harNAPI.T2lGetVarChar("testValChar");
    hilog.info(0x0000, 'testTag', '5.4返回值 =%{public}s', tmpValChar);

    hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lSetVarBool');
    harNAPI.T2lSetVarBool("testValBool", false);
    hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lGetVarBool,获取lua中testValBool值');
    let tmpValBool: number = harNAPI.T2lGetVarBool("testValBool");
    hilog.info(0x0000, 'testTag', '5.5返回值 =%{public}d', tmpValBool);

    hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lSetTableInt');
    harNAPI.T2lSetTableInt("tbl", "id", 666);
    hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lGetTableInt,获取lua中Table中的int变量');
    tmpValInt = harNAPI.T2lGetTableInt("tbl", "id");
    hilog.info(0x0000, 'testTag', '6.1 返回值=%{public}d', tmpValInt);

    hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lSetTableLong');
    harNAPI.T2lSetTableLong("tbl1", "idlong", 2200000001);
    hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lGetTableLong,获取lua中Table中的long型变量');
    tmpValLong = harNAPI.T2lGetTableLong("tbl1", "idlong");
    hilog.info(0x0000, 'testTag', '6.2 返回值=%{public}d', tmpValLong);

    hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lSetTableDouble');
    harNAPI.T2lSetTableDouble("tbl2", "id2", 123.123456);
    hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lGetTableDouble,获取lua中Table中的double型变量');
    tmpValDouble = harNAPI.T2lGetTableDouble("tbl2", "id2");
    console.info(`testTag, 6.3返回值 =${tmpValDouble}`);

    hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lSetTableString');
    harNAPI.T2lSetTableString("tbl2", "str", "hello world123456789");
    hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lGetTableChar,获取lua中Table中的char型变量');
    tmpValChar = harNAPI.T2lGetTableChar("tbl2", "str");
    hilog.info(0x0000, 'testTag', '6.4返回值 =%{public}s', tmpValChar);

    hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lSetTableBool');
    harNAPI.T2lSetTableBool("tbl2", "valueBool", false);
    hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lGetTableBool,获取lua中Table中的bool型变量');
    tmpValBool = harNAPI.T2lGetTableBool("tbl2", "valueBool");
    hilog.info(0x0000, 'testTag', '6.5返回值 =%{public}d', tmpValBool);

    hilog.info(0x0000, 'testTag', '7测试多模块输出 =%{public}d', harNAPI.TestNAPI(1,2));

    hilog.info(0x0000, 'testTag', '8.测试arkts->lua接口,无返回值');
    harNAPI.T2lCallFunction("testLuaHelloWorld");

    hilog.info(0x0000, 'testTag', '8.测试arkts->lua接口,传入 number，返回number');
    let res: number = harNAPI.T2lCallFunction("testcallback", 100, 200);
    hilog.info(0x0000, 'testTag', '8.返回值 = ' + res);

    hilog.info(0x0000, 'testTag', '9.测试arkts->lua接口,传入 string，返回string');
    let res1: string = harNAPI.T2lCallFunction("testcallstring", "100", "200");
    hilog.info(0x0000, 'testTag', '9.返回值 = ' + res1);

    hilog.info(0x0000, 'testTag', '10.测试arkts->lua接口,传入 boolean，返回boolean');
    let res2: boolean = harNAPI.T2lCallFunction("testcallbool", true);
    hilog.info(0x0000, 'testTag', '10.返回值 = ' + res2);

    hilog.info(0x0000, 'testTag', '10.测试arkts->lua接口,传入 boolean，返回boolean');
    res2 = harNAPI.T2lCallFunction("testcallbool", false);
    hilog.info(0x0000, 'testTag', '10.返回值 = ' + res2);
}