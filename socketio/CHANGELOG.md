## v2.0.1-rc.3
- 新增设置请求头header功能

## v2.0.1-rc.2
- 支持x86

## v2.0.1-rc.1

- 修复Openharmony4.1.0.66版本上connect接口调用crash问题，问题原因：由于系统napi_call_function接口在该版本上参数定义问题导致crash。

## v2.0.1-rc.0

- 修复socket.io接口connect调用crash问题

## v2.0.0

- 包管理工具由npm切换为ohpm
- DevEco Studio 版本： 4.1 Canary(4.1.3.317)
- OpenHarmony SDK:API11 (4.1.0.36)

## v1.0.1

- 适配3.1.0.200 IDE

## v1.0.0

- 实现功能

  作为与服务端之间建立链接的客户端库，使用c代码在ohos平台编译成.so文件，对外暴露connect、on、open、off、close、emit等接口。
