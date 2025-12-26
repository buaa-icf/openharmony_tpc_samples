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
  OnSwipeListener,
  OnMenuStateChangeListener,
  OnAnimationStateChangeListener,
  OnItemLongPressListener,
  SwipeDirection
} from '@ohos/swipemenulistview';
import promptAction from '@ohos.promptAction';

// 数据模型接口
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
  _updateTimestamp?: number;
}

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
  _updateTimestamp?: number; // 内部更新时间戳，用于触发ForEach刷新

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

// 菜单创建器
class MenuCreator implements SwipeMenuCreator {
  private component: DemoPage;

  constructor(component: DemoPage) {
    this.component = component;
  }

  create(menu: SwipeMenu, item?: Object, position?: number): void {
    console.log(`=== MenuCreator.create 被调用，position=${position} ===`);
    if (item) {
      const contact = item as ContactInfo;
      console.log(`联系人: ${contact.name}, 位置: ${position}`);
      console.log(`dynamicMenuTestEnabled: ${this.component.isDynamicMenuTestEnabled()}`);
      console.log(`removeTestItemEnabled: ${this.component.shouldRemoveTestItem()}`);
      console.log(`menuItemModifyEnabled: ${this.component.shouldModifyMenuItem()}`);

      if (contact.isVip) {
        // VIP用户菜单 - 设置viewType为1
        menu.setViewType(1);

        // VIP专属：视频通话（大尺寸突出显示）
        const videoCallItem = new SwipeMenuItem({
          id: 'video_call',
          title: '视频',
          background: '#9C27B0',
          titleColor: '#FFFFFF',
          titleSize: 16,
          width: 100,
          icon: $r('app.media.phonecall')
        });
        menu.addMenuItem(videoCallItem);

        // VIP专属：优先消息（大尺寸突出显示）
        const priorityMessageItem = new SwipeMenuItem({
          id: 'priority_message',
          title: '优先',
          background: '#FF9800',
          titleColor: '#FFFFFF',
          titleSize: 16,
          width: 100,
          icon: $r('app.media.message')
        });
        menu.addMenuItem(priorityMessageItem);

        // 通话菜单项（中等尺寸）
        const callItem = new SwipeMenuItem({
          id: 'call',
          title: '通话',
          background: '#4CAF50',
          titleColor: '#FFFFFF',
          titleSize: 14,
          width: 85,
          icon: $r('app.media.phonecall')
        });
        menu.addMenuItem(callItem);

        // 删除菜单项（紧凑尺寸）
        const deleteItem = new SwipeMenuItem({
          id: 'delete',
          title: '删除',
          background: '#F44336',
          titleColor: '#FFFFFF',
          titleSize: 12,
          width: 70,
          icon: $r('app.media.close')
        });
        menu.addMenuItem(deleteItem);

      } else {
        // 普通用户菜单 - 设置viewType为0
        menu.setViewType(0);

        // 消息菜单项（普通用户标准尺寸）
        const messageItem = new SwipeMenuItem({
          id: 'message',
          title: '消息',
          background: '#2196F3',
          titleColor: '#FFFFFF',
          titleSize: 13,
          width: 80,
          icon: $r('app.media.message')
        });
        menu.addMenuItem(messageItem);

        // 删除菜单项（普通用户紧凑尺寸）
        const deleteItem = new SwipeMenuItem({
          id: 'delete',
          title: '删除',
          background: '#F44336',
          titleColor: '#FFFFFF',
          titleSize: 12,
          width: 70,
          icon: $r('app.media.close')
        });
        menu.addMenuItem(deleteItem);
      }

      // 测试addMenuItem和removeMenuItem接口
      this.testMenuItemOperations(menu, contact);
      
      console.log(`=== 菜单创建完成，最终包含 ${menu.getMenuItems().length} 个菜单项 ===`);

    } else {
      // 默认菜单（向后兼容）
      menu.setViewType(0);
      const defaultItem = new SwipeMenuItem({
        id: 'default',
        title: '操作',
        background: '#607D8B',
        titleColor: '#FFFFFF',
        titleSize: 14,
        width: 90
      });
      menu.addMenuItem(defaultItem);
    }
  }

