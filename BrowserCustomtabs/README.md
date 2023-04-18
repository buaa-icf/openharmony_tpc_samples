# BrowserCustomtabs

## 简介
CustomTabs在用户的默认浏览器中显示网页，相当于在自己的app中用默认浏览器打开网页，效果类似WebView,
但使用起来比WebView轻量，也更安全，性能更好。并且可以定制浏览器导航栏的样式。
该库暂时无法使用，只是定义了接口和使用方法。


## 使用说明
- 步骤一

将源码下载下来，把library模块引入到自己的项目中

在entry的package.json做如下配置

```
  "dependencies": {
    "@ohos/browser_customtabs": "file:../browser_customtabs"
  }
```

 - 步骤二

 ```
 import { CustomTabsIntent, CustomTabColorSchemeParams } from '@ohos/browser_customtabs';
 let schemeParams = new CustomTabColorSchemeParams.Builder()
      .setToobarColor(0xff0000)
      .setNavigationBarColor(0x00ff00)
      .setNavigationBarColor(0x0000ff)
      .setSecondaryToolbarColor(0xffff00)
      .building();
    let customTabsIntent = new CustomTabsIntent.Builder()
      .setDefaultColorSchemeParams(schemeParams)
      .setActionButton(media, 'action-button', remoteObject)
      .setCloseButtonIcon(media)
      .setShareState(true)
      .setUrlBarHidingEnabled(false)
      .setShowTitle(true)
      .addMenuItem('menu-item', remoteObject)
      .addToobarItem(0, media, 'toolbar-item', remoteObject)
      .building();
```
  
## 接口使用说明

接口定义：

| 方法名                              | 接口描述                       |
|------------------------------------|-------------------------------|
| constructor(toolbarColor: number, secondaryToolbarColor: number, navigationBarColor: number, navigationBarDividerColor: number) | 构造函数 |
| setToobarColor(color: number)：Builder | 修改导航栏的颜色              |
| setSecondaryToolbarColor(color: number)：Builder | 设置二 Toolbar的颜色 |
| setNavigationBarColor(color: number)：Builder |  设置虚拟导航栏上面分割线的颜色 |
| building(): CustomTabColorSchemeParams：Builder | 创建CustomTabColorSchemeParams对象 |
| toWangParameters(): any            |  返回参数对象                    |
| withDefaults(defaults: CustomTabColorSchemeParams): CustomTabColorSchemeParams | 设置默认的颜色参数 |
| launchUrl(ability: Ability, url: string)  | 打开网页                 |
| static getMaxToolbarItems(): number | 返回Toolbar的item的最大限制数    |
| setUrlBarHidingEnabled(enabled: boolean):Builder | 设置是否显示网页加载的进度条 |
| enableUrlBarHiding():Builder        | 隐藏网页加载的进度条             |
| setCloseButtonIcon(icon: Uint8Array)：Builder | 设置关闭页面的按钮     |
| setShowTitle(showTitle: boolean)：Builder | 设置是否显示分享按钮     |
| addMenuItem(label: string, remoteObject: rpc.RemoteObject) | 添加菜单栏选项图标及点击事件     |
| setShareState(showTitle: boolean)：Builder | 设置是否显示分享按钮     |
| setActionButton(icon: Uint8Array, description: string, remoteObject: rpc.RemoteObject, shouldTint?: boolean)：Builder | 设置ActionButton的图标和点击事件     |
| addToobarItem(id: number, icon: Uint8Array, description: string, remoteObject: rpc.RemoteObject)：Builder | 添加Toolbar的item选项图标及点击事件     |
| building(): CustomTabsIntent | 创建样式     |
| setDefaultColorSchemeParams(params: CustomTabColorSchemeParams)：Builder | 设置导航栏的颜色     |




## 约束与限制
在下述版本验证通过：

DevEco Studio: 3.1Release(3.1.0.200), SDK: API9 Release(3.2.10.6)

## 目录结构

````
|-----BrowserCustomtabs           
|     |-------entry  # 示例代码文件夹 
|          |-----src/main/ets
|               |pages
|                  |---index.ets
|     |---------browser_customtabs
|          |-----src/main/ets/components/MainPage
|                  |---CustomTabColorSchemeParams.ets
|                  |---CustomTabsIntent.ets                 
├── README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/BrowserCustomtabs/LICENSE) ，请自由地享受和参与开源。