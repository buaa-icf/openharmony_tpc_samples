import { XMPMetaFactory } from '@ohos/xmp_toolkit';
import type { XMPVersionInfo } from '@ohos/xmp_toolkit';

@Entry
@Component
struct VersionInfoPage {
  @State message: string = 'XMP工具包版本信息';

  // 版本信息状态
  @State versionInfo: XMPVersionInfo | null = null;
  @State isLoading: boolean = false;
  @State errorMessage: string = '';

  // 版本信息详情
  @State majorVersion: number = 0;
  @State minorVersion: number = 0;
  @State microVersion: number = 0;
  @State buildNumber: number = 0;
  @State isDebugBuild: boolean = false;
  @State fullVersionMessage: string = '';

  // 加载版本信息
  loadVersionInfo() {
    this.isLoading = true;
    this.errorMessage = '';

    try {
      // 获取版本信息
      this.versionInfo = XMPMetaFactory.getVersionInfo();

      if (!this.versionInfo) {
        this.errorMessage = '无法获取版本信息对象';
        return;
      }

      // 提取所有版本信息
      this.majorVersion = this.versionInfo.getMajor();
      this.minorVersion = this.versionInfo.getMinor();
      this.microVersion = this.versionInfo.getMicro();
      this.buildNumber = this.versionInfo.getBuild();
      this.isDebugBuild = this.versionInfo.isDebug();
      this.fullVersionMessage = this.versionInfo.getMessage();

    } catch (e) {
      this.errorMessage = `获取版本信息失败: ${(e as Error).message}`;
    } finally {
      this.isLoading = false;
    }
  }

  // 清空信息
  clearInfo() {
    this.versionInfo = null;
    this.majorVersion = 0;
    this.minorVersion = 0;
    this.microVersion = 0;
    this.buildNumber = 0;
    this.isDebugBuild = false;
    this.fullVersionMessage = '';
    this.errorMessage = '';
  }

  // 格式化版本号
  formatVersion(): string {
    if (this.majorVersion === 0 && this.minorVersion === 0 && this.microVersion === 0) {
      return '未知版本';
    }
    return `${this.majorVersion}.${this.minorVersion}.${this.microVersion}`;
  }

  // 获取构建类型文本
  getBuildTypeText(): string {
    return this.isDebugBuild ? '调试版本' : '发布版本';
  }

  // 获取构建类型颜色
  getBuildTypeColor(): ResourceColor {
    return this.isDebugBuild ? Color.Red : Color.Green;
  }

  // 初始化
  aboutToAppear() {
    this.loadVersionInfo();
  }

  build() {
    Column({ space: 15 }) {
      // 标题
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Blue)
        .margin({ top: 20, bottom: 10 })
        .width('95%')
        .textAlign(TextAlign.Center)

      // 操作按钮
      Row({ space: 10 }) {
        Button('获取版本信息')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor(Color.Blue)
          .height(45)
          .flexGrow(1)
          .enabled(!this.isLoading)
          .onClick(() => {
            this.loadVersionInfo();
          })

        Button('清空信息')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor(Color.Grey)
          .height(45)
          .flexGrow(1)
          .enabled(!this.isLoading)
          .onClick(() => {
            this.clearInfo();
          })
      }
      .width('95%')
      .margin({ bottom: 15 })

      // 错误信息显示
      if (this.errorMessage) {
        Column({ space: 8 }) {
          Text('错误信息')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.Red)
            .width('95%')
            .textAlign(TextAlign.Start)

          Text(this.errorMessage)
            .fontSize(14)
            .fontColor(Color.Red)
            .width('95%')
            .textAlign(TextAlign.Start)
            .padding(12)
            .backgroundColor('#FFF0F0')
            .border({ width: 1, color: Color.Red })
            .borderRadius(8)
        }
        .width('100%')
        .padding(15)
        .backgroundColor(Color.White)
        .border({ width: 1, color: Color.Grey })
        .borderRadius(8)
        .margin({ bottom: 15 })
      }

