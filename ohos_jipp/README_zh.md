# ohos_jipp

## 介绍

ohos_jipp是一个将pdf转换成pclm文件的库。

本项目主要是OpenHarmony系统下以[jipp 0.7.17](https://github.com/HPInc/jipp)为主要依赖开发，主要接口针对OpenHarmony系统进行合理的适配研发。

## 下载安装

1.安装

```
ohpm install @ohos/jipp_pdl
```
OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。


## 使用说明

1.pdf转换成pclm

```
import { image } from '@kit.ImageKit';
import { fileIo, fileUri, picker } from '@kit.CoreFileKit';
import { Pdfium, PdfiumPage } from 'libentry.so';
import {
  ColorSpace,
  ImageType,
  MediaSource,
  OutputSettings,
  PclmSettings,
  PclmWriter,
  RenderablePage,
  Sides
} from '@ohos/jipp_pdl';
import { BusinessError } from '@kit.BasicServicesKit';
import { taskpool } from '@kit.ArkTS';

@Concurrent
async function pdfToPclm(pdfPath: string, outputPath: string, DPI: number,
  RED_COEFFICIENT: number,
  GREEN_COEFFICIENT: number,
  BLUE_COEFFICIENT: number) {
  let pix: ArrayBuffer | undefined = undefined
  let colorSpace: ColorSpace = ColorSpace.Rgb;
  let outputSettings: OutputSettings =
    new OutputSettings(colorSpace, Sides.oneSided, MediaSource.auto, null, false);
  let setting: PclmSettings = new PclmSettings(outputSettings, 16);
  let writeStream = fileIo.createStreamSync(outputPath, 'w+');
  let writer = new PclmWriter(writeStream, setting);
  let renderablePages: RenderablePage[] = new Array<RenderablePage>();
  let pdf: Pdfium = new Pdfium(pdfPath)
  let pageCount = pdf.GetPageCount()
  for (let i = 0; i < pageCount; i++) {
    let page: PdfiumPage = pdf.LoadPage(i);
    let size: image.Size = { width: page.GetWidth(), height: page.GetHeight() }
    let pixelMap = page.Render(Math.ceil(size.width * DPI / 72), Math.ceil(size.height * DPI / 72));
    size = pixelMap.getImageInfoSync().size
    console.info('ohos_jipp--> page size: ' + size.width + ' x ' + size.height);
    let renderablePage = new RenderablePage(size.width, size.height, DPI,
      (yOffset: number, swathHeight: number, colorSpace: ColorSpace, byteArray: Uint8Array) => {
        if (pix == undefined || pix.byteLength != size.width * swathHeight) {
          pix = new ArrayBuffer(size.width * swathHeight * 4)
        }
        const area: image.PositionArea = {
          pixels: pix,
          offset: 0,
          stride: size.width * 4,
          region: { size: { width: size.width, height: swathHeight, }, x: 0, y: yOffset }
        };
        //BGRA_8888格式
        pixelMap.readPixelsSync(area);
        let uint8Data = new Uint8Array(pix);
        let red: number;
        let green: number;
        let blue: number;

        let byteIndex: number = 0;
        for (let y = 0; y < swathHeight; y++) {
          for (let x = 0; x < size.width; x++) {
            const pixelIndex = (y * size.width + x) * 4;
            blue = uint8Data[pixelIndex]; // Blue通道
            green = uint8Data[pixelIndex + 1]; // Green通道
            red = uint8Data[pixelIndex + 2]; // Red通道

            if (colorSpace == ColorSpace.Grayscale) {
              const grayValue = RED_COEFFICIENT * red +
                GREEN_COEFFICIENT * green +
                BLUE_COEFFICIENT * blue;
              byteArray[byteIndex++] = grayValue;
            } else {
              byteArray[byteIndex++] =
                red;
              byteArray[byteIndex++] =
                green;
              byteArray[byteIndex++] =
                blue;
            }
          }
        }
      })
    renderablePages.push(renderablePage)
  }
  await writer.write(renderablePages);
  writer.close()
  console.info('ohos_jipp--> PCLm conversion completed successfully!');
}


@Entry
@Component
struct PdfToPclmPage {
  path: string = '';
  context: Context | undefined = undefined;
  outputPath: string = '';
  RED_COEFFICIENT: number = 0.2126;
  GREEN_COEFFICIENT: number = 0.7512;
  BLUE_COEFFICIENT: number = 0.0722;
  DPI: number = 300;
  @State resizePixelMap: image.PixelMap | undefined = undefined
  @State status: string = ''

  aboutToAppear(): void {
    this.context = this.getUIContext().getHostContext() as Context;
    this.outputPath = this.context.filesDir + '/harmony.pclm';
  }

  convertImageTypeToColorSpace(imageType: ImageType): number {
    switch (imageType) {
      case ImageType.BINARY:
      case ImageType.GRAY:
        return ColorSpace.Grayscale;
      default:
        return ColorSpace.Rgb;
    }
  }

  build() {
    Column() {
      Button('pdf 转 pclm')
        .fontSize(18)
        .height(45)
        .width('90%')
        .margin({ top: 10 })
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          try {
            let DocumentSelectOptions = new picker.DocumentSelectOptions();
            DocumentSelectOptions.maxSelectNumber = 1
            DocumentSelectOptions.fileSuffixFilters = ['.pdf', '.doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'];
            let documentPicker = new picker.DocumentViewPicker();
            documentPicker.select(DocumentSelectOptions).then((DocumentSelectResult) => {
              if (DocumentSelectResult !== null && DocumentSelectResult !== undefined) {
                DocumentSelectResult.forEach(async (value: string) => {
                  let task =
                    new taskpool.Task(pdfToPclm, new fileUri.FileUri(value).path, this.outputPath, this.DPI,
                      this.RED_COEFFICIENT,
                      this.GREEN_COEFFICIENT, this.BLUE_COEFFICIENT);
                  this.status = '正在转换...'
                  await taskpool.execute(task)
                  this.status = '转换完成'
                })
              }
            }).catch((err: BusinessError) => {
              console.error('test-->', 'DocumentViewPicker.select failed with err: ' + JSON.stringify(err));
            });
          } catch (err) {
            console.error('test-->', 'DocumentViewPicker failed with err: ' + JSON.stringify(err));
          }
        });

      Text(this.status)
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: 10 })
        .height('50%')
    }
    .height('100%')
    .width('100%');
  }
}
```

## 接口说明

**write**

write(renderablePages: RenderablePage[])

开始写入页面到pclm

参数：

| 参数名   | 类型     | 必填 | 说明                                                   |
| -------- |--------|----| ------------------------------------------------------ |
| renderablePages  | RenderablePage | 是  | 渲染的页面数组。 |

返回值：

| 类型 | 说明 |
|----|---|
| 无  | 无 |

**close**

close()

关闭流

参数

| 参数名 | 类型 | 必填 | 说明 |
|-----|----|---|----|
| 无   | 无  | 否 | 无。 |

返回值：

| 类型 | 说明 |
|----|----|
| 无  | 无。 |

**flush**

flush（）

刷新流

| 参数名 | 类型                                       | 必填 | 说明         |
|-----| ------------------------------------------ |----|------------|
| 无   | 无 | 无  | 无。 |


返回值：

| 类型 | 说明 |
|----|----|
| 无  | 无。 |

**calculateJobPagesPerSet**

calculateJobPagesPerSet(renderablePages: RenderablePage[]): number

计算物理页面总数

| 参数名          | 类型   | 必填 | 说明                                                         |
| --------------- |------| ---- | ------------------------------------------------------------ |
| renderablePages | RenderablePage | 是   | 渲染的页面数组。                                         |

返回值：

| 类型                      | 说明  |
|-------------------------|-----|
| number | 页数。 |

**getBackSide**

getBackSide()

获取双面打印

参数：

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无  |

返回值：

| 类型     | 说明        |
|--------|-----------|
| string | 双面还是单面打印。 |

**getOutput**

getOutput(): OutputSettings

获取输出设置

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明    |
|--------|-------|
| OutputSettings | 输出设置。 |

**getStripHeight**

getStripHeight(): number

获取条带高度

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明    |
|--------|-------|
| number | 条带高度。 |


**getColorSpace**

getColorSpace(): ColorSpace

获取色彩空间

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明    |
|--------|-------|
| ColorSpace | 颜色空间。 |


**getQuality**

getQuality(): PrintQuality | null

将一个由键及其各自的值组成的数组转换为string，省略未定义的值

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明    |
|--------|-------|
| PrintQuality | 打印质量。 |

**getSides**

getSides(): Sides

获取单面还是双面打印

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明    |
|--------|-------|
| Sides | 打印方式。 |

**getSource**

getSource(): MediaSource

获取纸张来源

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明    |
|--------|-------|
| MediaSource | 纸张来源。 |

**getReversed**

getReversed(): boolean

是否反转

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型      | 说明    |
|---------|-------|
| boolean | 纸张来源。 |

**getHeightPixels**

getHeightPixels():number

获取高度

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明  |
|--------|-----|
| number | 高度。 |

**getWidthPixels**

getWidthPixels() :number

获取纸张来源

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明  |
|--------|-----|
| number | 高度。 |

**flipX**

flipX(): RenderablePage

返回一个的新页面视图，该页面的内容沿水平轴（X轴）进行了垂直翻转（上下颠倒）

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明    |
|--------|-------|
| RenderablePage | 渲染试图。 |

**flipY**

flipY(): RenderablePage

返回一个的新页面视图，该页面的内容沿垂直轴（Y轴）进行了水平翻转

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明    |
|--------|-------|
| RenderablePage | 渲染试图。 |

**rotated**

rotated(): RenderablePage

返回一个的新页面视图，该页面的内容被旋转了180度

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明    |
|--------|-------|
| RenderablePage | 渲染试图。 |


**blank**

blank(): RenderablePage

返回一个空白页面

| 参数名 | 类型 | 必填 | 说明 |
|-----|----| ---- |----|
| 无   | 无  | 是   | 无。 |

返回值：

| 类型     | 说明    |
|--------|-------|
| RenderablePage | 渲染试图。 |

**renderSize**

renderSize(swathHeight: Int, colorSpace: ColorSpace)：number

计算渲染指定区域所需缓冲区的大小（字节数）

| 参数名 | 类型     | 必填 | 说明      |
|-----|--------| ---- |---------|
| swathHeight   | number | 是   | 条带高度。   |
| colorSpace   | ColorSpace | 是   | 色彩空间类型。 |

返回值：

| 类型     | 说明   |
|--------|------|
| number | 字节数。 |


## 约束与限制
在下述版本验证通过：

-  DevEco Studio: 5.1.1.830, SDK: API19 (5.1.1.208)

## 目录结构

```
|---- ohos_jipp
|     |---- AppScrope  # 示例代码文件夹
|     |---- entry  # 示例代码文件夹
|     |---- pdl  # 核心库
|           |---- src/main  # 模块代码
|                |---- ets/   # 模块代码
|                     |---- pclm/
|                         |---- PclmSettings.ets     # 转换设置
|                         |---- PclmWriter.ets    # 生成pclm文件核心逻辑
|                     |---- OhColorSpace.ets     # 定义颜色空间
|                     |---- OutputSettings.ets     # pclm生成输出设置
|                     |---- PdlUtil.ets     # 工具类
|                     |---- RenderablePage.ets     # 可渲染的页面
|            |---- index.ets          # 入口文件
|            |---- .ohpmignore        # ohpm发布的忽略文件
|            |---- *.json5      # 配置文件
|     |---- README_zh.md  # 安装使用方法
|     |---- README.OpenSource  # 开源说明
|     |---- CHANGELOG.md  # 更新日志
```

## 遗留问题
   
1. 不支持ipp打印功能,此功能可使用 https://ohpm.openharmony.cn/#/cn/detail/jsipp 库代替。
2. 不支持pdf转pwg。

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建 。

## 开源协议

本项目基于 [BSD License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/ohos_jipp/blob/master/LICENSE) ，请自由地享受和参与开源。
