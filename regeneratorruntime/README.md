# regeneratorRuntime

# Introduction

regeneratorRuntime is an asynchronous programming solution provided by ES6 and uses a syntax behavior completely different from that of traditional functions.

## How to Install

```
 ohpm install regenerator-runtime
 ohpm install @types/regenerator-runtime  // If a syntax error is reported, the regenerator-runtime package does not contain the type declaration. You need to download the declaration file of the package from @types/regenerator-runtime to rectify the syntax error.
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

### Available APIs
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/regeneratorRuntime/TEST.md).

# How to Use
```
import regeneratorRuntime from "regenerator-runtime";
```

API Calling Process

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

## Constraints
This project has been verified in the following version:

DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

```
|---- Domhandler  
|     |---- entry  # Sample code
            |---src # Sample code
            |---ohosTest
                |---ets 
                    |---test # Test case
|     |---- README.MD  # Readme    
|     |---- README_zh.MD  # Readme                 
```

## How to Contribute

If you find any problem when using parser-html-json, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/regeneratorruntime/LICENSE).
