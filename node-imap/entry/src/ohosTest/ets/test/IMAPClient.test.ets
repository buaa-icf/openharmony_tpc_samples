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

import hilog from '@ohos.hilog';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import promptAction from '@ohos.promptAction'
import Imap, { inspect } from '@ohos/node_imap'
import socket from '@ohos.net.socket'
import StatusBean from '../../../main/ets/bean/StatusBean'
import MsgListBean, { MsgListFootBean, MsgListHeadBean } from '../../../main/ets/bean/MsgListBean'

export default function IMAPClientTest() {
  let isLogin = false;
  // let endIndex: number = 10 //当前页
  // let bean: StatusBean = undefined //获取邮件列表之前先获取该文件夹里面的邮件总数和状态
  // let uidList: Array<string> = [] //邮件uid列表
  // let subFolderList: Array<string> = [] //邮件列表数据集合
  // let folderList: Array<string> = [] //邮件列表数据集合
  // let listData: Array<MsgListBean> = [] //邮件列表数据集合
  describe('IMAPClientTest', function () {
    beforeAll(async function (done) {
      try {
        if (!globalThis.client) {
          globalThis.client = new Imap({
            user: 'xxx@xx.com',
            password: 'xxxx',
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
        if (globalThis.client) {
          globalThis.client.once('ready', function () {
            isLogin = true;
            done()
          });

          globalThis.client.once('error', function (err) {
            console.log(err);
            done()
          });

          globalThis.client.once('end', function () {
            console.log('Connection ended');
            done()
          });
          await globalThis.client.connect();
        }
      } catch (err) {
        done()
      }
    })
    it('serverSupports', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let checkResult = globalThis.client.serverSupports('IMAP4');
      expect(checkResult).assertEqual(true)
      done()
    })
    it('getBoxes', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      globalThis.client.getBoxes(function (err, data) {
        if (err) {
          expect(1).assertEqual(2)
          done()
        }
        if (!data || typeof data != 'object') {
          expect(1).assertEqual(2)
          done()
        }
        expect(1).assertEqual(1)
        done()
      })
    })
    it('addBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      try {
        let folderName = 'test' + new Date().getTime();
        globalThis.client.addBox(folderName, (err, result) => {
          if (err) {
            expect(1).assertEqual(2)
            done()
          } else {
            expect(1).assertEqual(1)
            done()
          }
        });

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('delBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      try {
        let folderName = 'test' + new Date().getTime();
        globalThis.client.addBox(folderName, (err, result) => {
          if (err) {
            expect(1).assertEqual(2)
            done()
          } else {
            globalThis.client.delBox(folderName, (err, result) => {
              if (err) {
                expect(1).assertEqual(2)
                done()
              } else {
                expect(1).assertEqual(1)
                done()
              }
            });
          }
        });

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('renameBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      try {
        let folderName = 'test' + new Date().getTime();
        globalThis.client.addBox(folderName, (err, result) => {
          if (err) {
            expect(1).assertEqual(2)
            done()
          } else {
            globalThis.client.renameBox(folderName, 'newFolder', (err, result) => {
              if (err) {
                expect(1).assertEqual(2)
                done()
              } else {
                globalThis.client.delBox('newFolder', (err, result) => {
                  if (err) {
                    expect(1).assertEqual(2)
                    done()
                  } else {
                    expect(1).assertEqual(1)
                    done()
                  }
                });
              }
            });
          }
        });

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('subscribeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      try {
        let folderName = 'test' + new Date().getTime();
        globalThis.client.addBox(folderName, (err, result) => {
          if (err) {
            expect(1).assertEqual(2)
            done()
          } else {
            globalThis.client.subscribeBox(folderName, (err, result) => {
              if (err) {
                expect(1).assertEqual(2)
                done()
              } else {
                expect(1).assertEqual(1)
                done()
              }
            });
          }
        });

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('unsubscribeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      try {
        let folderName = 'test' + new Date().getTime();
        globalThis.client.addBox(folderName, (err, result) => {
          if (err) {
            expect(1).assertEqual(2)
            done()
          } else {
            globalThis.client.subscribeBox(folderName, (err, result) => {
              if (err) {
                expect(1).assertEqual(2)
                done()
              } else {
                globalThis.client.unsubscribeBox(folderName, (err, result) => {
                  if (err) {
                    expect(1).assertEqual(2)
                    done()
                  } else {
                    expect(1).assertEqual(1)
                    done()
                  }
                });
              }
            });
          }
        });

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('getSubscribedBoxes', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      try {
        globalThis.client.getSubscribedBoxes((err, result) => {
          if (err) {
            expect(1).assertEqual(2)
            done()
          } else {
            expect(1).assertEqual(1)
            done()
          }
        });

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('status', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            expect(1).assertEqual(1)
            done()
          })
        })


      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('openBox_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              globalThis.client.closeBox((err, result) => {
                if (err) {
                  expect(1).assertEqual(2)
                  done()
                } else {
                  expect(1).assertEqual(1)
                  done()
                }
              });
            });
          })
        })
      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('fetch_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              let buffer = ''
              var f = globalThis.client.seq.fetch(`1:10`, {
                bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                struct: true
              });
              f.on('message', function (msg, seqno) {
                msg.on('body', function (stream, info) {

                  stream.on('data', function (chunk) {
                    buffer += chunk.toString('utf8');
                  });
                  stream.once('end', function () {
                  });
                });
                msg.once('attributes', function (attrs) {
                });
                msg.once('end', function () {
                });
              });
              f.once('error', function (err) {
                expect(1).assertEqual(2)
                done()
              });
              f.once('end', function () {
                console.log('Done fetching all messages!');
                if (buffer && buffer.length > 1) {
                  globalThis.client.closeBox((err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      expect(1).assertEqual(1)
                      done()
                    }
                  });
                } else {
                  expect(1).assertEqual(0)
                  done()
                }

              });

            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('addFlags_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              var f = globalThis.client.seq.fetch(`1`, {
                bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                struct: true
              });
              f.on('message', function (msg, seqno) {
                msg.on('body', function (stream, info) {

                  stream.on('data', function (chunk) {
                  });
                  stream.once('end', function () {
                  });
                });
                msg.once('attributes', function (attrs) {
                  if (attrs && typeof attrs === 'object') {
                    let uid = attrs['uid'] ? attrs['uid'] : ''
                    uidList.push(uid);
                  }
                });
                msg.once('end', function () {
                });
              });
              f.once('error', function (err) {
                expect(1).assertEqual(2)
                done()
              });
              f.once('end', function () {
                console.log('Done fetching all messages!');
                if (uidList && uidList.length >= 1 && uidList[0]) {
                  globalThis.client.addFlags(uidList[0], '\\Seen', (err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      globalThis.client.closeBox((err, result) => {
                        if (err) {
                          expect(1).assertEqual(2)
                          done()
                        } else {
                          expect(1).assertEqual(1)
                          done()
                        }
                      });
                    }
                  });
                } else {
                  expect(1).assertEqual(0)
                  done()
                }

              });

            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('setFlags_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              var f = globalThis.client.seq.fetch(`1`, {
                bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                struct: true
              });
              f.on('message', function (msg, seqno) {
                msg.on('body', function (stream, info) {

                  stream.on('data', function (chunk) {
                  });
                  stream.once('end', function () {
                  });
                });
                msg.once('attributes', function (attrs) {
                  if (attrs && typeof attrs === 'object') {
                    let uid = attrs['uid'] ? attrs['uid'] : ''
                    uidList.push(uid);
                  }
                });
                msg.once('end', function () {
                });
              });
              f.once('error', function (err) {
                expect(1).assertEqual(2)
                done()
              });
              f.once('end', function () {
                console.log('Done fetching all messages!');
                if (uidList && uidList.length >= 1 && uidList[0]) {
                  globalThis.client.setFlags(uidList[0], '\\Seen', (err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      globalThis.client.closeBox((err, result) => {
                        if (err) {
                          expect(1).assertEqual(2)
                          done()
                        } else {
                          expect(1).assertEqual(1)
                          done()
                        }
                      });
                    }
                  });
                } else {
                  expect(1).assertEqual(0)
                  done()
                }

              });

            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('delFlags_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              var f = globalThis.client.seq.fetch(`1`, {
                bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                struct: true
              });
              f.on('message', function (msg, seqno) {
                msg.on('body', function (stream, info) {

                  stream.on('data', function (chunk) {
                  });
                  stream.once('end', function () {
                  });
                });
                msg.once('attributes', function (attrs) {
                  if (attrs && typeof attrs === 'object') {
                    let uid = attrs['uid'] ? attrs['uid'] : ''
                    uidList.push(uid);
                  }
                });
                msg.once('end', function () {
                });
              });
              f.once('error', function (err) {
                expect(1).assertEqual(2)
                done()
              });
              f.once('end', function () {
                console.log('Done fetching all messages!');
                if (uidList && uidList.length >= 1 && uidList[0]) {
                  globalThis.client.delFlags(uidList[0], '\\Seen', (err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      globalThis.client.closeBox((err, result) => {
                        if (err) {
                          expect(1).assertEqual(2)
                          done()
                        } else {
                          expect(1).assertEqual(1)
                          done()
                        }
                      });
                    }
                  });
                } else {
                  expect(1).assertEqual(0)
                  done()
                }

              });

            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('addKeywords_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              var f = globalThis.client.seq.fetch(`1`, {
                bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                struct: true
              });
              f.on('message', function (msg, seqno) {
                msg.on('body', function (stream, info) {

                  stream.on('data', function (chunk) {
                  });
                  stream.once('end', function () {
                  });
                });
                msg.once('attributes', function (attrs) {
                  if (attrs && typeof attrs === 'object') {
                    let uid = attrs['uid'] ? attrs['uid'] : ''
                    uidList.push(uid);
                  }
                });
                msg.once('end', function () {
                });
              });
              f.once('error', function (err) {
                expect(1).assertEqual(2)
                done()
              });
              f.once('end', function () {
                console.log('Done fetching all messages!');
                if (uidList && uidList.length >= 1 && uidList[0]) {
                  globalThis.client.addKeywords(uidList[0], 'testKeyWords', (err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      globalThis.client.closeBox((err, result) => {
                        if (err) {
                          expect(1).assertEqual(2)
                          done()
                        } else {
                          expect(1).assertEqual(1)
                          done()
                        }
                      });
                    }
                  });
                } else {
                  expect(1).assertEqual(0)
                  done()
                }

              });

            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('setKeywords_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              var f = globalThis.client.seq.fetch(`1`, {
                bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                struct: true
              });
              f.on('message', function (msg, seqno) {
                msg.on('body', function (stream, info) {

                  stream.on('data', function (chunk) {
                  });
                  stream.once('end', function () {
                  });
                });
                msg.once('attributes', function (attrs) {
                  if (attrs && typeof attrs === 'object') {
                    let uid = attrs['uid'] ? attrs['uid'] : ''
                    uidList.push(uid);
                  }
                });
                msg.once('end', function () {
                });
              });
              f.once('error', function (err) {
                expect(1).assertEqual(2)
                done()
              });
              f.once('end', function () {
                console.log('Done fetching all messages!');
                if (uidList && uidList.length >= 1 && uidList[0]) {
                  globalThis.client.setKeywords(uidList[0], 'testKeyWords', (err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      globalThis.client.closeBox((err, result) => {
                        if (err) {
                          expect(1).assertEqual(2)
                          done()
                        } else {
                          expect(1).assertEqual(1)
                          done()
                        }
                      });
                    }
                  });
                } else {
                  expect(1).assertEqual(0)
                  done()
                }

              });

            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('delKeywords_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              var f = globalThis.client.seq.fetch(`1`, {
                bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                struct: true
              });
              f.on('message', function (msg, seqno) {
                msg.on('body', function (stream, info) {

                  stream.on('data', function (chunk) {
                  });
                  stream.once('end', function () {
                  });
                });
                msg.once('attributes', function (attrs) {
                  if (attrs && typeof attrs === 'object') {
                    let uid = attrs['uid'] ? attrs['uid'] : ''
                    uidList.push(uid);
                  }
                });
                msg.once('end', function () {
                });
              });
              f.once('error', function (err) {
                expect(1).assertEqual(2)
                done()
              });
              f.once('end', function () {
                console.log('Done fetching all messages!');
                if (uidList && uidList.length >= 1 && uidList[0]) {
                  globalThis.client.delKeywords(uidList[0], 'testKeyWords', (err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      globalThis.client.closeBox((err, result) => {
                        if (err) {
                          expect(1).assertEqual(2)
                          done()
                        } else {
                          expect(1).assertEqual(1)
                          done()
                        }
                      });
                    }
                  });
                } else {
                  expect(1).assertEqual(0)
                  done()
                }

              });

            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('expunge_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              var f = globalThis.client.seq.fetch(`1`, {
                bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                struct: true
              });
              f.on('message', function (msg, seqno) {
                msg.on('body', function (stream, info) {

                  stream.on('data', function (chunk) {
                  });
                  stream.once('end', function () {
                  });
                });
                msg.once('attributes', function (attrs) {
                  if (attrs && typeof attrs === 'object') {
                    let uid = attrs['uid'] ? attrs['uid'] : ''
                    uidList.push(uid);
                  }
                });
                msg.once('end', function () {
                });
              });
              f.once('error', function (err) {
                expect(1).assertEqual(2)
                done()
              });
              f.once('end', function () {
                console.log('Done fetching all messages!');
                if (uidList && uidList.length >= 1 && uidList[0]) {
                  let uid = uidList[0]
                  globalThis.client.addFlags(uid, '\\Deleted', (err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      globalThis.client.expunge(uid, (err, result) => {
                        if (err) {
                          expect(1).assertEqual(2)
                          done()
                        } else {
                          globalThis.client.closeBox((err, result) => {
                            if (err) {
                              expect(1).assertEqual(2)
                              done()
                            } else {
                              expect(1).assertEqual(1)
                              done()
                            }
                          });
                        }
                      });
                    }
                  });
                } else {
                  expect(1).assertEqual(0)
                  done()
                }
              });
            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('search_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              globalThis.client.search(['RECENT'], (err, result) => {
                if (err) {
                  expect(1).assertEqual(2)
                  done()
                } else {
                  globalThis.client.closeBox((err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      expect(1).assertEqual(1)
                      done()
                    }
                  });
                }
              });
            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('sort_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
              break;
            }
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              try{
                globalThis.client.sort(['DATE'], ['ALL'], (err, result) => {
                  if (err) {
                    expect(1).assertEqual(2)
                    done()
                  }else {
                    globalThis.client.closeBox((err, result) => {
                      if (err) {
                        expect(1).assertEqual(2)
                        done()
                      } else {
                        expect(1).assertEqual(1)
                        done()
                      }
                    });
                  }
                });
              }catch (err){
                if (err && err.message == 'Sort is not supported on the server') {
                  expect(1).assertEqual(1)
                  done()
                }else {
                  expect(1).assertEqual(2)
                  done()
                }
                globalThis.client.closeBox((err, result) => {
                  if (err) {
                    expect(1).assertEqual(2)
                    done()
                  } else {
                    expect(1).assertEqual(1)
                    done()
                  }
                });
              }
            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('copy_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          let selectFoler = ''
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
            }
            selectFoler = key
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              var f = globalThis.client.seq.fetch(`1`, {
                bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                struct: true
              });
              f.on('message', function (msg, seqno) {
                msg.on('body', function (stream, info) {

                  stream.on('data', function (chunk) {
                  });
                  stream.once('end', function () {
                  });
                });
                msg.once('attributes', function (attrs) {
                  if (attrs && typeof attrs === 'object') {
                    let uid = attrs['uid'] ? attrs['uid'] : ''
                    uidList.push(uid);
                  }
                });
                msg.once('end', function () {
                });
              });
              f.once('error', function (err) {
                expect(1).assertEqual(2)
                done()
              });
              f.once('end', function () {
                console.log('Done fetching all messages!');
                if (uidList && uidList.length >= 1 && uidList[0]) {
                  let uid = uidList[0];
                  globalThis.client.copy(uid, selectFoler, (err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      globalThis.client.closeBox((err, result) => {
                        if (err) {
                          expect(1).assertEqual(2)
                          done()
                        } else {
                          expect(1).assertEqual(1)
                          done()
                        }
                      });
                    }
                  });
                } else {
                  expect(1).assertEqual(0)
                  done()
                }
              });
            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('move_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      let uidList: Array<string> = []
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasInbox = false;
          let selectFoler = ''
          for (let key in data) {
            if (key === 'INBOX') {
              hasInbox = true;
            }
            selectFoler = key
          }
          if (!hasInbox) {
            expect(1).assertEqual(2)
            done()
          }
          globalThis.client.status('INBOX', function (err, data) {
            if (err) {
              expect(1).assertEqual(2)
              done()
            }
            if (!data || data.length < 1) {
              expect(1).assertEqual(2)
              done()
            }
            globalThis.client.openBox('INBOX', true, function (err, box) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              var f = globalThis.client.seq.fetch(`1`, {
                bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                struct: true
              });
              f.on('message', function (msg, seqno) {
                msg.on('body', function (stream, info) {

                  stream.on('data', function (chunk) {
                  });
                  stream.once('end', function () {
                  });
                });
                msg.once('attributes', function (attrs) {
                  if (attrs && typeof attrs === 'object') {
                    let uid = attrs['uid'] ? attrs['uid'] : ''
                    uidList.push(uid);
                  }
                });
                msg.once('end', function () {
                });
              });
              f.once('error', function (err) {
                expect(1).assertEqual(2)
                done()
              });
              f.once('end', function () {
                console.log('Done fetching all messages!');
                if (uidList && uidList.length >= 1 && uidList[0]) {
                  let uid = uidList[0];
                  globalThis.client.move(uid, selectFoler, (err, result) => {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    } else {
                      globalThis.client.closeBox((err, result) => {
                        if (err) {
                          expect(1).assertEqual(2)
                          done()
                        } else {
                          expect(1).assertEqual(1)
                          done()
                        }
                      });
                    }
                  });
                } else {
                  expect(1).assertEqual(0)
                  done()
                }

              });


            });
          })
        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('append_closeBox', 0, function (done) {
      if (!globalThis.client || !isLogin) {
        expect(1).assertEqual(2)
        done()
      }
      try {
        globalThis.client.getBoxes(function (err, data) {
          if (err) {
            expect(1).assertEqual(2)
            done()
          }
          if (!data || typeof data != 'object') {
            expect(1).assertEqual(2)
            done()
          }
          let hasUploadBox = false;
          let selectFoler = 'uploadMail'
          for (let key in data) {
            if (key.toString() === selectFoler) {
              hasUploadBox = true;
              break;
            }

          }
          if (!hasUploadBox) {
            globalThis.client.addBox(selectFoler, (err, result) => {
              if (err) {
                expect(1).assertEqual(2)
                done()
              } else {
                globalThis.client.status(selectFoler, function (err, data) {
                  if (err) {
                    expect(1).assertEqual(2)
                    done()
                  }
                  if (!data || data.length < 1) {
                    expect(1).assertEqual(2)
                    done()
                  }
                  globalThis.client.openBox(selectFoler, true, function (err, box) {
                    if (err) {
                      expect(1).assertEqual(2)
                      done()
                    }
                    let msg = {
                      text: 'IMAP协议测试上传的邮件',
                      from: `${'鸿蒙搬砖工'} <${'xxx@xxx.com'}>`,
                      to: 'xxx@xxxx.com',
                      cc: 'xxx@xxx.com',
                      bcc: 'xxx@xxx.com',
                      subject: '鸿蒙客户端IMAP协议的主题'
                    }
                    let data = JSON.stringify(msg);
                    let option = {
                      mailbox: 'INBOX',
                      flag: ['Seen'], //取值 Seen flagged等
                      date: new Date(),
                    }
                    globalThis.client.append(data, option, (err, result) => {
                      if (err) {
                        expect(1).assertEqual(2)
                        done()
                      } else {
                        globalThis.client.closeBox((err, result) => {
                          if (err) {
                            expect(1).assertEqual(2)
                            done()
                          } else {
                            expect(1).assertEqual(1)
                            done()
                          }
                        });
                      }
                    });

                  });
                })
              }
            });
          } else {
            globalThis.client.status(selectFoler, function (err, data) {
              if (err) {
                expect(1).assertEqual(2)
                done()
              }
              if (!data || data.length < 1) {
                expect(1).assertEqual(2)
                done()
              }
              globalThis.client.openBox(selectFoler, true, function (err, box) {
                if (err) {
                  expect(1).assertEqual(2)
                  done()
                }
                let msg = {
                  text: 'IMAP协议测试上传的邮件',
                  from: `${'鸿蒙搬砖工'} <${'xxx@xx.com'}>`,
                  to: 'xxx@xx.com',
                  cc: 'xxx@xxx.com',
                  bcc: 'xxx@xxx.com',
                  subject: '鸿蒙客户端IMAP协议的主题'
                }
                let data = JSON.stringify(msg);
                let option = {
                  mailbox: 'INBOX',
                  flag: ['Seen'], //取值 Seen flagged等
                  date: new Date(),
                }
                globalThis.client.append(data, option, (err, result) => {
                  if (err) {
                    expect(1).assertEqual(2)
                    done()
                  } else {
                    globalThis.client.closeBox((err, result) => {
                      if (err) {
                        expect(1).assertEqual(2)
                        done()
                      } else {
                        expect(1).assertEqual(1)
                        done()
                      }
                    });
                  }
                });

              });
            })
          }

        })

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
    it('end', 0, function (done) {
      try {
        if (!globalThis.client || !isLogin) {
          expect(1).assertEqual(2)
          done()
        }
        globalThis.client.end(() => {
          isLogin = false;
          expect(1).assertEqual(1)
          done()
        });

      } catch (err) {
        expect(1).assertEqual(2)
        done()
      }
    })
  })
}