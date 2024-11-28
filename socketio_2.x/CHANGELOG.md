## v1.0.3-rc.0

- Fixed the issue of duplicate emit messages.

## v1.0.2

- Fix the problem that the set_option interface cannot be connected with {}.
- fix the problem that the array content is lost when sending the array data.
- Fix the problem that the client parses json string data when the server sends data with escape characters.

## v1.0.1

- Fixed an issue when the server returned json strings containing special characters.
- Binary data reception is supported.

## v1.0.0

- 实现功能

  作为与服务端之间建立链接的客户端库，使用c代码在ohos平台编译成.so文件，对外暴露connect、on、open、off、close、emit等接口。
