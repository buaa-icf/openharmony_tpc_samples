## 1.0.1-rc.0

- 修复中文乱码问题
  - 新增接口SetCharEncoding(charEncoding : number)
- 修复创建多层级目录失败问题
- 修复unzipToDirectory接口解压0kb文件失败问题

## 1.0.0

- 支持zip包解密解压，支持GetEntryNames（获取压缩包文件列表）、ExtractFileToJS（解压文件内容）接口。