  // 测试addMenuItem和removeMenuItem接口的功能
  private testMenuItemOperations(menu: SwipeMenu, contact: ContactInfo): void {
    // 根据动态菜单状态添加菜单项
    if (this.component.isDynamicMenuTestEnabled()) {
      const testItem = new SwipeMenuItem({
        id: 'test_item',
        title: '测试',
        background: '#607D8B',
        titleColor: '#FFFFFF',
        titleSize: 14,
        width: 90,
        icon: $r('app.media.user')
      });
      
      // 添加测试菜单项
      menu.addMenuItem(testItem);
    }

    // 根据移除状态移除刚才添加的菜单项
    if (this.component.shouldRemoveTestItem()) {
      // 查找并移除测试菜单项
      const menuItems = menu.getMenuItems();
      const itemToRemove = menuItems.find(item => item.getId() === 'test_item');
      if (itemToRemove) {
        menu.removeMenuItem(itemToRemove);
      }
    }

    // 运行时修改菜单项内容
    if (this.component.shouldModifyMenuItem()) {
      // 获取第一个菜单项并修改其属性
      const firstMenuItem = menu.getMenuItem(0);
      if (firstMenuItem) {
        // 修改标题、背景色和宽度
        firstMenuItem.setTitle('已修改');
        firstMenuItem.setBackground('#4CAF50');
        firstMenuItem.setWidth(120);
      }

      // 如果有第二个菜单项，也进行修改
      const secondMenuItem = menu.getMenuItem(1);
      if (secondMenuItem) {
        secondMenuItem.setTitle('修改2');
        secondMenuItem.setBackground('#FF9800');
        secondMenuItem.setWidth(100);
      }
    }

  }
}



// 菜单点击处理器
class MenuClickHandler implements OnMenuItemClickListener {
  private component: DemoPage;

  constructor(component: DemoPage) {
    this.component = component;
  }

  onMenuItemClick(position: number, menu: SwipeMenu, menuIndex: number): boolean {
    return this.component.handleMenuItemClick(position, menu, menuIndex);
  }
}

// 滑动事件监听器
class SwipeListener implements OnSwipeListener {
  constructor() {
  }

  onSwipeStart = (position: number): void => {
    // 滑动开始处理
  }

  onSwipeEnd = (position: number): void => {
    // 滑动结束处理
  }
}

// 菜单状态变化监听器
class MenuStateChangeListener implements OnMenuStateChangeListener {
  constructor() {
  }

  onMenuOpen = (position: number): void => {
    // 菜单打开处理
  }

  onMenuClose = (position: number): void => {
    // 菜单关闭处理
  }
}

// 长按事件监听器
class LongPressListener implements OnItemLongPressListener {
  constructor() {
  }

  onItemLongPress = (_position: number, item: Object): boolean => {
    const contact = item as ContactInfo;
    
    promptAction.showDialog({
      title: '联系人操作',
      message: `选择对 ${contact.name} 的操作`,
      buttons: [
        { text: '查看详情', color: '#2196F3' },
        { text: '编辑', color: '#FF9800' },
        { text: '取消', color: '#666666' }
      ]
    }).then((result) => {
      if (result.index === 0) {
        promptAction.showToast({
          message: `查看 ${contact.name} 的详情`,
          duration: 1500
        });
      } else if (result.index === 1) {
        promptAction.showToast({
          message: `编辑 ${contact.name} 的信息`,
          duration: 1500
        });
      }
    });
    
    return true; // 阻止事件传递
  }
}

// 动画状态变化监听器
class AnimationStateChangeListener implements OnAnimationStateChangeListener {
  constructor() {
  }

  onAnimationStart = (itemPosition: number, animationType: AnimationType): void => {
    // 动画开始处理
  }

  onAnimationEnd = (itemPosition: number, animationType: AnimationType): void => {
    // 动画结束处理
  }

  onDragProgress = (itemPosition: number, progress: number, offsetX: number): void => {
    // 拖拽进度处理
  }
}

@Entry
@Component
struct DemoPage {
  @State contactList: ContactInfo[] = [];
  @State openAnimationConfig: AnimationConfig = new AnimationConfig().setInterpolator(InterpolatorType.SPRING).setDuration(300);
  @State closeAnimationConfig: AnimationConfig = new AnimationConfig().setInterpolator(InterpolatorType.BOUNCE).setDuration(350);
  @State touchConfig: TouchConfig = TouchConfig.default();
  
