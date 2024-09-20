# IMAP

## Introduction

This project describes how to use the third-party IMAP library in OpenHarmony. It supports the following capabilities:

- Connection to an email server
- Downloading emails from an email server to a client
- Obtaining email information
- Sending email operations to an email server

## How to Install

```
ohpm install @ohos/node-imap
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
1. Log in. (LoginPage login)

   ```
   async login() {
       const ctx = this;
       try {
         ctx.showToast('Start login.', 'login-imap')
         let hostParam = ctx.mailType.substring(ctx.mailType.indexOf('@') + 1, ctx.mailType.indexOf('.'))
         if (!globalThis.client) {
           if (ctx.secure) {
             let context: Context = globalThis.context ? globalThis.context : getContext(ctx)
             let ca0Data = await context.resourceManager.getRawFileContent('QQMailMiddle.pem')
             let ca0 = '';
             for (let i = 0; i < ca0Data.length; i++) {
               let todo = ca0Data[i]
               let item = String.fromCharCode(todo);
               ca0 += item;
             }
             // @ts-ignore
             ctx.option.secureOptions.ca[0] = ca0;
   
             let ca1Data = await context.resourceManager.getRawFileContent('QQMailRoot.pem')
             let ca1 = '';
             for (let i = 0; i < ca1Data.length; i++) {
               let todo = ca1Data[i]
               let item = String.fromCharCode(todo);
               ca1 += item;
             }
             // @ts-ignore
             option.secureOptions.ca[1] = ca1;
   
             globalThis.client = new Imap({
               user: ctx.account + ctx.mailType,
               password: ctx.password,
               host: `imap.${hostParam}.com`,
               port: 993,
               tls: true,
               tlsOptions: ctx.option,
               socketTimeout: 60000,
               connTimeout: 60000,
               authTimeout: 60000,
               keepalive: true,
   
             });
           } else {
             globalThis.client = new Imap({
               user: 'xxx@xx.com',
               password: 'xxxxx',
               host: 'imap.xx.com',
               port: 143,
               tls: false,
               tlsOptions: undefined,
               socketTimeout: 60000,
               connTimeout: 60000,
               authTimeout: 60000,
               keepalive: true,
   
             });
           }
         }
         ctx.showToast('Client initialized. Parameter: ${JSON.stringify(globalThis.client._config) }', 'login-imap')
         if (globalThis.client) {
           globalThis.client.once('ready', function () {
             ctx.isLogin = true;
             ctx.showToast('Login succeeded. Prepare to redirect to the email folders.', 'login-imap')
             // globalThis.client._doKeepaliveTimer(true) // After successful login, the noop command is used as a periodic poll to prevent server disconnection. This command has been encapsulated in the source repository and is continuously executed. You do not need to manually run this command.
           });
   
           globalThis.client.once('error', function (err) {
             console.log(err);
           });
   
           globalThis.client.once('end', function () {
             console.log('Connection ended');
           });
           ctx.showToast('Start server connection.', 'login-imap')
           await globalThis.client.connect();
           ctx.showToast('Server connected.', 'login-imap')
         }
       } catch (err) {
         ctx.showToast('Account login error: ${err.message}', 'login-smtp')
       }
     }
   ```

2. Log out. (LoginPage loginOut)

   ```
     loginOut() {
       const ctx = this;
       try {
         ctx.showToast('Start logout.', 'loginOut-imap')
         if (globalThis.client) {
           globalThis.client.end(() => {
             ctx.showToast('Logout succeeded.', 'loginOut-imap')
             router.clear()
             router.pushUrl({
               url: 'pages/Index"'
             })
           });
   
         } else {
           ctx.showToast('Logout failed. The client object is empty.', 'loginOut-imap')
           router.clear()
           router.pushUrl({
             url: 'pages/Index"'
           })
         }
       } catch (err) {
         ctx.showToast('Logout error: ${err.message}', 'loginOut-smtp')
       }
     }
   ```

3. Obtain the list of email folders. (FolerPager refreshFolderList)

   ```
     refreshFolderList() {
       const ctx = this;
       if (globalThis.client) {
         globalThis.client.getBoxes(function (err, data) {
           if (err) throw err;
           if (!data || typeof data != 'object') {
             throw new Error('get box status fail')
           }
           ctx.listData = [];
           for (let key in data) {
             console.log(`zdy---getBoxes key--->${key}`);
             ctx.listData.push(key.toString())
           }
   
         })
       } else {
         this.showToast('Not logged in yet. Log in and try again.', 'MsgList-imap')
         router.back()
       }
     }
   ```

4. Create a folder. (FolerPager createFolder)

   ```
     createFolder() {
       const ctx = this;
       try {
         if (!ctx.inputValue || ctx.inputValue.length < 1) {
           ctx.showToast('Enter a new folder name.', 'renameFolder-imap')
           return
         }
         ctx.showToast('Start folder creation.', 'createFolder-imap')
         if (globalThis.client) {
           globalThis.client.addBox(ctx.inputValue, (err, result) => {
             if (err) {
               ctx.showToast('Failed to create the folder. Cause: ${err.message}', 'createFolder-imap')
             } else {
               ctx.inputValue = '';
               ctx.textValue = '';
               ctx.showToast('Folder created.', 'createFolder-imap')
               ctx.refreshFolderList()
             }
           });
         } else {
           this.showToast('Not logged in yet. Log in and try again.', 'createFolder-imap')
           router.back()
         }
   
       } catch (err) {
         ctx.showToast('Account login error: ${err.message}', 'createFolder-smtp')
       }
     }
   ```

5. Delete a folder. (FolerPager deleteFolder)

   ```
     deleteFolder() {
       const ctx = this;
       try {
         if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
           ctx.showToast('Select a folder to delete.', 'renameFolder-imap')
           return
         }
         ctx.showToast('Start folder deletion.', 'deleteFolder-imap')
         if (globalThis.client) {
           globalThis.client.delBox(ctx.selectFolder, (err, result) => {
             if (err) {
               ctx.showToast('Failed to delete the folder.', 'deleteFolder-imap')
             } else {
               ctx.selectFolder = undefined;
               ctx.showToast('Folder deleted.', 'deleteFolder-imap')
               ctx.refreshFolderList()
             }
           });
         } else {
           this.showToast('Not logged in yet. Log in and try again.', 'MsgList-imap')
           router.back()
         }
   
       } catch (err) {
         ctx.showToast('Account login error: ${err.message}', 'login-smtp')
       }
     }
   ```

6. Rename a folder. (FolerPager renameFolder)

   ```
    renameFolder() {
       const ctx = this;
       try {
         if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
           ctx.showToast('Select a folder to rename.', 'renameFolder-imap')
           return
         }
         if (!ctx.inputValue || ctx.inputValue.length < 1) {
           ctx.showToast('Enter a new folder name.', 'renameFolder-imap')
           return
         }
         ctx.showToast('Start renaming the folder.', 'renameFolder-imap')
         if (globalThis.client) {
           globalThis.client.renameBox(ctx.selectFolder, ctx.inputValue, (err, result) => {
             if (err) {
               ctx.showToast('Failed to rename the folder. Cause: ${err.message}', 'renameFolder-imap')
             } else {
               ctx.selectFolder = undefined;
               ctx.inputValue = '';
               ctx.textValue = '';
               ctx.showToast('Folder renamed.', 'renameFolder-imap')
               ctx.refreshFolderList()
             }
           });
         } else {
           this.showToast('Not logged in yet. Log in and try again.', 'renameFolder-imap')
           router.back()
         }
   
       } catch (err) {
         ctx.showToast('Account login error: ${err.message}', 'renameFolder-smtp')
       }
     }
   ```

7. Subscribe to a folder. (FolerPager subBox)

   ```
     subBox() {
       const ctx = this;
       try {
         if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
           ctx.showToast('Select a mailbox.', 'subBox-imap')
           return
         }
         ctx.showToast('Subscribe to a folder.', 'subBox-imap')
         if (globalThis.client) {
           globalThis.client.subscribeBox(this.selectFolder , (err, result) => {
             if (err) {
               ctx.showToast('Failed to subscribe to the mailbox. Cause: ${err.message}', 'subBox-imap')
             } else {
               ctx.inputValue = '';
               ctx.textValue = '';
               ctx.showToast('Mailbox subscribed.', 'subBox-imap')
               // ctx.refreshFolderList()
             }
           });
         } else {
           this.showToast('Not logged in yet. Log in and try again.', 'subBox-imap')
           router.back()
         }
   
       } catch (err) {
         ctx.showToast('Mailbox subscription error: ${err.message}', 'subBox-smtp')
       }
     }
   ```

8. Unsubscribe from a folder. (FolerPager unSubBox)

   ```
   unSubBox() {
       const ctx = this;
       try {
         if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
           ctx.showToast('Select a mailbox.', 'unSubBox-imap')
           return
         }
         ctx.showToast('Unsubscribe from a mailbox.', 'unSubBox-imap')
         if (globalThis.client) {
           globalThis.client.unsubscribeBox(this.selectFolder, (err, result) => {
             if (err) {
               ctx.showToast('Failed to unsubscribe from the mailbox. Cause: ${err.message}', 'unSubBox-imap')
             } else {
               ctx.inputValue = '';
               ctx.textValue = '';
               ctx.showToast('Mailbox unsubscribed.', 'unSubBox-imap')
               // ctx.refreshFolderList()
             }
           });
         } else {
           this.showToast('Not logged in yet. Log in and try again.', 'unSubBox-imap')
           router.back()
         }
   
       } catch (err) {
         ctx.showToast('Mailbox unsubscription error: ${err.message}', 'unSubBox-smtp')
       }
     }
   ```

9. Obtain the list of subscribed-to folders. (FolerPager getSubList)

   ```
   getSubList() {
       const ctx = this;
       try {
         ctx.showToast('Start to return all files in the $HOME directory of the user, but the LSUB command displays only files that are set to active mailboxes using the SUBSCRIBE command. Two parameters: mailbox path and mailbox name.', 'closeBox-imap')
         if (globalThis.client) {
           globalThis.client.getSubscribedBoxes((err, result) => {
             if (err) {
               ctx.showToast('Failed to obtain files of all active mailboxes. Cause: ${err.message}', 'expungeMail-imap')
             } else {
               ctx.showToast('Succeeded in obtaining files of all active mailboxes', 'expungeMail-imap')
               ctx.listData = [];
               for (let key in result) {
                 console.log(`zdy---getBoxes key--->${key}`);
                 ctx.listData.push(key.toString())
               }
             }
           });
         } else {
           this.showToast('Not logged in yet. Log in and try again.', 'expungeMail-imap')
           router.back()
         }
   
       } catch (err) {
         ctx.showToast('Error occurred when obtaining files of all active mailboxes: ${err.message}', 'expungeMail-smtp')
       }
     }
   ```

10. Obtain the message list. (MsgListPage getListData)

    ```
      getListData() {
        const ctx = this;
        ctx.refreshPageSize();
        let buffer = '';
        ctx.uidList = [];
        ctx.listData = [];
        ctx.selectFolder = '';
        ctx.searchType = '';
        ctx.selectMsg = -1;
        // fetch can be fetch('1:3') or fetch('1'), where fetch('1:3') is used to obtain messages numbered from 1 to 3 and fetch('1') is used to obtain message numbered 1.
        var f = globalThis.client.seq.fetch(`${ctx.startIndex}:${ctx.endIndex}`, {
          bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
          struct: true
        });
        f.on('message', function (msg, seqno) {
          console.log('Message #%d', seqno);
          var prefix = '(#' + seqno + ') ';
    
          msg.on('body', function (stream, info) {
    
            stream.on('data', function (chunk) {
              buffer += chunk.toString('utf8');
            });
            stream.once('end', function () {
              // console.log(prefix + 'Parsed header: %s', inspect(Imap.parseHeader(buffer)));
    
            });
          });
          msg.once('attributes', function (attrs) {
            if (attrs && typeof attrs === 'object') {
              let uid = attrs['uid'] ? attrs['uid'] : ''
              ctx.uidList.push(uid);
            }
          });
          msg.once('end', function () {
            console.log(prefix + 'Finished');
          });
        });
        f.once('error', function (err) {
          console.log('Fetch error: ' + err);
        });
        f.once('end', function () {
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
            throw err
          }
          // globalThis.client.end();
        });
      }
    ```

11. Upload an email. (MsgListPage appendMail)

    ```
      appendMail() {
        const ctx = this;
        ctx.selectMsg = -1
        try {
          let data = ctx.createMailData();
          if (!data || data.length < 1) {
            ctx.showToast('The email to upload cannot be empty.', 'appendMail-imap')
            return
          }
          ctx.showToast('Start uploading the email', 'appendMail-imap')
          if (globalThis.client) {
            let option = {
              mailbox: ctx.folderName,
              flag: ['Seen'], // Value: Seen, flagged, and more
              date: new Date(), // Value: Seen, flagged, and more
    
            }
            globalThis.client.append(data, option, (err, result) => {
              if (err) {
                ctx.showToast('Failed to upload the email. Cause: ${err.message}', 'appendMail-imap')
              } else {
                ctx.showToast('Email uploaded.', 'appendMail-imap')
                ctx.startIndex = 0;
                ctx.endIndex = 0;
                ctx.getListData()
              }
            });
          } else {
            this.showToast('Not logged in yet. Log in and try again.', 'appendMail-imap')
            router.back()
          }
    
        } catch (err) {
          ctx.showToast('Email upload error: ${err.message}', 'appendMail-smtp')
        }
      }
    ```

12. Close a mailbox. (MsgListPage closeBox)

    ```
      closeBox() {
        const ctx = this;
        try {
          ctx.selectMsg = -1
          ctx.showToast('Start closing the folder.', 'closeBox-imap')
          if (globalThis.client) {
    
            globalThis.client.closeBox((err, result) => {
              if (err) {
                ctx.showToast('Failed to close the folder. Cause: ${err.message}', 'closeBox-imap')
              } else {
                ctx.showToast('Folder closed.', 'appendMail-imap')
                router.clear()
                router.pushUrl({
                  url: 'pages/FolderPage'
                })
              }
            });
          } else {
            this.showToast('Not logged in yet. Log in and try again.', 'closeBox-imap')
            router.back()
          }
    
        } catch (err) {
          ctx.showToast('Folder closing error: ${err.message}', 'closeBox-smtp')
        }
      }
    ```

13. Search for an email. (search)

    ```
      search() {
        const ctx = this;
        try {
          ctx.selectMsg = -1
          ctx.showToast('Start email search.', 'search-imap')
          if (globalThis.client) {
            globalThis.client.search([ctx.searchType], (err, result) => {
              if (err) {
                ctx.showToast('Failed to find the email. Cause: ${err.message}', 'search-imap')
              } else {
                ctx.showToast('Email found.' + JSON.stringify(result), 'search-imap')
    
                let jsonObj = result.split(',')
                if (!jsonObj) {
                  throw new Error('get message list fail')
                }
                ctx.listData = [];
                for (let i = 0; i < jsonObj.length; i++) {
                  let bean = new MsgListBean();
                  bean.Date = '';
                  bean.From = '';
                  bean.To = '';
                  bean.Subject ='ID of the email to search for:' + jsonObj[i];
                  ctx.listData.push(bean)
                }
    
              }
            });
          } else {
            this.showToast('Not logged in yet. Log in and try again.', 'search-imap')
            router.back()
          }
    
        } catch (err) {
          ctx.showToast('Email search error: ${err.message}', 'search-smtp')
        }
      }
    ```

14. Copy an email. (copyMail)

    ```
    copyMail() {
      const ctx = this;
      try {
        if (!ctx.selectMsg || ctx.selectMsg === -1) {
          ctx.showToast('Select an email.', 'copyMail---IMAP')
          return
        }
        if (!ctx.listData || ctx.listData.length < 3) {
          ctx.showToast('No message in the mailbox.', 'copyMail---IMAP')
          return
        }
        if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
          ctx.showToast('Select an email that can be operated.', 'copyMail---IMAP')
          return
        }
        if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
          ctx.showToast('Select a mailbox.', 'copyMail---IMAP')
          return
        }
        let uid = ctx.listData[ctx.selectMsg].uid
        if (globalThis.client) {
          globalThis.client.copy(uid, ctx.selectFolder, (err, result) => {
            if (err) {
              ctx.showToast('Failed to copy the email. Cause: ${err.message}', 'copyMail-imap')
            } else {
              ctx.showToast('Email copied.' + JSON.stringify(result), 'copyMail-imap')
    
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'copyMail-imap')
          router.back()
        }
      } catch (err) {
        ctx.showToast('Email copy error: ${err.message}', 'copyMail-smtp')
      }
    }
    ```

15. Move an email. (moveMail)

    ```
    moveMail() {
      const ctx = this;
      try {
        if (!ctx.selectMsg || ctx.selectMsg === -1) {
          ctx.showToast('Select an email.', 'moveMail---IMAP')
          return
        }
        if (!ctx.listData || ctx.listData.length < 3) {
          ctx.showToast('No email in the mailbox.', 'moveMail---IMAP')
          return
        }
        if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
          ctx.showToast('Select an email that can be operated.', 'moveMail---IMAP')
          return
        }
        if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
          ctx.showToast('Select a mailbox.', 'moveMail---IMAP')
          return
        }
        let uid = ctx.listData[ctx.selectMsg].uid
        if (globalThis.client) {
          globalThis.client.move(uid, ctx.selectFolder, (err, result) => {
            if (err) {
              ctx.showToast('Failed to move the email. Cause: ${err.message}', 'moveMail-imap')
            } else {
              ctx.showToast('Email moved.' + JSON.stringify(result), 'moveMail-imap')
    
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'moveMail-imap')
          router.back()
        }
      } catch (err) {
        ctx.showToast('Error occurred when moving the email: ${err.message}', 'moveMail-smtp')
      }
    }
    ```

16. Sort emails. (sortMail)

    ```
    sortMail() {
      const ctx = this;
      try {
        if (!ctx.selectSort || ctx.selectSort.length < 1) {
          ctx.showToast('The sorting parameter cannot be empty.', 'sortMail-imap')
          return
        }
        ctx.showToast('Start email sorting.', 'sortMail-imap')
        if (globalThis.client) {
    
          globalThis.client.sort([ctx.selectSort], ['ALL'], (err, result) => {
            if (err) {
              ctx.showToast('Failed to sort emails. Cause: ${err.message}', 'sortMail-imap')
            } else {
              ctx.showToast('Emails sorted.', 'sortMail-imap')
              ctx.startIndex = 0;
              ctx.endIndex = 0;
              ctx.getListData()
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'sortMail-imap')
          router.back()
        }
    
      } catch (err) {
        ctx.showToast('Error occurred when sorting the emails: ${err.message}', 'sortMail-smtp')
      }
    }
    ```

17. Add a flag. (addFlag)

    ```
    addFlag() {
      const ctx = this;
      try {
        const ctx = this;
        if (!ctx.selectMsg || ctx.selectMsg === -1) {
          ctx.showToast('Select an email.', 'addFlag---IMAP')
          return
        }
        if (!ctx.listData || ctx.listData.length < 3) {
          ctx.showToast('No email in the mailbox.', 'addFlag---IMAP')
          return
        }
        if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
          ctx.showToast('Select an email that can be operated.', 'addFlag---IMAP')
          return
        }
        let uid = ctx.listData[ctx.selectMsg].uid
    
        ctx.showToast('Start marking the email as READ.', 'addFlag-imap')
        if (globalThis.client) {
          globalThis.client.addFlags(uid, '\\Seen', (err, result) => {
            if (err) {
              ctx.showToast('Failed to mark the email as READ. Cause: ${err.message}', 'addFlag-imap')
            } else {
              ctx.showToast('Email marked as READ.', 'addFlag-imap')
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'storeMail-imap')
          router.back()
        }
    
      } catch (err) {
        ctx.showToast('Error occurred when marking the email as READ: ${err.message}', 'storeMail-smtp')
      }
    }
    ```

18. Set a flag. (setFlag)

    ```
    setFlag() {
      const ctx = this;
      try {
        const ctx = this;
        if (!ctx.selectMsg || ctx.selectMsg === -1) {
          ctx.showToast('Select an email.', 'setFlag---IMAP')
          return
        }
        if (!ctx.listData || ctx.listData.length < 3) {
          ctx.showToast('No email in the mailbox.', 'setFlag---IMAP')
          return
        }
        if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
          ctx.showToast('Select an email that can be operated.', 'setFlag---IMAP')
          return
        }
        let uid = ctx.listData[ctx.selectMsg].uid
    
        ctx.showToast('Start marking the email as READ.', 'setFlag-imap')
        if (globalThis.client) {
          globalThis.client.setFlags(uid, '\\Seen', (err, result) => {
            if (err) {
              ctx.showToast('Failed to mark the email as READ. Cause: ${err.message}', 'setFlag-imap')
            } else {
              ctx.showToast('Email marked as READ.', 'setFlag-imap')
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'setFlag-imap')
          router.back()
        }
    
      } catch (err) {
        ctx.showToast('Error occurred when marking the email as READ: ${err.message}', 'setFlag-smtp')
      }
    }
    ```

19. Delete a flag. (deleteFlag)

    ```
    deleteFlag() {
      const ctx = this;
      try {
        const ctx = this;
        if (!ctx.selectMsg || ctx.selectMsg === -1) {
          ctx.showToast('Select an email.', 'deleteFlag---IMAP')
          return
        }
        if (!ctx.listData || ctx.listData.length < 3) {
          ctx.showToast('No email in the mailbox.', 'deleteFlag---IMAP')
          return
        }
        if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
          ctx.showToast('Select an email that can be operated.', 'deleteFlag---IMAP')
          return
        }
        let uid = ctx.listData[ctx.selectMsg].uid
    
        ctx.showToast('Start removing the READ flag of the email.', 'deleteFlag-imap')
        if (globalThis.client) {
          globalThis.client.delFlags(uid, '\\Seen', (err, result) => {
            if (err) {
              ctx.showToast('Failed to remove the READ flag of the email. Cause: ${err.message}', 'deleteFlag-imap')
            } else {
              ctx.showToast('READ flag removed.', 'deleteFlag-imap')
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'deleteFlag-imap')
          router.back()
        }
    
      } catch (err) {
        ctx.showToast('Error occurred when removing the READ flag: ${err.message}', 'deleteFlag-smtp')
      }
    }
    ```

20. Add keywords. (addKeywords)

    ```
    addKeywords() {
      const ctx = this;
      try {
        const ctx = this;
        if (!ctx.selectMsg || ctx.selectMsg === -1) {
          ctx.showToast('Select an email.', 'setKeywords---IMAP')
          return
        }
        if (!ctx.listData || ctx.listData.length < 3) {
          ctx.showToast('No email in the mailbox.', 'setKeywords---IMAP')
          return
        }
        if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
          ctx.showToast('Select an email that can be operated.', 'setKeywords---IMAP')
          return
        }
        let uid = ctx.listData[ctx.selectMsg].uid
    
        ctx.showToast('Start adding keywords to the email', 'setKeywords-imap')
        if (globalThis.client) {
          globalThis.client.addKeywords(uid,' OpenHarmony keywords', (err, result) => {
            if (err) {
              ctx.showToast('Failed to add keywords to the email. Cause: ${err.message}', 'setKeywords-imap')
            } else {
              ctx.showToast('Keywords added.', 'setKeywords-imap')
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'setKeywords-imap')
          router.back()
        }
    
      } catch (err) {
        ctx.showToast('Error occurred when adding keywords to the email: ${err.message}', 'setKeywords-smtp')
      }
    }
    ```

21. Set keywords. (setKeywords)

    ```
    setKeywords() {
      const ctx = this;
      try {
        const ctx = this;
        if (!ctx.selectMsg || ctx.selectMsg === -1) {
          ctx.showToast('Select an email.', 'setKeywords---IMAP')
          return
        }
        if (!ctx.listData || ctx.listData.length < 3) {
          ctx.showToast('No email in the mailbox.', 'setKeywords---IMAP')
          return
        }
        if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
          ctx.showToast('Select an email that can be operated.', 'setKeywords---IMAP')
          return
        }
        let uid = ctx.listData[ctx.selectMsg].uid
    
        ctx.showToast('Start setting keywords for the email', 'setKeywords-imap')
        if (globalThis.client) {
          globalThis.client.setKeywords(uid,' OpenHarmony keywords', (err, result) => {
            if (err) {
              ctx.showToast('Failed to set keywords for the email. Cause: ${err.message}', 'setKeywords-imap')
            } else {
              ctx.showToast('Keywords set.', 'setKeywords-imap')
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'setKeywords-imap')
          router.back()
        }
    
      } catch (err) {
        ctx.showToast('Error occurred when setting keywords for the email: ${err.message}', 'setKeywords-smtp')
      }
    }
    ```

22. Delete keywords. (delKeywords)

    ```
    delKeywords() {
      const ctx = this;
      try {
        const ctx = this;
        if (!ctx.selectMsg || ctx.selectMsg === -1) {
          ctx.showToast('Select an email.', 'delKeywords---IMAP')
          return
        }
        if (!ctx.listData || ctx.listData.length < 3) {
          ctx.showToast('No email in the mailbox.', 'delKeywords---IMAP')
          return
        }
        if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
          ctx.showToast('Select an email that can be operated.', 'delKeywords---IMAP')
          return
        }
        let uid = ctx.listData[ctx.selectMsg].uid
    
        ctx.showToast('Start deleting keywords for the email', 'delKeywords-imap')
        if (globalThis.client) {
          globalThis.client.delKeywords(uid,' OpenHarmony keywords', (err, result) => {
            if (err) {
              ctx.showToast('Failed to delete keywords for the email. Cause: ${err.message}', 'delKeywords-imap')
            } else {
              ctx.showToast('Keywords deleted.', 'delKeywords-imap')
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'delKeywords-imap')
          router.back()
        }
    
      } catch (err) {
        ctx.showToast('Error occurred when deleting keywords for the email: ${err.message}', 'delKeywords-smtp')
      }
    }
    ```

23. Permanently delete an email. (storeMail -> addDeleteFlag -> expungeMail)

    ```
    storeMail() {
      const ctx = this;
      if (!ctx.selectMsg || ctx.selectMsg === -1) {
        ctx.showToast('Select an email.', 'storeMail---IMAP')
        return
      }
      if (!ctx.listData || ctx.listData.length < 3) {
        ctx.showToast('No email in the mailbox.', 'storeMail---IMAP')
        return
      }
      if (ctx.selectMsg <= 0 || ctx.selectMsg >= ctx.listData.length - 1) {
        ctx.showToast('Select an email that can be operated.', storeMail---IMAP')
        return
      }
      let uid = ctx.listData[ctx.selectMsg].uid
      ctx.addDeleteFlag(uid)
    }
    
    addDeleteFlag(uid: string) {
      const ctx = this;
      try {
    
        ctx.showToast('Start marking the mail as DELETED', 'storeMail-imap')
        if (globalThis.client) {
          globalThis.client.addFlags(uid, '\\Seen', (err, result) => {
            if (err) {
              ctx.showToast('Failed to mark the email as DELETED. Cause: ${err.message}', 'storeMail-imap')
            } else {
              ctx.showToast('Email marked as DELETED.', 'storeMail-imap')
              ctx.startIndex = 0;
              ctx.endIndex = 0;
              ctx.expungeMail(uid)
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'storeMail-imap')
          router.back()
        }
    
      } catch (err) {
        ctx.showToast('Error occurred when marking the email as DELETED: ${err.message}', 'storeMail-smtp')
      }
    }
    
    expungeMail(uid: string) {
      const ctx = this;
      try {
        ctx.selectMsg = -1
        ctx.showToast('Start permanently deleting all emails marked as DELETED. Permanently deleted emails cannot be restored.', 'closeBox-imap')
        if (globalThis.client) {
          globalThis.client.expunge(uid, (err, result) => {
            if (err) {
              ctx.showToast('Failed to permanently delete emails. Cause: ${err.message}', 'expungeMail-imap')
            } else {
              ctx.showToast('Emails permanently deleted.', 'expungeMail-imap')
              ctx.getListData()
            }
          });
        } else {
          this.showToast('Not logged in yet. Log in and try again.', 'expungeMail-imap')
          router.back()
        }
    
      } catch (err) {
        ctx.showToast('Error occurred when permanently deleting the emails: ${err.message}', 'expungeMail-smtp')
      }
    }
    ```

24. Obtain the email details. (MsgDetailPage aboutToAppear)

    ```
    aboutToAppear() {
      const ctx = this;
      if (!globalThis.client) {
        this.showToast('Not logged in yet. Log in and try again.', 'MsgDetail-imap')
        router.back()
        return
      }
      if (router.getParams() && router.getParams()['clickIndex']) {
        ctx.clickIndex = router.getParams()['clickIndex']
      } else {
        this.showToast('Failed to obtain the email folder parameter.', 'MsgDetail-imap')
        router.back()
        return
      }
      var f = globalThis.client.seq.fetch(`${ctx.clickIndex}`, {
        bodies: 'TEXT',
        struct: true
      });
      f.on('message', function (msg, seqno) {
        console.log('Message #%d', seqno);
        var prefix = '(#' + seqno + ') ';
    
        msg.on('body', function (stream, info) {
          var buffer = '';
          stream.on('data', function (chunk) {
            buffer += chunk.toString('utf8');
          });
          stream.once('end', function () {
            try {
              ctx.showToast('Succeeded in obtaining the entire email body: ${'\r\n'}${buffer}', 'MsgDetail-imap');
              if (buffer.length > 65535) {
                ctx.message ='Succeeded in obtaining the entire email body. The body contains more than 65535 characters. Only the first 65535 characters are displayed: ${'\r\n'}${buffer.substring(0, 65535)}'
              } else {
                ctx.message ='Succeeded in obtaining the entire email body: ${'\r\n'}${buffer}'
              }
    
            } catch (err) {
              throw err
            }
          });
        });
        msg.once('attributes', function (attrs) {
          // console.log(prefix + 'Attributes: %s', inspect(attrs, false, 8));
        });
        msg.once('end', function () {
          console.log(prefix + 'Finished');
        });
      });
      f.once('error', function (err) {
        console.log('Fetch error: ' + err);
      });
      f.once('end', function () {
        console.log('Done fetching all messages!');
        globalThis.client.end();
      });
    }
    ```

## Available APIs

| API                                                    | Parameter                                                        | Description                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| end()                                                        |                                                              | Ends the connection to the server after all requests in the queue are sent.                  |
| on(event:stringm listener:Function)                          |                                                              | Binds an event listener.                                              |
| append(msgdata:any, options:Connection.AppendOption, callback:(err:Error) =>void) | msgdata:any, options:Connection.AppendOption, callback:(err:Error) =>void | Appends a message to a mailbox. **msgData** is a string or buffer that contains RFC822 compatible MIME messages.|
| serverSupports(capability: string)                           | capability: string                                           | Checks whether the server supports a specified feature.                                |
| destroy()                                                    |                                                              | Disconnects from the server immediately.                                      |
| copy(source:any, mailboxName: string, callback:(error:Error)=>void) | source:any, mailboxName: string, callback:(error:Error)=>void | Copies emails from the current mailbox to another mailbox.                    |
| addBox(mailboxName:string, callback:(error:Error)=>void)     | mailboxName:string, callback:(error:Error)=>void             | Creates a mailbox on the server. The mailbox name should include any necessary prefix or path.   |
| expunge(uids:any, callback:(error:Error)=>void)              | uids:any, callback:(error:Error)=>void                       | Permanently deletes all emails marked as DELETED in the current mailbox. If the server supports the UIDPLUS extension, only the UID can be provided to delete messages that have the UID and the DELETED flag. Note: At least on Gmail, calling this API for any currently open non-spam or non-trash mailbox archives only any messages marked as DELETED (by moving them to the All Mail folder).|
| fetch(source:any, options:Connection.FetchOptions)           | source:any, options:Connection.FetchOptions                  | Obtains the emails in the current mailbox.                                  |
| connect()                                                    |                                                              | Attempts to connect to the IMAP server and authenticate the user.                              |
| getSubscribedBoxes(nsPrefix:string, callback:(error:Error, mailboxes:Connection.MailBoxes)=>void) | nsPrefix:string, callback:(error:Error, mailboxes:Connection.MailBoxes)=>void | Obtains the list of subscribed-to email addresses. If **nsPrefix** is not specified, the primary personal namespace is used.|
| renameBox(oldMailboxName: string, newMailboxName:string, callback:(error:Error,mailbox:Connection.Box)=>void) | oldMailboxName: string, newMailboxName:string, callback:(error:Error,mailbox:Connection.Box)=>void | Renames a mailbox on the server. Both **oldMailBoxName** and **newMailBoxName** should include any necessary prefix or path. Note: Renaming the Inbox folder will cause all messages in Inbox to be moved to the new folder.|
| search(criteria:any[], callback:(error:Error, uids:number[])) | criteria:any[], callback:(error:Error, uids:number[])        | Searches for emails in the current mailbox based on specified criteria, which are a list of contents to be searched for. For criteria that require parameters, use arrays instead of string condition type names (for example, ['From', 'foo@bar.com']). An exclamation mark (!) must be added before the condition type.|
| openBox()                                                    |                                                              | Opens the current folder.                       |
| status(mailboxName:string, callback:(error:Error, mailbox:Connection.Box) => void) | mailboxName:string, callback:(error:Error, mailbox:Connection.Box) => void | Obtains information about mailboxes other than the current mailbox. Note: There is no guarantee that this will be a quick operation on the server. In addition, do not call this API on the current mailbox.|
| subscribeBox(mailboxName: string, callback:(error: Error)=>void) | mailboxName: string, callback:(error: Error)=>void           | Subscribes to a mailbox that exists on the server. The mailbox name should include any necessary prefix or path.|
| unsubscribeBox(mailboxName: string, callback:(error: Error)=>void) | mailboxName: string, callback:(error: Error)=>void           | Unsubscribes from a mailbox that exists on the server. The mailbox name should include any necessary prefix or path.|
| sort(sortCriteria:Connection.SortCriteria[], searchCriteria: any[], callback:(error:Error, uid:number[])=>void) | sortCriteria:Connection.SortCriteria[], searchCriteria: any[], callback:(error:Error, uid:number[])=>void | Sorts emails in the current mailbox based on the given criteria. This API first searches the mailbox for emails that match the given search criteria, and then sorts the emails according to the given sorting criteria. (This operation complies with RFC5256.)|
| move(source:any, flags:any, callback:(error:Error)=>void)    | source:any, flags:any, callback:(error:Error)=>void          | Moves emails from the current mailbox to another mailbox. Note: Emails in the destination mailbox will have new email UIDs.|
| addFlags(source:any, flags:any,callback:(error:Error)=>void) | source:any, flags:any,callback:(error:Error)=>void           | Adds flags to messages.                                        |
| delFlags(source:any, flags:any,callback:(error:Error)=>void) | source:any, flags:any,callback:(error:Error)=>void           | Deletes flags from messages.                                        |
| setlFlags(source:any, flags:any,callback:(error:Error)=>void) | source:any, flags:any,callback:(error:Error)=>void           | Sets flags for messages.                                        |
| addKeywords(source:any,keywords:any,callback:(error:Error)=>void) | source:any,keywords:any,callback:(error:Error)=>void         | Adds keywords to messages. Keywords can be a single keyword or an array of keywords.|
| delKeywords(source:any,keywords:any,callback:(error:Error)=>void) | source:any,keywords:any,callback:(error:Error)=>void         | Deletes keywords from messages. Keywords can be a single keyword or an array of keywords.|
| setKeywords(source:any,keywords:any,callback:(error:Error)=>void) | source:any,keywords:any,callback:(error:Error)=>void         | Sets keywords for messages. Keywords can be a single keyword or an array of keywords.|
| openBox(mailboxName:string, openReadOnly:boolean, modifiers: Object, callback:(error:Error, mailbox: Connection.Box)=>void) | mailboxName:string, openReadOnly:boolean, modifiers: Object, callback:(error:Error, mailbox: Connection.Box)=>void | Opens a mailbox on the server. The mailbox name should include any necessary prefix or path. Modifiers should be used for IMAP extensions.|
| closeBox(autoExpunge:boolean, callback:(error: Error)=>void) | autoExpunge:boolean, callback:(error: Error)=>void           | Closes the current mailbox. If **autoExpunge** is **true** and the mailbox is not opened in read-only mode, any messages marked as DELETED in the current mailbox will be deleted. If **autoExpunge** is **false**, the mailbox is disconnected or another mailbox is opened, and emails marked as DELETED will not be deleted from the current mailbox.|
| delBox(mailboxName:string,callback:(error:Error)=>void)      | mailboxName:string,callback:(error:Error)=>void              | Removes a mailbox on the server. The mailbox name should include any necessary prefix or path.|
| getBoxes(nsPrefix:string,callback:(error:Error,maiboxes:Connection.MailBoxes)=>void) | nsPrefix:string,callback:(error:Error,maiboxes:Connection.MailBoxes)=>void | Obtains the complete list of mailboxes. If **nsPrefix** is not specified, the primary personal namespace is used. |
| append(msgData:any,options:Connection.AppendOptions,callback:(error:Error)=>void) | msgData:any,options:Connection.AppendOptions,callback:(error:Error)=>void | Appends a message to a mailbox. **msgData** is a string or buffer containing RFC822 compatible MIME messages.|

For more details, see [Official Documentation](https://github.com/mscdex/node-imap/blob/master/README.md) and [Unit Test Cases](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/node-imap/TEST.md).

## Constraints

This project has been verified in the following version:

DevEco Studio: 4.0 Release (4.0.3.413), SDK: API version 10 (4.0.10.3)

The following mailbox types are supported: QQ, Sina, Sohu, and 126 mailboxes.

## Directory Structure

```
|---- node-imap
|     |---- entry  # Sample code
			|----bean # Test data definitions
			|----pages # Page test code
				|----index.ets 			# Entry page
				|----LoginPage.ets 		# Login page
				|----FolderPage.ets 	# Page for operating files
				|----MsgDetailPage.ets	# Page for processing information
			    |----MsgListPage.ets	# Page for processing the information list
			    |----TestPage.ets		# Test scenario page
|     |---- IMAP  # IMAP library folder
|           |---- src  # IMAP library core code
				|----main
					 |----dependecies  # Utility dependecies
					 |----js  	       # IMAP core code
					 |----polyfill     # Dependency on pollyfill
|           |---- index.ets  # External interfaces of the IMAP library
|     |---- README_EN.MD  # Readme
|     |---- README_zh.MD  # Readme
```

## How to Contribute

If you find any problem when using IMAP, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/node-imap/LICENSE).