      // 加载状态或无数据状态
      Column() {
        if (this.isLoading) {
          // 加载状态
          Column() {
            Text('正在加载版本信息...')
              .fontSize(16)
              .fontColor(Color.Blue)
              .padding(30)
          }
          .width('100%')
          .backgroundColor(Color.White)
          .border({ width: 1, color: Color.Grey })
          .borderRadius(8)
        } else if (this.errorMessage) {
          // 错误信息已经在上方显示，这里可以留空或者显示其他内容
        } else if (this.versionInfo) {
          // 版本信息显示 - 滚动区域（关键修改部分）
          Scroll() {
            Column({ space: 15 }) {
              // 主要版本信息卡片
              Column({ space: 10 }) {
                Text('版本信息概览')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.Blue)
                  .width('95%')
                  .textAlign(TextAlign.Start)

                // 版本号显示
                Row({ space: 10 }) {
                  Column() {
                    Text('版本号')
                      .fontSize(12)
                      .fontColor(Color.Gray)
                    Text(this.formatVersion())
                      .fontSize(24)
                      .fontColor(Color.Blue)
                      .fontWeight(FontWeight.Bold)
                  }
                  .layoutWeight(1)

                  Column() {
                    Text('构建类型')
                      .fontSize(12)
                      .fontColor(Color.Gray)
                    Text(this.getBuildTypeText())
                      .fontSize(16)
                      .fontColor(this.getBuildTypeColor())
                      .fontWeight(FontWeight.Bold)
                  }
                  .layoutWeight(1)
                }
                .width('95%')

                // 构建号
                Row({ space: 10 }) {
                  Column() {
                    Text('构建号')
                      .fontSize(12)
                      .fontColor(Color.Gray)
                    Text(`#${this.buildNumber}`)
                      .fontSize(18)
                      .fontColor(Color.Green)
                      .fontWeight(FontWeight.Bold)
                  }
                  .layoutWeight(1)
                }
                .width('95%')
                .margin({ top: 10 })
              }
              .width('100%')
              .padding(20)
              .backgroundColor('#F0F8FF')
              .border({ width: 2, color: Color.Blue })
              .borderRadius(12)

              // 详细版本信息
              Column({ space: 10 }) {
                Text('详细版本信息')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Color.Blue)
                  .width('95%')
                  .textAlign(TextAlign.Start)

                // 版本号详情
                Column({ space: 8 }) {
                  Row() {
                    Text('主版本号 (Major):')
                      .fontSize(14)
                      .fontColor(Color.Black)
                      .layoutWeight(1)
                    Text(this.majorVersion.toString())
                      .fontSize(14)
                      .fontColor(Color.Blue)
                      .fontWeight(FontWeight.Bold)
                  }
                  .width('95%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('次版本号 (Minor):')
                      .fontSize(14)
                      .fontColor(Color.Black)
                      .layoutWeight(1)
                    Text(this.minorVersion.toString())
                      .fontSize(14)
                      .fontColor(Color.Blue)
                      .fontWeight(FontWeight.Bold)
                  }
                  .width('95%')
                  .padding({ top: 5, bottom: 5 })
                  .backgroundColor('#F8F8F8')

                  Row() {
                    Text('第三版本号 (Micro):')
                      .fontSize(14)
                      .fontColor(Color.Black)
                      .layoutWeight(1)
                    Text(this.microVersion.toString())
                      .fontSize(14)
                      .fontColor(Color.Blue)
                      .fontWeight(FontWeight.Bold)
                  }
                  .width('95%')
                  .padding({ top: 5, bottom: 5 })
                }
                .width('95%')
                .padding(15)
                .backgroundColor(Color.White)
                .border({ width: 1, color: Color.Grey })
                .borderRadius(8)

                // 构建信息详情
                Column({ space: 8 }) {
                  Row() {
                    Text('构建号 (Build):')
                      .fontSize(14)
                      .fontColor(Color.Black)
                      .layoutWeight(1)
                    Text(this.buildNumber.toString())
                      .fontSize(14)
                      .fontColor(Color.Green)
                      .fontWeight(FontWeight.Bold)
                  }
                  .width('95%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('构建类型:')
                      .fontSize(14)
                      .fontColor(Color.Black)
                      .layoutWeight(1)
                    Text(this.getBuildTypeText())
                      .fontSize(14)
                      .fontColor(this.getBuildTypeColor())
                      .fontWeight(FontWeight.Bold)
                  }
                  .width('95%')
                  .padding({ top: 5, bottom: 5 })
                  .backgroundColor('#F8F8F8')
                }
                .width('95%')
                .padding(15)
                .backgroundColor(Color.White)
                .border({ width: 1, color: Color.Grey })
                .borderRadius(8)
                .margin({ top: 10 })

                // 完整版本信息
                Column({ space: 8 }) {
                  Text('完整版本信息:')
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(Color.Blue)
                    .width('95%')
                    .textAlign(TextAlign.Start)

                  Text(this.fullVersionMessage || '暂无描述信息')
                    .fontSize(13)
                    .fontColor(Color.Black)
                    .width('95%')
                    .textAlign(TextAlign.Start)
                    .padding(12)
                    .backgroundColor('#F8F8F8')
                    .border({ width: 1, color: Color.Grey })
                    .borderRadius(6)
                }
                .width('95%')
                .margin({ top: 10 })
              }
              .width('100%')
              .padding(20)
              .backgroundColor(Color.White)
              .border({ width: 1, color: Color.Grey })
              .borderRadius(8)
            }
            .width('100%')
            .padding({ bottom: 20 })
          }
          .flexGrow(1)  // 关键修改：让滚动区域自动填充剩余空间
          .width('100%')
        } else {
          // 无数据时的提示
          Column() {
            Text('暂无版本信息')
              .fontSize(16)
              .fontColor(Color.Gray)
              .padding(30)
            Text('请点击"获取版本信息"按钮')
              .fontSize(14)
              .fontColor(Color.Gray)
          }
          .width('100%')
          .backgroundColor(Color.White)
          .border({ width: 1, color: Color.Grey })
          .borderRadius(8)
        }
      }
      .flexGrow(1)  // 关键修改：让内容区域自动填充剩余空间
      .width('100%')
      .justifyContent(FlexAlign.Start)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .padding({ left: 10, right: 10 })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }
}