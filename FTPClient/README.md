

## FTPClient

## 简介

FTPClient是一个提供FTP/FTPS传输协议的客户端。

## 下载安装

```javascript
ohpm install @ohos/basic-ftp
```

OpenHarmony ohpm
环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)



## 使用说明

```
import { AccessOptions, FileInfo, FileType, FTPResponse, UnixPermissions } from '@ohos/basic-ftp'
import buffer from '@ohos.buffer'
import socket from '@ohos.net.socket';
import NoTlsUtil from '../utils/FtpApiUtil'
```


### 登录FTP服务器

  ```javascript

 let option = {
    ALPNProtocols: ["spdy/1", "http/1.1"],
    address: {
      address: '1.15.87.xx',
      port: 21,
      family: 1
    },
    secureOptions: {
      key: '',
      cert: '',
      ca: [''],
      password: 'xxxxx',
      protocols: [socket.Protocol.TLSv12, socket.Protocol.TLSv13],
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    }
  }

 let loginInfo = {
        host: '1.15.87.x',
        user: 'xxxxxxxx',
        password: 'xxxxxx',
        secure: 'implicit',
        secureOptions: option
      }
  
  ftpUtil.doLogin(loginInfo, {
        onLoginStart(info) {
        },
        onLoginSuccess(result) {        
        },
        onLoginErr(err: Error) {
        }
      })
       
  ```

### 获取文件列表

```javascript
if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          return;
        }
        let startTime1 = new Date().getTime();
        ftpUtil.getCurrentDirectory({
          currentDirectoryErr(err: Error) {
          },
          currentDirectoryStart(info) {
          },
          currentDirectorySuccess(msg) {
            remoteRoot = msg
            let listName = '';
            if (remoteRoot == '' || remoteRoot == '\\' || remoteRoot == '/') {
              listName = ''
            } else {
              listName = msg
            }
            ftpUtil.getList(listName, {
              getListErr(err: Error) {
              },
              getListStart(info) {
              },
              getListSuccess(result: FileInfo[]) {
               
              }
            })

          }
        })
}
```

### 上传单个文件

  ```javascript
if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          operationType = ''
          return
        }
        if (!localUploadFilePath || localUploadFilePath.length < 1) {
          operationType = ''
          return
        }
        if (!remoteRoot || remoteRoot.length < 1) {
          operationType = ''
          return
        }
        inputValue = "clientToServer.txt"
        if (!inputValue || inputValue.length < 1) {
          operationType = ''
          return
        }
        ftpUtil.uploadSingleFile(localUploadFilePath, inputValue, {
          uploadErr(err: Error) {
          },
          uploadStart(info) {
          },
          uploadSuccess(msg: FTPResponse) {
            
          },
          uploadProgress(currentSize: number, totalSize: number) {
          }
        })
}
  ```

### 上传文件夹

```javascript
 if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          operationType = ''
          return
        }
        if (!localUploadFileDir || localUploadFileDir.length < 1) {
          operationType = ''
          return
        }
        if (!remoteRoot || remoteRoot.length < 1) {
          operationType = ''
          return
        }
        inputValue = "client"
        if (!inputValue || inputValue.length < 1) {
          operationType = ''
          return
        }
        let regex = new RegExp(`^(?!_)(?!.*?_$)[a-zA-Z0-9_u4e00-u9fa5]+$`); //正则表达式
        if (!regex.test(inputValue)) {
          operationType = ''
          return
        }
        ftpUtil.uploadDir(localUploadFileDir, inputValue, {
          uploadDirErr(err: Error) {
          },
          uploadDirStart(info) {
          },
          uploadDirSuccess(msg) {
          },
          uploadDirProgress(currentSize: number, totalSize: number) {
          }
        })
}
  ```  

### 下载单个文件

```javascript
 if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          return
        }
        if (!remoteRoot || remoteRoot.length < 1) {
          return
        }
        selectFilePath = "clientToServer.txt";
        if (!selectFilePath || selectFilePath.length < 1) {
          return
        }
        ftpUtil.downloadSingleFile(localPath, selectFilePath, {
          downloadErr(err: Error) {
            expect(0).assertEqual(1)
            done()
          },
          downloadStart(info) {
          },
          downloadSuccess(msg: FTPResponse) {
          },
          downloadProgress(currentSize: number, totalSize: number) {
          }
        })
}
  ```  

### 下载文件夹

