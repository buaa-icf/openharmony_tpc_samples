# SwipeMenuListView

## 简介
HarmonyOS 滑动菜单列表组件，支持自定义菜单项和流畅动画效果。

## 效果展示

![avatar](ScreenShots/演示.gif)

## 安装

```shell
ohpm install @ohos/swipemenulistview
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)。

## X86模拟器配置

[使用模拟器运行应用/服务](https://developer.huawei.com/consumer/cn/deveco-developer-suite/enabling/kit?currentPage=1&pageSize=100)

## 基础用法

### 1. 导入组件

```typescript
import {
  SwipeMenuList,
  SwipeMenu,
  SwipeMenuItem,
  SwipeMenuCreator,
  SwipeStateController,
  TouchConfig,
  AnimationConfig,
  AnimationType,
  OnMenuItemClickListener,
  OnSwipeListener,
  OnMenuStateChangeListener,
  OnAnimationStateChangeListener,
  OnItemLongPressListener,
  InterpolatorType,
  SwipeDirection
} from '@ohos/swipemenulistview';
```

### 2. 创建菜单创建器

菜单创建器接口支持多视图类型，可以根据数据项和位置创建不同的菜单：

```typescript
class MyMenuCreator implements SwipeMenuCreator {
  create(menu: SwipeMenu, item?: Object, position?: number): void {
    // 添加删除菜单
    const deleteItem = new SwipeMenuItem({
      id: 'delete',
      title: '删除',
      background: '#F44336',
      titleColor: '#FFFFFF',
      width: 90,
      icon: $r('app.media.delete_icon')
    });
    menu.addMenuItem(deleteItem);

    // 添加编辑菜单
    const editItem = new SwipeMenuItem({
      id: 'edit',
      title: '编辑',
      background: '#2196F3',
      titleColor: '#FFFFFF',
      width: 90
    });
    menu.addMenuItem(editItem);
  }
}
```

### 3. 使用组件

```typescript
@Entry
@Component
struct MainPage {
  // 定义数据源，每个对象需要有唯一的id
  @State dataList: Array<Object> = [
    { id: '1', name: '项目1' },
    { id: '2', name: '项目2' },
    { id: '3', name: '项目3' }
  ];

  // 触摸配置，控制滑动敏感度
  @State touchConfig: TouchConfig = TouchConfig.default();
  // 菜单打开动画配置
  @State openAnimationConfig: AnimationConfig = AnimationConfig.default();
  // 菜单关闭动画配置，使用快速动画
  @State closeAnimationConfig: AnimationConfig = AnimationConfig.fast();

  // 提供滑动状态控制器，用于编程式控制菜单
  @Provide('swipeStateController') swipeController: SwipeStateController = new SwipeStateController();

  // 创建菜单创建器实例
  private menuCreator: MyMenuCreator = new MyMenuCreator();

  build() {
    Column() {
      SwipeMenuList({
        data: this.dataList,                          // 绑定数据源
        menuCreator: this.menuCreator,                // 设置菜单创建器
        touchConfig: this.touchConfig,                // 应用触摸配置
        openAnimationConfig: this.openAnimationConfig,   // 设置打开动画
        closeAnimationConfig: this.closeAnimationConfig, // 设置关闭动画
        itemBuilder: (item: Object, index: number): void => {
          this.ItemBuilder(item, index);              // 自定义列表项构建器
        },
        onMenuItemClick: (position: number, menu: SwipeMenu, menuIndex: number): boolean => {
          const clickedItem = menu.getMenuItem(menuIndex);  // 获取被点击的菜单项
          if (clickedItem?.getId() === 'delete') {          // 判断是否为删除按钮
            this.deleteItem(position);                      // 执行删除操作
          }
          return false; // 返回false表示点击后关闭菜单
        }
      })
    }
  }

  // 自定义列表项构建器
  @Builder
  ItemBuilder(item: Object, index: number) {
    Row() {
      Text((item as any).name)
        .fontSize(16)
        .fontColor('#333333')
    }
    .width('100%')
    .height(60)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
  }

  // 删除指定位置的数据项
  private deleteItem(position: number) {
    this.dataList = this.dataList.filter((_, index) => index !== position);
  }
}
```

## 更多配置

### 触摸配置

```typescript
// 敏感模式 - 容易触发滑动
@State touchConfig: TouchConfig = TouchConfig.sensitive();

// 严格模式 - 难以触发滑动
@State touchConfig: TouchConfig = TouchConfig.strict();

