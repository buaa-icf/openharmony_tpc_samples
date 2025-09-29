/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import {
  SwipeMenuList,
  SwipeMenu,
  SwipeMenuItem,
  SwipeMenuCreator,
  SwipeStateController,
  TouchConfig,
  AnimationConfig,
  AnimationType,
  InterpolatorType,
  OnMenuItemClickListener,
  OnMenuStateChangeListener,
  OnAnimationStateChangeListener,
  SwipeDirection
} from '@ohos/swipemenulistview';

/**
 * 动画插值器演示数据模型
 */
interface InterpolatorTestItem {
  id: number;
  title: string;
  subtitle: string;
  interpolatorType: InterpolatorType;
  description: string;
  color: string;
}

/**
 * 插值器测试菜单创建器
 */
class InterpolatorMenuCreator implements SwipeMenuCreator {
  create(menu: SwipeMenu, item?: Object, position?: number): void {
    if (item && position !== undefined) {
      const testItem = item as InterpolatorTestItem;
      menu.addMenuItem(new SwipeMenuItem({ 
        id: 'delete', 
        title: '删除', 
        background: '#FF4444', 
        width: 100, 
        titleColor: '#FFFFFF', 
        titleSize: 16 
      }));
      menu.addMenuItem(new SwipeMenuItem({ 
        id: 'edit', 
        title: '编辑', 
        background: '#FFA500', 
        width: 100, 
        titleColor: '#FFFFFF', 
        titleSize: 16 
      }));
      menu.addMenuItem(new SwipeMenuItem({ 
        id: 'detail', 
        title: '详情', 
        background: testItem.color, 
        width: 100, 
        titleColor: '#FFFFFF', 
        titleSize: 16 
      }));
    }
  }
}

/**
 * 菜单项点击监听器实现类
 */
class InterpolatorMenuItemClickListener implements OnMenuItemClickListener {
  private component: InterpolatorDemo;

  constructor(component: InterpolatorDemo) {
    this.component = component;
  }

  onMenuItemClick(position: number, menu: SwipeMenu, menuIndex: number): boolean {
    if (!this.component.data[position]) return false;
    const testItem = this.component.data[position];
    const menuItem = menu.getMenuItem(menuIndex);
    const menuId = String(menuItem?.getId() || '');
    switch (menuId) {
      case 'delete':
        this.component.data.splice(position, 1);
        this.component.data = [...this.component.data];
        break;
      case 'edit':
        console.log(`编辑项目: ${testItem.title}`);
        break;
      case 'detail':
        console.log(`查看详情: ${testItem.title}`);
        break;
    }
    return false; // 点击后关闭菜单
  }
}

/**
 * 菜单状态变化监听器实现类
 */
class InterpolatorMenuStateChangeListener implements OnMenuStateChangeListener {
  private component: InterpolatorDemo;

  constructor(component: InterpolatorDemo) {
    this.component = component;
  }

  onMenuOpen = (position: number): void => {
    if (!this.component.data[position]) return;
    this.component.lastTriggeredAnimation = `打开菜单: ${this.component.data[position].title}`;
  }

  onMenuClose = (position: number): void => {
    // 可以在这里处理菜单关闭逻辑
  }
}

/**
 * 动画状态变化监听器实现类
 */
class InterpolatorAnimationStateChangeListener implements OnAnimationStateChangeListener {
  private component: InterpolatorDemo;

  constructor(component: InterpolatorDemo) {
    this.component = component;
  }

  onAnimationStart = (itemPosition: number, animationType: AnimationType): void => {
    this.component.showAnimationInfo = true;
  }

  onAnimationEnd = (itemPosition: number, animationType: AnimationType): void => {
    // 动画结束处理
  }

  onDragProgress = (itemPosition: number, progress: number, offsetX: number): void => {
    if (progress > 0.05 && this.component.data[itemPosition]) {
      this.component.lastTriggeredAnimation = `${this.component.data[itemPosition].title} - 拖拽进度: ${(progress * 100).toFixed(0)}%`;
    }
  }
}

/**
 * 测试数据
 */