```javascript
  if (ftpUtil) {
          if (!ftpUtil.getLogin()) {
            return
          }
          remoteRoot="/"
          if (!remoteRoot || remoteRoot.length < 1) {
            return
          }
          selectDirPath = "client"
          if (!selectDirPath || selectDirPath.length < 1) {
            return
          }
          ftpUtil.downloadDir(localDir, selectDirPath, {
            downloadDirErr(err: Error) {
            },
            downloadDirStart(info) {
            },
            downloadDirSuccess(msg) {
             
            },
            downloadDirProgress(currentSize: number, totalSize: number) {
            }
          })
}
  ```  

### 获取文件大小

```javascript
if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          return
        }
        if (!remoteRoot || remoteRoot.length < 1) {
          return
        }
        selectFilePath = "clientToServer.txt";
        if (!selectFilePath || selectFilePath.length < 1) {
          return
        }
        ftpUtil.getFileSize(selectFilePath, {
          getSizeErr(err: Error) {
          },
          getSizeStart(info) {
          },
          getSizeSuccess(result: number) {
          }
        })
}
  ```  
### 获取服务器能力

```javascript
 if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          return
        }
        ftpUtil.getServerFeatures({
          featuresErr(err: Error) {
          },
          featuresStart(info) {
          },
          featuresSuccess(msg: Map<string, string>) {
          }
        })
}
  ```  
### 获取最后修改时间

```javascript
 if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          return
        }
        if (!remoteRoot || remoteRoot.length < 1) {
          return
        }
        selectFilePath = "clientToServer.txt";

        if (!selectFilePath || selectFilePath.length < 1) {
          return
        }
        ftpUtil.getLastModify(selectFilePath, {
          lastModifyErr(err: Error) {
          },
          lastModifyStart(info) {
          },
          lastModifySuccess(msg: Date) {
          }
        })
 }
  ```    
### 重命名文件

```javascript
  if (ftpUtil) {
          if (!ftpUtil.getLogin()) {
            operationType = ''
            return
          }
          if (!remoteRoot || remoteRoot.length < 1) {
            operationType = ''
            return
          }

          inputValue = "clientToServerNew.txt"
          if (!inputValue || inputValue.length < 1) {
            operationType = ''
            return
          }
          selectFilePath = "clientToServer.txt";

          if (!selectFilePath || selectFilePath.length < 1) {
            return
          }
          ftpUtil.renameFile(inputValue, selectFilePath, {
            renameFileErr(err: Error) {
            },
            renameFileStart(info) {
              operationType = ''
            },
            renameFileSuccess(result: FTPResponse) {
            }
          })
        }
  ``` 
### 切换目录

```javascript
  if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          return
        }
        if (!remoteRoot || remoteRoot.length < 1) {
          return
        }
        ftpUtil.cdToParentDirectory({
          cdToParentDirectoryErr(err: Error) {

          },
          cdToParentDirectoryStart(info) {
          },
          cdToParentDirectorySuccess(res: FTPResponse) {
            
          }
        })
  }
  ``` 
### 确认远端路径

```javascript
  if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          operationType = ''
          return
        }
        if (!remoteRoot || remoteRoot.length < 1) {
          operationType = ''
          return
        }
        inputValue = "client"
        if (!inputValue || inputValue.length < 1) {
          operationType = ''
          return
        }
        let regex = new RegExp(`^(?!_)(?!.*?_$)[a-zA-Z0-9_u4e00-u9fa5]+$`); //正则表达式
        if (!regex.test(inputValue)) {
          operationType = ''
          return
        }
        ftpUtil.ensureRemotePath(inputValue, {
          ensureRemotePathErr(err: Error) {
          
          },
          ensureRemotePathStart(info) {
          },
          ensureRemotePathSuccess(result) {
           
          }
        })
      }
  ``` 
### 删除空目录

```javascript
if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          return
        }
        remoteRoot="/"
        if (!remoteRoot || remoteRoot.length < 1) {
          return
        }
        selectDirPath = "/testempty"
        if (!selectDirPath || selectDirPath.length < 1) {
          return
        }
        let startTime1 = new Date().getTime();
        ftpUtil.deleteEmptyDirectory(selectDirPath, {
          deleteEmptyDirectoryErr(err: Error) {

          },
          deleteEmptyDirectoryStart(info) {
          },
          deleteEmptyDirectorySuccess(result: FTPResponse) {
           
          }
        })
      }
  ``` 
### 删除单个文件