// 自定义配置
@State touchConfig: TouchConfig = new TouchConfig({
  minSwipeDistance: 20,        // 最小滑动距离（像素）
  minFlingVelocity: 800,       // 快速滑动最小速度（像素/秒）
  menuOpenThreshold: 0.6,      // 菜单打开阈值（0-1，表示滑动距离占菜单宽度的比例）
  enableTouchIntercept: true   // 启用触摸拦截，防止与父容器手势冲突
});
```

### 动画配置

```typescript
// 预设动画配置
@State openConfig: AnimationConfig = AnimationConfig.spring();   // 弹簧动画
@State closeConfig: AnimationConfig = AnimationConfig.bounce();  // 回弹动画

// 自定义动画配置
@State customConfig: AnimationConfig = new AnimationConfig({
  duration: 300,                                        // 动画持续时间（毫秒）
  interpolator: InterpolatorType.ACCELERATE_DECELERATE, // 插值器类型：先加速后减速
  springConfig: {                                       // 弹簧动画参数
    stiffness: 1.0,                                     // 弹簧刚度，值越大弹性越强
    damping: 0.8,                                       // 阻尼系数，值越大震荡越小
    mass: 1.0                                           // 质量，影响动画速度
  }
});
```

### 滑动方向控制

```typescript
SwipeMenuList({
  // ...其他配置
  swipeDirection: SwipeDirection.DIRECTION_LEFT,  // 左滑显示菜单（默认）
  // swipeDirection: SwipeDirection.DIRECTION_RIGHT, // 右滑显示菜单
})
```

### 条件滑动控制

```typescript
SwipeMenuList({
  // ...其他配置
  getSwipeEnabled: (position: number): boolean => {
    // 只有偶数位置的项目可以滑动
    return position % 2 === 0;
  }
})
```

## 事件监听

### 菜单项点击

```typescript
onMenuItemClick: (position: number, menu: SwipeMenu, menuIndex: number): boolean => {
  const clickedItem = menu.getMenuItem(menuIndex);  // 根据索引获取被点击的菜单项
  const itemId = clickedItem?.getId();              // 获取菜单项的唯一标识

  switch (itemId) {
    case 'delete':
      // 执行删除操作
      console.log(`删除第${position}项`);
      break;
    case 'edit':
      // 执行编辑操作
      console.log(`编辑第${position}项`);
      break;
  }

  return false; // 返回false关闭菜单，返回true保持菜单打开状态
}
```

### 滑动事件监听

```typescript
class MySwipeListener implements OnSwipeListener {
  onSwipeStart = (position: number): void => {
    console.log(`滑动开始 - 位置: ${position}`);
  }

  onSwipeEnd = (position: number): void => {
    console.log(`滑动结束 - 位置: ${position}`);
  }
}

SwipeMenuList({
  // ...其他配置
  onSwipeListener: new MySwipeListener()
})
```

### 菜单状态监听

```typescript
class MyMenuStateListener implements OnMenuStateChangeListener {
  onMenuOpen = (position: number): void => {
    console.log(`菜单打开 - 位置: ${position}`);
  }

  onMenuClose = (position: number): void => {
    console.log(`菜单关闭 - 位置: ${position}`);
  }
}

SwipeMenuList({
  // ...其他配置
  onMenuStateChangeListener: new MyMenuStateListener()
})
```

### 长按事件监听

```typescript
class MyLongPressListener implements OnItemLongPressListener {
  onItemLongPress = (position: number, item: Object): boolean => {
    console.log(`长按了第${position}项`);
    // 显示上下文菜单或其他操作
    // 可以在这里弹出对话框、显示更多选项等
    return true; // 返回true阻止事件继续传递给其他组件
  }
}

SwipeMenuList({
  // ...其他配置
  onItemLongPress: new MyLongPressListener()
})
```

### 动画状态监听

```typescript
class MyAnimationListener implements OnAnimationStateChangeListener {
  onAnimationStart = (itemPosition: number, animationType: AnimationType): void => {
    console.log(`动画开始 - 位置: ${itemPosition}, 类型: ${animationType}`);
  }

  onAnimationEnd = (itemPosition: number, animationType: AnimationType): void => {
    console.log(`动画结束 - 位置: ${itemPosition}, 类型: ${animationType}`);
  }

