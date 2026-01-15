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

| **接口**                                                                     | 参数                                                                                                                    | 功能                |
|----------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-------------------|
| XMPMeta.getProperty                                                        | String schemaNS, String propName                                                                                      | 获取属性值             |
| XMPMeta.getArrayItem                                                       | String schemaNS, String arrayName, int itemIndex                                                                      | 获取数组项             |
| XMPMeta.countArrayItems                                                    | String schemaNS, String arrayName                                                                                     | 获取数组项数量           |
| XMPMeta.getStructField                                                     | String schemaNS, String structName, String fieldNS, String fieldName                                                  | 获取结构体字段           |
| XMPMeta.getQualifier                                                       | String schemaNS, String propName, String qualNS, String qualName                                                      | 获取限定符             |
| XMPMeta.setProperty                                                        | String schemaNS, String propName, Object propValue, PropertyOptions options	                                          | 设置属性值             |
| XMPMeta.setArrayItem                                                       | String schemaNS, String arrayName, int itemIndex, String itemValue, PropertyOptions options                           | 设置数组项             |
| XMPMeta.insertArrayItem                                                    | String schemaNS, String arrayName, int itemIndex, String itemValue, PropertyOptions options                           | 插入数组项             |
| XMPMeta.appendArrayItem                                                    | String schemaNS, String propName, PropertyOptions arrayOptions, String itemValue, PropertyOptions options	            | 追加数组项             |
| XMPMeta.setStructField                                                     | String schemaNS, String propName, String fieldNS, String fieldName, String fieldValue, PropertyOptions options        | 设置结构体字段           |
| XMPMeta.setQualifier                                                       | String schemaNS, String propName, String qualNS, String qualName, String qualValue, PropertyOptions options           | 设置限定符             |
| XMPMeta.deleteProperty                                                     | String schemaNS, String propName                                                                                      | 删除属性              |
| XMPMeta.deleteArrayItem                                                    | String schemaNS, String arrayName, int itemIndex	                                                                     | 删除数组项             |
| XMPMeta.deleteStructField                                                  | String schemaNS, String structName, String fieldNS, String fieldName                                                  | 删除结构体字段           |
| XMPMeta.deleteQualifier                                                    | String schemaNS, String propName, String qualNS, String qualName	                                                     | 删除限定符             |
| XMPMeta.doesPropertyExist                                                  | String schemaNS, String propName                                                                                      | 检查属性是否存在          |
| XMPMeta.doesArrayItemExist                                                 | String schemaNS, String arrayName, int itemIndex                                                                      | 检查数组项是否存在         |
| XMPMeta.doesStructFieldExist                                               | String schemaNS, String structName, String fieldNS, String fieldName                                                  | 检查结构体字段是否存在       |
| XMPMeta.doesQualifierExist                                                 | String schemaNS, String propName, String qualNS, String qualName	                                                     | 检查限定符是否存在         |
| XMPMeta.getLocalizedText                                                   | String schemaNS, String propName, String genericLang, String specificLang                                             | 获取本地化文本           |
| XMPMeta.setLocalizedText                                                   | String schemaNS, String propName, String genericLang, String specificLang, String itemValue, PropertyOptions options	 | 设置本地化文本           |
| XMPMeta.getPropertyBoolean                                                 | String schemaNS, String propName                                                                                      | 获取布尔属性            |
| XMPMeta.getPropertyInteger                                                 | String schemaNS, String propName                                                                                      | 获取整型属性            |
| XMPMeta.getPropertyLong                                                    | String schemaNS, String propName                                                                                      | 获取长整型属性           |
| XMPMeta.getPropertyDouble                                                  | String schemaNS, String propName                                                                                      | 获取双精度属性           |
| XMPMeta.getPropertyDate                                                    | String schemaNS, String propName	                                                                                     | 获取日期属性            |
| XMPMeta.getPropertyCalendar                                                | String schemaNS, String propName	                                                                                     | 获取日历属性            |
| XMPMeta.getPropertyBase64                                                  | String schemaNS, String propName                                                                                      | 获取Base64属性        |
| XMPMeta.getPropertyString                                                  | String schemaNS, String propName                                                                                      | 获取字符串属性           |
| XMPMeta.setPropertyBoolean                                                 | String schemaNS, String propName, boolean propValue, PropertyOptions options                                          | 设置布尔属性            |
| XMPMeta.setPropertyInteger                                                 | String schemaNS, String propName, number propValue, PropertyOptions options	                                          | 设置整数属性            |
| XMPMeta.setPropertyLong                                                    | String schemaNS, String propName, number propValue, PropertyOptions options                                           | 设置长整数属性           |
| XMPMeta.setPropertyDouble                                                  | String schemaNS, String propName, number propValue, PropertyOptions options                                           | 设置双精度属性           |
| XMPMeta.setPropertyDate                                                    | String schemaNS, String propName, XMPDateTime propValue, PropertyOptions options	                                     | 设置日期属性            |
| XMPMeta.setPropertyCalendar                                                | String schemaNS, String propName, Calendar propValue, PropertyOptions options	                                        | 设置日历属性            |
| XMPMeta.setPropertyBase64                                                  | String schemaNS, String propName, byte[] propValue, PropertyOptions options	                                          | 设置Base64属性        |
| XMPMeta.iterator                                                           | 	                                                                                                                     | 创建属性迭代器           |
| XMPMeta.iterator(IteratorOptions options)                                  | IteratorOptions options	                                                                                              | 创建属性迭代器           |
| XMPMeta.iterator(String schemaNS, String propName,IteratorOptions options) | String schemaNS, String propName, IteratorOptions options                                                             | 创建属性迭代器           |
| XMPMeta.getObjectName                                                      | 	                                                                                                                     | 获取对象名称            |
| XMPMeta.setObjectName                                                      | String name	                                                                                                          | 设置对象名称            |
| XMPMeta.getPacketHeader                                                    | 	                                                                                                                     | 获取数据包头            |
| XMPMeta.normalize(ParseOptions options)                                    | ParseOptions options	                                                                                                 | 规范化元数据            |
| XMPMeta.sort                                                               | 	                                                                                                                     | 排序数据模型            |
| XMPMeta.dumpObject                                                         | 	                                                                                                                     | 以可读形式转储对象         |
| XMPMeta.clone                                                              | 	                                                                                                                     | 克隆元数据树            |
| XMPMetaFactory.create                                                      |                                                                                                                       | 创建空的XMPMeta对象     |
| XMPMetaFactory.parse                                                       | InputStream in, ParseOptions options                                                                                  | 从输入流解析            |
| XMPMetaFactory.parseFromString                                             | String packet, ParseOptions options	                                                                                  | 从字符串解析            |
| XMPMetaFactory.parseFromBuffer                                             | byte[] buffer, ParseOptions options	                                                                                  | 从字节数组解析           |
| XMPMetaFactory.serialize                                                   | XMPMeta xmp, OutputStream out, SerializeOptions options	                                                              | 序列化到输出流           |
| XMPMetaFactory.serializeToBuffer                                           | XMPMeta xmp, SerializeOptions options	                                                                                | 序列化到字节数组          |
| XMPMetaFactory.serializeToString                                           | XMPMeta xmp, SerializeOptions options                                                                                 | 序列化到字符串           |
| XMPMetaFactory.getSchemaRegistry                                           | 	                                                                                                                     | 获取模式注册表单例         |
| XMPMetaFactory.reset                                                       | 	                                                                                                                     | 重置模式注册表           |
| XMPUtils.catenateArrayItems                                                | XMPMeta xmp, String schemaNS, String arrayName, String separator, String quotes, boolean allowCommas 	                | 将数组连接成字符串         |
| XMPUtils.separateArrayItems                                                | XMPMeta xmp, String schemaNS, String arrayName, String catedStr, PropertyOptions arrayOptions, boolean preserveCommas | 将字符串分离成数组项        |
| XMPUtils.removeProperties                                                  | XMPMeta xmp, String schemaNS, String arrayName, doAllProperties boolean, boolean includeAliases                       | 删除多个属性            |
| XMPUtils.appendProperties                                                  | XMPMeta source, XMPMeta dest, boolean doAllProperties, boolean replaceOldValues, boolean deleteEmptyValues            | 追加属性              |
| XMPUtils.convertToBoolean                                                  | String value                                                                                                          | Boolean转换         |
| XMPUtils.convertFromBoolean                                                | Boolean value	                                                                                                        | Boolean转换         |
| XMPUtils.convertToInteger                                                  | String rawValue                                                                                                       | Integer转换         |
| XMPUtils.convertFromInteger                                                | int value	                                                                                                            | Integer转换         |
| XMPUtils.convertToLong                                                     | String rawValue	                                                                                                      | Long转换            |
| XMPUtils.convertFromLong                                                   | long value	                                                                                                           | Long转换            |
| XMPUtils.convertToDouble                                                   | String rawValue	                                                                                                      | Double转换          |
| XMPUtils.convertFromDouble                                                 | double value	                                                                                                         | Double转换          |
| XMPUtils.convertToDate                                                     | String rawValue	                                                                                                      | Date转换            |
| XMPUtils.convertFromDate                                                   | XMPDateTime value	                                                                                                    | Date转换            |
| XMPUtils.encodeBase64                                                      | byte[] buffer	                                                                                                        | Base64编码          |
| XMPUtils.decodeBase64                                                      | String base64String	                                                                                                  | Base64解码          |
| XMPiterator.skipSubtree                                                    | 	                                                                                                                     | 跳过当前节点的子树         |
| XMPiterator.skipSiblings                                                   | 	                                                                                                                     | 跳过当前节点及其剩余兄弟节点    |
| XMPDateTime.getYear                                                        | 	                                                                                                                     | 获取年份              |
| XMPDateTime.setYear                                                        | int year                                                                                                              | 设置年份              |
| XMPDateTime.getMonth                                                       | 	                                                                                                                     | 获取月份              |
| XMPDateTime.setMonth                                                       | int Month	                                                                                                            | 设置月份              |
| XMPDateTime.getDay                                                         | 	                                                                                                                     | 获取日期              |
| XMPDateTime.setDay                                                         | int day                                                                                                               | 设置日期              |
| XMPDateTime.getHour                                                        | 	                                                                                                                     | 获取小时              |
| XMPDateTime.setHour                                                        | int hour                                                                                                              | 设置小时              |
| XMPDateTime.getMinute                                                      | 	                                                                                                                     | 获取分钟              |
| XMPDateTime.setMinute                                                      | int minute                                                                                                            | 设置分钟              |
| XMPDateTime.getSecond                                                      | 	                                                                                                                     | 获取秒               |
| XMPDateTime.setSecond                                                      | int second                                                                                                            | 设置秒               |
| XMPDateTime.getNanoSecond                                                  | 	                                                                                                                     | 获取纳秒              |
| XMPDateTime.setNanoSecond                                                  | int nanoSecond                                                                                                        | 设置纳秒              |
| XMPDateTime.getTimeZone                                                    | 	                                                                                                                     | 获取时区              |
| XMPDateTime.setTimeZone                                                    | TimeZone tz                                                                                                           | 设置时区              |
| XMPDateTime.getCalendar                                                    | 	                                                                                                                     | 获取日历              |
| XMPDateTime.getISO8601String                                               | 	                                                                                                                     | 获取ISO8601字符串      |
| XMPDateTimeFactory.createFromCalendar                                      | Calendar calendar	                                                                                                    | 从Calendar创建       |
| XMPDateTimeFactory.create                                                  | int year, int month, int day, int hour, int minute, int	second, int nanoSecond                                        | 从初始值创建            |
| XMPDateTimeFactory.createFromISO8601                                       | String strValue	                                                                                                      | 从ISO8601字符串创建     |
| XMPDateTimeFactory.getCurrentDateTime                                      | 	                                                                                                                     | 获取当前日期时间          |
| XMPDateTimeFactory.setLocalTimeZone                                        | XMPDateTime dateTime                                                                                                  | 设置为本地时区           |
| XMPDateTimeFactory.convertToUTCTime                                        | XMPDateTime dateTime                                                                                                  | 转换为UTC时间          |
| XMPDateTimeFactory.convertToLocalTime                                      | XMPDateTime dateTime                                                                                                  | 转换为本地时间           |
| XMPSchemaRegistry.registerNamespace                                        | String namespaceURI, String suggestedPrefix                                                                           | 注册命名空间            |
| XMPSchemaRegistry.getNamespacePrefix                                       | String namespaceURI                                                                                                   | 获取命名空间前缀          |
| XMPSchemaRegistry.getNamespaceURL                                          | String suggestedPrefix                                                                                                | 获取命名空间URL         |
| XMPSchemaRegistry.getNamespaces                                            | 	                                                                                                                     | 获取所有命名空间(URL->前缀) |
| XMPSchemaRegistry.getPrefixes                                              | 	                                                                                                                     | 获取所有前缀(前缀->URL)   |
| XMPSchemaRegistry.deleteNamespace                                          | String namespaceURI                                                                                                   | 删除命名空间            |
| XMPSchemaRegistry.resolveAlias                                             | String aliasNS, String aliasProp                                                                                      | 解析别名              |
| XMPSchemaRegistry.findAliases                                              | String aliasNS                                                                                                        | 查找命名空间中的所有别名      |
| XMPSchemaRegistry.findAlias                                                | String qname                                                                                                          | 查找别名              |
| XMPSchemaRegistry.getAliases                                               | 	                                                                                                                     | 获取所有别名            |
| XMPPathFactory.composeArrayItemPath                                        | String arrayName, String itemIndex                                                                                    | 构建数组项路径           |
| XMPPathFactory.composeStructFieldPath                                      | String fieldNS, String fieldName                                                                                      | 构建结构体字段路径         |
| XMPPathFactory.composeQualifierPath                                        | String qualNS, String qualName                                                                                        | 构建限定符路径           |
| XMPPathFactory.composeLangSelector                                         | String arrayName, String langName                                                                                     | 构建语言选择器路径         |
| XMPPathFactory.composeFieldSelector                                        | String arrayName, String fieldNS, String fieldName, String fieldValue                                                | 构建字段选择器路径         |
| XMPVersionInfo.getMajor                                                    | 	                                                                                                         | 获取主版本号            |
| XMPVersionInfo.getMinor                                                    | 	                                                                                                         | 获取次版本号            |
| XMPVersionInfo.getMicro                                                    | 	                                                                                                           | 获取微版本号            |
| XMPVersionInfo.getBuild                                                    | 	                                                                                                           | 获取构建号             |
| XMPVersionInfo.isDebug                                                     | 	                                                                                                         | 是否为调式版本           |
| XMPVersionInfo.getMessage                                                  | 	                                                                                                         | 获取版本信息字符串         |
| XMPException.getErrorCode                                                  | 获取错误码	                                                                                                                | 获取数组项             |

