/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import promptAction from '@ohos.promptAction'
import Imap, { inspect } from '@ohos/node-imap'
import router from '@ohos.router'
import StatusBean from '../bean/StatusBean'
import MsgListBean, { MsgListFootBean, MsgListHeadBean } from '../bean/MsgListBean'
import { Buffer } from '@ohos/node-imap/src/main/polyfill/buffer'
import buffer from '@ohos.buffer'
import MsgListUtil, { SortCriteria } from '../MsgListUtil'
import Box from '../bean/Box'
import GlobalObj from '../GlobalObj'
import DetailCallback from '../bean/DetailCallback'
import { ImapMessageAttributes } from '../bean/ImapMessage'
import MsgSendBean from '../bean/MsgSendBean'
import AppendOptions from '../bean/AppendOptions'

const searchCommand = ['ALL', 'ANSWERED', 'DELETED', 'DRAFT',
  'FLAGGED', 'NEW', 'SEEN', 'RECENT',
  'OLD', 'UNANSWERED', 'UNDELETED', 'UNDRAFT',
  'UNFLAGGED', 'UNSEEN', 'BCC', 'BODY',
  'CC', 'FROM', 'SUBJECT', 'TEXT',
  'TO', 'BEFORE', 'ON', 'SENTBEFORE',
  'SENTON', 'SENTSINCE', 'SINCE', 'KEYWORD',
  'UNKEYWORD', 'LARGER', 'SMALLER', 'HEADER',
  'UID', 'X-GM-MSGID', 'X-GM-THRID', 'X-GM-RAW',
  'X-GM-LABELS', 'MODSEQ']

const sortCommand = ['ARRIVAL', 'CC', 'DATE', 'FROM',
  'SIZE', 'SUBJECT', 'TO']

@CustomDialog
struct CustomDialogDiy {
  @Link textValue: string
  @Link inputValue: string
  controller: CustomDialogController
  cancel: Function = () => {
  };
  confirm: Function = () => {
  };

  build() {
    Column() {
      Text($r('app.string.Please_enter_email_type')).fontSize(20).margin({ top: 10, bottom: 10 }).width('90%')
      TextInput({ placeholder: '', text: this.textValue }).height(60).width('90%')
        .onChange((value: string) => {
          this.textValue = value;
        })
      Text($r('app.string.Please_enter_the_folder_name_in_the_correct_format'))
        .margin({ top: 10, bottom: 10 })
        .width('90%')
        .fontSize(8)
        .fontColor(Color.Red)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.Cancel'))
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
        Button($r('app.string.Confirm'))
          .onClick(() => {
            this.inputValue = this.textValue
            this.controller.close()
            this.confirm()
          })

      }

    }
  }
}