  onDragProgress = (itemPosition: number, progress: number, offsetX: number): void => {
    console.log(`拖拽进度 - 位置: ${itemPosition}, 进度: ${progress.toFixed(2)}, 偏移: ${offsetX}`);
  }
}

SwipeMenuList({
  // ...其他配置
  onAnimationStateChangeListener: new MyAnimationListener()
})
```

## 编程式控制

```typescript
// 获取状态控制器（通过@Consume注入，需要与@Provide配对使用）
@Consume('swipeStateController') swipeController: SwipeStateController;

// 主动打开指定位置的菜单（带动画效果）
this.swipeController.smoothOpenMenu(position);

// 关闭当前打开的菜单（如果有的话）
this.swipeController.smoothCloseMenu();

// 检查指定位置的菜单是否处于打开状态
const isOpen = this.swipeController.isMenuOpen(position);

// 动态更新触摸配置，立即生效
this.swipeController.updateTouchConfig(TouchConfig.sensitive());
```

## 自定义菜单项

### SwipeMenuItem 配置选项

```typescript
const menuItem = new SwipeMenuItem({
  id: 'custom',                    // 唯一标识
  title: '自定义',                 // 显示文字
  icon: $r('app.media.icon'),      // 图标资源
  background: '#FF5722',           // 背景色
  titleColor: '#FFFFFF',           // 文字颜色
  titleSize: 14,                   // 文字大小
  width: 100                       // 宽度
});
```

### 动态修改菜单项

```typescript
// 获取菜单项
const menuItem = menu.getMenuItem(0);

// 修改属性
menuItem?.setTitle('新标题');
menuItem?.setBackground('#4CAF50');
menuItem?.setWidth(120);
```

## API 参考

### SwipeMenuList 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| data | Array<Object> | [] | 数据源数组 |
| menuCreator | SwipeMenuCreator | DefaultMenuCreator | 菜单创建器 |
| itemBuilder | BuilderParam | - | 列表项构建器 |
| touchConfig | TouchConfig | TouchConfig.default() | 触摸配置 |
| openAnimationConfig | AnimationConfig | AnimationConfig.default() | 打开动画配置 |
| closeAnimationConfig | AnimationConfig | AnimationConfig.default() | 关闭动画配置 |
| swipeDirection | number | SwipeDirection.DIRECTION_LEFT | 滑动方向 |
| dragFollowAnimation | boolean | true | 是否启用拖拽跟随动画 |
| enableSpringBack | boolean | true | 是否启用回弹效果 |
| keyGenerator | (item: Object) => string | JSON.stringify | 唯一键生成器 |
| getSwipeEnabled | (position: number) => boolean | undefined | 滑动能力控制函数 |

### SwipeMenuList 事件

| 事件 | 类型 | 说明 |
|------|------|------|
| onMenuItemClick | OnMenuItemClickListener | 菜单项点击事件 |
| onSwipeListener | OnSwipeListener | 滑动事件监听 |
| onMenuStateChangeListener | OnMenuStateChangeListener | 菜单状态变化监听 |
| onAnimationStateChangeListener | OnAnimationStateChangeListener | 动画状态变化监听 |
| onItemLongPress | OnItemLongPressListener | 长按事件监听 |

### TouchConfig 预设配置

| 方法 | 说明 |
|------|------|
| TouchConfig.default() | 默认配置 |
| TouchConfig.sensitive() | 敏感配置（容易触发） |
| TouchConfig.strict() | 严格配置（难以触发） |

### AnimationConfig 预设配置

| 方法 | 说明 |
|------|------|
| AnimationConfig.default() | 默认动画 |
| AnimationConfig.fast() | 快速动画 |
| AnimationConfig.slow() | 慢速动画 |
| AnimationConfig.spring() | 弹簧动画 |
| AnimationConfig.bounce() | 回弹动画 |
| AnimationConfig.overshoot() | 过冲动画 |
| AnimationConfig.anticipate() | 预期动画 |
| AnimationConfig.none() | 无动画 |

### InterpolatorType 动画插值器

| 类型 | 说明 |
|------|------|
| LINEAR | 线性插值 |
| ACCELERATE | 加速 |
| DECELERATE | 减速 |
| ACCELERATE_DECELERATE | 加速减速 |
| SPRING | 弹簧效果 |
| BOUNCE | 回弹效果 |
| OVERSHOOT | 过冲效果 |
| ANTICIPATE | 预期效果 |

## 菜单动态更新

当需要在运行时动态更新菜单时，必须确保数据源的对象引用发生变化，以触发ForEach组件重新渲染。

### 核心原理

HarmonyOS的ForEach组件依赖keyGenerator生成的唯一键来判断是否需要重新渲染。当菜单状态发生变化时，必须同时更新数据对象的引用和key值。

### 数据模型定义

```typescript
// 定义数据接口
interface ContactInfoData {
  id: string;
  name: string;
  phone: string;
  email: string;
  avatar: Resource;
  isVip: boolean;
  isOnline: boolean;
  lastMessage: string;
  messageTime: string;
  _updateTimestamp?: number; // 用于触发UI刷新的时间戳
}

