**CHANGELOG.md**

## 1.0.2-rc.1
- Replace luaJIT with the Lua library
- Fix the l2tCallModuleFunc interface so that it can return string types

## 1.0.2-rc.0
- Fix the issue where T2lCallFunction fails when passing a string

## 1.0.1
- Switch the repository address to gitcode

## 1.0.1-rc.1
- Remove useless demo code from luaarks module

## 1.0.1-rc.0
- 在entry模块下增加XTS文件

## 1.0.0
- 正式版本发布
- 通过LuaJIT和NAPI实现lua脚本和ts脚本互相访问的能力。并通过AKI库简化C++和Arkts开发
- lua->arkts 模块动态加载
- lua->arkts 函数访问
- lua->arkts 变量访问
- lua->arkts 回调
- arkts->lua 访问前导入
- arkts->lua 读写变量
- arkts->lua 读写table变量
- arkts->lua 函数访问