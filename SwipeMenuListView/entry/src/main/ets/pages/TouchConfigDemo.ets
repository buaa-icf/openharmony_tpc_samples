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
  InterpolatorType,
  OnMenuItemClickListener,
  SwipeDirection
} from '@ohos/swipemenulistview';
import promptAction from '@ohos.promptAction';

/**
 * 测试数据模型
 */
interface TestItemData {
  id: string;
  title: string;
  description: string;
}

@Observed
class TestItem {
  public id: string;
  public title: string;
  public description: string;
  public _updateTimestamp?: number;

  constructor(data: TestItemData) {
    this.id = data.id;
    this.title = data.title;
    this.description = data.description;
  }
}

/**
 * 菜单创建器
 */
class TouchConfigMenuCreator implements SwipeMenuCreator {
  create(menu: SwipeMenu, _item?: Object, _position?: number): void {
    // 编辑菜单项
    const editItem = new SwipeMenuItem({
      id: 'edit',
      title: '编辑',
      background: '#2196F3',
      titleColor: '#FFFFFF',
      titleSize: 14,
      width: 80,
      icon: $r('app.media.message')
    });
    menu.addMenuItem(editItem);

    // 收藏菜单项
    const favoriteItem = new SwipeMenuItem({
      id: 'favorite',
      title: '收藏',
      background: '#FF9800',
      titleColor: '#FFFFFF',
      titleSize: 14,
      width: 80,
      icon: $r('app.media.user')
    });
    menu.addMenuItem(favoriteItem);

    // 删除菜单项
    const deleteItem = new SwipeMenuItem({
      id: 'delete',
      title: '删除',
      background: '#F44336',
      titleColor: '#FFFFFF',
      titleSize: 14,
      width: 80,
      icon: $r('app.media.close')
    });
    menu.addMenuItem(deleteItem);
  }
}

/**
 * 菜单点击处理器
 */
class TouchConfigMenuClickHandler implements OnMenuItemClickListener {
  onMenuItemClick(position: number, menu: SwipeMenu, menuIndex: number): boolean {
    const clickedMenuItem = menu.getMenuItem(menuIndex);
    const menuItemId = clickedMenuItem?.getId();
    const menuTitle = clickedMenuItem?.getTitle();

    promptAction.showToast({
      message: `位置 ${position}: 点击了 ${menuTitle} (${menuItemId})`,
      duration: 1500
    });

    return false; // 点击后关闭菜单
  }
}

/**
 * TouchConfig 配置类型
 */
type ConfigType = 'sensitive' | 'default' | 'strict';

/**
 * 配置信息接口
 */
interface ConfigInfo {
  name: string;
  color: string;
  minSwipeDistance: number;
  minFlingVelocity: number;
  menuOpenThreshold: number;
}

@Entry
@Component
struct TouchConfigDemo {
  @State testItems: TestItem[] = [];
  @State currentConfigType: ConfigType = 'sensitive';
  @State touchConfig: TouchConfig = TouchConfig.sensitive();
  @State openAnimationConfig: AnimationConfig = new AnimationConfig()
    .setInterpolator(InterpolatorType.SPRING)
    .setDuration(300);
  @State closeAnimationConfig: AnimationConfig = new AnimationConfig()
    .setInterpolator(InterpolatorType.SPRING)
    .setDuration(250);

  @Provide('swipeStateController') swipeController: SwipeStateController = new SwipeStateController();

  private menuCreator: TouchConfigMenuCreator = new TouchConfigMenuCreator();
  private menuClickHandler: TouchConfigMenuClickHandler = new TouchConfigMenuClickHandler();

  // 配置信息映射
  private configInfoMap: Record<ConfigType, ConfigInfo> = {
    'sensitive': {
      name: '敏感模式 (Sensitive)',
      color: '#4CAF50',
      minSwipeDistance: 3,
      minFlingVelocity: 200,
      menuOpenThreshold: 0.2
    },
    'default': {
      name: '默认模式 (Default)',
      color: '#2196F3',
      minSwipeDistance: 100,
      minFlingVelocity: 1000,
      menuOpenThreshold: 0.5
    },
    'strict': {
      name: '严格模式 (Strict)',
      color: '#FF5722',
      minSwipeDistance: 200,
      minFlingVelocity: 2000,
      menuOpenThreshold: 0.8
    }
  };

  aboutToAppear() {
    this.loadTestData();
  }

  /**
   * 加载测试数据
   */
  private loadTestData(): void {
    const data: TestItemData[] = [
      { id: '1', title: '测试项目 1', description: '向右滑动显示菜单' },
      { id: '2', title: '测试项目 2', description: '体验不同灵敏度配置' },
      { id: '3', title: '测试项目 3', description: '菜单显示在左侧' },
      { id: '4', title: '测试项目 4', description: '观察滑动阈值差异' },
      { id: '5', title: '测试项目 5', description: '尝试快速滑动与慢速滑动' },
      { id: '6', title: '测试项目 6', description: '比较三种配置的手感' }
    ];
    this.testItems = data.map(d => new TestItem(d));
  }

