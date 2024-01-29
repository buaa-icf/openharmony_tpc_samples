# regeneratorRuntime

# 简介

regeneratorRuntime是 ES6 提供的一种异步编程解决方案，语法行为与传统函数完全不同,是一种解决异步方案

## 下载安装

```
 ohpm install regenerator-runtime
```

OpenHarmony ohpm环境配置等更多内容，请参考[如何安装OpenHarmony ohpm](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

### 接口说明
单元测试用例详情见[TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/regeneratorRuntime/TEST.md)

# 使用说明
```
import regeneratorRuntime from "regenerator-runtime";
```

调用流程。

```javascript
var marked = regeneratorRuntime.mark(foo);
export default function foo() {
    return regeneratorRuntime.wrap(function foo$(_context) {
        while (1) {
            switch ((_context.prev = _context.next)) {
                case 0:
                    _context.next = 2;
                    return "result1";
                case 2:
                    _context.next = 4
                    return "result2";
                case 4:
                    _context.next = 6;
                    return "result3";
                case 6:
                case "end":
                    return _context.stop();
            }
        }
    }, marked);
}
```

## 约束与限制
在下述版本验证通过：

DevEco Studio 版本： 4.1 Canary(4.1.3.317),OpenHarmony SDK:API11 (4.1.0.36)。

## 目录结构

```
|---- Domhandler  
|     |---- entry  # 示例代码文件夹
            |---src # sample代码
            |---ohosTest
                |---ets 
                    |---test #测试用例
|     |---- README.MD  # 安装使用方法                   
```

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)。

## 开源协议

本项目基于 [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/regeneratorruntime/LICENSE)，请自由地享受和参与开源。

