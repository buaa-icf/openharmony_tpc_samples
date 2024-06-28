# Lua2arkts

## 简介

> 通过LuaJIT和NAPI实现lua脚本和ts脚本互相访问的能力.并通过AKI库简化C++和Arkts开发.

## 编译运行

1、通过IDE（DevEco Studio：5.0.3.200）工具下载依赖SDK，Tools->SDK Manager->OpenHarmony SDK 把native选项勾上下载，API版本**必须**>=12

2、开发板选择RK3568，ROM下载地址. 选择开发板类型是rk3568，请使用最新的版本

3、使用git clone下载源码，不要直接通过gitee网页的方式下载

## 库使用

## 下载安装

``` 
ohpm install @ohos/luaarkts
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## har包引用

自建项目,然后在Hap包的`oh-package.json5`文件的`dependencies`字段,增加类似下面的引用

```
"@ohos/luaarkts": "file:../luaarkts/build/default/outputs/default/luaarkts.har"
```

## 源码包引用

参考源码的Hap包的`oh-package.json5`文件的`dependencies`字段,增加类似下面的引用

```
"@ohos/luaarkts": "file:../luaarkts"
```

## 库初始化调用

参考源码hap包下`ets/pages/index.ets`文件例子

```
if(this.runMode == EnumRunMode.eRunRelease)
{
    //发布模式...
    let filePath = content.resourceDir + "/main.lua";
    hilog.info(0x0000, 'testTag', '1.获取lua入口文件沙箱地址,path=%{public}s', filePath);
    
    //调用har包初始化接口
    hilog.info(0x0000, 'testTag', '2.准备调用har包init初始化接口');
    SetLogShowState(false);
    init(this.context, this.canvasWidth, this.canvasHeight, filePath);
    
    hilog.info(0x0000, 'testTag', 'end.完成初始化');
}
}else{
    //单元测试用例...
}
```

## 单元测试

参考源码hap包下`ets/pages/index.ets`文件例子

```
if(this.runMode == EnumRunMode.eRunRelease)
{
    //发布模式...
}else{
    //单元测试用例...
    let filePath = content.resourceDir + "/unitTest.lua";
    hilog.info(0x0000, 'testTag', '1.获取lua入口文件沙箱地址,path=%{public}s', filePath);
    
    //调用har包初始化接口
    hilog.info(0x0000, 'testTag', '2.准备调用har包UnitTest初始化接口');
    SetLogShowState(false);
    UnitTest(this.context, this.canvasWidth, this.canvasHeight, filePath);
    
    hilog.info(0x0000, 'testTag', 'end.完成所有测试');
}
```

### 单元测试结果

看到`end.完成所有测试`则说明所有项目测试成功.

```
06-11 16:27:00.772   24249-24249  A00000/testTag                 com.hwyb....luaarkts  I     7测试多模块输出 =3
06-11 16:27:00.772   24249-24249  A00000/testTag                 com.hwyb....luaarkts  I     8.测试arkts->lua接口,无返回值
06-11 16:27:00.772   24249-24249  A00000/testTag                 com.hwyb....luaarkts  I     lua触发testLuaHelloWorld
06-11 16:27:00.772   24249-24249  A00000/testTag                 com.hwyb....luaarkts  I     8.测试arkts->lua接口,有返回值
06-11 16:27:00.773   24249-24249  A00000/testTag                 com.hwyb....luaarkts  I     lua触发testcallback=300
06-11 16:27:00.773   24249-24249  A00000/testTag                 com.hwyb....luaarkts  I     8.返回值 =300
06-11 16:27:00.773   24249-24249  A00000/testTag                 com.hwyb....luaarkts  I     end.完成所有测试
```

# 基础类型支持

| 基础数据类型 | lua                                | lua->arkts            | arkts->lua变量  | arkts->luaTable   |
| ------------ | ---------------------------------- | --------------------- | --------------- | ----------------- |
| char         | lua_tolstring                      | l2tGetModuleVarChar   | t2lGetVarChar   | t2lGetTableChar   |
| byte         | lua_tonumber                       | l2tGetModuleVarInt    | t2lGetVarInt    | t2lGetTableInt    |
| short        | lua_tonumber                       | l2tGetModuleVarInt    | t2lGetVarInt    | t2lGetTableInt    |
| int          | lua_tointeger                      | l2tGetModuleVarInt    | t2lGetVarInt    | t2lGetTableInt    |
| long         | lua_tonumber                       | l2tGetModuleVarLong   | t2lGetVarLong   | t2lGetTableLong   |
| float        | lua_tonumber                       | l2tGetModuleVarDouble | t2lGetVarDouble | t2lGetTableDouble |
| double       | lua_tonumber                       | l2tGetModuleVarDouble | t2lGetVarDouble | t2lGetTableDouble |
| bool         | lua_toboolean                      | l2tGetModuleVarBool   | t2lGetVarBool   | t2lGetTableBool   |
| 地址         | lua_tocfunction(返回lua_CFunction) | 不支持                | 不支持          | 不支持            |
|              | ~~lua_touserdata(返回void *）~~    | /                     | /               | /                 |
|              | ~~lua_tothread(返回lua_State*)~~   | /                     | /               | /                 |
|              | ~~lua_topointer(返回const void*)~~ | /                     | /               | /                 |

# 部分示例

## lua->arkts 模块动态加载

```
cc.l2tLoadModule("ets/test/TestTs")                             --lua->arkts,动态加载arkts模块
```

## lua->arkts 函数访问

```
cc.l2tCallModuleFunc("ets/test/TestTs", "test")                 --lua->arkts,调用arkts函数
cc.l2tLogDebug("测试访问类成员函数")
resultl2tCallClass = cc.l2tCallClass("ets/test/TestTs", "CClassTest", "testClassFuncAdd", 4, 6)
cc.l2tLogDebug("访问类函数,不定长,不定类型,返回值testClassFuncAdd=" .. resultl2tCallClass)