  /**
   * 切换 TouchConfig 配置
   */
  private switchConfig(type: ConfigType): void {
    this.currentConfigType = type;

    switch (type) {
      case 'sensitive':
        this.touchConfig = TouchConfig.sensitive();
        break;
      case 'default':
        this.touchConfig = TouchConfig.default();
        break;
      case 'strict':
        this.touchConfig = TouchConfig.strict();
        break;
    }

    // 通过 SwipeStateController 更新配置
    this.swipeController.updateTouchConfig(this.touchConfig);

    // 刷新列表以应用新配置
    this.refreshItemList();

    promptAction.showToast({
      message: `已切换到: ${this.configInfoMap[type].name}`,
      duration: 1500
    });
  }

  /**
   * 刷新列表项
   */
  private refreshItemList(): void {
    const timestamp = Date.now();
    this.testItems = this.testItems.map((item: TestItem): TestItem => {
      const data: TestItemData = {
        id: item.id,
        title: item.title,
        description: item.description
      };
      const newItem = new TestItem(data);
      newItem._updateTimestamp = timestamp;
      return newItem;
    });
  }

  /**
   * 获取当前配置信息
   */
  private getCurrentConfigInfo(): ConfigInfo {
    return this.configInfoMap[this.currentConfigType];
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('TouchConfig 灵敏度演示')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1976D2')
          .layoutWeight(1)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      // 配置切换面板
      Column() {
        Text('选择 TouchConfig 配置')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .margin({ bottom: 12 })

        // 配置按钮行
        Row() {
          Button('Sensitive')
            .fontSize(12)
            .backgroundColor(this.currentConfigType === 'sensitive' ? '#4CAF50' : '#BDBDBD')
            .fontColor('#FFFFFF')
            .borderRadius(6)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .onClick(() => this.switchConfig('sensitive'))

          Button('Default')
            .fontSize(12)
            .backgroundColor(this.currentConfigType === 'default' ? '#2196F3' : '#BDBDBD')
            .fontColor('#FFFFFF')
            .borderRadius(6)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .margin({ left: 12 })
            .onClick(() => this.switchConfig('default'))

          Button('Strict')
            .fontSize(12)
            .backgroundColor(this.currentConfigType === 'strict' ? '#FF5722' : '#BDBDBD')
            .fontColor('#FFFFFF')
            .borderRadius(6)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .margin({ left: 12 })
            .onClick(() => this.switchConfig('strict'))
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        // 当前配置参数显示
        Column() {
          Text(this.getCurrentConfigInfo().name)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.getCurrentConfigInfo().color)
            .margin({ bottom: 8 })
        }
        .width('100%')
        .padding(12)
        .margin({ top: 12 })
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .margin({ bottom: 8 })

      // 滑动列表
      SwipeMenuList({
        data: this.testItems,
        menuCreator: this.menuCreator,
        touchConfig: this.touchConfig,
        openAnimationConfig: this.openAnimationConfig,
        closeAnimationConfig: this.closeAnimationConfig,
        swipeDirection: SwipeDirection.DIRECTION_RIGHT, // 向右滑动
        itemBuilder: (item: Object, index: number): void => {
          this.TestItemBuilder(item as TestItem, index);
        },
        keyGenerator: (item: Object) => {
          const testItem = item as TestItem;
          return testItem.id + '_' + (testItem._updateTimestamp || 0);
        },
        onMenuItemClick: this.menuClickHandler
      })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F0F0F0')
  }

  /**
   * 配置参数项构建器
   */
  @Builder
  ConfigParamItem(label: string, value: string) {
    Column() {
      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#212121')
      Text(label)
        .fontSize(10)
        .fontColor('#757575')
        .margin({ top: 2 })
    }
    .alignItems(HorizontalAlign.Center)
  }

  /**
   * 测试项目构建器
   */
  @Builder
  TestItemBuilder(item: TestItem, index: number) {
    Row() {
      // 序号标识
      Column() {
        Text(`${index + 1}`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
      }
      .width(40)
      .height(40)
      .borderRadius(20)
      .backgroundColor(this.getCurrentConfigInfo().color)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 内容区域
      Column() {
        Text(item.title)
          .fontSize(16)
          .fontColor('#212121')
          .fontWeight(FontWeight.Medium)

        Text(item.description)
          .fontSize(14)
          .fontColor('#757575')
          .margin({ top: 4 })

        // 显示当前配置参数
        Text(`滑动距离: ${this.getCurrentConfigInfo().minSwipeDistance}px | 速度: ${this.getCurrentConfigInfo().minFlingVelocity}px/ms | 阈值: ${(this.getCurrentConfigInfo().menuOpenThreshold * 100).toFixed(0)}%`)
          .fontSize(11)
          .fontColor(this.getCurrentConfigInfo().color)
          .margin({ top: 4 })
          .fontWeight(FontWeight.Medium)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)

      // 右侧箭头指示（向右滑动提示）
      Text('←')
        .fontSize(20)
        .fontColor('#BDBDBD')
    }
    .width('100%')
    .padding(16)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .onClick(() => {
      promptAction.showToast({
        message: `点击了: ${item.title}`,
        duration: 1000
      });
    })
  }
}