  // 动态菜单相关状态
  @State dynamicMenuTestEnabled: boolean = false;
  @State removeTestItemEnabled: boolean = false;
  @State menuItemModifyEnabled: boolean = false;
  
  @Provide('swipeStateController') swipeController: SwipeStateController = new SwipeStateController();
  
  private menuClickHandler: MenuClickHandler = new MenuClickHandler(this);
  private swipeListener: SwipeListener = new SwipeListener();
  private menuStateChangeListener: MenuStateChangeListener = new MenuStateChangeListener();
  private longPressListener: LongPressListener = new LongPressListener();
  private animationStateChangeListener: AnimationStateChangeListener = new AnimationStateChangeListener();
  private normalMenuCreator: MenuCreator = new MenuCreator(this);

  // 控制滑动能力：只有在线用户可以滑动
  private getSwipeEnabled = (position: number): boolean => {
    if (position >= 0 && position < this.contactList.length) {
      const contact = this.contactList[position];
      return contact.isOnline; // 只有在线用户可以滑动
    }
    return false;
  }

  aboutToAppear() {
    this.loadContactData();
  }

  // 动态菜单相关方法
  isDynamicMenuTestEnabled(): boolean {
    return this.dynamicMenuTestEnabled;
  }

  shouldRemoveTestItem(): boolean {
    // 当启用移除测试时，移除之前添加的测试菜单项
    return this.removeTestItemEnabled;
  }

  shouldModifyMenuItem(): boolean {
    // 当启用菜单项修改测试时，修改菜单项内容
    return this.menuItemModifyEnabled;
  }

  // 动态添加菜单项
  private addMenuItem(): void {
    console.log('=== 添加菜单项开始 ===');
    this.dynamicMenuTestEnabled = true;
    console.log('dynamicMenuTestEnabled设置为:', this.dynamicMenuTestEnabled);
    
    // 根据HarmonyOS官方文档：ForEach需要通过修改对象引用来触发UI更新
    // 创建新的对象实例，确保每个contact都有新的引用
    // 添加时间戳确保keyGenerator生成不同的key值
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
    
    console.log('contactList已更新，新数组长度:', this.contactList.length);
    console.log('=== 添加菜单项结束 ===');
  }

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



  // 加载联系人数据
  private loadContactData() {
    const contactData: ContactInfoData[] = [
      {
        id: 'contact_1',
        name: '张三',
        phone: '138****1234',
        email: 'zhangsan@example.com',
        avatar: $r('app.media.user'),
        isVip: true,
        isOnline: true,
        lastMessage: '你好，明天的会议准备好了吗？',
        messageTime: '10:30'
      },
      {
        id: 'contact_2', 
        name: '李四',
        phone: '139****5678',
        email: 'lisi@example.com',
        avatar: $r('app.media.user'),
        isVip: false,
        isOnline: false,
        lastMessage: '周末一起吃饭吧',
        messageTime: '昨天'
      },
      {
        id: 'contact_3',
        name: '王五',
        phone: '136****9012',
        email: 'wangwu@example.com',
        avatar: $r('app.media.user'),
        isVip: true,
        isOnline: true,
        lastMessage: '项目进度如何？',
        messageTime: '09:15'
      },
      {
        id: 'contact_4',
        name: '赵六',
        phone: '137****3456',
        email: 'zhaoliu@example.com',
        avatar: $r('app.media.user'),
        isVip: false,
        isOnline: true,
        lastMessage: '文档已经发送给你了',
        messageTime: '08:45'
      },
      {
        id: 'contact_5',
        name: '钱七',
        phone: '135****7890',
        email: 'qianqi@example.com',
        avatar: $r('app.media.user'),
        isVip: false,
        isOnline: false,
        lastMessage: '好的，收到了',
        messageTime: '前天'
      },
      {
        id: 'contact_6',
        name: '孙八',
        phone: '134****2468',
        email: 'sunba@example.com',
        avatar: $r('app.media.user'),
        isVip: true,
        isOnline: true,
        lastMessage: '新产品发布会安排在下周三',
        messageTime: '11:20'
      }
    ];
    this.contactList = contactData.map(data => new ContactInfo(data));
  }



