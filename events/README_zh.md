# events

## 简介
events 是一个提供事件监听的功能库

## 下载安装:
```bash
ohpm install events@3.3.0
ohpm install @types/events --save-dev // import events 的时候语法报错, 其原因是events包内不含类型声明, 需要 @types/events 下载这个包的声明文件, 从而解决语法的报错.
```

## 使用说明
```bash
import * as events from 'events'
this.event = new events.EventEmitter();
this.event.on('message', this.messageCb);
```
## 接口说明


| **接口**                                                      | 功能             |
| ------------------------------------------------------------ | ---------------- |
| on(topic: string,cb:Function) | 监听特定topic |
| emit(topic:string,msg:string) | 发送特定topic的消息通知 |
| off(topic:string) | 取消监听特定topic |

## 约束与限制

在下述版本验证通过：
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio:4.1 Canary(4.1.3.317)，OpenHarmony SDK:API version 11 (4.1.0.36)
## 目录结构
````
|---- events 
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- README.md  # 安装使用方法                    
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。
## 开源协议
本项目基于 [MIT LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/events/LICENSE) ，请自由地享受和参与开源。