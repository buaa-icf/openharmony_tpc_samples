# SwipeMenuListView

一个用于HarmonyOS的滑动菜单列表组件，支持左右滑动显示菜单项，提供丰富的自定义配置和事件回调。

## 特性

- ✅ **双向滑动支持** - 支持左滑和右滑显示菜单
- ✅ **丰富的动画配置** - 内置8种动画插值器，支持自定义动画曲线
- ✅ **触摸配置** - 提供敏感、默认、严格三种触摸模式
- ✅ **条件滑动控制** - 可以动态控制特定项目是否允许滑动
- ✅ **完整事件监听** - 滑动、菜单状态、长按、动画状态等事件监听
- ✅ **编程式控制** - 支持代码主动打开/关闭菜单
- ✅ **状态管理** - 内置状态控制器，确保只有一个菜单处于打开状态
- ✅ **自定义菜单项** - 支持图标、文字、背景色等完整自定义

## 安装

在项目的 `oh-package.json5` 中添加依赖：

```json
{
  "dependencies": {
    "@ohos/swipe-menu-listview": "^1.0.0"
  }
}
```

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
  AnimationConfig
} from '@ohos/swipe-menu-listview';
```

### 2. 创建菜单创建器

```typescript
class MyMenuCreator implements SwipeMenuCreator {
  create(menu: SwipeMenu): void {
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
  @State dataList: Array<Object> = [
    { id: '1', name: '项目1' },
    { id: '2', name: '项目2' },
    { id: '3', name: '项目3' }
  ];

  @State touchConfig: TouchConfig = TouchConfig.default();
  @State openAnimationConfig: AnimationConfig = AnimationConfig.default();
  @State closeAnimationConfig: AnimationConfig = AnimationConfig.fast();

  @Provide('swipeStateController') swipeController: SwipeStateController = new SwipeStateController();

  private menuCreator: MyMenuCreator = new MyMenuCreator();

  build() {
    Column() {
      SwipeMenuList({
        data: this.dataList,
        menuCreator: this.menuCreator,
        touchConfig: this.touchConfig,
        openAnimationConfig: this.openAnimationConfig,
        closeAnimationConfig: this.closeAnimationConfig,
        itemBuilder: (item: Object, index: number): void => {
          this.ItemBuilder(item, index);
        },
        onMenuItemClick: (position: number, menu: SwipeMenu, menuIndex: number): boolean => {
          const clickedItem = menu.getMenuItem(menuIndex);
          if (clickedItem?.getId() === 'delete') {
            // 处理删除操作
            this.deleteItem(position);
          }
          return false; // 点击后关闭菜单
        }
      })
    }
  }

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

  private deleteItem(position: number) {
    this.dataList = this.dataList.filter((_, index) => index !== position);
  }
}
```

## 高级配置

### 触摸配置

```typescript
// 敏感模式 - 容易触发滑动
@State touchConfig: TouchConfig = TouchConfig.sensitive();

// 严格模式 - 难以触发滑动
@State touchConfig: TouchConfig = TouchConfig.strict();

// 自定义配置
@State touchConfig: TouchConfig = new TouchConfig({
  minSwipeDistance: 20,        // 最小滑动距离
  minFlingVelocity: 800,       // 快速滑动最小速度
  menuOpenThreshold: 0.6,      // 菜单打开阈值
  enableTouchIntercept: true   // 启用触摸拦截
});
```

### 动画配置

```typescript
// 预设动画配置
@State openConfig: AnimationConfig = AnimationConfig.spring();   // 弹簧动画
@State closeConfig: AnimationConfig = AnimationConfig.bounce();  // 回弹动画

// 自定义动画配置
@State customConfig: AnimationConfig = new AnimationConfig({
  duration: 300,
  interpolator: InterpolatorType.ACCELERATE_DECELERATE,
  springConfig: {
    stiffness: 1.0,
    damping: 0.8,
    mass: 1.0
  }
});
```

### 滑动方向控制

```typescript
SwipeMenuList({
  // ...其他配置
  swipeDirection: SwipeDirection.DIRECTION_LEFT,  // 左滑显示菜单
  // swipeDirection: SwipeDirection.DIRECTION_RIGHT, // 右滑显示菜单
})
```

### 条件滑动控制

```typescript
SwipeMenuList({
  // ...其他配置
  getSwipeEnabled: (position: number): boolean => {
    // 只有奇数位置的项目可以滑动
    return position % 2 === 0;
  }
})
```

## 事件监听

### 菜单项点击

```typescript
onMenuItemClick: (position: number, menu: SwipeMenu, menuIndex: number): boolean => {
  const clickedItem = menu.getMenuItem(menuIndex);
  const itemId = clickedItem?.getId();

  switch (itemId) {
    case 'delete':
      // 删除操作
      break;
    case 'edit':
      // 编辑操作
      break;
  }

  return false; // 返回false关闭菜单，返回true保持菜单打开
}
```

### 滑动事件监听

```typescript
class MySwipeListener implements OnSwipeListener {
  onSwipeStart = (): void => {
    console.log('滑动开始');
  }

  onSwipeEnd = (): void => {
    console.log('滑动结束');
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
  onMenuOpen = (): void => {
    console.log('菜单打开');
  }

  onMenuClose = (): void => {
    console.log('菜单关闭');
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
    return true; // 返回true阻止事件传递
  }
}

SwipeMenuList({
  // ...其他配置
  onItemLongPress: new MyLongPressListener()
})
```

## 编程式控制

```typescript
// 获取状态控制器（通过@Consume注入）
@Consume('swipeStateController') swipeController: SwipeStateController;

// 主动打开指定位置的菜单
this.swipeController.smoothOpenMenu(position);

// 关闭当前打开的菜单
this.swipeController.smoothCloseMenu();

// 检查指定位置菜单是否打开
const isOpen = this.swipeController.isMenuOpen(position);

// 更新触摸配置
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
| swipeDirection | number | SwipeDirection.DEFAULT | 滑动方向 |
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

## 注意事项

1. **状态管理**: 组件内部使用 `@Provide/@Consume` 模式管理状态，确保在使用时正确提供 `SwipeStateController`

2. **性能优化**: 对于大量数据，建议实现高效的 `keyGenerator` 函数以优化渲染性能

3. **手势冲突**: 在滚动容器中使用时，组件会自动处理手势冲突，但建议根据实际情况调整 `touchConfig`

4. **内存管理**: 注意及时清理事件监听器，避免内存泄漏

## 许可证

Copyright (C) 2025 Huawei Device Co., Ltd.

本软件按许可证分发。完整的许可证协议可以在本发行版的 LICENSE 文件中找到。