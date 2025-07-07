# EspBlufiForHarmony

## 简介
本软件是参照开源软件 [EspBlufiForAndroid](https://github.com/EspressifApp/EspBlufiForAndroid) 源码并用 TypeScript 语言实现了相关功能。
这是一个用于控制运行的ESP设备的演示应用程序 [BluFi](https://github.com/espressif/esp-idf/tree/master/examples/bluetooth/blufi)

## 下载安装

- 方式1： 源码引入，在项目根目录的 `build-profile.json5` 添加如下配置,支持加载library源码:
  ```
  "modules": [
    {
      "name": "library",
      "srcPath": "./library",
      "targets": [
        {
          "name": "default",
          "applyToProducts": [
            "default"
          ]
        }
      ]
    }
  ]
   ```

- 方式2:

```shell
ohpm install @ohos/espblufiforharmony

```

OpenHarmony
ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

### 实例化 BlufiClient

```ets
    let client:BlufiClient = new BlufiClient(deviceid);

    // BlufiCallback声明为回调对象，可以用来通知app设备发送的数据。
    let blufiCallback:BlufiCallback = {
        onGattPrepared:Function,
        onError:Function,
     };;
    client.setBlufiCallback(blufiCallback);
    
    // BlufiGattCallback 监听Gatt连接状态与服务发现回调
	 let gattCallback:BlufiGattCallback = {
        onConnectionStateChange:Function,
        onServicesDiscovered:Function,
     };
	 client.setGattCallback(gattCallback);

```

### 设置 Blufi 发送数据时每包数据的最大长度

```ets
    let limit:number = 128; // 设置长度限制，若数据超出限制将进行分包发送
    client.setPostPackageLengthLimit(limit);
    ```

### 与 Device 建立连接

  ```ets
  // client 与设备建立连接，client 将主动扫描 Blufi 的服务和特征
  // 用户在收到 BlufiCallback 回调 onGattPrepared 后才可以与设备发起通信
 client.connect();
 
  ```

### 与 Device 协商数据加密

    ```ets
    client.negotiateSecurity();
    ```

    ```ets
    // 协商结果在 BlufiCallback 回调方法内通知
    public onNegotiateSecurityResult?:(client: BlufiClient, status: number) {
        // status 为 0 表示加密成功，否则为失败
    }
    ```

### 请求获取 Device 版本

    ```ets
    client.requestDeviceVersion();
    ```
    ```ets
    // 设备版本在 BlufiCallback 回调方法内通知
    public onDeviceVersionResponse?:(client: BlufiClient, status: number, response: BlufiVersionResponse) {
        //  status 为 0 表示加密成功，否则为失败

        switch (status) {
            case 0:
                let version:string = response.getVersionString(); // 获得版本号
                break;
            default:
                break;
        }
    }
    ```

### 请求获取 Device 当前扫描到的 Wi-Fi 信号

    ```ets
    client.requestDeviceWifiScan();
    ```

    ```ets
    // 扫描结果在 BlufiCallback 回调方法内通知
    public onDeviceScanResult?:(client: BlufiClient,  status: number, results: Array<BlufiScanResult>) {
        // status 为 0 表示获取数据成功，否则为失败
        
        switch (status) {
            case 0:
                for (BlufiScanResult scanResult : results) {
                    let ssid:string = scanResult.getSsid(); // 获得 Wi-Fi SSID
                    let rssi:number = scanResult.getRssi(); // 获得 Wi-Fi RSSI
                }
                break;
            default:
                break;
        }
    }
    ```

### 发送自定义数据

    ```ets
    let dataAff = buffer.from("Custom Data").buffer;
    let data = new Uint8Array(dataAff);
    client.postCustomData(data);
    ```

    ```ets
    // 自定义数据发送结果在 BlufiCallback 回调方法内通知
    public onPostCustomDataResult?:(client: BlufiClient, status: number, data: Uint8Array) {
        // status 为 0 表示发送成功，否则为发送失败

        // data 为需要发送的自定义数据
    }

    // 收到 Device 端发送的自定义数据
    public onReceiveCustomData?:(client: BlufiClient,status: number, data: Uint8Array) => {
        // status 为 0 表示成功接收
        // data 为收到的数据
    }
    ```

- 请求获取 Device 当前状态

    ```ets
    client.requestDeviceStatus();
    ```

    ```ets
    // Device 状态在 BlufiCallback 回调方法内通知.
      public onDeviceStatusResponse?:(client: BlufiClient, status: number, response: BlufiStatusResponse) => {
        // status 为 0 表示获取状态成功，否则为失败

        switch (status) {
            case 0:
                int opMode = response.getOpMode();
                if (opMode == BlufiParameter.OP_MODE_STA) {
                    // Station mode is currently enabled.
                    let conn:number = response.getStaConnectionStatus(); // 获取 Device 当前连接状态：0 表示有 Wi-Fi 连接，否则没有 Wi-Fi 连接
                    let ssid:string = response.getStaSSID(); // 获取 Device 当前连接的 Wi-Fi 的 SSID
                    let bssid:string = response.getStaBSSID(); // 获取 Device 当前连接的 Wi-Fi 的 BSSID
                    let password:string = response.getStaPassword(); // 获取 Device 当前连接的 Wi-Fi 密码
                } else if (opMode == BlufiParameter.OP_MODE_SOFTAP) {
                    // 当前为 SoftAP 模式
                    let ssid:string = response.getSoftAPSSID(); // 获取 Device 的 SSID
                    let channel:number = response.getSoftAPChannel(); // 获取 Device 的信道
                    let security:number = response.getSoftAPSecurity(); // 获取 Device 的加密方式：0 为不加密，2 为 WPA，3 为 WPA2，4 为 WPA/WPA2
                    let connMaxCount:number = response.getSoftAPMaxConnectionCount(); // 最多可连接的 Device 个数
                    let connCount:number = response.getSoftAPConnectionCount(); // 当前已连接 的 Device 个数
                } else if (opMode == BlufiParameter.OP_MODE_STASOFTAP) {
                    // 当前为 Station 和 SoftAP 共存模式
                    // 获取状态方法同 Station 模式和 SoftAP 模式
                }
                break;
            default:
                break;
        }
    }
    ```

### 对 Device 进行配网

    ```ets
    let params = new BlufiConfigureParams();
    int opMode = // 设置需要配置的模式：1 为 Station 模式，2 为 SoftAP 模式，3 为 Station 和 SoftAP 共存模式
    params.setOpMode(deviceMode);
    if (opMode == BlufiParameter.OP_MODE_STA) {
        // 设置 Station 配置信息
        params.setStaSSID(ssid); // 设置 Wi-Fi SSID
        params.setStaPassword(password); // 设置 Wi-Fi 密码，若是开放 Wi-Fi 则不设或设空
        // 注意: Device 不支持连接 5G Wi-Fi，建议提前检查一下是不是 5G Wi-Fi
    } else if (opMode == BlufiParameter.OP_MODE_SOFTAP) {
        // 设置 SoftAP 配置信息
        params.setSoftAPSSID(ssid); // 设置 Device 的 SSID
        params.setSoftAPSecurity(security); // 设置 Device 的加密方式：0 为不加密，2 为 WPA，3 为 WPA2，4 为 WPA/WPA2
        params.setSoftAPPAssword(password); // 若 Security 非 0 则必须设置 
        params.setSoftAPChannel(channel); // 设置 Device 的信道
        params.setSoftAPMaxConnection(maxConnection); // 设置可连接 Device 的最大个数

    } else if (opMode == BlufiParameter.OP_MODE_STASOFTAP) {
        // 同上两个
    }

    client.configure(params);
    ```

    ```ets
    // 设置信息发送结果在 BlufiCallback 回调方法内通知
      public onPostConfigureParams?:(client: BlufiClient, status: number)=>void;


    // 配置后的状态变化回调
      public onDeviceStatusResponse?:(client: BlufiClient, status: number, response: BlufiStatusResponse) => void;

    ```

### 请求 Device 断开 BLE 连接

    ```ets
    // Device 端无法获知 app 端已主动断开连接, 此时会导致 app 后续无法重新连上设备

    client.requestCloseConnection();
    ```

### 关闭 BlufiClient

    ```ets
    //  释放资源
    client.close();
    ```

### BlufiCallback 说明

```ets
// 当扫描 Gatt 服务结束后调用该方法
// service, writeChar, notifyChar 中有 null 的时候表示扫描失败
  public onGattPrepared:(client: BlufiClient, device:ble.GattClientDevice,service: ble.GattService, writeChar: ble.BLECharacteristic, notifyChar: ble.BLECharacteristic) => void;


// 收到 Device 的通知数据
// 返回 false 表示处理尚未结束，交给 BlufiClient 继续后续处理
// 返回 true 表示处理结束，后续将不再解析该数据，也不会调用回调方法
  public onGattNotification?:(client: BlufiClient, pkgType: number, subType: number, data: Uint8Array) => boolean;


// 收到 Device 发出的错误代码
  public onError:(client: BlufiClient, errCode: number) => void;


// 与 Device 协商加密的结果
  public onNegotiateSecurityResult?:(client: BlufiClient, status: number) => void;


// 发送配置信息的结果
  public onConfigureResult?:(client: BlufiClient, status: number) => void;


// 收到 Device 的版本信息
  public onPostConfigureParams?:(client: BlufiClient, status: number)=>void;


// 收到 Device 的状态信息
  public onDeviceStatusResponse?:(client: BlufiClient, status: number, response: BlufiStatusResponse) => void;


// 收到 Device 扫描到的 Wi-Fi 信息
  public onDeviceScanResult?:(client: BlufiClient,  status: number, results: Array<BlufiScanResult>) => void;


// 发送自定义数据的结果
  public onPostCustomDataResult?:(client: BlufiClient, status: number, data: Uint8Array) => void;


// 收到 Device 的自定义信息
  public onReceiveCustomData?:(client: BlufiClient,status: number, data: Uint8Array) => void;

```

## 接口说明

| Name                 | Parameter                                                        | Return Value                     | Description                                                        |
| ----------------------- | ------------------------------------------------------------ | --------------------------- | ------------------------------------------------------------ |
| setBlufiCallback          |  BlufiCallback   |  void | BlufiCallback声明为回调对象，可以用来通知app设备发送的数据         |
| setGattCallback           |  BlufiGattCallback   |  void | BlufiGattCallback 监听Gatt连接状态与服务发现回调 callback. |
| setPostPackageLengthLimit |  lengthLimit: number  |   void  | 设置长度限制，若数据超出限制将进行分包发送.                        |
| connect                   |   void |   void | client 与设备建立连接，client 将主动扫描 Blufi 的服务和特征.     |
| negotiateSecurity         |   void |   void | 与 Device 协商数据加密                               |
| requestDeviceVersion      |   void |   void | 请求获取 Device 版本                                |
| requestDeviceWifiScan     |   void |   void | 请求获取 Device 当前扫描到的 Wi-Fi 信号result             |
| postCustomData            |   data: Uint8Array |   void | 发送自定义数据                                       |
| requestDeviceStatus       |   void |   void | 请求获取 Device 当前状态                              |
| configure                 |   params: BlufiConfigureParams |   void | 对 Device 进行配网                                 |
| requestCloseConnection    |   void |   void | 请求 Device 断开 BLE 连接                           |
| close                     |   void |   void | 关闭 BlufiClient                                |

## 约束与限制

### 兼容性

在下述版本验证通过：

- DevEco Studio: NEXT Beta1（5.0.3.810） SDK: API 12 (5.0.0.68)


### 应用权限申请

#### 在 entry 目录下的module.json5中添加权限

在 `YourProject/entry/src/main/module.json5`补上配置

```diff
{
  "module": {
    "name": "entry",
    "type": "entry",

  ···

    "requestPermissions": [
+     { "name": "ohos.permission.GET_WIFI_INFO" },
+     {
+       "name": "ohos.permission.USE_BLUETOOTH",
+       "reason": "$string:Access_bluetooth",
+       "usedScene": {"when": "inuse"}
+     },
+     { "name": "ohos.permission.ACCESS_BLUETOOTH"，
+       "reason": "$string:Access_bluetooth", 
+       "usedScene": {
+          "when": "always"
+        }
+     }
    ]
  }
}
```

在 `YourProject/entry/src/main/resources/base/element/string.json`补上配置

#### 在 entry 目录下添加申请权限的原因

打开 `entry/src/main/resources/base/element/string.json`，添加：

```diff
...
{
  "string": [
+    {
+      "name": "Access_bluetooth",
+      "value": "access bluetooth"
+    }
  ]
}
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)
,当然，也非常欢迎发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## 开源协议

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/EspBlufiForHarmony/LICENSE).