const testData: InterpolatorTestItem[] = [
  { id: 1, title: '测试项目 #1', subtitle: '滑动体验动画效果', interpolatorType: InterpolatorType.LINEAR, description: '左滑查看当前插值器的动画效果', color: '#4CAF50' },
  { id: 2, title: '测试项目 #2', subtitle: '滑动体验动画效果', interpolatorType: InterpolatorType.ACCELERATE, description: '左滑查看当前插值器的动画效果', color: '#2196F3' },
  { id: 3, title: '测试项目 #3', subtitle: '滑动体验动画效果', interpolatorType: InterpolatorType.DECELERATE, description: '左滑查看当前插值器的动画效果', color: '#FF9800' },
  { id: 4, title: '测试项目 #4', subtitle: '滑动体验动画效果', interpolatorType: InterpolatorType.ACCELERATE_DECELERATE, description: '左滑查看当前插值器的动画效果', color: '#9C27B0' },
  { id: 5, title: '测试项目 #5', subtitle: '滑动体验动画效果', interpolatorType: InterpolatorType.SPRING, description: '左滑查看当前插值器的动画效果', color: '#E91E63' },
  { id: 6, title: '测试项目 #6', subtitle: '滑动体验动画效果', interpolatorType: InterpolatorType.BOUNCE, description: '左滑查看当前插值器的动画效果', color: '#00BCD4' },
  { id: 7, title: '测试项目 #7', subtitle: '滑动体验动画效果', interpolatorType: InterpolatorType.OVERSHOOT, description: '左滑查看当前插值器的动画效果', color: '#FF5722' },
  { id: 8, title: '测试项目 #8', subtitle: '滑动体验动画效果', interpolatorType: InterpolatorType.ANTICIPATE, description: '左滑查看当前插值器的动画效果', color: '#795548' }
];

@Entry
@Component
struct InterpolatorDemo {
  @State data: InterpolatorTestItem[] = [...testData];
  @State touchConfig: TouchConfig = TouchConfig.default();
  @State currentInterpolatorIndex: number = 0;
  @State showAnimationInfo: boolean = false;
  @State lastTriggeredAnimation: string = '';
  @State refreshKey: number = 0; // 强制刷新UI
  @State selectedItemIndex: number = 0; // 当前选中的列表项索引
  @State @Watch('onAnimConfigChanged') openAnimConfig: AnimationConfig = new AnimationConfig().setInterpolator(testData[0].interpolatorType).setDuration(200);
  @State @Watch('onAnimConfigChanged') closeAnimConfig: AnimationConfig = new AnimationConfig().setInterpolator(testData[0].interpolatorType).setDuration(150);

  @Provide('swipeStateController') stateController: SwipeStateController = new SwipeStateController();

  private menuCreator = new InterpolatorMenuCreator();
  private onMenuItemClick = new InterpolatorMenuItemClickListener(this);
  private onMenuStateChange = new InterpolatorMenuStateChangeListener(this);
  private onAnimationStateChange = new InterpolatorAnimationStateChangeListener(this);

  aboutToAppear(): void {
    this.applyInterpolator(testData[0].interpolatorType); // 初始化
  }

  applyInterpolator(interpolatorType: InterpolatorType): void {
    const index = testData.findIndex(item => item.interpolatorType === interpolatorType);
    if (index !== -1) {
      this.currentInterpolatorIndex = index;
      this.lastTriggeredAnimation = `当前效果: ${this.getInterpolatorName(interpolatorType)}`;
      this.showAnimationInfo = true;
      setTimeout(() => { this.showAnimationInfo = false; }, 2000);

      // 为每种插值器配置不同的动画参数以突出效果差异
      this.updateAnimationConfigs(interpolatorType);
      this.refreshKey++; // 强制刷新

      console.log(`[插值器切换] 当前插值器: ${interpolatorType}, 打开动画: ${this.openAnimConfig.duration}ms, 关闭动画: ${this.closeAnimConfig.duration}ms`);
    }
  }

  /**
   * 根据插值器类型更新动画配置，突出不同插值器的特色
   */
  private updateAnimationConfigs(interpolatorType: InterpolatorType): void {
    switch (interpolatorType) {
      case InterpolatorType.LINEAR:
        // 线性：匀速机械感，使用短时长
        this.openAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(400);
        this.closeAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(300);
        break;

      case InterpolatorType.ACCELERATE:
        // 加速：开始慢后来快，短时长突出加速
        this.openAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(300);
        this.closeAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(250);
        break;

      case InterpolatorType.DECELERATE:
        // 减速：开始快后来慢，短时长突出减速
        this.openAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(350);
        this.closeAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(300);
        break;

      case InterpolatorType.ACCELERATE_DECELERATE:
        // 加速减速：经典曲线，标准时长
        this.openAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(300);
        this.closeAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(250);
        break;

      case InterpolatorType.SPRING:
        // 弹簧：物理动画，使用较短时长
        this.openAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(500);
        this.closeAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(400);
        break;

      case InterpolatorType.BOUNCE:
        // 回弹：物理动画，使用短时长
        this.openAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(400);
        this.closeAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(350);
        break;

      case InterpolatorType.OVERSHOOT:
        // 过冲：物理动画，使用短时长
        this.openAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(300);
        this.closeAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(250);
        break;

      case InterpolatorType.ANTICIPATE:
        this.openAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(600).setAnticipateTension(3.5);
        this.closeAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(500).setAnticipateTension(3.0);
        break;

      default:
      // 默认配置
        this.openAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(200);
        this.closeAnimConfig = new AnimationConfig().setInterpolator(interpolatorType).setDuration(150);
        break;
    }
  }