## 使用示例
```
- 提取图片中的XMP元数据

  import { XMPMeta, XMPProperty } from '@ohos/xmp_toolkit';
  import { XMPMetaFactory } from '@ohos/xmp_toolkit';

  /**
   * 解析图片文件中的 XMP 元数据
   */
  async parseImageMetadata() {
    this.showAIGC = true;
    this.aigcResults = '正在解析...\n';

    try {
      const context = getContext(this) as common.UIAbilityContext;
      const resourceMgr = context.resourceManager;

      try {
        const jpgBuffer = await resourceMgr.getRawFileContent('testJpg.jpg');
        const jpgArray: Uint8Array = new Uint8Array(jpgBuffer);

        const xmpXml: string | null = this.extractXMPFromJPEG(jpgArray);
        if (xmpXml) {
          const meta: XMPMeta = XMPMetaFactory.parseFromString(xmpXml);
          const xmpInfo: string = this.parseXMPMetadata(meta);

          this.aigcResults = '找到XMP数据！\n\n' + xmpInfo;
        } else {
          this.aigcResults = '未找到XMP数据';
        }
      } catch (e) {
        this.aigcResults = '解析失败: ' + (e as Error).message;
      }
    } catch (e) {
      this.aigcResults = '错误: ' + (e as Error).message;
    }
  }
  
  private extractXMPFromJPEG(buffer: Uint8Array): string | null {
    const XMP_NAMESPACE: string = 'http://ns.adobe.com/xap/1.0/\0';
    
    while (position < buffer.length - 1) {
        if (buffer[position] === 0xFF && buffer[position + 1] === 0xE1) {
          // 找到 APP1 段
          const segmentLength: number = (buffer[position + 2] << 8) | buffer[position + 3];

          // 检查是否是 XMP 段
          const namespaceStart: number = position + 4;
          if (namespaceStart + 29 <= buffer.length) {
            const namespaceBytes: Uint8Array = buffer.slice(namespaceStart, namespaceStart + 29);
            const decoder: util.TextDecoder = new util.TextDecoder();
            const namespace: string = decoder.decodeToString(namespaceBytes);

            if (namespace === XMP_NAMESPACE) {
              // 提取 XMP XML
              const xmpStart: number = namespaceStart + 29;
              const xmpLength: number = segmentLength - 2 - 29;
              const xmpBytes: Uint8Array = buffer.slice(xmpStart, xmpStart + xmpLength);
              return decoder.decodeToString(xmpBytes);
            }
          }

          position += 2 + segmentLength;
        } else if (buffer[position] === 0xFF &&
          buffer[position + 1] >= 0xE0 &&
          buffer[position + 1] <= 0xEF) {

          const segmentLength: number = (buffer[position + 2] << 8) | buffer[position + 3];
          position += 2 + segmentLength;
        } else {
          position++;
        }
      }
  }

  /**
   * 解析 XMP 元数据
   */
  private parseXMPMetadata(meta: XMPMeta): string {
    try {
      // 注册常用命名空间
      const NS_DC: string = 'http://purl.org/dc/elements/1.1/';
      const NS_XMP: string = 'http://ns.adobe.com/xap/1.0/';
      const NS_TIFF: string = 'http://ns.adobe.com/tiff/1.0/';
      const NS_PHOTOSHOP: string = 'http://ns.adobe.com/photoshop/1.0/';
      const NS_EXIF: string = 'http://ns.adobe.com/exif/1.0/';

      const registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(NS_DC, 'dc');
      registry.registerNamespace(NS_XMP, 'xmp');
      registry.registerNamespace(NS_TIFF, 'tiff');
      registry.registerNamespace(NS_PHOTOSHOP, 'photoshop');
      registry.registerNamespace(NS_EXIF, 'exif');

      let result: string = 'XMP 元数据:\n\n';

      // 1. 提取标题
      try {
        const titleProp: XMPProperty | null = meta.getLocalizedText(NS_DC, 'title', '', 'x-default');
        if (titleProp) {
          result += `标题: ${titleProp.getValue()}\n`;
        }
      } catch (e) {
        console.log('提取标题失败:', e);
      }

      // 2. 提取描述
      try {
        const descProp: XMPProperty | null = meta.getLocalizedText(NS_DC, 'description', '', 'x-default');
        if (descProp) {
          result += `描述: ${descProp.getValue()}\n`;
        }
      } catch (e) {
        console.log('提取描述失败:', e);
      }
      
      
      ......
      

      // 3. 提取创建日期
      try {
        const createDate: string = meta.getPropertyString(NS_XMP, 'CreateDate');
        if (createDate) {
          result += `创建日期: ${createDate}\n`;
        }
      } catch (e) {
        console.log('提取创建日期失败:', e);
      }

      // 4. 提取地理位置
      try {
        const city: string = meta.getPropertyString(NS_PHOTOSHOP, 'City');
        const state: string = meta.getPropertyString(NS_PHOTOSHOP, 'State');
        const country: string = meta.getPropertyString(NS_PHOTOSHOP, 'Country');
        if (city || state || country) {
          let location: string = '';
          if (city) {
            location += city;
          }
          if (state) {
            location += (location ? ', ' : '') + state;
          }
          if (country) {
            location += (location ? ', ' : '') + country;
          }
          result += `地理位置: ${location}\n`;
        }
      } catch (e) {
        console.log('提取地理位置失败:', e);
      }

      // 5. 提取TIFF信息
      try {
        const make: string = meta.getPropertyString(NS_TIFF, 'Make');
        const model: string = meta.getPropertyString(NS_TIFF, 'Model');
        const width: string = meta.getPropertyString(NS_TIFF, 'ImageWidth');
        const height: string = meta.getPropertyString(NS_TIFF, 'ImageLength');
        if (make || model) {
          result += `相机信息: ${make || ''}${make && model ? ' ' : ''}${model || ''}\n`;
        }
        if (width && height) {
          result += `图片尺寸: ${width} × ${height}\n`;
        }
      } catch (e) {
        console.log('提取TIFF信息失败:', e);
      }

      // 6. 提取EXIF信息
      try {
        const colorSpace: string = meta.getPropertyString(NS_EXIF, 'ColorSpace');
        if (colorSpace) {
          result += `色彩空间: ${colorSpace}\n`;
        }
      } catch (e) {
        console.log('提取EXIF信息失败:', e);
      }

      // 7. 检查是否可能包含AIGC信息（通过描述字段）
      try {
        const descProp: XMPProperty | null = meta.getLocalizedText(NS_DC, 'description', '', 'x-default');
        if (descProp) {
          const descValue: string = descProp.getValue();
          if (descValue.includes('AIGC') || descValue.includes('AI生成') ||
          descValue.includes('Artificial Intelligence') || descValue.includes('生成式AI')) {
            result += `\nAIGC信息: ${descValue}\n`;
          }
        }
      } catch (e) {
        console.log('检查AIGC信息失败:', e);
      }

      if (result === 'XMP 元数据:\n\n') {
        result += '未找到标准XMP元数据';
      }

      return result;
    } catch (e) {
      return '解析错误: ' + (e as Error).message;
    }
  }

```

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