# SwipeMenuListView

## Introduction
A HarmonyOS swipe menu list component that supports custom menu items and smooth animation effects.

## Demo

![avatar](ScreenShots/演示.gif)

## Installation

```shell
ohpm install @ohos/swipemenulistview
```
For more information on OpenHarmony ohpm environment configuration, please refer to [How to install OpenHarmony ohpm packages](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md).

## X86 Emulator Configuration

[Using an Emulator to Run Your App/Service](https://developer.huawei.com/consumer/cn/deveco-developer-suite/enabling/kit?currentPage=1&pageSize=100)

## Basic Usage

### 1. Import Components

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

### 2. Create a Menu Creator

The menu creator interface supports multiple view types, allowing you to create different menus based on data items and positions:

```typescript
class MyMenuCreator implements SwipeMenuCreator {
  create(menu: SwipeMenu, item?: Object, position?: number): void {
    // Add delete menu
    const deleteItem = new SwipeMenuItem({
      id: 'delete',
      title: 'Delete',
      background: '#F44336',
      titleColor: '#FFFFFF',
      width: 90,
      icon: $r('app.media.delete_icon')
    });
    menu.addMenuItem(deleteItem);

    // Add edit menu
    const editItem = new SwipeMenuItem({
      id: 'edit',
      title: 'Edit',
      background: '#2196F3',
      titleColor: '#FFFFFF',
      width: 90
    });
    menu.addMenuItem(editItem);
  }
}
```

### 3. Use the Component

```typescript
@Entry
@Component
struct MainPage {
  // Define the data source, each object needs a unique id
  @State dataList: Array<Object> = [
    { id: '1', name: 'Item 1' },
    { id: '2', name: 'Item 2' },
    { id: '3', name: 'Item 3' }
  ];

  // Touch configuration to control swipe sensitivity
  @State touchConfig: TouchConfig = TouchConfig.default();
  // Menu open animation configuration
  @State openAnimationConfig: AnimationConfig = AnimationConfig.default();
  // Menu close animation configuration, using a fast animation
  @State closeAnimationConfig: AnimationConfig = AnimationConfig.fast();

  // Provide a swipe state controller for programmatic menu control
  @Provide('swipeStateController') swipeController: SwipeStateController = new SwipeStateController();

  // Create a menu creator instance
  private menuCreator: MyMenuCreator = new MyMenuCreator();

  build() {
    Column() {
      SwipeMenuList({
        data: this.dataList,                          // Bind the data source
        menuCreator: this.menuCreator,                // Set the menu creator
        touchConfig: this.touchConfig,                // Apply touch configuration
        openAnimationConfig: this.openAnimationConfig,   // Set the open animation
        closeAnimationConfig: this.closeAnimationConfig, // Set the close animation
        itemBuilder: (item: Object, index: number): void => {
          this.ItemBuilder(item, index);              // Custom list item builder
        },
        onMenuItemClick: (position: number, menu: SwipeMenu, menuIndex: number): boolean => {
          const clickedItem = menu.getMenuItem(menuIndex);  // Get the clicked menu item
          if (clickedItem?.getId() === 'delete') {          // Check if it's the delete button
            this.deleteItem(position);                      // Perform the delete operation
          }
          return false; // Returning false closes the menu after a click
        }
      })
    }
  }

  // Custom list item builder
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

  // Delete the data item at the specified position
  private deleteItem(position: number) {
    this.dataList = this.dataList.filter((_, index) => index !== position);
  }
}
```

## More Configurations

### Touch Configuration

```typescript
// Sensitive mode - easier to trigger swipe
@State touchConfig: TouchConfig = TouchConfig.sensitive();

// Strict mode - harder to trigger swipe
@State touchConfig: TouchConfig = TouchConfig.strict();

// Custom configuration
@State touchConfig: TouchConfig = new TouchConfig({
  minSwipeDistance: 20,        // Minimum swipe distance (in pixels)
  minFlingVelocity: 800,       // Minimum fling velocity (in pixels/second)
  menuOpenThreshold: 0.6,      // Menu open threshold (0-1, the ratio of swipe distance to menu width)
  enableTouchIntercept: true   // Enable touch interception to prevent gesture conflicts with parent containers
});
```

### Animation Configuration

```typescript
// Preset animation configurations
@State openConfig: AnimationConfig = AnimationConfig.spring();   // Spring animation
@State closeConfig: AnimationConfig = AnimationConfig.bounce();  // Bounce animation

// Custom animation configuration
@State customConfig: AnimationConfig = new AnimationConfig({
  duration: 300,                                        // Animation duration (in milliseconds)
  interpolator: InterpolatorType.ACCELERATE_DECELERATE, // Interpolator type: accelerate then decelerate
  springConfig: {                                       // Spring animation parameters
    stiffness: 1.0,                                     // Spring stiffness, higher value means stronger elasticity
    damping: 0.8,                                       // Damping ratio, higher value means less oscillation
    mass: 1.0                                           // Mass, affects animation speed
  }
});
```

### Swipe Direction Control

```typescript
SwipeMenuList({
  // ...other configurations
  swipeDirection: SwipeDirection.DIRECTION_LEFT,  // Swipe left to show menu (default)
  // swipeDirection: SwipeDirection.DIRECTION_RIGHT, // Swipe right to show menu
})
```

### Conditional Swipe Control

```typescript
SwipeMenuList({
  // ...other configurations
  getSwipeEnabled: (position: number): boolean => {
    // Only items at even positions can be swiped
    return position % 2 === 0;
  }
})
```

## Event Listeners

### Menu Item Clicks

```typescript
onMenuItemClick: (position: number, menu: SwipeMenu, menuIndex: number): boolean => {
  const clickedItem = menu.getMenuItem(menuIndex);  // Get the clicked menu item by index
  const itemId = clickedItem?.getId();              // Get the unique ID of the menu item

  switch (itemId) {
    case 'delete':
      // Perform delete operation
      console.log(`Deleting item at position ${position}`);
      break;
    case 'edit':
      // Perform edit operation
      console.log(`Editing item at position ${position}`);
      break;
  }

  return false; // Return false to close the menu, true to keep it open
}```

### Swipe Event Listener

```typescript
class MySwipeListener implements OnSwipeListener {
  onSwipeStart = (position: number): void => {
    console.log(`Swipe start - position: ${position}`);
  }

  onSwipeEnd = (position: number): void => {
    console.log(`Swipe end - position: ${position}`);
  }
}

SwipeMenuList({
  // ...other configurations
  onSwipeListener: new MySwipeListener()
})
```

### Menu State Listener

```typescript
class MyMenuStateListener implements OnMenuStateChangeListener {
  onMenuOpen = (position: number): void => {
    console.log(`Menu opened - position: ${position}`);
  }

  onMenuClose = (position: number): void => {
    console.log(`Menu closed - position: ${position}`);
  }
}

SwipeMenuList({
  // ...other configurations
  onMenuStateChangeListener: new MyMenuStateListener()
})
```

### Long Press Event Listener

```typescript
class MyLongPressListener implements OnItemLongPressListener {
  onItemLongPress = (position: number, item: Object): boolean => {
    console.log(`Long pressed item at position ${position}`);
    // Show context menu or perform other actions
    // You can show a dialog, display more options, etc., here
    return true; // Return true to prevent the event from propagating to other components
  }
}

SwipeMenuList({
  // ...other configurations
  onItemLongPress: new MyLongPressListener()
})
```

### Animation State Listener

```typescript
class MyAnimationListener implements OnAnimationStateChangeListener {
  onAnimationStart = (itemPosition: number, animationType: AnimationType): void => {
    console.log(`Animation start - position: ${itemPosition}, type: ${animationType}`);
  }

  onAnimationEnd = (itemPosition: number, animationType: AnimationType): void => {
    console.log(`Animation end - position: ${itemPosition}, type: ${animationType}`);
  }

  onDragProgress = (itemPosition: number, progress: number, offsetX: number): void => {
    console.log(`Drag progress - position: ${itemPosition}, progress: ${progress.toFixed(2)}, offset: ${offsetX}`);
  }
}

SwipeMenuList({
  // ...other configurations
  onAnimationStateChangeListener: new MyAnimationListener()
})
```

## Programmatic Control

```typescript
// Get the state controller (injected via @Consume, needs to be paired with @Provide)
@Consume('swipeStateController') swipeController: SwipeStateController;

// Programmatically open the menu at a specific position (with animation)
this.swipeController.smoothOpenMenu(position);

// Close the currently open menu (if any)
this.swipeController.smoothCloseMenu();

// Check if the menu at a specific position is open
const isOpen = this.swipeController.isMenuOpen(position);

// Dynamically update the touch configuration, which takes effect immediately
this.swipeController.updateTouchConfig(TouchConfig.sensitive());
```

## Customizing Menu Items

### SwipeMenuItem Configuration Options

```typescript
const menuItem = new SwipeMenuItem({
  id: 'custom',                    // Unique identifier
  title: 'Custom',                 // Display text
  icon: $r('app.media.icon'),      // Icon resource
  background: '#FF5722',           // Background color
  titleColor: '#FFFFFF',           // Text color
  titleSize: 14,                   // Text size
  width: 100                       // Width
});
```

### Dynamically Modifying Menu Items

```typescript
// Get the menu item
const menuItem = menu.getMenuItem(0);

// Modify properties
menuItem?.setTitle('New Title');
menuItem?.setBackground('#4CAF50');
menuItem?.setWidth(120);
```

## API Reference

### SwipeMenuList Properties

| Property | Type | Default | Description |
|---|---|---|---|
| data | Array<Object> | [] | Data source array |
| menuCreator | SwipeMenuCreator | DefaultMenuCreator | Menu creator |
| itemBuilder | BuilderParam | - | List item builder |
| touchConfig | TouchConfig | TouchConfig.default() | Touch configuration |
| openAnimationConfig | AnimationConfig | AnimationConfig.default() | Open animation configuration |
| closeAnimationConfig | AnimationConfig | AnimationConfig.default() | Close animation configuration |
| swipeDirection | number | SwipeDirection.DIRECTION_LEFT | Swipe direction |
| dragFollowAnimation | boolean | true | Whether to enable drag-follow animation |
| enableSpringBack | boolean | true | Whether to enable spring-back effect |
| keyGenerator | (item: Object) => string | JSON.stringify | Unique key generator |
| getSwipeEnabled | (position: number) => boolean | undefined | Function to control swipe capability |

### SwipeMenuList Events

| Event | Type | Description |
|---|---|---|
| onMenuItemClick | OnMenuItemClickListener | Menu item click event |
| onSwipeListener | OnSwipeListener | Swipe event listener |
| onMenuStateChangeListener | OnMenuStateChangeListener | Menu state change listener |
| onAnimationStateChangeListener | OnAnimationStateChangeListener | Animation state change listener |
| onItemLongPress | OnItemLongPressListener | Long press event listener |

### TouchConfig Preset Configurations

| Method | Description |
|---|---|
| TouchConfig.default() | Default configuration |
| TouchConfig.sensitive() | Sensitive configuration (easier to trigger) |
| TouchConfig.strict() | Strict configuration (harder to trigger) |

### AnimationConfig Preset Configurations

| Method | Description |
|---|---|
| AnimationConfig.default() | Default animation |
| AnimationConfig.fast() | Fast animation |
| AnimationConfig.slow() | Slow animation |
| AnimationConfig.spring() | Spring animation |
| AnimationConfig.bounce() | Bounce animation |
| AnimationConfig.overshoot() | Overshoot animation |
| AnimationConfig.anticipate() | Anticipate animation |
| AnimationConfig.none() | No animation |

### InterpolatorType Animation Interpolators

| Type | Description |
|---|---|
| LINEAR | Linear interpolation |
| ACCELERATE | Accelerate |
| DECELERATE | Decelerate |
| ACCELERATE_DECELERATE | Accelerate-decelerate |
| SPRING | Spring effect |
| BOUNCE | Bounce effect |
| OVERSHOOT | Overshoot effect |
| ANTICIPATE | Anticipate effect |

## Dynamic Menu Updates

When you need to dynamically update the menu at runtime, you must ensure that the object references in the data source change to trigger a re-render of the ForEach component.

### Core Principle

The ForEach component in HarmonyOS relies on the unique keys generated by keyGenerator to determine whether a re-render is necessary. When the menu state changes, you must update both the data object's reference and its key value.

### Data Model Definition

```typescript
// Define the data interface
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
  _updateTimestamp?: number; // Timestamp to trigger UI refresh
}

// Declare the data class with the @Observed decorator
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

### Key Configuration

```typescript
SwipeMenuList({
  data: this.contactList,
  menuCreator: this.menuCreator,
  // Key: Customize keyGenerator, use id+timestamp to ensure the key value changes
  keyGenerator: (item: Object) => {
    const contact = item as ContactInfo;
    return contact.id + '_' + (contact._updateTimestamp || 0);
  },
  // ...other configurations
})
```

### Unified Refresh Method

```typescript
@Entry
@Component
struct DemoPage {
  @State contactList: ContactInfo[] = [];
  @State dynamicMenuTestEnabled: boolean = false;
  @State removeTestItemEnabled: boolean = false;
  @State menuItemModifyEnabled: boolean = false;

  /**
   * Refreshes the contact list to trigger a UI update.
   * ForEach needs to modify object references to trigger a UI update.
   * Adding a timestamp ensures that keyGenerator generates different key values.
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

  // Dynamically add a menu item
  private addMenuItem(): void {
    this.dynamicMenuTestEnabled = true;
    this.refreshContactList();
  }

  // Dynamically remove a menu item
  private removeMenuItem(): void {
    this.removeTestItemEnabled = true;
    this.refreshContactList();
  }

  // Modify menu item content
  private modifyMenuItem(): void {
    this.menuItemModifyEnabled = true;
    this.refreshContactList();
  }

  // Reset all menu states
  private resetMenuStates(): void {
    this.dynamicMenuTestEnabled = false;
    this.removeTestItemEnabled = false;
    this.menuItemModifyEnabled = false;
    this.refreshContactList();
  }
}
```

### Dynamic Menu Creator

```typescript
class MenuCreator implements SwipeMenuCreator {
  private component: DemoPage;

  constructor(component: DemoPage) {
    this.component = component;
  }

  create(menu: SwipeMenu, item?: Object, position?: number): void {
    if (item) {
      const contact = item as ContactInfo;

      // Basic menu item
      const deleteItem = new SwipeMenuItem({
        id: 'delete',
        title: 'Delete',
        background: '#F44336',
        titleColor: '#FFFFFF',
        width: 90
      });
      menu.addMenuItem(deleteItem);

      // Dynamically add a menu item based on state
      if (this.component.isDynamicMenuTestEnabled()) {
        const testItem = new SwipeMenuItem({
          id: 'test_item',
          title: 'Test',
          background: '#607D8B',
          titleColor: '#FFFFFF',
          width: 90
        });
        menu.addMenuItem(testItem);
      }

      // Dynamically remove a menu item based on state
      if (this.component.shouldRemoveTestItem()) {
        const menuItems = menu.getMenuItems();
        const itemToRemove = menuItems.find(item => item.getId() === 'test_item');
        if (itemToRemove) {
          menu.removeMenuItem(itemToRemove);
        }
      }

      // Dynamically modify a menu item based on state
      if (this.component.shouldModifyMenuItem()) {
        const firstMenuItem = menu.getMenuItem(0);
        if (firstMenuItem) {
          firstMenuItem.setTitle('Modified');
          firstMenuItem.setBackground('#4CAF50');
          firstMenuItem.setWidth(120);
        }
      }
    }
  }
}
```

### Implementation Points

1.  **Unified Refresh Method**: Encapsulate repetitive refresh logic into the `refreshContactList()` method.
2.  **Object Reference Updates**: Create new object instances using `new ContactInfo(data)`.
3.  **Timestamp Mechanism**: Use `_updateTimestamp` to ensure keyGenerator generates different key values.
4.  **State-Driven**: Control the dynamic behavior of the menu through component state.
5.  **Avoid Code Duplication**: All operations that require a UI refresh should call the unified refresh method.

### Common Mistakes

```typescript
// Wrong: Only the array reference is updated, not the object references
this.contactList = [...this.contactList];

// Wrong: Directly modifying object properties
this.contactList[0].name = 'newName';

// Wrong: Using spread without a timestamp
this.contactList = this.contactList.map(contact => ({...contact}));
```

### Correct Approach

```typescript
// Correct: Create new object instances + timestamp + unified method
private refreshContactList(): void {
  const timestamp = Date.now();
  this.contactList = this.contactList.map((contact: ContactInfo): ContactInfo => {
    const data: ContactInfoData = {
      id: contact.id,
      name: contact.name,
      // ...other properties
      _updateTimestamp: timestamp
    };
    return new ContactInfo(data);
  });
}

// Call this where a refresh is needed
private addMenuItem(): void {
  this.dynamicMenuTestEnabled = true;
  this.refreshContactList(); // Call the unified refresh method
}
```

## Notes

-   **State Management**: The component uses the @Provide/@Consume pattern internally for state management. Ensure that `SwipeStateController` is correctly provided when using it.
-   **Gesture Conflicts**: When used within a scrolling container, the component automatically handles gesture conflicts. However, it's recommended to adjust the `touchConfig` based on your specific use case.


## About Obfuscation
- For code obfuscation, please refer to the [Introduction to Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md).
- If you want to prevent the `@ohos/swipemenulistview` library from being obfuscated, you need to add the corresponding exclusion rule to the obfuscation rules file, `obfuscation-rules.txt`:
```
-keep
./oh_modules/@ohos/swipemenulistview
```

## Constraints and Limitations

Verified on the following versions:

- IDE: DevEco Studio 5.1.0.849; SDK: API18 (5.1.0.125).
- IDE: DevEco Studio 5.1.1.823; SDK: API19 (5.1.1.823).

## Directory Structure

```
library/                               # SwipeMenuListView component library
├── src/
│   ├── main/
│   │   └── ets/
│   │       ├── components/            # Core components
│   │       │   ├── SwipeMenuList.ets
│   │       │   ├── SwipeMenuListItem.ets
│   │       │   └── SwipeMenuItemLayout.ets
│   │       ├── model/                 # Data models
│   │       │   ├── SwipeMenuItem.ets
│   │       │   ├── SwipeMenu.ets
│   │       │   ├── SwipeMenuCreator.ets
│   │       │   ├── AnimationConfig.ets
│   │       │   └── TouchConfig.ets
│   │       ├── interfaces/            # Interface definitions
│   │       │   ├── OnMenuItemClickListener.ets
│   │       │   ├── OnSwipeListener.ets
│   │       │   ├── OnMenuStateChangeListener.ets
│   │       │   ├── OnAnimationStateChangeListener.ets
│   │       │   └── OnItemLongPressListener.ets
│   │       ├── utils/                 # Utility classes
│   │       │   ├── SwipeStateController.ets
│   │       │   ├── AnimationInterpolator.ets
│   │       │   ├── SwipeMenuListUtils.ets
│   │       │   ├── SwipeMenuPreferences.ets
│   │       │   └── Logger.ets
│   │       └── constants/             # Constant definitions
│   │           ├── SwipeDirection.ets
│   │           └── TouchState.ets
│   ├── ohosTest/                      # Component tests
│   └── test/                          # Unit tests
├── Index.ets                          # Public exports
├── build-profile.json5                # Build configuration
└── oh-package.json5                   # Component library dependency configuration
```

## Contributing

If you encounter any issues while using the component, feel free to submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues). We also welcome you to contribute by submitting a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is based on the [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/tree/master/SwipeMenuListView/LICENSE). Please feel free to enjoy and participate in open source.