/**
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { Toolbar } from '../../base/toolbar'
import router from '@ohos.router';
import prompt from '@ohos.prompt';
import { Switches } from '../../base/Switches';
import { ItemInput } from '../../base/ItemInput';
import { RoomConfig } from '@ohos/smack'
import { SelectDialog } from '../../base/SelectDialog'
import { Smack } from '@ohos/smack'
import { SelectOptionsEntity } from '../../../entity/SelectOptionsEntity';
import { GlobalContext } from '../../../entity/GlobalContext';

@Entry
@Component
struct Group_chat_edit {
  private passwordprotectedroom: string = ''
  @State temp: string = ''
  @State JidVal: string = getContext().resourceManager.getStringByNameSync('GroupChat_String1')
  @State PrivateVal: string = getContext().resourceManager.getStringByNameSync('GroupChat_String1')
  @State roomName: string = ''
  @State roomDesc: string = ''
  @State roomMaxusers: string = ''
  @State roomPassword: string = ''
  @State roomAdmins: string = ''
  @State roomOwners: string = ''
  @State roomPresencebroadcast: Array<string> = []
  @State whois_options: Array<SelectOptionsEntity> = [
    {
      "label": getContext().resourceManager.getStringByNameSync('GroupChat_String1'),
      "value": "anyone"
    },
    {
      "label": getContext().resourceManager.getStringByNameSync('GroupChat_String2'),
      "value": "moderators"
    }
  ]
  @State allowpm_options: Array<SelectOptionsEntity> = [
    {
      "label": getContext().resourceManager.getStringByNameSync('GroupChat_String1'),
      "value": "anyone"
    },
    {
      "label": getContext().resourceManager.getStringByNameSync('GroupChat_String3'),
      "value": "participants"
    },
    {
      "label": getContext().resourceManager.getStringByNameSync('GroupChat_String2'),
      "value": "moderators"
    },
    {
      "label": "None",
      "value": "none"
    }
  ]
  public roomConfig: RoomConfig =new RoomConfig();
  scroller: Scroller = new Scroller()
  allowpm_selectDialog: CustomDialogController = new CustomDialogController({
    builder: SelectDialog({
      vue: $PrivateVal,
      options: this.allowpm_options
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
  })
  whois_selectDialog: CustomDialogController = new CustomDialogController({
    builder: SelectDialog({
      vue: $JidVal,
      options: this.whois_options,
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
  })

  aboutToAppear() {
    this.getRoomConfig()
  }

  switchAllowpm(str: string) {
    switch (str) {
      case "anyone":
        this.PrivateVal = getContext().resourceManager.getStringByNameSync('GroupChat_String1')
        break
      case "participants":
        this.PrivateVal = getContext().resourceManager.getStringByNameSync('GroupChat_String3')
        break
      case "moderators":
        this.PrivateVal = getContext().resourceManager.getStringByNameSync('GroupChat_String2')
        break
      case "none":
        this.PrivateVal = "None"
        break
    }
  }

  switchAllowpmStr(str: string): string{
    let val = 'anyone'
    switch (str) {
      case getContext().resourceManager.getStringByNameSync('GroupChat_String1'):
        val = "anyone"
        break
      case getContext().resourceManager.getStringByNameSync('GroupChat_String3'):
        val = "participants"
        break
      case getContext().resourceManager.getStringByNameSync('GroupChat_String2'):
        val = "moderators"
        break
      case "None":
        val = "none"
        break
    }
    return val
  }

  public getRoomConfig() {
    Smack.getRoomConfig((result: string) => {
      this.roomConfig= JSON.parse(result) as RoomConfig;
      this.JidVal = this.roomConfig.whois == "anyone" ? getContext().resourceManager.getStringByNameSync('GroupChat_String1') : getContext().resourceManager.getStringByNameSync('GroupChat_String2')
      this.switchAllowpm(this.roomConfig.allowpm)
      this.roomName = this.roomConfig.roomname
      this.roomDesc = this.roomConfig.roomdesc
      this.roomMaxusers = this.roomConfig.maxusers
      this.roomPassword = this.roomConfig.roomsecret?this.roomConfig.roomsecret:""
      this.passwordprotectedroom = this.roomConfig.passwordprotectedroom
      console.info('passwordprotectedroom-----------//' + this.passwordprotectedroom)
      this.roomAdmins = this.roomConfig.roomadmins
      this.roomOwners = this.roomConfig.roomowners
      this.roomPresencebroadcast = this.roomConfig.presencebroadcast
      console.info('Checkbox-----------//' + JSON.stringify(this.roomPresencebroadcast))
      console.info('roomConfig-----------//' + JSON.stringify(this.roomConfig))
    });
  }

  //todo 修改房间配置
  updateRoomConfig() {
    this.roomConfig.allowpm = this.switchAllowpmStr(this.PrivateVal)
    this.roomConfig.whois = (this.JidVal == getContext().resourceManager.getStringByNameSync('GroupChat_String1')) ? "anyone" : "moderators"
    this.roomConfig.roomname = this.roomName
    this.roomConfig.roomdesc = this.roomDesc
    this.roomConfig.maxusers = this.roomMaxusers
    this.roomConfig.roomsecret = this.roomPassword
    this.roomConfig.roomadmins = this.roomAdmins
    this.roomConfig.roomowners = this.roomOwners
    this.roomConfig.presencebroadcast = this.roomPresencebroadcast
    this.roomConfig.passwordprotectedroom = this.roomPassword ? '1' : '0'
    console.info('update roomConfig roomPassword-----------//' + this.roomPassword+',passwordprotectedroom:'+this.roomConfig.passwordprotectedroom+',,')

    console.info('update roomConfig-----------//' + JSON.stringify(this.roomConfig))
    Smack.setRoomConfig(JSON.stringify(this.roomConfig))
    prompt.showToast({ message: "update Success" })
    setTimeout(() => {
      router.back()
    }, 500)
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Toolbar({
        isBack: true,
        title: getContext().resourceManager.getStringByNameSync('GroupChat_String4'),
        rightText: getContext().resourceManager.getStringByNameSync('GroupChat_String5'),
        rightClickCallBack: () => {
          this.updateRoomConfig()
        }
      })
      Scroll(this.scroller) {
        Column() {
          ItemInput({ title: getContext().resourceManager.getStringByNameSync('GroupChat_String6'), value: $roomName, val: $temp })
          ItemInput({ title: getContext().resourceManager.getStringByNameSync('GroupChat_String7'), value: $roomDesc, val: $temp })
          ItemInput({
            title: getContext().resourceManager.getStringByNameSync('GroupChat_String8'),
            value: $roomMaxusers,
            val: $temp,
            typeStr: "4"
          })
          ItemInput({
            title: getContext().resourceManager.getStringByNameSync('GroupChat_String9'),
            value: $roomPassword,
            typeStr: "2",
            val: $temp
          })
          ItemInput({
            title: getContext().resourceManager.getStringByNameSync('GroupChat_String10'),
            widthStr: '65%',
            widthInput: '30%',
            value: $temp,
            val: $JidVal,
            radio: true,
            selectDialog: () => {
              this.whois_selectDialog.open()
            }
          })
          ItemInput({
            title: "Allowed to Send Private Messages",
            widthStr: '65%',
            widthInput: '30%',
            value: $temp,
            val: $PrivateVal,
            radio: true,
            selectDialog: () => {
              this.allowpm_selectDialog.open()
            }
          })
          ItemInput({
            title: getContext().resourceManager.getStringByNameSync('GroupChat_String11'),
            widthStr: '30%',
            widthInput: '65%',
            value: $roomAdmins,
            val: $temp,
            radio: false,
            selectDialog: () => {
              this.allowpm_selectDialog.open()
            }
          })
          ItemInput({
            title: getContext().resourceManager.getStringByNameSync('GroupChat_String12'),
            widthStr: '30%',
            widthInput: '65%',
            value: $roomOwners,
            val: $temp,
            radio: false,
            selectDialog: () => {
              this.allowpm_selectDialog.open()
            }
          })
          Row() {
            Text(getContext().resourceManager.getStringByNameSync('GroupChat_String13')).width('35%').height('100%').fontSize(18)
            Row() {
              Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
                .select(this.roomPresencebroadcast.indexOf("moderator") == 0)
                .selectedColor(0x39a2db)
                .onChange((value: boolean) => {
                  let that = this
                  console.info('Checkbox1 change is' + value)
                  this.roomPresencebroadcast[0] = (value ? 'moderator' : '')

                })
              Text(getContext().resourceManager.getStringByNameSync('GroupChat_String2')).fontSize(16)
              Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
                .select(this.roomPresencebroadcast.indexOf("participant") == 1)
                .selectedColor(0x39a2db)
                .onChange((value: boolean) => {
                  console.info('Checkbox2 change is' + value)
                  this.roomPresencebroadcast[1] = (value  ? 'participant' : '')
                })
              Text(getContext().resourceManager.getStringByNameSync('GroupChat_String3')).fontSize(16)
              Checkbox({ name: 'checkbox3', group: 'checkboxGroup' })
                .select(this.roomPresencebroadcast.indexOf("visitor") == 2)
                .selectedColor(0x39a2db)
                .onChange((value: boolean) => {
                  console.info('Checkbox3 change is' + value)
                  this.roomPresencebroadcast[2] = (value ? 'visitor' : '')
                })
              Text("Guest").fontSize(16)
            }.width('55%').justifyContent(FlexAlign.End)
          }
          .padding({ left: 15 })
          .height(54)
          .backgroundColor(Color.White)
          .margin({ top: 1 })
          .width('100%')

          Switches({ isOn: this.roomConfig.publicroom, title: getContext().resourceManager.getStringByNameSync('GroupChat_String14'), onToggleChange: (HisOn:string) => {
            this.roomConfig.publicroom = HisOn
          } })
          Switches({ isOn: this.roomConfig.persistentroom, title: getContext().resourceManager.getStringByNameSync('GroupChat_String15'), onToggleChange: (HisOn:string) => {
            this.roomConfig.persistentroom = HisOn
          } })
          Switches({ isOn: this.roomConfig.membersonly, title: getContext().resourceManager.getStringByNameSync('GroupChat_String16'), onToggleChange: (HisOn:string) => {
            this.roomConfig.membersonly = HisOn
          } })
          Switches({ isOn: this.roomConfig.moderatedroom, title: getContext().resourceManager.getStringByNameSync('GroupChat_String17'), onToggleChange: (HisOn:string) => {
            this.roomConfig.moderatedroom = HisOn
          } })
          Switches({ isOn: this.roomConfig.allowinvites, title: getContext().resourceManager.getStringByNameSync('GroupChat_String18'), onToggleChange: (HisOn:string) => {
            this.roomConfig.allowinvites = HisOn
          } })
          Switches({ isOn: this.roomConfig.changesubject, title: getContext().resourceManager.getStringByNameSync('GroupChat_String19'), onToggleChange: (HisOn:string) => {
            this.roomConfig.changesubject = HisOn
          } })
          Switches({ isOn: this.roomConfig.reservednick, title: getContext().resourceManager.getStringByNameSync('GroupChat_String20'), onToggleChange: (HisOn:string) => {
            this.roomConfig.reservednick = HisOn
          } })
          Switches({ isOn: this.roomConfig.canchangenick, title: getContext().resourceManager.getStringByNameSync('GroupChat_String21'), onToggleChange: (HisOn:string) => {
            this.roomConfig.canchangenick = HisOn
          } })
          Switches({ isOn: this.roomConfig.canchangenick, title: getContext().resourceManager.getStringByNameSync('GroupChat_String22'), onToggleChange: (HisOn:string) => {
            this.roomConfig.canchangenick = HisOn
          } })
          Switches({ isOn: this.roomConfig.enablelogging, title: getContext().resourceManager.getStringByNameSync('GroupChat_String23'), onToggleChange: (HisOn:string) => {
            this.roomConfig.enablelogging = HisOn
          } })

        }
      }.scrollable(ScrollDirection.Vertical).scrollBar(BarState.On)

    }
    .width('100%')
    .backgroundColor('#ececec')
  }

  // todo 退出群聊
  onExitGroup() {
    //销毁房间,群主可调用
    Smack.destroy(GlobalContext.getContext().getValue('userName') as string, "123");
  }
}