// 使用@Observed装饰器声明数据类
@Observed
class ContactInfo {
  id: string;
  name: string;
  phone: string;
  email: string;
  avatar: Resource;
  isVip: boolean;
  isOnline: boolean;
  lastMessage: string;
  messageTime: string;
  _updateTimestamp?: number;

  constructor(data: ContactInfoData) {
    this.id = data.id;
    this.name = data.name;
    this.phone = data.phone;
    this.email = data.email;
    this.avatar = data.avatar;
    this.isVip = data.isVip;
    this.isOnline = data.isOnline;
    this.lastMessage = data.lastMessage;
    this.messageTime = data.messageTime;
    this._updateTimestamp = data._updateTimestamp;
  }
}
```

### 关键配置

```typescript
SwipeMenuList({
  data: this.contactList,
  menuCreator: this.menuCreator,
  // 关键：自定义keyGenerator，使用id+timestamp确保key值变化
  keyGenerator: (item: Object) => {
    const contact = item as ContactInfo;
    return contact.id + '_' + (contact._updateTimestamp || 0);
  },
  // ...其他配置
})
```

### 统一刷新方法

```typescript
@Entry
@Component
struct DemoPage {
  @State contactList: ContactInfo[] = [];
  @State dynamicMenuTestEnabled: boolean = false;
  @State removeTestItemEnabled: boolean = false;
  @State menuItemModifyEnabled: boolean = false;
  
  /**
   * 刷新联系人列表以触发UI更新
   * ForEach需要通过修改对象引用来触发UI更新
   * 添加时间戳确保keyGenerator生成不同的key值
   */
  private refreshContactList(): void {
    const timestamp = Date.now();
    this.contactList = this.contactList.map((contact: ContactInfo): ContactInfo => {
      const data: ContactInfoData = {
        id: contact.id,
        name: contact.name,
        phone: contact.phone,
        email: contact.email,
        avatar: contact.avatar,
        isVip: contact.isVip,
        isOnline: contact.isOnline,
        lastMessage: contact.lastMessage,
        messageTime: contact.messageTime,
        _updateTimestamp: timestamp
      };
      return new ContactInfo(data);
    });
  }

  // 动态添加菜单项
  private addMenuItem(): void {
    this.dynamicMenuTestEnabled = true;
    this.refreshContactList();
  }

  // 动态移除菜单项
  private removeMenuItem(): void {
    this.removeTestItemEnabled = true;
    this.refreshContactList();
  }

  // 修改菜单项内容
  private modifyMenuItem(): void {
    this.menuItemModifyEnabled = true;
    this.refreshContactList();
  }

  // 重置所有菜单状态
  private resetMenuStates(): void {
    this.dynamicMenuTestEnabled = false;
    this.removeTestItemEnabled = false;
    this.menuItemModifyEnabled = false;
    this.refreshContactList();
  }
}
```

### 动态菜单创建器

```typescript
class MenuCreator implements SwipeMenuCreator {
  private component: DemoPage;

  constructor(component: DemoPage) {
    this.component = component;
  }

