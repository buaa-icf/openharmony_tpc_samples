## 1.0.0

Bouncy Castle ISO9797算法3 MAC（ANSI X9.19零售MAC）的OpenHarmony实现。提供与Android Bouncy Castle API的跨平台兼容性。

##### ✨ 核心功能

- 实现 ISO9797 Algorithm 3 MAC 算法（ANSI X9.19 Retail MAC）
- 支持 16 字节（双长度）和 24 字节（三长度）DES 密钥
- 支持 IV（初始化向量）
- 支持 CBC 模式手动实现
- 支持 EDE（Encrypt-Decrypt-Encrypt）操作
- 支持完整的6种填充方式：ISO7816d4Padding、ZeroBytePadding、PKCS7Padding、ISO10126d2Padding、X923Padding、TBCPadding