cc.l2tLogDebug("测试系统访问")
cc.l2tCallModuleFunc("@ohos.hilog", "info", 0, "test", "testtag, Hello OpenHarmony1111111")   --lua->arkts,动态加载其他模块
```

## lua->arkts 变量访问

```
cc.l2tLogDebug("VarInt start")
--ts变量不能直接修改,修改会成功但是会引起ts挂起,必须通过ts中接口间接修改
--cc.l2tSetModuleVarInt("ets/test/TestTs", "value", 10)        --lua->arkts,设置int类型全局变量
vint = cc.l2tGetModuleVarInt("ets/test/TestTs", "valueInt")        --lua->arkts,获取int类型全局变量
cc.l2tLogDebug("l2tGetModuleVarLong return vint=" .. vint)       --lua->c++,打印日志
cc.l2tLogDebug("VarInt end")

cc.l2tLogDebug("VarLong start")
--ts变量不能直接修改,修改会成功但是会引起ts挂起,必须通过ts中接口间接修改
--cc.l2tSetModuleVarLong("ets/test/TestTs", "valueLong", 123456789)        --lua->arkts,设置long类型全局变量
vlong = cc.l2tGetModuleVarLong("ets/test/TestTs", "valueLong")        --lua->arkts,获取long类型全局变量
cc.l2tLogDebug("l2tGetModuleVarLong return vlong=" .. vlong)       --lua->c++,打印日志
cc.l2tLogDebug("VarLong end")

cc.l2tLogDebug("VarChar start")
--ts变量不能直接修改,修改会成功但是会引起ts挂起,必须通过ts中接口间接修改
--cc.l2tSetModuleVarChar("ets/test/TestTs", "valueChar", "hello world123")        --lua->arkts,设置char类型全局变量
vchar = cc.l2tGetModuleVarChar("ets/test/TestTs", "valueChar")        --lua->arkts,获取char类型全局变量
cc.l2tLogDebug("l2tGetModuleVarChar return vchar=" .. vchar)       --lua->c++,打印日志
cc.l2tLogDebug("VarChar end")

cc.l2tLogDebug("VarDouble start")
--ts变量不能直接修改,修改会成功但是会引起ts挂起,必须通过ts中接口间接修改
--cc.l2tSetModuleVarDouble("ets/test/TestTs", "valueDouble", 3.14123)        --lua->arkts,设置long类型全局变量
vdouble = cc.l2tGetModuleVarDouble("ets/test/TestTs", "valueDouble")        --lua->arkts,获取double类型全局变量
cc.l2tLogDebug("l2tGetModuleVarDouble return vdouble=" .. vdouble)       --lua->c++,打印日志
cc.l2tLogDebug("VarDouble end")