  // 处理菜单项点击
  handleMenuItemClick(position: number, menu: SwipeMenu, menuIndex: number): boolean {
    const contact = this.contactList[position];
    const clickedMenuItem = menu.getMenuItem(menuIndex);
    const menuItemId = clickedMenuItem?.getId();
    const viewType = menu.getViewType();


    switch (menuItemId) {
      case 'video_call':
        this.makeVideoCall(contact);
        break;
      case 'priority_message':
        this.sendPriorityMessage(contact);
        break;
      case 'call':
        this.makeCall(contact);
        break;
      case 'message':
        this.sendMessage(contact);
        break;
      case 'delete':
        this.deleteContact(position);
        break;
      case 'test_item':
        this.handleTestItem(contact);
        break;
      case 'extra_vip':
        this.handleExtraVipItem(contact);
        break;
      case 'extra_normal':
        this.handleExtraNormalItem(contact);
        break;
      case 'special_item':
        this.handleSpecialItem(contact);
        break;
      default:
        promptAction.showToast({
          message: `点击了 ${menuItemId} 菜单`,
          duration: 1500
        });
        break;
    }

    return false; // 点击后关闭菜单
  }

  // VIP专属：视频通话
  private makeVideoCall(contact: ContactInfo) {
    promptAction.showToast({
      message: `发起视频通话给VIP用户 ${contact.name}`,
      duration: 2000
    });
  }

  // VIP专属：优先消息
  private sendPriorityMessage(contact: ContactInfo) {
    promptAction.showToast({
      message: `发送优先消息给VIP用户 ${contact.name}`,
      duration: 2000
    });
  }

  // 拨打电话
  private makeCall(contact: ContactInfo) {
    promptAction.showToast({
      message: `拨打电话给 ${contact.name}`,
      duration: 2000
    });
  }

  // 发送消息
  private sendMessage(contact: ContactInfo) {
    promptAction.showToast({
      message: `发送消息给 ${contact.name}`,
      duration: 2000
    });
  }

  // 删除联系人
  private deleteContact(position: number) {
    const contact = this.contactList[position];
    
    // 先关闭菜单再删除
    if (this.swipeController.isMenuOpen(position)) {
      this.swipeController.smoothCloseMenu();
    }
    
    setTimeout(() => {
      this.contactList = this.contactList.filter((_, index) => index !== position);
      promptAction.showToast({
        message: `已删除 ${contact.name}`,
        duration: 2000
      });
    }, 100);
  }

  // 处理测试菜单项点击
  private handleTestItem(contact: ContactInfo) {
    promptAction.showToast({
      message: `测试菜单项被点击 - ${contact.name}`,
      duration: 2000
    });
  }

  // 处理VIP额外菜单项点击
  private handleExtraVipItem(contact: ContactInfo) {
    promptAction.showToast({
      message: `VIP特权菜单被点击 - ${contact.name}`,
      duration: 2000
    });
  }

  // 处理普通用户额外菜单项点击
  private handleExtraNormalItem(contact: ContactInfo) {
    promptAction.showToast({
      message: `更多菜单被点击 - ${contact.name}`,
      duration: 2000
    });
  }

