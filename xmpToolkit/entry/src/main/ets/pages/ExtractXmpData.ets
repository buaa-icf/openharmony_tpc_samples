import { XMPMeta, XMPProperty, XMPMetaFactory } from '@ohos/xmp_toolkit';
import { util } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct xmpSample {
  @State isRunning: boolean = false;
  @State aigcResults: string = '';
  @State showAIGC: boolean = false;

  /**
   * 从 JPEG 文件中提取 XMP 元数据
   */
  private extractXMPFromJPEG(buffer: Uint8Array): string | null {
    try {
      // 查找 JPEG SOI 标记
      if (buffer[0] !== 0xFF || buffer[1] !== 0xD8) {
        return null;
      }

      let position: number = 2; // 跳过 SOI
      const protocol = 'http:';
      const XMP_NAMESPACE: string = protocol + '//ns.adobe.com/xap/1.0/\0';

      // 遍历所有 APP 段
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
          // 其他 APP 段，跳过
          const segmentLength: number = (buffer[position + 2] << 8) | buffer[position + 3];
          position += 2 + segmentLength;
        } else {
          position++;
        }
      }

      return null;
    } catch (e) {
      console.error('JPEG XMP extraction error:', e);
      return null;
    }
  }

  /**
   * 解析 XMP 元数据
   */
  private parseXMPMetadata(meta: XMPMeta): string {
    try {
      // 注册常用命名空间
      const protocol = 'http:';
      const NS_DC: string = protocol + '//purl.org/dc/elements/1.1/';
      const NS_XMP: string = protocol + '//ns.adobe.com/xap/1.0/';
      const NS_TIFF: string = protocol + '//ns.adobe.com/tiff/1.0/';
      const NS_PHOTOSHOP: string = protocol + '//ns.adobe.com/photoshop/1.0/';
      const NS_EXIF: string = protocol + '//ns.adobe.com/exif/1.0/';

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

      // 3. 提取创建者
      try {
        const creator: string = meta.getPropertyString(NS_DC, 'creator');
        if (creator) {
          result += `创建者: ${creator}\n`;
        }
      } catch (e) {
        console.log('提取创建者失败:', e);
      }

      // 4. 提取主题标签
      try {
        const subject: string = meta.getPropertyString(NS_DC, 'subject');
        if (subject) {
          result += `主题标签: ${subject}\n`;
        }
      } catch (e) {
        console.log('提取主题标签失败:', e);
      }

      // 5. 提取创建工具
      try {
        const creatorTool: string = meta.getPropertyString(NS_XMP, 'CreatorTool');
        if (creatorTool) {
          result += `创建工具: ${creatorTool}\n`;
        }
      } catch (e) {
        console.log('提取创建工具失败:', e);
      }

      // 6. 提取创建日期
      try {
        const createDate: string = meta.getPropertyString(NS_XMP, 'CreateDate');
        if (createDate) {
          result += `创建日期: ${createDate}\n`;
        }
      } catch (e) {
        console.log('提取创建日期失败:', e);
      }

      // 7. 提取修改日期
      try {
        const modifyDate: string = meta.getPropertyString(NS_XMP, 'ModifyDate');
        if (modifyDate) {
          result += `修改日期: ${modifyDate}\n`;
        }
      } catch (e) {
        console.log('提取修改日期失败:', e);
      }

      // 8. 提取评分
      try {
        const rating: string = meta.getPropertyString(NS_XMP, 'Rating');
        if (rating) {
          result += `评分: ${rating}\n`;
        }
      } catch (e) {
        console.log('提取评分失败:', e);
      }

      // 9. 提取地理位置
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

      // 10. 提取作者职位和版权信息
      try {
        const authorsPosition: string = meta.getPropertyString(NS_PHOTOSHOP, 'AuthorsPosition');
        const credit: string = meta.getPropertyString(NS_PHOTOSHOP, 'Credit');
        if (authorsPosition) {
          result += `作者职位: ${authorsPosition}\n`;
        }
        if (credit) {
          result += `版权信息: ${credit}\n`;
        }
      } catch (e) {
        console.log('提取作者信息失败:', e);
      }

      // 11. 提取TIFF信息
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

      // 12. 提取EXIF信息
      try {
        const colorSpace: string = meta.getPropertyString(NS_EXIF, 'ColorSpace');
        if (colorSpace) {
          result += `色彩空间: ${colorSpace}\n`;
        }
      } catch (e) {
        console.log('提取EXIF信息失败:', e);
      }

      // 13. 检查是否可能包含AIGC信息（通过描述字段）
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

  build() {
    Column() {
      // 标题
      Text('xmp_toolkit 元数据提取测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 12, bottom: 12 })

      // XMP 元数据解析按钮
      Button('解析图片XMP元数据')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .width('85%')
        .height(44)
        .enabled(!this.isRunning)
        .onClick(async () => {
          await this.parseImageMetadata();
        })
        .margin({ bottom: 12 })

      // XMP 元数据解析结果
      if (this.showAIGC) {
        Text('XMP元数据解析结果:')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Start)
          .margin({ top: 12, bottom: 8 })

        Scroll() {
          Text(this.aigcResults)
            .fontSize(11)
            .fontFamily('monospace')
            .backgroundColor('#F5F5F5')
            .padding(10)
            .borderRadius(8)
            .width('100%')
        }
        .width('94%')
        .height(300)
        .scrollable(ScrollDirection.Vertical)
        .margin({ bottom: 12 })
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10, top: 6, bottom: 6 })
  }
}