  onAnimConfigChanged(propName: string): void {
    console.log(`[AnimationWatch] ${propName} has been updated.`);
  }

  private getInterpolatorName(type: InterpolatorType): string {
    switch (type) {
      case InterpolatorType.LINEAR:
        return '线性动画';
      case InterpolatorType.ACCELERATE:
        return '加速动画';
      case InterpolatorType.DECELERATE:
        return '减速动画';
      case InterpolatorType.ACCELERATE_DECELERATE:
        return '加速减速';
      case InterpolatorType.SPRING:
        return '弹簧动画';
      case InterpolatorType.BOUNCE:
        return '回弹动画';
      case InterpolatorType.OVERSHOOT:
        return '过冲动画';
      case InterpolatorType.ANTICIPATE:
        return '预期动画';
      default:
        return String(type);
    }
  }

  private switchInterpolator(): void {
    const newIndex = (this.currentInterpolatorIndex + 1) % testData.length;
    this.applyInterpolator(testData[newIndex].interpolatorType);
  }

  private resetData(): void {
    this.data = [...testData];
    this.showAnimationInfo = false;
  }

  // 编程式打开指定项的菜单
  private openMenuAtIndex(index: number): void {
    if (index >= 0 && index < this.data.length) {
      this.stateController.smoothOpenMenu(index);
      this.lastTriggeredAnimation = `编程式打开: ${this.data[index].title}`;
      this.showAnimationInfo = true;
      setTimeout(() => { this.showAnimationInfo = false; }, 2000);
    }
  }

  // 关闭所有打开的菜单
  private closeAllMenus(): void {
    this.stateController.smoothCloseMenu();
    this.lastTriggeredAnimation = '关闭所有菜单';
    this.showAnimationInfo = true;
    setTimeout(() => { this.showAnimationInfo = false; }, 1500);
  }

  // 切换指定项的菜单状态
  private toggleMenuAtIndex(index: number): void {
    if (index >= 0 && index < this.data.length) {
      if (this.stateController.isMenuOpen(index)) {
        this.stateController.smoothCloseMenu();
      } else {
        this.stateController.smoothOpenMenu(index);
      }
    }
  }