  // 处理特殊菜单项点击
  private handleSpecialItem(contact: ContactInfo) {
    promptAction.showToast({
      message: `特殊菜单被点击 - ${contact.name}`,
      duration: 2000
    });
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('联系人列表')
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

      // 测试控制面板
      Column() {
        Text('菜单操作')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .margin({ bottom: 12 })

        // 测试按钮行
        Row() {
          Button('添加菜单')
            .fontSize(12)
            .backgroundColor('#4CAF50')
            .fontColor('#FFFFFF')
            .borderRadius(6)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .onClick(() => {
              this.addMenuItem();
            })

          Button('删除菜单')
            .fontSize(12)
            .backgroundColor('#FF9800')
            .fontColor('#FFFFFF')
            .borderRadius(6)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .margin({ left: 8 })
            .onClick(() => {
              this.removeMenuItem();
            })

          Button('修改菜单')
            .fontSize(12)
            .backgroundColor('#9C27B0')
            .fontColor('#FFFFFF')
            .borderRadius(6)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .margin({ left: 8 })
            .onClick(() => {
              this.modifyMenuItem();
            })

          Button('重置')
            .fontSize(12)
            .backgroundColor('#607D8B')
            .fontColor('#FFFFFF')
            .borderRadius(6)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .margin({ left: 8 })
            .onClick(() => {
              this.resetMenuStates();
            })


        }
        .width('100%')
        .justifyContent(FlexAlign.Start)


      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .margin({ bottom: 8 })


      // 联系人列表
      SwipeMenuList({
        data: this.contactList,
        menuCreator: this.normalMenuCreator,
        touchConfig: this.touchConfig,
        openAnimationConfig: this.openAnimationConfig,
        closeAnimationConfig: this.closeAnimationConfig,
        swipeDirection: SwipeDirection.DIRECTION_LEFT,
        getSwipeEnabled: this.getSwipeEnabled, // 控制滑动能力
        itemBuilder: (item: Object, index: number): void => {
          this.ContactItemBuilder(item as ContactInfo, index);
        },
        keyGenerator: (item: Object) => {
          const contact = item as ContactInfo;
          // 使用id + timestamp确保key值在数据更新时会变化
          return contact.id + '_' + (contact._updateTimestamp || 0);
        },
        onMenuItemClick: this.menuClickHandler,
        
        // 滑动事件监听
        onSwipeListener: this.swipeListener,
        
        // 菜单状态监听
        onMenuStateChangeListener: this.menuStateChangeListener,

        // 长按事件监听
        onItemLongPress: this.longPressListener,
        
        // 动画状态监听
        onAnimationStateChangeListener: this.animationStateChangeListener
      })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F0F0F0')
  }

  // 联系人项目构建器
  @Builder
  ContactItemBuilder(contact: ContactInfo, _index: number) {
    Row() {
      Image(contact.avatar)
        .width(50)
        .height(50)
        .borderRadius(25)
        .border({ width: 2, color: contact.isOnline ? '#4CAF50' : '#E0E0E0' })
        .onClick(() => {
          // 头像专属点击事件
          if (contact.isOnline) {
            promptAction.showToast({
              message: `查看 ${contact.name} 的头像`,
              duration: 1500
            });
          } else {
            promptAction.showToast({
              message: `${contact.name} 离线，无法查看头像`,
              duration: 1500
            });
          }
        })


      Column() {
        Row() {
          Text(contact.name)
            .fontSize(16)
            .fontColor('#212121')
            .fontWeight(FontWeight.Medium)

          if (contact.isVip) {
            Text('VIP')
              .fontSize(10)
              .fontColor('#FFD700')
              .backgroundColor('#FFF8E1')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(8)
              .margin({ left: 8 })
          }

          Blank()

          Text(contact.messageTime)
            .fontSize(12)
            .fontColor('#999999')
        }
        .width('100%')

        Row() {
          Text(contact.phone)
            .fontSize(12)
            .fontColor('#666666')

          Blank()

          Row() {
            Circle({ width: 8, height: 8 })
              .fill(contact.isOnline ? '#4CAF50' : '#E0E0E0')

            Text(contact.isOnline ? '在线' : '离线')
              .fontSize(10)
              .fontColor(contact.isOnline ? '#4CAF50' : '#999999')
              .margin({ left: 4 })
          }
        }
        .width('100%')
        .margin({ top: 4 })

        Row() {
          Text(contact.lastMessage)
            .fontSize(14)
            .fontColor('#757575')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)

          if (!contact.isOnline) {
            Text('不可滑动')
              .fontSize(10)
              .fontColor($r('sys.color.multi_color_10'))
              .backgroundColor('#FFF3E0')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(8)
              .margin({ left: 8 })
          }
        }
        .width('100%')
        .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)
      .onClick(() => {
        if (contact.isOnline) {
          promptAction.showToast({
            message: `查看 ${contact.name} 的详细信息`,
            duration: 1500
          });
        } else {
          promptAction.showToast({
            message: `${contact.name} 离线中，无法查看详情`,
            duration: 1500
          });
        }
      })
    }
    .width('100%')
    .padding(16)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .opacity(contact.isOnline ? 1.0 : 0.6)
  }
}