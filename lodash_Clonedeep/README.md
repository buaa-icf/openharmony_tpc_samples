# lodash.clonedeep

## 简介
lodash.clonedeep库用于创建一个深度克隆的给定对象。深度克隆意味着不仅会复制对象的属性，还会递归地复制其所有子对象，以确保生成的副本是完全独立于原始对象的。

## 下载安装:
```bash
ohpm install lodash.clonedeep@4.5.0
```

## 使用说明
```bash
import cloneDeep from @ohos/lodash.clonedeep
this.message = 'const objb = { b: null };\r\n const obja = { a: objb }; \r\nobjb.b = obja;\r\n拷贝结果是：\r\n'
    try {
      const objb = { b: null };
      const obja = { a: objb };
      objb.b = obja;
      let origin = JSON.stringify(objb)
      console.log('ZDY---不使用拷贝--->' + origin);
      this.message = this.message + "不使用拷贝，直接打印循环引用的结果是：" + origin
    } catch (err) {
      console.log('ZDY---不使用拷贝--->' + err);
      this.message = this.message + "\r\n不使用拷贝，循环引用出错：" + err
    }
    try {
      const objb = {
        b: null
      };
      const obja = {
        a: objb
      };
      objb.b = cloneDeep(obja);
      let cloneObj = JSON.stringify(objb)
      console.log('ZDY---使用拷贝--->' + cloneObj);
      this.message = this.message + "\r\n使用深拷贝，循环引用的结果是：" + cloneObj
    } catch (err) {
      console.log('ZDY---使用拷贝--->' + err);
      this.message = this.message + "\r\n使用深拷贝，循环引用出错：" + err
    }
```
## 接口说明


| **接口**                                                      | 功能             |
| ------------------------------------------------------------ | ---------------- |
| cloneDeep(value: ESObject): ESObject | 深拷贝对象，将一个对象进行深拷贝 |



## 约束与限制

在下述版本验证通过：适配DevEco Studio:4.1 Canary(4.1.3.317)，OpenHarmony SDK:API version 11 (4.1.0.36).
## 目录结构
````
|---- lodash_Clonedeep  
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。
## 开源协议
本项目基于 [MIT LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/lodash_Clonedeep/LICENSE) ，请自由地享受和参与开源。