@Entry
@Component
struct MsgListPage {
  @State message: string = 'Hello World'
  @State folderName: string = 'INDEX'
  @State startIndex: number = 1 //当前页
  @State endIndex: number = 10 //当前页
  @State searchType: string = ''
  @State textValue: string = ''
  @State selectList: Array<SelectOption> = [] //可选择的邮箱列表
  @State uidList: Array<string> = [] //邮件uid列表
  @State selectIndex: number = -1 //当前选中的邮箱序号
  @State selectSortIndex: number = 0 //当前选中的邮箱序号
  @State selectFolder: string = '' //当前选中的邮箱名字
  @State selectSort: SortCriteria = 'DATE' //当前选中的排序规则
  @State inputValue: string = 'click me'
  @State listData: Array<MsgListBean> = [] //邮件列表数据集合
  @State selectMsg: number = -1 //选择的邮件列表 用于添加已读或者删除的标记
  @State bean: Box | null = null //获取邮件列表之前先获取该文件夹里面的邮件总数和状态
  private selectMenuList: SortCriteria[] = [];
  private selectMenuArr: Array<SelectOption> = [];
  pageSize: number = 10 //请求时的每页多少条信息，用于分页请求
  private util: MsgListUtil = new MsgListUtil()
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogDiy({
      cancel: () => {
        this.showToast(this.getResourceString('Closed_the_dialog_box'), 'imap-search')
      },
      confirm: () => {
        if (!this.inputValue || this.inputValue.length < 1) {
          this.showToast(this.getResourceString('The_search_content_cannot_be_empty'), 'imap-search')
          return
        }
        this.search()
      },
      textValue: $textValue,
      inputValue: $inputValue
    }),
    autoCancel: true,
    customStyle: false
  })

  showToast(text: string, name = '测试') {
    console.log(`zdy---${name}--->${text}`)
    promptAction.showToast({
      message: text,
      duration: 2000,
      bottom: 50
    })
  }

  @Builder
  MailMenu() {
    Menu() {
      MenuItem({ content: '所有', labelInfo: 'ALL' })
        .onChange((selected) => {
          if (selected) {
            this.searchType = 'ALL'
            this.search()
          }
        })

      MenuItem({ content: '新消息', labelInfo: 'NEW' })
        .onChange((selected) => {
          if (selected) {
            this.searchType = 'NEW'
            this.search()
          }
        })

      MenuItem({ content: '最近消息', labelInfo: 'RECENT' })
        .onChange((selected) => {
          if (selected) {
            this.searchType = 'RECENT'
            this.search()
          }
        })
      MenuItem({ content: '草稿', labelInfo: 'DRAFT' })
        .onChange((selected) => {
          if (selected) {
            this.searchType = 'DRAFT'
            this.search()
          }
        })

    }
  }

  refreshPageSize() {
    const ctx = this;
    if (ctx.startIndex >= (ctx.bean?.messages?.total ? ctx.bean?.messages?.total : 0)) {
      return;
    }
    ctx.endIndex = ctx.startIndex + ctx.pageSize - 1;
    if (ctx.endIndex > (ctx.bean?.messages?.total ? ctx.bean?.messages?.total : 0)) {
      ctx.endIndex = (ctx.bean?.messages?.total ? ctx.bean?.messages?.total : 0);
    }
  }

  aboutToAppear() {
    const ctx = this;
    ctx.selectMenuList.push("ARRIVAL")
    ctx.selectMenuList.push("-ARRIVAL")
    ctx.selectMenuList.push("CC")
    ctx.selectMenuList.push("-CC")
    ctx.selectMenuList.push("DATE")
    ctx.selectMenuList.push("-DATE")
    ctx.selectMenuList.push("FROM")
    ctx.selectMenuList.push("-FROM")
    ctx.selectMenuList.push("SIZE")
    ctx.selectMenuList.push("-SIZE")
    ctx.selectMenuList.push("SUBJECT")
    ctx.selectMenuList.push("-SUBJECT")
    ctx.selectMenuList.push("TO")
    ctx.selectMenuList.push("-TO")

    for (let i = 0; i < ctx.selectMenuList.length; i++) {
      let obj: SelectOption = {
        value: ctx.selectMenuList[i].toString(),
        icon: "app.media.app_icon"
      }
      ctx.selectMenuArr.push(obj)
    }

    if (!GlobalObj?.getInstance()?.getClient()) {
      this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'MsgList-imap')
      router.back()
      return
    }
    let tempParam = router.getParams() as Record<string, string | Array<string>>
    if (tempParam && tempParam['folderName'] && (tempParam['folderName'] as string).length > 0) {
      ctx.folderName = tempParam['folderName'] as string
    } else {
      this.showToast(this.getResourceString('Email_folder_parameters_not_obtained'), 'MsgList-imap')
      router.back()
      return
    }

    if (tempParam && tempParam['folderList']) {
      let folderList: Array<string> = tempParam['folderList'] as Array<string>
      if (folderList) {
        for (let i = 0; i < folderList.length; i++) {
          ctx.selectList.push({
            value: folderList[i],
            icon: this.getResourceString('app.media.icon')
          })
          if (ctx.folderName === folderList[i]) {
            ctx.selectIndex = i;
          }
        }
      }
    } else {
      this.showToast(this.getResourceString('Email_folder_parameters_not_obtained'), 'MsgList-imap')
      router.back()
      return
    }
    GlobalObj?.getInstance()?.getClient()?.status(ctx.folderName, (err: Error, data: Box) => {
      if (err) throw err;
      if (!data || (data?.messages?.total ? data?.messages?.total : 0) < 1) {
        throw new Error('get box status fail')
      }
      try {
        if ((data?.messages?.total ? data?.messages?.total : 0) > 0) {
          GlobalObj?.getInstance()?.getClient()?.openBox(ctx.folderName, true, (err: Error, data: Box) => {
            if (err) throw err;
            ctx.getListData()
          });
        } else {
          ctx.showToast(`文件夹：${ctx.folderName}中，有信息总共：${ctx?.bean?.messages?.total},新消息:${ctx?.bean?.messages?.new},未读消息:${ctx?.bean?.messages?.unseen}`)
          ctx.listData = []
          let emptyBean = new MsgListBean()
          emptyBean.Subject = `文件夹：${ctx.folderName}中，有信息总共：${ctx?.bean?.messages?.total},新消息:${ctx?.bean?.messages?.new},未读消息:${ctx?.bean?.messages?.unseen}`
          ctx.listData.push(emptyBean)
        }

      } catch (err) {
        throw err as Error
      }
    })
  }

  aboutToDisappear() {
    this.dialogController = null;
    GlobalObj?.getInstance()?.getClient()?.end()
  }

  getListData() {
    const ctx = this;
    ctx.refreshPageSize();
    ctx.uidList = [];
    ctx.listData = [];
    ctx.selectFolder = '';
    ctx.searchType = '';
    ctx.selectMsg = -1;
    // fetch里面可以是fetch(`1:3`）这种取序号为1-3的信息的  也可以是可以是fetch(`1`）这种取序号为1的信息
    let prefix: string = ''
    let buffer: string = '';
    let callback: DetailCallback = {
      messageStartCallback: (seqno: number) => {
        console.log('Message #%d', seqno);
        prefix = '(#' + seqno + ') ';
      },
      bodyStartCallback: () => {
      },
      bodyDataCallback: (data: string) => {
        buffer += data;
      },
      bodyEndCallback: () => {
        try {
          ctx.showToast(this.getResourceString('Successfully_obtained_the_entire_email_body') + `：${'\r\n'}${buffer}`, 'MsgDetail-imap');
          if (buffer.length > 65535) {
            ctx.message = this.getResourceString('Successfully_obtained') + `：${'\r\n'}${buffer.substring(0, 65535)}`
          } else {
            ctx.message = this.getResourceString('Successfully_obtained_the_entire_email_body') + `：${'\r\n'}${buffer}`
          }

        } catch (err) {
          throw err as Error
        }
      },
      attributesCallback: (attrs: ImapMessageAttributes) => {
        if (attrs && attrs.uid) {
          ctx.uidList.push(attrs.uid + "");
        }
      },
      messageEndCallback: () => {
        console.log(prefix + 'Finished');
      },
      fetchErrorCallback: (err: Error) => {
        console.log('Fetch error: ' + err);
      },
      fetchEndCallback: () => {
        console.log('Done fetching all messages!');
        try {
          if (ctx.listData.length > 0) {
            ctx.listData.pop()
          }
          if (ctx.listData.length == 0) {
            ctx.listData.push(new MsgListHeadBean())
          }
          let jsonObj = buffer.split('\r\n\r\n')
          if (!jsonObj) {
            throw new Error('get message list fail')
          }
          for (let i = 0; i < jsonObj.length; i++) {
            let childArr = jsonObj[i].split('\r\n')
            let bean = new MsgListBean();
            if (i < ctx.uidList.length) {
              bean.uid = ctx.uidList[i];
            }
            for (let j = 0; j < childArr.length; j++) {
              let child = childArr[j];
              if (child && child.indexOf('Date') != -1) {
                bean.Date = child;
              } else if (child && child.indexOf('From') != -1) {
                bean.From = child;
              } else if (child && child.indexOf('To') != -1) {
                bean.To = child;
              } else if (child && child.indexOf('Subject') != -1) {
                bean.Subject = child;
              } else {
                continue;
              }
            }
            ctx.listData.push(bean)
          }
          ctx.listData.push(new MsgListFootBean())
        } catch (err) {
          throw err as Error
        }
        // GlobalObj?.getInstance()?.getClient().end();
      }
    }
    this.util?.getListData(ctx.startIndex, ctx.endIndex, callback)
  }

  build() {
    Row() {
      Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Button($r('app.string.Upload_email'))
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.appendMail()
            })

          Button($r('app.string.Close_email'))
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.closeBox()
            })

        }
        .height(60)
        .margin({ left: 15, top: 20 })

        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {

          Button($r('app.string.Delete_tagged_emails'))
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.storeMail()
            })
          Button($r('app.string.search_mail'))
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .bindMenu(this.MailMenu)


        }
        .height(60)
        .margin({ left: 15, top: 20 })

        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {

          Button($r('app.string.Add_flag'))
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.addFlag()
            })
          Button($r('app.string.Set_flag'))
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.setFlag()
            })
          Button($r('app.string.Delete_flag'))
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.deleteFlag()
            })


        }
        .height(60)
        .margin({ left: 15, top: 20 })

        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {

          Button($r('app.string.Add_keywords'))
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.addKeywords()
            })
          Button($r('app.string.Set_keywords'))
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.setKeywords()
            })
          Button($r('app.string.Delete_keywords'))
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.delKeywords()
            })


        }
        .height(60)
        .margin({ left: 15, top: 20 })


        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {

          Select(this.selectList)
            .selected(this.selectIndex)
            .value(this.getResourceString('Replication_Information'))
            .fontColor("#182431")
            .font({ size: 16, weight: 500 })
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number, text: string) => {
              this.selectIndex = index;
              this.selectFolder = text;
              this.copyMail();
            })
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)

          Select(this.selectList)
            .selected(this.selectIndex)
            .value(this.getResourceString('Mobile_Information'))
            .fontColor("#182431")
            .margin({ left: 30 })
            .font({ size: 16, weight: 500 })
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number, text: string) => {
              this.selectIndex = index;
              this.selectFolder = text;
              this.moveMail()


            })
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)

          Select(this.selectMenuArr)
            .selected(this.selectSortIndex)
            .value(this.getResourceString('Email_sorting'))
            .fontColor("#182431")
            .margin({ left: 30 })
            .font({ size: 16, weight: 500 })
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number, text: string) => {
              this.selectIndex = index;
              for (let i = 0; i < this.selectMenuList.length; i++) {
                if (this.selectMenuList[i].toString() == text) {
                  this.selectFolder = text;
                  this.sortMail();
                  break;
                }
              }
            })
            .margin(10)
            .height(50)
            .backgroundColor(Color.Blue)
        }
        .height(60)
        .margin({ left: 15, top: 20 })


        List({ space: 10, initialIndex: 0 }) {
          ForEach(this.listData, (item: MsgListBean, index: number) => {
            ListItem() {
              if (index === 0 || index === this.listData.length - 1) {
                Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center, direction: FlexDirection.Row }) {
                  Text(item.Subject)
                    .fontSize(14)
                    .height(50)
                    .margin({ left: 10 })
                    .fontWeight(FontWeight.Bold)
                }.height(110)
              } else {
                Flex({ alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start, direction: FlexDirection.Row }) {
                  Toggle({ type: ToggleType.Checkbox, isOn: true })
                    .size({ width: 30, height: 30 })
                    .selectedColor('#007DFF')
                    .visibility(this.selectMsg != -1 && this.selectMsg === index ? Visibility.Visible : Visibility.None)

                  Image($r('app.media.mail'))
                    .height(40)
                    .width(40)
                    .margin({ left: 10 })

                  Flex({
                    alignItems: ItemAlign.Center,
                    justifyContent: FlexAlign.Center,
                    alignContent: FlexAlign.Center,
                    direction: FlexDirection.Column
                  }) {
                    Text(item.From)
                      .fontSize(14)
                      .height(50)
                      .margin({ left: 10 })
                      .fontWeight(FontWeight.Bold)
                    Text(item.Subject)
                      .fontSize(12)
                      .height(50)
                      .margin({ left: 10 })
                      .fontWeight(FontWeight.Bold)
                  }.layoutWeight(1)

                  Text(item.Date)
                    .fontSize(10)
                    .height(50)
                    .width(100)
                    .textAlign(TextAlign.End)
                    .margin({ left: 10 })
                    .fontWeight(FontWeight.Bold)
                }.height(110)
              }
            }
            .parallelGesture(TapGesture().onAction((event) => {
              if (index === 0) {
                this.listData = []
                this.startIndex = 0;
                this.endIndex = 0;
                this.getListData()
              } else if (index === (this.listData.length - 1)) {
                this.startIndex = this.endIndex + 1;
                this.getListData()
              } else {
                this.showToast(this.getResourceString('Clicked_on_the_first_item_in_the_list') + `${index}`, 'list-click-imap')
                router.pushUrl({
                  url: 'pages/MsgDetailPage',
                  params: {
                    clickIndex: index
                  }
                })
              }
            }), GestureMask.Normal)
            .gesture(LongPressGesture().onAction((event) => {
              if (this.selectMsg != -1) {
                this.selectMsg = -1;
              } else {
                this.selectMsg = index;
                this.selectMailBox()
              }
            }), GestureMask.Normal)

          }, (item: MsgListBean, index: number) => index + '')
        }
        .width('100%')
        .listDirection(Axis.Vertical)
        .divider({ strokeWidth: 2, color: 0x888888 })
        .edgeEffect(EdgeEffect.None)
        .chainAnimation(false)

      }

    }
    .height('100%')
  }

  createMailData() {
    let msg: MsgSendBean = {
      text: this.getResourceString('Email_uploaded_during_IMAP_protocol_testing'),
      from: `${'鸿蒙搬砖工'} <${'xxxx@xxxx.com'}>`,
      to: 'xxxx@xxxx.com',
      cc: 'xxxx@xxx.com',
      bcc: 'xxx@xxx.com',
      subject: this.getResourceString('Topic_of_IMAP_Protocol_for_Client')
    }
    return JSON.stringify(msg);
  }

  appendMail() {
    const ctx = this;
    ctx.selectMsg = -1
    try {
      let data = ctx.createMailData();
      if (!data || data.length < 1) {
        ctx.showToast(this.getResourceString('The_uploaded_email_data_cannot_be_empty'), 'appendMail-imap')
        return
      }
      ctx.showToast(this.getResourceString('Start_uploading_emails'), 'appendMail-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        let option: AppendOptions = {
          mailbox: ctx.folderName,
          flags: ['Seen'], //取值 Seen flagged等
          date: new Date(), //取值 Seen flagged等

        }
        GlobalObj?.getInstance()?.getClient()?.append(data, option, (err: Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Failed_to_upload_email') + `：${err.message}`, 'appendMail-imap')
          } else {
            ctx.showToast(this.getResourceString('Email_uploaded_successfully'), 'appendMail-imap')
            ctx.startIndex = 0;
            ctx.endIndex = 0;
            ctx.getListData()
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'appendMail-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('Error_uploading_email') + `：${err.message}`, 'appendMail-smtp')
    }
  }

  selectMailBox() {
    console.log(this.getResourceString('Zdy_SELECT_instruction_internal_call'))
  }

  closeBox() {
    const ctx = this;
    try {
      ctx.selectMsg = -1
      ctx.showToast(this.getResourceString('Start_closing_this_folder'), 'closeBox-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.closeBox((err: Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Failed_to_close_this_folder_reason') + `：${err.message}`, 'closeBox-imap')
          } else {
            ctx.showToast(this.getResourceString('Successfully_closed_this_folder'), 'appendMail-imap')
            router.clear()
            router.pushUrl({
              url: 'pages/FolderPage'
            })
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'closeBox-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('Error_closing_this_folder') + `：${err.message}`, 'closeBox-smtp')
    }
  }

  sortMail() {
    const ctx = this;
    try {
      if (!ctx.selectSort || ctx.selectSort.length < 1) {
        ctx.showToast(this.getResourceString('The_sorting_parameter_cannot_be_empty'), 'sortMail-imap')
        return
      }
      ctx.showToast(this.getResourceString('Start_setting_sorting'), 'sortMail-imap')
      if (GlobalObj?.getInstance()?.getClient()) {

        GlobalObj?.getInstance()?.getClient()?.sort([ctx.selectSort], ['ALL'], (err: Error, uids: number[]) => {
          if (err) {
            ctx.showToast(this.getResourceString('Setting_sorting_failed_reason') + `：${err.message}`, 'sortMail-imap')
          } else {
            ctx.showToast(this.getResourceString('Sort_successfully_set'), 'sortMail-imap')
            ctx.startIndex = 0;
            ctx.endIndex = 0;
            ctx.getListData()
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'sortMail-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('Setting_sorting_error') + `：${err.message}`, 'sortMail-smtp')
    }
  }

  search() {
    const ctx = this;
    try {
      ctx.selectMsg = -1
      ctx.showToast(this.getResourceString('Start_searching_for_emails'), 'search-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.search([ctx.searchType], (err: Error, uids: number[]) => {
          if (err) {
            ctx.showToast(this.getResourceString('Search_email_failed_reason') + `：${err.message}`, 'search-imap')
          } else {
            ctx.showToast(this.getResourceString('Search_email_successful') + JSON.stringify(uids), 'search-imap')
            if (!uids) {
              throw new Error('get message list fail')
            }
            ctx.listData = [];
            for (let i = 0; i < uids.length; i++) {
              let bean = new MsgListBean();
              bean.Date = '';
              bean.From = '';
              bean.To = '';
              bean.Subject = this.getResourceString('The_current_search_information_number') + uids[i];
              ctx.listData.push(bean)
            }
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'search-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('Search_email_error') + `：${err.message}`, 'search-smtp')
    }
  }

  /**
   * 给邮件打标记 比如删除 已读
   * Deleted \Flagged \Seen
   *
   */
  storeMail() {
    const ctx = this;
    if (!ctx.selectMsg || ctx.selectMsg === -1) {
      ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'storeMail---IMAP')
      return
    }
    if (!ctx.listData || ctx.listData.length < 3) {
      ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'storeMail---IMAP')
      return
    }
    if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
      ctx.showToast(this.getResourceString('Please_select_the_correct_email_that_can_be_operated_on'), 'storeMail---IMAP')
      return
    }
    let uid = ctx.listData[ctx.selectMsg].uid
    ctx.addDeleteFlag(uid)
  }

  addDeleteFlag(uid: string) {
    const ctx = this;
    try {

      ctx.showToast(this.getResourceString('Start_marking_emails_for_deletion'), 'storeMail-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.addFlags(uid, '\\Seen', (err: Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Failed_to_mark_the_email_for_deletion_reason') + `：${err.message}`, 'storeMail-imap')
          } else {
            ctx.showToast(this.getResourceString('Successfully_marked_the_email_for_deletion'), 'storeMail-imap')
            ctx.startIndex = 0;
            ctx.endIndex = 0;
            ctx.expungeMail(uid)
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'storeMail-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('Error_in_marking_email_for_deletion') + `：${err.message}`, 'storeMail-smtp')
    }
  }

  expungeMail(uid: string) {
    const ctx = this;
    try {
      ctx.selectMsg = -1
      ctx.showToast(this.getResourceString('Starting_to_permanently_delete_all_emails_marked_as_DELETED'), 'closeBox-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.expunge(uid, (err: Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Permanent_deletion_failed_reason') + `：${err.message}`, 'expungeMail-imap')
          } else {
            ctx.showToast(this.getResourceString('Permanently_deleted_successfully'), 'expungeMail-imap')
            ctx.getListData()
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'expungeMail-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('Permanent_deletion_error') + `：${err.message}`, 'expungeMail-smtp')
    }
  }

  copyMail() {
    const ctx = this;
    try {
      if (!ctx.selectMsg || ctx.selectMsg === -1) {
        ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'copyMail---IMAP')
        return
      }
      if (!ctx.listData || ctx.listData.length < 3) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'copyMail---IMAP')
        return
      }
      if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
        ctx.showToast(this.getResourceString('Please_select_the_correct_email_that_can_be_operated_on'), 'copyMail---IMAP')
        return
      }
      if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
        ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'copyMail---IMAP')
        return
      }
      let uid = ctx.listData[ctx.selectMsg].uid
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.copy(uid, ctx.selectFolder, (err: Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Copy_email_failed_reason') + `：${err.message}`, 'copyMail-imap')
          } else {
            ctx.showToast(this.getResourceString('Copy_email_successfully'), 'copyMail-imap')
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'copyMail-imap')
        router.back()
      }
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_copying_email') + `：${err.message}`, 'copyMail-smtp')
    }
  }

  moveMail() {
    const ctx = this;
    try {
      if (!ctx.selectMsg || ctx.selectMsg === -1) {
        ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'moveMail---IMAP')
        return
      }
      if (!ctx.listData || ctx.listData.length < 3) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'moveMail---IMAP')
        return
      }
      if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
        ctx.showToast(this.getResourceString('Please_select_the_correct_email_that_can_be_operated_on'), 'moveMail---IMAP')
        return
      }
      if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
        ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'moveMail---IMAP')
        return
      }
      let uid = ctx.listData[ctx.selectMsg].uid
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.move(uid, ctx.selectFolder, (err: Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Mobile_email_failed_reason') + `：${err.message}`, 'moveMail-imap')
          } else {
            ctx.showToast(this.getResourceString('Mobile_email_successfully_sent'), 'moveMail-imap')

          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'moveMail-imap')
        router.back()
      }
    } catch (err) {
      ctx.showToast(this.getResourceString('Mobile_email_error') + `：${err.message}`, 'moveMail-smtp')
    }
  }

  addFlag() {
    const ctx = this;
    try {
      const ctx = this;
      if (!ctx.selectMsg || ctx.selectMsg === -1) {
        ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'addFlag---IMAP')
        return
      }
      if (!ctx.listData || ctx.listData.length < 3) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'addFlag---IMAP')
        return
      }
      if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
        ctx.showToast(this.getResourceString('Please_select_the_correct_email_that_can_be_operated_on'), 'addFlag---IMAP')
        return
      }
      let uid = ctx.listData[ctx.selectMsg].uid
      ctx.showToast(this.getResourceString('Start_adding_read_tags_to_emails'), 'addFlag-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.addFlags(uid, '\\Seen', (err:Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Adding_read_mark_to_email_failed_reason') + `：${err.message}`, 'addFlag-imap')
          } else {
            ctx.showToast(this.getResourceString('Successfully_marked_the_email_as_read'), 'addFlag-imap')
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'storeMail-imap')
        router.back()
      }
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_adding_read_mark_to_email') + `：${err.message}`, 'storeMail-smtp')
    }
  }

  setFlag() {
    const ctx = this;
    try {
      const ctx = this;
      if (!ctx.selectMsg || ctx.selectMsg === -1) {
        ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'setFlag---IMAP')
        return
      }
      if (!ctx.listData || ctx.listData.length < 3) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'setFlag---IMAP')
        return
      }
      if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
        ctx.showToast(this.getResourceString('Please_select_the_correct_email_that_can_be_operated_on'), 'setFlag---IMAP')
        return
      }
      let uid = ctx.listData[ctx.selectMsg].uid

      ctx.showToast(this.getResourceString('Start_marking_emails_as_read'), 'setFlag-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.setFlags(uid, '\\Seen', (err:Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Failed_to_set_read_flag_for_email_reason') + `：${err.message}`, 'setFlag-imap')
          } else {
            ctx.showToast(this.getResourceString('Successfully_marked_the_email_as_read'), 'setFlag-imap')
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'setFlag-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('Error_setting_read_flag_for_email') + `：${err.message}`, 'setFlag-smtp')
    }
  }

  deleteFlag() {
    const ctx = this;
    try {
      const ctx = this;
      if (!ctx.selectMsg || ctx.selectMsg === -1) {
        ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'deleteFlag---IMAP')
        return
      }
      if (!ctx.listData || ctx.listData.length < 3) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'deleteFlag---IMAP')
        return
      }
      if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
        ctx.showToast(this.getResourceString('Please_select_the_correct_email_that_can_be_operated_on'), 'deleteFlag---IMAP')
        return
      }
      let uid = ctx.listData[ctx.selectMsg].uid

      ctx.showToast(this.getResourceString('Start_unmarking_emails_as_read'), 'deleteFlag-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.delFlags(uid, '\\Seen', (err:Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Failed_to_unmark_the_email_as_read_reason') + `：${err.message}`, 'deleteFlag-imap')
          } else {
            ctx.showToast(this.getResourceString('Successfully_unmarked_the_email_as_read'), 'deleteFlag-imap')
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'deleteFlag-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('Error_occurred_in_removing_the_read_mark_from_the_email') + `：${err.message}`, 'deleteFlag-smtp')
    }
  }

  addKeywords() {
    const ctx = this;
    try {
      const ctx = this;
      if (!ctx.selectMsg || ctx.selectMsg === -1) {
        ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'setKeywords---IMAP')
        return
      }
      if (!ctx.listData || ctx.listData.length < 3) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'setKeywords---IMAP')
        return
      }
      if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
        ctx.showToast(this.getResourceString('Please_select_the_correct_email_that_can_be_operated_on'), 'setKeywords---IMAP')
        return
      }
      let uid = ctx.listData[ctx.selectMsg].uid
      ctx.showToast(this.getResourceString('Start_adding_keywords_to_emails'), 'setKeywords-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.addKeywords(uid, this.getResourceString('OpenHarmony_keywords'), (err:Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Adding_keywords_to_email_failed_reason') + `：${err.message}`, 'setKeywords-imap')
          } else {
            ctx.showToast(this.getResourceString('Successfully_added_keywords_to_email'), 'setKeywords-imap')
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'setKeywords-imap')
        router.back()
      }
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_adding_keywords_to_email') + `：${err.message}`, 'setKeywords-smtp')
    }
  }

  setKeywords() {
    const ctx = this;
    try {
      const ctx = this;
      if (!ctx.selectMsg || ctx.selectMsg === -1) {
        ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'setKeywords---IMAP')
        return
      }
      if (!ctx.listData || ctx.listData.length < 3) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'setKeywords---IMAP')
        return
      }
      if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
        ctx.showToast(this.getResourceString('Please_select_the_correct_email_that_can_be_operated_on'), 'setKeywords---IMAP')
        return
      }
      let uid = ctx.listData[ctx.selectMsg].uid
      ctx.showToast(this.getResourceString('Start_setting_keywords_for_emails'), 'setKeywords-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.setKeywords(uid, this.getResourceString('OpenHarmony_keywords'), (err:Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Failed_to_set_keywords_for_email_reason') + `：${err.message}`, 'setKeywords-imap')
          } else {
            ctx.showToast(this.getResourceString('Successfully_set_keywords_for_email'), 'setKeywords-imap')
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'setKeywords-imap')
        router.back()
      }
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_setting_keywords_for_email') + `：${err.message}`, 'setKeywords-smtp')
    }
  }

  delKeywords() {
    const ctx = this;
    try {
      const ctx = this;
      if (!ctx.selectMsg || ctx.selectMsg === -1) {
        ctx.showToast(this.getResourceString('Please_select_an_email_first'), 'delKeywords---IMAP')
        return
      }
      if (!ctx.listData || ctx.listData.length < 3) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'delKeywords---IMAP')
        return
      }
      if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
        ctx.showToast(this.getResourceString('Please_select_the_correct_email_that_can_be_operated_on'), 'delKeywords---IMAP')
        return
      }
      let uid = ctx.listData[ctx.selectMsg].uid
      ctx.showToast(this.getResourceString('Start_deleting_keywords_from_emails'), 'delKeywords-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.delKeywords(uid, '鸿蒙关键字', (err:Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('Failed_to_delete_keywords_from_email_reason') + `：${err.message}`, 'delKeywords-imap')
          } else {
            ctx.showToast(this.getResourceString('Successfully_deleted_keywords_from_email'), 'delKeywords-imap')
          }
        });
      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'delKeywords-imap')
        router.back()
      }
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_deleting_keywords_from_email') + `：${err.message}`, 'delKeywords-smtp')
    }
  }

  getResourceString(resourceName:string) {
    return getContext().resourceManager.getStringByNameSync(resourceName)
  }
}