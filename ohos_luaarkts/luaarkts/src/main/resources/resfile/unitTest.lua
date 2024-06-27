--
-- Copyright (c) 2024 Huawei Device Co., Ltd.
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
str = "form hap hello lua."
testValInt = 123456789
testValLong = 1234567891
testValDouble = 1.342345
testValChar = "hello world"
testValBool = true

tbl = {name = "DC", id = 987654321}
tbl1 = {name = "DC", id1 = 1987654321, idlong = 2200000000}
tbl2 = {name = "DE", id2 = 1.4234567, str = "hello world", valueBool = true}
function add(a,b)
	return a + b
end

function testLuaHelloWorld()
	cc.l2tLogDebug("lua触发testLuaHelloWorld")
end


cc.l2tTestHelloWorld()   -- hello world!
cc.l2tCallModuleFunc("ets/common/ts/index", "drawImage")        --lua->arkts,动态访问drawImage
cc.l2tLoadModule("ets/test/TestTs")                             --lua->arkts,动态加载arkts模块
cc.l2tCallModuleFunc("ets/test/TestTs", "test")                 --lua->arkts,调用arkts函数

cc.l2tLogDebug("测试获取返回值,lua->arkts->lua获取函数返回值")
result_testNumberAdd = cc.l2tCallModuleFunc("ets/common/ts/index", "testNumberAdd", 123456)
cc.l2tLogDebug("获取返回值,result_testNumberAdd=" .. result_testNumberAdd)




function generate_func_id()
    local counter = 0 -- 计数器变量

    counter = counter + 1
    return counter
end



function wrap(fn)
	local id = generate_func_id()
	local fn_s = "__callback_fn" .. id
	_G[fn_s] = fn
	return fn_s
end

function testcallback(a, b)
    local c = a + b
	cc.l2tLogDebug("lua触发testcallback=" .. c)
    return c
end

cc.l2tLogDebug("测试lua回调匿名函数1")
cc.l2cTestCallBack("testLuaHelloWorld") -- right

cc.l2tLogDebug("测试lua回调匿名函数2")
cc.l2cTestCallBack(wrap(function()
    cc.l2tLogDebug("测试lua回调匿名函数,从c++回调")
end))

cc.l2tLogDebug("测试lua回调匿名函数3")
cc.l2cTestCallBack(wrap(testLuaHelloWorld))

cc.l2tLogDebug("测试异步回调1,lua->arkts->lua异步回调匿名函数")
resultl2tCallModuleFunc2 = cc.l2tCallModuleFunc("ets/common/ts/index", "C2tCallBack", 1, "测试参数类型", 2, wrap(function()
    cc.l2tLogDebug("测试成功1,lua->arkts->lua异步回调匿名函数")
end)) 
cc.l2tLogDebug("异步回调结果1,lua->arkts->lua异步回调匿名函数=resultl2tCallModuleFunc2=" .. resultl2tCallModuleFunc2)

cc.l2tLogDebug("测试异步回调2,lua->arkts->lua异步回调匿名函数")
resultl2tCallModuleFunc2 = cc.l2tCallModuleFunc("ets/common/ts/index", "C2tCallBack2", 1, "测试参数类型", 2, wrap(function(c)
    cc.l2tLogDebug("测试成功2,lua->arkts->lua异步回调匿名函数,返回c=" .. c)
    --cc.l2tLogDebug("测试成功,lua->arkts->lua异步回调匿名函数")
end))        --lua->arkts,动态访问drawImage
cc.l2tLogDebug("异步回调结果2,lua->arkts->lua异步回调匿名函数=resultl2tCallModuleFunc2=" .. resultl2tCallModuleFunc2)

cc.l2tLogDebug("测试访问类成员函数")
resultl2tCallClass = cc.l2tCallClass("ets/test/TestTs", "CClassTest", "testClassFuncAdd", 4, 6)
cc.l2tLogDebug("访问类函数,不定长,不定类型,返回值testClassFuncAdd=" .. resultl2tCallClass)

cc.l2tLogDebug("测试系统访问")
cc.l2tCallModuleFunc("@ohos.hilog", "info", 0, "test", "testtag, Hello OpenHarmony1111111")   --lua->arkts,动态加载其他模块

cc.l2tLogDebug("VarInt start")
--ts变量不能直接修改,修改会成功但是会引起ts挂起,必须通过ts中接口间接修改(已和底层接口开发人员确认)
--cc.l2tSetModuleVarInt("ets/test/TestTs", "value", 10)        --lua->arkts,设置int类型全局变量
vint = cc.l2tGetModuleVarInt("ets/test/TestTs", "valueInt")        --lua->arkts,获取int类型全局变量
cc.l2tLogDebug("l2tGetModuleVarLong return vint=" .. vint)       --lua->c++,打印日志
cc.l2tLogDebug("VarInt end")

cc.l2tLogDebug("VarLong start")
--ts变量不能直接修改,修改会成功但是会引起ts挂起,必须通过ts中接口间接修改(已和底层接口开发人员确认)
--cc.l2tSetModuleVarLong("ets/test/TestTs", "valueLong", 123456789)        --lua->arkts,设置long类型全局变量
vlong = cc.l2tGetModuleVarLong("ets/test/TestTs", "valueLong")        --lua->arkts,获取long类型全局变量
cc.l2tLogDebug("l2tGetModuleVarLong return vlong=" .. vlong)       --lua->c++,打印日志
cc.l2tLogDebug("VarLong end")

cc.l2tLogDebug("VarChar start")
--ts变量不能直接修改,修改会成功但是会引起ts挂起,必须通过ts中接口间接修改(已和底层接口开发人员确认)
--cc.l2tSetModuleVarChar("ets/test/TestTs", "valueChar", "hello world123")        --lua->arkts,设置char类型全局变量
vchar = cc.l2tGetModuleVarChar("ets/test/TestTs", "valueChar")        --lua->arkts,获取char类型全局变量
cc.l2tLogDebug("l2tGetModuleVarChar return vchar=" .. vchar)       --lua->c++,打印日志
cc.l2tLogDebug("VarChar end")

cc.l2tLogDebug("VarDouble start")
--ts变量不能直接修改,修改会成功但是会引起ts挂起,必须通过ts中接口间接修改(已和底层接口开发人员确认)
--cc.l2tSetModuleVarDouble("ets/test/TestTs", "valueDouble", 3.14123)        --lua->arkts,设置long类型全局变量
vdouble = cc.l2tGetModuleVarDouble("ets/test/TestTs", "valueDouble")        --lua->arkts,获取double类型全局变量
cc.l2tLogDebug("l2tGetModuleVarDouble return vdouble=" .. vdouble)       --lua->c++,打印日志
cc.l2tLogDebug("VarDouble end")

cc.l2tLogDebug("VarBool start")
--ts变量不能直接修改,修改会成功但是会引起ts挂起,必须通过ts中接口间接修改(已和底层接口开发人员确认)
--cc.l2tSetModuleVarBool("ets/test/TestTs", "valueBool", 0)        --lua->arkts,设置bool类型全局变量
vbool = cc.l2tGetModuleVarBool("ets/test/TestTs", "valueBool")        --lua->arkts,获取bool类型全局变量
cc.l2tLogDebug("l2tGetModuleVarBool return vbool=" .. tostring(vbool))       --lua->c++,打印日志
cc.l2tLogDebug("VarBool end")