cc.l2tLogDebug("VarBool start")
--ts变量不能直接修改,修改会成功但是会引起ts挂起,必须通过ts中接口间接修改
--cc.l2tSetModuleVarBool("ets/test/TestTs", "valueBool", 0)        --lua->arkts,设置bool类型全局变量
vbool = cc.l2tGetModuleVarBool("ets/test/TestTs", "valueBool")        --lua->arkts,获取bool类型全局变量
cc.l2tLogDebug("l2tGetModuleVarBool return vbool=" .. tostring(vbool))       --lua->c++,打印日志
cc.l2tLogDebug("VarBool end")
```

## lua->arkts 回调

```
cc.l2tLogDebug("测试获取返回值,lua->arkts->lua获取函数返回值")
result_testNumberAdd = cc.l2tCallModuleFunc("ets/common/ts/index", "testNumberAdd", 123456)
cc.l2tLogDebug("获取返回值,result_testNumberAdd=" .. result_testNumberAdd)

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
end))        --lua->arkts,动态访问drawImage
cc.l2tLogDebug("异步回调结果2,lua->arkts->lua异步回调匿名函数=resultl2tCallModuleFunc2=" .. resultl2tCallModuleFunc2)
```

## arkts->lua 访问前导入

单元测试的例子,需要在前面导入以下代码

```
import { hilog } from '@kit.PerformanceAnalysisKit';
import harNAPI  from 'libluaarkts.so';
```

## arkts->lua 读写变量

```
hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lSetVarInt');
harNAPI.t2lSetVarInt("testValInt", 12);
hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lGetVarInt,获取lua中testValInt值');
let tmpValInt = harNAPI.t2lGetVarInt("testValInt");
hilog.info(0x0000, 'testTag', '5.1返回值 =%{public}d', tmpValInt);

hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lSetVarLong');
harNAPI.t2lSetVarLong("testValLong", 1234567890);
hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lGetVarLong,获取lua中testValLong值');
let tmpValLong = harNAPI.t2lGetVarLong("testValLong");
hilog.info(0x0000, 'testTag', '5.2返回值 =%{public}d', tmpValLong);

hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lSetVarDouble');
harNAPI.t2lSetVarDouble("testValDouble", 3.13456);
hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lGetVarDouble,获取lua中testValDouble值');
let tmpValDouble = harNAPI.t2lGetVarDouble("testValDouble");
console.info(`testTag, 5.3返回值 =${tmpValDouble}`);

hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lSetVarChar');
harNAPI.t2lSetVarChar("testValChar", "hello world123");
hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lGetVarChar,获取lua中testValChar值');
let tmpValChar = harNAPI.t2lGetVarChar("testValChar");
hilog.info(0x0000, 'testTag', '5.4返回值 =%{public}s', tmpValChar);

hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lSetVarBool');
harNAPI.t2lSetVarBool("testValBool", false);
hilog.info(0x0000, 'testTag', '5.arkts->lua,start t2lGetVarBool,获取lua中testValBool值');
let tmpValBool = harNAPI.t2lGetVarBool("testValBool");
hilog.info(0x0000, 'testTag', '5.5返回值 =%{public}d', tmpValBool);
```

## arkts->lua 读写table变量

```
hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lSetTableInt');
harNAPI.t2lSetTableInt("tbl", "id", 666);
hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lGetTableInt,获取lua中Table中的int变量');
tmpValInt = harNAPI.t2lGetTableInt("tbl", "id");
hilog.info(0x0000, 'testTag', '6.1 返回值=%{public}d', tmpValInt);

hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lSetTableLong');
harNAPI.t2lSetTableLong("tbl1", "idlong", 2200000001);
hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lGetTableLong,获取lua中Table中的long型变量');
tmpValLong = harNAPI.t2lGetTableLong("tbl1", "idlong");
hilog.info(0x0000, 'testTag', '6.2 返回值=%{public}d', tmpValLong);

hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lSetTableDouble');
harNAPI.t2lSetTableDouble("tbl2", "id2", 123.123456);
hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lGetTableDouble,获取lua中Table中的double型变量');
tmpValDouble = harNAPI.t2lGetTableDouble("tbl2", "id2");
console.info(`testTag, 6.3返回值 =${tmpValDouble}`);

hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lSetTableString');
harNAPI.t2lSetTableString("tbl2", "str", "hello world123456789");
hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lGetTableChar,获取lua中Table中的char型变量');
tmpValChar = harNAPI.t2lGetTableChar("tbl2", "str");
hilog.info(0x0000, 'testTag', '6.4返回值 =%{public}s', tmpValChar);

hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lSetTableBool');
harNAPI.t2lSetTableBool("tbl2", "valueBool", false);
hilog.info(0x0000, 'testTag', '6.arkts->lua,start t2lGetTableBool,获取lua中Table中的bool型变量');
tmpValBool = harNAPI.t2lGetTableBool("tbl2", "valueBool");
hilog.info(0x0000, 'testTag', '6.5返回值 =%{public}d', tmpValBool);
```

## arkts->lua 函数访问

```
hilog.info(0x0000, 'testTag', '8.测试arkts->lua接口,无返回值');
harNAPI.t2lCallFunction("testLuaHelloWorld");

