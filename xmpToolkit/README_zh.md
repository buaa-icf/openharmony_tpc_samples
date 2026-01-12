# @ohos/xmp_toolkit

## 简介

    本库是参照开源软件 xmp_toolkit源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供用于从图像、视频和音频文件中提取XMP元数据的组件。

## 下载安装
     1. 安装命令如下
        ohpm install @ohos/xmp_toolkit

## 使用说明

1. 引入文件及代码依赖

 ```
    import { XMPMetaFactory, XMPMeta, XMPPropertyInfo } from '@ohos/xmp_toolkit';
 ```

## 接口列表

| **接口**                                | 功能                  |
|---------------------------------------|---------------------|
| XMPMeta.getProperty                   | 获取属性                |
| XMPMeta.getArrayItem                  | 获取数组项               |
| XMPMeta.countArrayItems               | 统计数组项个数	            |
| XMPMeta.getStructField                | 获取结构体字段             |
| XMPMeta.getQualifier                  | 获取限定符	              |
| XMPMeta.getLocalizedText              | 获取本地文本项	            |
| XMPMeta.getPropertyBoolean            | 获取布尔属性值	            |
| XMPMeta.getPropertyInteger            | 获取整型属性值		           |
| XMPMeta.getPropertyLong               | 获取长整型属性值	           |
| XMPMeta.getPropertyDouble             | 获取双精度属性值	           |
| XMPMeta.getPropertyDate               | 获取日期属性值	            |
| XMPMeta.getPropertyCalendar           | 获取日历属性值	            |
| XMPMeta.getPropertyBase64             | 获取Base64属性值	        |
| XMPMeta.getPropertyString             | 获取字符串属性值	           |
| XMPMeta.setProperty                   | 设置属性	               |
| XMPMeta.setArrayItem                  | 设置数组项	              |
| XMPMeta.insertArrayItem               | 插入数组项	              |
| XMPMeta.appendArrayItem               | 追加数组项	              |
| XMPMeta.setStructField                | 设置结构体字段	            |
| XMPMeta.setQualifier                  | 设置限定符	              |
| XMPMeta.setLocalizedText              | 设置本地化文本	            |
| XMPMeta.setPropertyBoolean            | 设置布尔属性	             |
| XMPMeta.setPropertyInteger            | 设置整型属性	             |
| XMPMeta.setPropertyLong               | 设置长整型属性	            |
| XMPMeta.setPropertyDouble             | 设置双精度属性	            |
| XMPMeta.setPropertyDate               | 设置日期属性	             |
| XMPMeta.setPropertyCalendar           | 设置日历属性	             |
| XMPMeta.setPropertyBase64             | 设置Base64属性	         |
| XMPMeta.deleteProperty                | 删除属性	               |
| XMPMeta.deleteArrayItem               | 删除数组项	              |
| XMPMeta.deleteStructField             | 删除结构体字段	            |
| XMPMeta.deleteQualifier               | 删除限定符	              |
| XMPMeta.doesPropertyExist             | 判断属性是否存在	           |
| XMPMeta.doesArrayItemExist            | 判断数组项是否存在	          |
| XMPMeta.doesStructFieldExist          | 判断结构体字段是否存在	        |
| XMPMeta.doesQualifierExist            | 判断限定符是否存在	          |
| XMPMeta.iterator                      | 获取迭代器	              |
| XMPMeta.getObjectName                 | 获取对象名称	             |
| XMPMeta.setObjectName                 | 设置对象名称	             |
| XMPMeta.getPacketHeader               | 获取Packet头部原文	       |
| XMPMeta.normalize                     | 对当前模型执行规范化	         |
| XMPMeta.sort                          | 排序整个数据模型	           |
| XMPMeta.dumpObject                    | 以可读形式输出模型	          |
| XMPMeta.clone                         | 深拷贝	                |
| XMPSchemaRegistry.registerNameSpace   | 注册命名空间	             |
| XMPSchemaRegistry.getNameSpacePrefix  | 获取命名空间前缀	           |
| XMPSchemaRegistry.getNameSpaceURL     | 获取命名空间URL	          |
| XMPSchemaRegistry.getNameSpaces       | 获取所有命名空间	           |
| XMPSchemaRegistry.getPrefix           | 获取前缀	               |
| XMPSchemaRegistry.deleteNamespace     | 删除命名空间	             |
| XMPSchemaRegistry.resolveAlias        | 解析别名映射	             |
| XMPSchemaRegistry.findAliases         | 查找全部别名	             |
| XMPSchemaRegistry.findAlias           | 查找指定别名	             |
| XMPSchemaRegistry.getAliases          | 获取全部别名映射	           |
| XMPiterator.skipSubtree               | 跳过当前节点的子树	          |
| XMPiterator.skipSiblings              | 跳过当前节点的剩余兄弟节点	      |
| XMPDateTime.getYear                   | 获取年	                |
| XMPDateTime.setYear                   | 设置年	                |
| XMPDateTime.getMonth                  | 获取月	                |
| XMPDateTime.setMonth                  | 设置月	                |
| XMPDateTime.getDay                    | 获取日	                |
| XMPDateTime.setDay                    | 设置日	                |
| XMPDateTime.getHour                   | 获取时	                |
| XMPDateTime.setHour                   | 设置时	                |
| XMPDateTime.getMinute                 | 获取分	                |
| XMPDateTime.setMinute                 | 设置分	                |
| XMPDateTime.getSecond                 | 获取秒	                |
| XMPDateTime.setSecond                 | 设置秒	                |
| XMPDateTime.getNanoSecond             | 获取纳秒	               |
| XMPDateTime.setNanoSecond             | 设置纳秒	               |
| XMPDateTime.getTimeZone               | 获取时区	               |
| XMPDateTime.setTimeZone               | 设置时区	               |
| XMPDateTime.getCalendar               | 获取日历视图	             |
| XMPDateTime.getISO8601String          | 获取ISO8601字符串	       |
| XMPVersionInfo.getMajor               | 获取主版本号	             |
| XMPVersionInfo.getMinor               | 获取次版本号	             |
| XMPVersionInfo.getMicro               | 获取修订号	              |
| XMPVersionInfo.getBuild               | 获取构建号	              |
| XMPVersionInfo.isDebug                | 是否调式版本	             |
| XMPVersionInfo.getMessage             | 获取版本描述信息	           |
| XMPMetaFactory.getSchemaRegistry      | 获取全局单例	             |
| XMPMetaFactory.create                 | 创建空的实例	             |
| XMPMetaFactory.parse                  | 解析XMP	              |
| XMPMetaFactory.parseFromString        | 从字符串解析	             |
| XMPMetaFactory.parseFromBuffer        | 从字节数组解析	            |
| XMPMetaFactory.serialize              | 序列化到流	              |
| XMPMetaFactory.serializeToBuffer      | 序列化为字节数组	           |
| XMPMetaFactory.serializeToString      | 序列化为字符串	            |
| XMPMetaFactory.reset                  | 重置全局实例	             |
| XMPDateTimeFactory.createFromCalendar | 从日历创建XMPDateTime实例	 |
| XMPDateTimeFactory.create             | 创建日期时间	             |
| XMPDateTimeFactory.createFromISO8601  | 从ISO8601字符串创建	      |
| XMPDateTimeFactory.getCurrentDateTime | 获取当前时间	             |
| XMPDateTimeFactory.setLocalTimeZone   | 设置为本地时区	            |
| XMPDateTimeFactory.convertToUTCTime   | 转为UTC时间	            |
| XMPDateTimeFactory.convertToLocalTime | 转为本地时间	             |
| XMPPathFactory.composeArrayItemPath   | 生成数组路径	             |
| XMPPathFactory.composeStructFieldPath | 生成结构体字段路径	          |
| XMPPathFactory.composeQualifierPath   | 生成限定符路径	            |
| XMPPathFactory.composeLangSelector    | 生成语言选择器路径	          |
| XMPPathFactory.composeFieldSelector   | 生成字段值选择器路径	         |
| XMPUtils.catenateArrayItems           | 数组合并为字符串	           |
| XMPUtils.separateArrayItems           | 字符串拆分到数组	           |
| XMPUtils.removeProperties             | 批量删除属性	             |
| XMPUtils.appendProperties             | 追加属性	               |
| XMPUtils.ConvertToBoolean             | 字符串转换为布尔	           |
| XMPUtils.ConvertFromBoolean           | 布尔转换为字符串	           |
| XMPUtils.ConvertToInteger             | 字符串转换为int	          |
| XMPUtils.ConvertFromInteger           | int转换为字符串	          |
| XMPUtils.ConvertToLong                | 字符串转为Long	          |
| XMPUtils.ConvertFromLong              | Long转换为字符串	         |
| XMPUtils.ConvertToDouble              | 字符串转换为Double	       |
| XMPUtils.ConvertFromDouble            | Double转换为字符串	       |
| XMPUtils.ConvertToDate                | 字符串转换为Date	         |
| XMPUtils.ConvertFromDate              | Date转换为字符串	         |
| XMPUtils.encodeBase64                 | 二进制转换为Base64	       |
| XMPUtils.decodeBase64                 | Base64转换为二进制	       |
| XMPException.getErrorCode             | 获取错误码	              |

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望三方库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
  
  -keep
  ./oh_modules/@ohos/xmp_toolkit


## 约束与限制

在下述版本验证通过：

- DevEco Studio: 6.0.1 release, SDK: API12 Release(5.0.0.66)

- OpenHarmony SDK:API12 (5.0.0)

## 目录结构
```
|---- xmpToolkit
|     |---- entry  # 示例代码文件夹
|     |---- xmp_Toolikit  # xmp_toolkit库文件夹
|               |----src/main #
|                           |----impl # xmp接口实现代码文件夹
|                           |----options # 选项接口实现代码文件夹
|                           |----properties  # 属性相关接口实代码文件夹
|                           |----Sample  # 源库中调用xmp_toolkit接口实例文件夹
|     |---- README.MD  # 安装使用方法
|     |---- README_zh.MD  # 安装使用方法
```

## 开源协议

本项目基于 [Apache-2.0 License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/metadata-extractor/LICENSE)
，请自由地享受和参与开源。