  create(menu: SwipeMenu, item?: Object, position?: number): void {
    if (item) {
      const contact = item as ContactInfo;
      
      // 基础菜单项
      const deleteItem = new SwipeMenuItem({
        id: 'delete',
        title: '删除',
        background: '#F44336',
        titleColor: '#FFFFFF',
        width: 90
      });
      menu.addMenuItem(deleteItem);
      
      // 根据状态动态添加菜单项
      if (this.component.isDynamicMenuTestEnabled()) {
        const testItem = new SwipeMenuItem({
          id: 'test_item',
          title: '测试',
          background: '#607D8B',
          titleColor: '#FFFFFF',
          width: 90
        });
        menu.addMenuItem(testItem);
      }
      
      // 根据状态动态移除菜单项
      if (this.component.shouldRemoveTestItem()) {
        const menuItems = menu.getMenuItems();
        const itemToRemove = menuItems.find(item => item.getId() === 'test_item');
        if (itemToRemove) {
          menu.removeMenuItem(itemToRemove);
        }
      }
      
      // 根据状态动态修改菜单项
      if (this.component.shouldModifyMenuItem()) {
        const firstMenuItem = menu.getMenuItem(0);
        if (firstMenuItem) {
          firstMenuItem.setTitle('已修改');
          firstMenuItem.setBackground('#4CAF50');
          firstMenuItem.setWidth(120);
        }
      }
    }
  }
}
```

### 实现要点

1. **统一刷新方法**: 将重复的刷新逻辑封装到 `refreshContactList()` 方法中
2. **对象引用更新**: 使用 `new ContactInfo(data)` 创建新的对象实例
3. **时间戳机制**: 通过 `_updateTimestamp` 确保keyGenerator生成不同的key值
4. **状态驱动**: 通过组件状态控制菜单的动态行为
5. **避免重复代码**: 所有需要刷新UI的操作都调用统一的刷新方法

### 常见错误

```typescript
// 错误：只更新数组引用，对象引用没变
this.contactList = [...this.contactList];

// 错误：直接修改对象属性
this.contactList[0].name = 'newName';

// 错误：使用spread但没有时间戳
this.contactList = this.contactList.map(contact => ({...contact}));
```

### 正确做法

```typescript
// 正确：创建新对象实例 + 时间戳 + 统一方法
private refreshContactList(): void {
  const timestamp = Date.now();
  this.contactList = this.contactList.map((contact: ContactInfo): ContactInfo => {
    const data: ContactInfoData = {
      id: contact.id,
      name: contact.name,
      // ...其他属性
      _updateTimestamp: timestamp
    };
    return new ContactInfo(data);
  });
}

// 在需要刷新的地方调用
private addMenuItem(): void {
  this.dynamicMenuTestEnabled = true;
  this.refreshContactList(); // 统一调用刷新方法
}
```

## 注意事项

- **状态管理**: 组件内部使用 @Provide/@Consume 模式管理状态，确保在使用时正确提供 SwipeStateController
- **手势冲突**: 在滚动容器中使用时，组件会自动处理手势冲突，但建议根据实际情况调整 touchConfig


## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望@ohos/swipemenulistview库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/swipemenulistview
```

## 约束与限制

在下述版本验证通过：

- IDE：DevEco Studio 5.1.0.849; SDK:API18 (5.1.0.125)。
- IDE：DevEco Studio 5.1.1.823; SDK:API19 (5.1.1.823)。

## 目录结构

```
library/                               # SwipeMenuListView 组件库
├── src/
│   ├── main/
│   │   └── ets/
│   │       ├── components/            # 核心组件
│   │       │   ├── SwipeMenuList.ets
│   │       │   ├── SwipeMenuListItem.ets
│   │       │   └── SwipeMenuItemLayout.ets
│   │       ├── model/                 # 数据模型
│   │       │   ├── SwipeMenuItem.ets
│   │       │   ├── SwipeMenu.ets
│   │       │   ├── SwipeMenuCreator.ets
│   │       │   ├── AnimationConfig.ets
│   │       │   └── TouchConfig.ets
│   │       ├── interfaces/            # 接口定义
│   │       │   ├── OnMenuItemClickListener.ets
│   │       │   ├── OnSwipeListener.ets
│   │       │   ├── OnMenuStateChangeListener.ets
│   │       │   ├── OnAnimationStateChangeListener.ets
│   │       │   └── OnItemLongPressListener.ets
│   │       ├── utils/                 # 工具类
│   │       │   ├── SwipeStateController.ets
│   │       │   ├── AnimationInterpolator.ets
│   │       │   ├── SwipeMenuListUtils.ets
│   │       │   ├── SwipeMenuPreferences.ets
│   │       │   └── Logger.ets
│   │       └── constants/             # 常量定义
│   │           ├── SwipeDirection.ets
│   │           └── TouchState.ets
│   ├── ohosTest/                      # 组件测试
│   └── test/                          # 单元测试
├── Index.ets                          # 对外导出接口
├── build-profile.json5                # 构建配置
└── oh-package.json5                   # 组件库依赖配置
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然也非常欢迎给
发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 共建。

## 开源协议

本项目基于 [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/tree/master/SwipeMenuListView/LICENSE) ，请自由地享受和参与开源。