hilog.info(0x0000, 'testTag', '8.测试arkts->lua接口,有返回值');
let c = harNAPI.t2lCallFunction("testcallback", 100, 200);
```

# 接口说明

## lua->arkts

| 接口名                | 参数                                                         | 返回值         | 说明                                                         | 示例                                                         |
| --------------------- | ------------------------------------------------------------ | -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| l2tTestHelloWorld     | /                                                            | /              | 测试打印helloworld                                           | cc.l2tTestHelloWorld() -- hello world!                       |
| l2tLogDebug           | string[字符串]                                               | void           | 从c++端打印日志                                              | cc.l2tLogDebug("lua触发testLuaHelloWorld")                   |
| l2tLoadModule         | string[字符串]                                               | void           | 加载指定模块,支持本地模块,支持har模块,支持@ohos系统模块      | cc.l2tLoadModule("ets/test/TestTs") --lua->arkts,动态加载arkts模块 |
| l2tGetModuleVarInt    | string[模块名],string[变量名]                                | int            | 获取指定模块指定变量                                         | vint = cc.l2tGetModuleVarInt("ets/test/TestTs", "valueInt") --lua->arkts,获取int类型全局变量 |
| l2tGetModuleVarLong   | string[模块名],string[变量名]                                | long           | 获取指定模块指定变量                                         | vlong = cc.l2tGetModuleVarLong("ets/test/TestTs", "valueLong") --lua->arkts,获取long类型全局变量 |
| l2tGetModuleVarChar   | string[模块名],string[变量名]                                | string         | 获取指定模块指定变量                                         | vchar = cc.l2tGetModuleVarChar("ets/test/TestTs", "valueChar") --lua->arkts,获取char类型全局变量 |
| l2tGetModuleVarDouble | string[模块名],string[变量名]                                | double         | 获取指定模块指定变量                                         | vdouble = cc.l2tGetModuleVarDouble("ets/test/TestTs", "valueDouble") --lua->arkts,获取double类型全局变量 |
| l2tGetModuleVarBool   | string[模块名],string[变量名]                                | bool           | 获取指定模块指定变量                                         | vbool = cc.l2tGetModuleVarBool("ets/test/TestTs", "valueBool") --lua->arkts,获取bool类型全局变量 |
| l2tCallClass          | string[模块名],string[类名],string[函数名], ...[不定参数列表,类型不定] | void或常用类型 | 调用指定模块中的指定类指定函数,同时传递不定长,不定类型参数列表.支持匿名函数,支持返回常用类型的一个返回值, | resultl2tCallClass = cc.l2tCallClass("ets/test/TestTs", "CClassTest", "testClassFuncAdd", 4, 6) |
| l2tCallModuleFunc     | string[模块名],string[函数名], ...[不定参数列表,类型不定]    | void或常用类型 | 调用指定模块中的指定函数,同时传递不定长,不定类型参数列表.支持匿名函数,支持返回常用类型的一个返回值, | cc.l2tCallModuleFunc("@ohos.hilog", "info", 0, "test", "testtag, Hello OpenHarmony1111111") --lua->arkts,动态加载其他模块 |
|                       |                                                              |                |                                                              |                                                              |

## arkts->lua

| 接口名            | 参数                                   | 返回值           | 说明                                                   | 示例                                                         |
| ----------------- | -------------------------------------- | ---------------- | ------------------------------------------------------ | ------------------------------------------------------------ |
| InitLuaEnv        | std::string sPath                      | void             | 初始化lua环境                                          | harNAPI.InitLuaEnv(pathLuaMain);                             |
| TestHelloWorld    | std::string msg                        | std::string      | 测试打印helloworld                                     | let strHello = harNAPI.TestHelloWorld("testTag, helloWorld"); |
| SetLogShowState   | bool bLogShowState                     | void             | 是否打印底层追踪日志                                   | 库维护一个全局日志开关,当打开时,会打印一些追踪日志,用来追踪lua<-->c++<--->arkts中的调用流程,默认关闭 |
| t2lSetVarInt      | string[变量名],int                     | void             | 设置lua指定类型变量的值                                | harNAPI.t2lSetVarInt("testValInt", 12);                      |
| t2lSetVarLong     | string[变量名],long                    | void             | 设置lua指定类型变量的值                                | harNAPI.t2lSetVarLong("testValLong", 1234567890);            |
| t2lSetVarDouble   | string[变量名],double                  | void             | 设置lua指定类型变量的值                                | harNAPI.t2lSetVarDouble("testValDouble", 3.13456);           |
| t2lSetVarChar     | string[变量名],string                  | void             | 设置lua指定类型变量的值                                | harNAPI.t2lSetVarChar("testValChar", "hello world123");      |
| t2lSetVarBool     | string[变量名],bool                    | void             | 设置lua指定类型变量的值                                | harNAPI.t2lSetVarBool("testValBool", false);                 |
| t2lGetVarInt      | string[变量名]                         | int              | 获取lua指定类型变量的值                                | let tmpValInt = harNAPI.t2lGetVarInt("testValInt");          |
| t2lGetVarLong     | string[变量名]                         | long             | 获取lua指定类型变量的值                                | let tmpValLong = harNAPI.t2lGetVarLong("testValLong");       |
| t2lGetVarDouble   | string[变量名]                         | double           | 获取lua指定类型变量的值                                | let tmpValDouble = harNAPI.t2lGetVarDouble("testValDouble"); |
| t2lGetVarChar     | string[变量名]                         | string           | 获取lua指定类型变量的值                                | let tmpValChar = harNAPI.t2lGetVarChar("testValChar");       |
| t2lGetVarBool     | string[变量名]                         | bool             | 获取lua指定类型变量的值                                | let tmpValBool = harNAPI.t2lGetVarBool("testValBool");       |
| t2lSetTableInt    | string[table名],string[field名],int    | void             | 设置lua指定Table指定类型变量的值                       | harNAPI.t2lSetTableInt("tbl", "id", 666);                    |
| t2lSetTableLong   | string[table名],string[field名],long   | void             | 设置lua指定Table指定类型变量的值                       | harNAPI.t2lSetTableLong("tbl1", "idlong", 2200000001);       |
| t2lSetTableDouble | string[table名],string[field名],double | void             | 设置lua指定Table指定类型变量的值                       | harNAPI.t2lSetTableDouble("tbl2", "id2", 123.123456);        |
| t2lSetTableString | string[table名],string[field名],string | void             | 设置lua指定Table指定类型变量的值                       | harNAPI.t2lSetTableString("tbl2", "str", "hello world123456789"); |
| t2lSetTableBool   | string[table名],string[field名],bool]  | void             | 设置lua指定Table指定类型变量的值                       | harNAPI.t2lSetTableBool("tbl2", "valueBool", false);         |
| t2lGetTableInt    | string[table名],string[field名]        | int              | 获取lua指定Table指定类型变量的值                       | tmpValInt = harNAPI.t2lGetTableInt("tbl", "id");             |
| t2lGetTableLong   | string[table名],string[field名]        | long             | 获取lua指定Table指定类型变量的值                       | tmpValLong = harNAPI.t2lGetTableLong("tbl1", "idlong");      |
| t2lGetTableDouble | string[table名],string[field名]        | double           | 获取lua指定Table指定类型变量的值                       | tmpValDouble = harNAPI.t2lGetTableDouble("tbl2", "id2");     |
| t2lGetTableChar   | string[table名],string[field名]        | string           | 获取lua指定Table指定类型变量的值                       | tmpValChar = harNAPI.t2lGetTableChar("tbl2", "str");         |
| t2lGetTableBool   | string[table名],string[field名]        | bool             | 获取lua指定Table指定类型变量的值                       | tmpValBool = harNAPI.t2lGetTableBool("tbl2", "valueBool");   |
|                   |                                        |                  |                                                        |                                                              |
| t2lCallFunction   | string[函数名],...[参数列表]           | 返回值[常用类型] | 调用lua指定函数,并传递不定长度,不定类型参数,支持返回值 | let c = harNAPI.t2lCallFunction("testcallback", 100, 200);   |
|                   |                                        |                  |                                                        |                                                              |
|                   |                                        |                  |                                                        |                                                              |

# 目录结构

```
|---- luaarkts  
|     |---- libs  # 引用第三方lua库
|     |---- src  # 引用第三方lua库
|         |---- main   # 源码目录
|                |---- cpp  # native模块
|                      |----- aki 		# aki源码库(当前aki推荐源码引用)
|                      |----- thirdparty      # 三方库
|                                |----LuaJit  # LuaJit库(可替换鸿蒙三方库其他clua库)
|                      |----- types     # d.ts文件导出模块
|                      |----- *.cpp     # 项目源码
|                |---- ets  # ets接口模块
|                      |----- common    # 单元测试需要的测试模块
|                      |----- test      # 单元测试需要的测试模块
|                      |----- utils
|                               |----- main.ets # har包导出的接口
|                               |----- unitTest.ets # 单元测试用例
```

# 开源协议

本项目基于 Apache License 2.0 ，请自由的享受和参与开源。