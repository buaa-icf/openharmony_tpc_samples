import { NativeInterface, PjsipApp } from 'ohos_pjsip'
import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';
import { CustomXComponentController } from './CustomXComponentController';
import { emitter } from '@kit.BasicServicesKit';
import { promptAction, router, ShowToastOptions } from '@kit.ArkUI';

const permissions: Array<Permissions> =
  ['ohos.permission.CAMERA', 'ohos.permission.INTERNET', 'ohos.permission.MICROPHONE'];

const CALL_DISCONNECTED = 6; //电话挂断状态
const ACC_ID = "sip:1002";
const REGISTRAR = "sip:47.96.177.62:5060"; //服务器ip地址
const USER_NAME = "1002";
const PASSWORD = "1002";

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  pjsip: PjsipApp = new PjsipApp();
  @State showCallState: Visibility = Visibility.Hidden;
  @State showColumn: Visibility = Visibility.Visible;
  @State textStatus: string = "";
  @State sipAccount: string = ACC_ID;
  @State sipAddress: string = REGISTRAR;
  @State sipName: string = USER_NAME;
  @State sipPwd: string = PASSWORD;
  @State sipTargetAcc: string = "sip:1006@47.96.177.62:5060";
  @State statusInitColor: Color = Color.Red;
  @State statusLoginColor: Color = Color.Blue;
  @State isShowButton: boolean = false;

  build() {
    RelativeContainer() {
      Stack() {
        Column() {
          Text(this.textStatus).margin({ bottom: 20, top: 20 }).fontColor(this.statusInitColor)
          Row() {
            Text("SIP账号：")
            TextInput({
              placeholder: "请输入账号",
              text: this.sipAccount
            }).layoutWeight(1).onChange((changeText) => {
              this.sipAccount = changeText;
              this.isShowButton = this.isShowModifyButton();
            })
          }

          Row() {
            Text("服务器地址：")
            TextInput({
              placeholder: "请输入地址",
              text: this.sipAddress
            }).layoutWeight(1).onChange((changeText) => {
              this.sipAddress = changeText;
              this.isShowButton = this.isShowModifyButton();
            })
          }.margin({ top: 10 })

          Row() {
            Text("登录名：")
            TextInput({
              placeholder: "请输入登录名",
              text: this.sipName
            }).layoutWeight(1).onChange((changeText) => {
              this.sipName = changeText;
              this.isShowButton = this.isShowModifyButton();
            })
          }.margin({ top: 10 })

          Row() {
            Text("密码：")
            TextInput({
              placeholder: "请输入密码",
              text: this.sipPwd
            }).layoutWeight(1).onChange((changeText) => {
              this.sipPwd = changeText;
              this.isShowButton = this.isShowModifyButton();
            })
          }.margin({ top: 10 })

          Button(this.statusLoginColor === Color.Green ? "登录成功" :
            this.statusLoginColor === Color.Gray ? "登录失败" : "登录")
            .width(240)
            .onClick((e) => {
              //编辑账号:
              let resultCode = this.pjsip.modifyAccount(this.sipAccount, this.sipAddress, this.sipName, this.sipPwd);
              this.statusLoginColor = resultCode === 0 ? Color.Green : Color.Gray;
            })
            .margin({ top: 20 })
            .visibility(this.isShowButton ? Visibility.Visible : Visibility.None)
            .backgroundColor(this.statusLoginColor)

          Row() {
            Text("对方sip：")
            TextInput({
              placeholder: "请输入sip账号",
              text: this.sipTargetAcc
            }).layoutWeight(1).onChange((changeText) => {
              this.sipTargetAcc = changeText;
            })
            Button("拨打").onClick((e) => {
              if (this.statusLoginColor !== Color.Green) {
                let msg: ShowToastOptions = {
                  message: "未登录账号"
                }
                promptAction.showToast(msg);
                return;
              }
              this.pjsip.makeCall(this.sipTargetAcc);
              router.push({
                url: "pages/VideoPage"
              })
            })
          }.margin({ top: 50 })

        }.width("90%").margin({ left: 20, right: 20 })
      }
      .alignContent(Alignment.TopStart)
      .visibility(this.showColumn)
      .width('100%')
      .height('100%')
    }
    .height('100%')
    .width('100%')

  }

  aboutToAppear() {
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    this.reqPermissionsFromUser(permissions, context);
    emitter.on("surfaceId", (e) => {
      let surfaceID: string = e.data ? e.data.id : "";
      if (surfaceID) {
        this.pjsip.setSurfaceId(surfaceID);
      }
    })
    emitter.on("acceptCall", (e) => {
      this.pjsip.acceptCall();
    })
    emitter.on("handUpCall", (e) => {
      this.pjsip.handUpCall();
    })
  }


   checkAccessToken(permission: Permissions): abilityAccessCtrl.GrantStatus {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    let grantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
    let tokenId: number = 0
    try {
      let bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoForSelfSync(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
      )
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo
      tokenId = appInfo.accessTokenId
    } catch (error) {
      console.error("failed to get tokenId ,message = " + JSON.stringify(error))
    }
    try {
      grantStatus = atManager.checkAccessTokenSync(tokenId, permission)
    } catch (error) {
      console.error( "error = " + JSON.stringify(error))
    }
    return grantStatus
  }



  async reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext) {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let isPermission = false;
    for (let index = 0; index < permissions.length; index++) {
      const per = permissions[index];
      isPermission = this.checkAccessToken(per) === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
    }
    if (!isPermission) {
      let result = await atManager.requestPermissionsFromUser(context, permissions);
      let grantStatus: Array<number> = result.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          isPermission = true;
        } else {
          isPermission = false;
        }
      }
    }
    if (isPermission) {
      let resultCode = this.pjsip.init();
      //注册来电回调：
      this.pjsip.addInCallingListener(() => {
        router.pushUrl({
          url: "pages/VideoPage"
        })
      })
      this.pjsip.addInCallStateListener((callStatus: number) => {
        if (callStatus === CALL_DISCONNECTED) {
          emitter.emit("closeVideo")
        }
      })
      if (resultCode === 0) {
        this.statusInitColor = Color.Green
        this.textStatus = "pjsip 初始化成功"
      } else {
        this.statusInitColor = Color.Red
        this.textStatus = "pjsip 初始化失败"
      }
    } else {
      this.statusInitColor = Color.Red
      this.textStatus = "pjsip 初始化失败，请授予相关权限"
    }
    this.isShowButton = this.isShowModifyButton();
  }

  /*
   判断账号，地址，用户名，密码输入的是否为空
   */
  isShowModifyButton(): boolean {
    return this.sipAccount.trim() !== "" &&
      this.sipAddress.trim() !== "" &&
      this.sipName.trim() !== "" &&
      this.sipPwd.trim() !== "" &&
      this.statusInitColor === Color.Green;
  }

  aboutToDisappear(): void {
    emitter.off("surfaceId");
    emitter.off("acceptCall");
    emitter.off("handUpCall");
    this.pjsip.destroy();
  }
}