```javascript
 if (ftpUtil) {
          if (!ftpUtil.getLogin()) {
            return
          }
          remoteRoot="/"
          if (!remoteRoot || remoteRoot.length < 1) {
            return
          }
          selectFilePath = "/clientToServerNew.txt";

          if (!selectFilePath || selectFilePath.length < 1) {
            return
          }
          ftpUtil.deleteFile(selectFilePath, {
            deleteFileErr(err: Error) {
            },
            deleteFileStart(info) {
            },
            deleteFileSuccess(msg: FTPResponse) {
            }
          })
}
  ``` 

### 删除所有文件

```javascript
  if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          return
        }
        remoteRoot="/"
        if (!remoteRoot || remoteRoot.length < 1) {
          return
        }
        selectDirPath="/deleteAll"
        if (!selectDirPath || selectDirPath.length < 1) {
          return
        }
        let startTime1 = new Date().getTime();
        ftpUtil.deleteAll(selectDirPath, {
          deleteAllErr(err: Error) {

          },
          deleteAllStart(info) {
          },
          deleteAllSuccess(result) {
           
          }
        })
      }
  ``` 

### 删除当前目录下的所有文件

```javascript
  if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          return
        }
        remoteRoot="/"
        if (!remoteRoot || remoteRoot.length < 1) {
          return
        }
        remoteChildPath="/deleteSelfBuf"
        let startTime1 = new Date().getTime();
        ftpUtil.setWorkingDirectory(remoteChildPath, {
          setWorkingDirectoryErr(err: Error) {
   
          },
          setWorkingDirectoryStart(info) {
          },
          setWorkingDirectorySuccess(result: FTPResponse) {
            ftpUtil.deleteAllButSelf({
              deleteAllButSelfErr(err: Error) {
       
              },
              deleteAllButSelfStart(info) {
              },
              deleteAllButSelfSuccess(result) {

              }
            })
          }
        })
      }
  ``` 

### 设置工作目录

```javascript
   if (ftpUtil) {
        if (!ftpUtil.getLogin()) {
          return
        }
        remoteRoot="/"
        if (!remoteRoot || remoteRoot.length < 1) {
          return
        }
        remoteChildPath="/client"
        if (!remoteChildPath || remoteChildPath.length < 1) {
          return
        }
        ftpUtil.setWorkingDirectory(remoteChildPath, {
          setWorkingDirectoryErr(err: Error) {

          },
          setWorkingDirectoryStart(info) {
          },
          setWorkingDirectorySuccess(result: FTPResponse) {

          }
        })
  }
  ``` 

## 接口说明

### client: Client = new Client(context, timeOut)

| 接口名               | 参数                             | 返回值                | 说明                                       |
| ----------------- | ------------------------------ | ------------------ | ---------------------------------------- |
| access    | AccessOptions                   | FTPResponse | 登录FTP服务器
| list     | string                 | FileInfo | 获取文件列表       |
| size | string                  | number | 获取文件大小                       |
| uploadFrom    | string, string                  | FTPResponse | 上传文件                       |
| downloadTo   | string, string                 | FTPResponse | 下载文件                       |
| features       | 无 | Map<string, string> | 获取服务器能力 |
| cd             | string                             | FTPResponse | 设置工作目录                            |
| cdup               | 无                            | FTPResponse | 切换工作目录                          |
| remove               | string                            | FTPResponse | 删除文件                          |
| lastMod               | string                            | Date | 获取最后修改的时间                          |
| pwd               | 无                            | string | 获取当前目录                          |
| ensureDir               | string                            | void | 确认远程是否存在目录                          |
| removeEmptyDir               | string                            | FTPResponse | 删除空目录                          |
| removeDir               | string                            | void | 删除所有目录和文件                          |
| clearWorkingDir               | 无                            | void | 清理当前目录                          |
| rename               | string, string                            | FTPResponse | 重命名文件                          |
| uploadFromDir               | string, string                            | void | 上传目录                          |
| downloadToDir               | string, string                            | void | 下载目录                          |


## 约束与限制
在下述版本验证通过：
DevEco Studio版本: 4.0 Release(4.0.3.413), SDK: (4.0.10.3)

## 目录结构

```javascript
|---- FTPClient  
|     |---- entry  # 示例代码文件夹
|     |---- BasicFtp  # FTPClient 库文件夹
|     |---- README.MD  # 安装使用方法                   
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [MIT](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/FTPClient/LICENSE.txt) ，请自由地享受和参与开源。