  build() {
    Column({ space: 0 }) {
      // ... (UI aart remains the same as previous correct version)
      Column({ space: 8 }) {
        Text('动画插值器演示').fontSize(24).fontWeight(FontWeight.Bold)
        Text('先选择插值器类型，再滑动下方列表项体验效果').fontSize(14).fontColor('#666666')
        if (this.showAnimationInfo && this.lastTriggeredAnimation) {
          Text(this.lastTriggeredAnimation)
            .fontSize(12).fontColor('#FF6B6B').backgroundColor('#FFF0F0').padding(8).borderRadius(4).margin({ top: 4 })
            .transition(TransitionEffect.opacity(1).animation({ duration: 300, curve: Curve.EaseOut }))
        }
      }.padding({ top: 20, left: 16, right: 16, bottom: 12 }).width('100%').backgroundColor('#FFFFFF')

      // 插值器选择按钮
      Column({ space: 8 }) {
        Text('选择要体验的插值器类型：').fontSize(16).fontWeight(FontWeight.Medium)

        Scroll() {
          Row({ space: 8 }) {
            ForEach(testData, (item: InterpolatorTestItem, index: number) => {
              Button(item.subtitle === '滑动体验动画效果' ? this.getInterpolatorName(item.interpolatorType) : item.subtitle)
                .type(ButtonType.Normal)
                .backgroundColor(this.currentInterpolatorIndex === index ? '#4CAF50' : '#F0F0F0')
                .fontColor(this.currentInterpolatorIndex === index ? '#FFFFFF' : '#333333')
                .fontSize(12)
                .height(36)
                .padding({ left: 12, right: 12 })
                .onClick(() => {
                  this.applyInterpolator(item.interpolatorType);
                })
            })
          }.alignItems(VerticalAlign.Center)
        }.scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off)

        Text(`当前选中: ${this.getInterpolatorName(testData[this.currentInterpolatorIndex].interpolatorType)}`)
          .fontSize(14)
          .fontColor('#4CAF50')
          .fontWeight(FontWeight.Bold)
      }.padding({ left: 16, right: 16, bottom: 12 }).width('100%').backgroundColor('#FFFFFF')

      // 控制按钮区域
      Column({ space: 8 }) {
        Text('菜单控制：').fontSize(14).fontWeight(FontWeight.Medium).fontColor('#333333')
        
        Row({ space: 8 }) {
          Button('重置列表')
            .fontSize(12)
            .height(32)
            .backgroundColor('#FF9800')
            .onClick(() => this.resetData())

          Button(`打开菜单 #${this.selectedItemIndex + 1}`)
            .fontSize(12)
            .height(32)
            .backgroundColor('#2196F3')
            .onClick(() => this.openMenuAtIndex(this.selectedItemIndex))

          Button('关闭菜单')
            .fontSize(12)
            .height(32)
            .backgroundColor('#607D8B')
            .onClick(() => this.closeAllMenus())
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)

        // 选择项目的滑动条
        Row() {
          Text('选择项目:')
            .fontSize(12)
            .fontColor('#666666')
            .margin({ right: 8 })

          Slider({
            value: this.selectedItemIndex,
            min: 0,
            max: this.data.length - 1,
            step: 1
          })
            .width(120)
            .trackColor('#E0E0E0')
            .selectedColor('#4CAF50')
            .blockColor('#4CAF50')
            .onChange((value: number) => {
              this.selectedItemIndex = Math.round(value);
            })

          Text(`#${this.selectedItemIndex + 1}`)
            .fontSize(12)
            .fontColor('#4CAF50')
            .fontWeight(FontWeight.Bold)
            .margin({ left: 8 })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)

      }.padding({ left: 16, right: 16, bottom: 12 }).width('100%').backgroundColor('#FFFFFF')

      SwipeMenuList({
        data: this.data,
        menuCreator: this.menuCreator,
        itemBuilder: (item: Object, index: number): void => {
          this.ItemBuilder(item as InterpolatorTestItem, index);
        },
        onMenuItemClick: this.onMenuItemClick,
        onMenuStateChangeListener: this.onMenuStateChange,
        onAnimationStateChangeListener: this.onAnimationStateChange,
        swipeDirection: SwipeDirection.DIRECTION_LEFT,
        touchConfig: this.touchConfig,
        openAnimationConfig: this.openAnimConfig,
        closeAnimationConfig: this.closeAnimConfig,
        keyGenerator: (item: Object) => `${(item as InterpolatorTestItem).id.toString()}-${this.refreshKey}`
      }).layoutWeight(1)
    }.width('100%').height('100%').backgroundColor('#F5F5F5')
  }

  @Builder
  ItemBuilder(itemObj: InterpolatorTestItem, index: number) {
    Row({ space: 12 }) {
      Column()
        .width(4)
        .height(60)
        .backgroundColor(itemObj.color)
        .borderRadius(2)
      
      Column({ space: 4 }) {
        Row() {
          Text(itemObj.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
          
          Text(`#${itemObj.id}`)
            .fontSize(12)
            .fontColor('#999999')
            .backgroundColor('#F0F0F0')
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })
            .borderRadius(10)
        }
        .width('100%')
        
        Text(itemObj.subtitle)
          .fontSize(13)
          .fontColor(itemObj.color)
          .fontWeight(FontWeight.Bold)
        
        Text(itemObj.description)
          .fontSize(12)
          .fontColor('#666666')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      
      Row() {
        Text('滑动试试')
          .fontSize(11)
          .fontColor('#999999')
        
        Text('→')
          .fontSize(16)
          .fontColor('#CCCCCC')
          .margin({ left: 4 })
      }
    }
    .width('100%')
    .height(80)
    .backgroundColor('#FFFFFF')
    .padding({ left: 16, right: 16, top: 10, bottom: 10 })
    .border({ width: { bottom: 0.5 }, color: '#E0E0E0' })
  }
}
