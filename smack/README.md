# Smack
## 简介
>Smack是一个基于XMPP协议的一个聊天客户端

## 效果展示
![效果展示](image/sample.gif)

## 下载安装
```
npm install @ohos/smack --save
```
OpenHarmony npm环境配置等更多内容，请参考 [如何安装OpenHarmony npm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_npm_usage.md) 。


## 使用说明

1. 创建后台服务
```
通过https://igniterealtime.org/downloads/地址下载最新版的Openfire并安装作为服务器
```


2. 在页面添加引用并设置服务信息

 ```
添加引用：import { Smack } from '@ohos/smack'
设置服务信息，如Constant.ets类中的设置：
static HOST_IP: string = "10.50.40.65"
static HOST_DOMAIN: string = "he-202101111234"
 ```

3. 调用方法

 ```
  1. 注册用户 globalThis.Smack.registers("dongpo_003","test2");
  2. 注销用户 globalThis.Smack.unregister();
  3. 用户登录 globalThis.Smack.Login(this.userName + '@' + Constant.HOST_IP, this.passWord);
  4. 用户登出 globalThis.Smack.loginout();
  5. 修改密码 globalThis.Smack.changPwd('123456')
  6. 设置用户状态（空闲、在线、离开等） globalThis.Smack.changePresence(presenceType, this.states[this.select]);
  7. 发送消息 globalThis.Smack.send(userName, msg)
  8. 接收消息 globalThis.Smack.registerMessageCallback((id, msg)=>{})
  9. 添加好友到指定分组 globalThis.Smack.addFriends(this.name + "@" + Constant.HOST_DOMAIN, this.name, this.group);
  10. 删除好友 globalThis.Smack.delfriend(this.userName + '@' + Constant.HOST_IP);
  11. 好友列表 globalThis.Smack.getFriendList();
  12. 更改分组名称 globalThis.Smack.changeGroup(this.oldName, this.newName);
  13. 更改好友分组 globalThis.Smack.changeFriendGroup(name + "@" + Constant.HOST_DOMAIN, this.newGroup);
  14. 创建群聊群组 globalThis.Smack.createRoom("444@"+Constant.HOST_IP+Constant.HOST_RES, "room1", Constant.HOST_DOMAIN, Constant.SERVICE_NAME);
  15. 加入群组 globalThis.Smack.join(); 
  16. 离开群组 globalThis.Smack.leave("leave msg");
  17. 发送群组消息 globalThis.Smack.sendGroupMessage("group msg test");
  18. 设置群组主题 globalThis.Smack.setSubject("subject");
  19. 销毁群组 globalThis.Smack.destroy("444@"+Constant.HOST_IP+Constant.HOST_RES, "123");
  20. 踢出群组 globalThis.Smack.kick("555", "kick");
  21. 踢出群组并拉进黑名单 globalThis.Smack.ban("555", "ban");
  22. 授予发言权限 globalThis.Smack.grantVoice("555", "grantVoice");
  23. 移除发言权限 globalThis.Smack.revokeVoice("555", "revokeVoice");
  24. 岗位设置 globalThis.Smack.setAffiliation("555", MUCRoomAffiliation.AffiliationOwner, "AffiliationOwner");
  25. 角色设置 RoleModerator globalThis.Smack.setRole("888", MUCRoomRole.RoleModerator, "RoleModerator");
  26. 邀请成员 globalThis.Smack.invite("777"+this.service, "invite");
  27. 获取全部群组成员 globalThis.Smack.getRoomItems();
  28. 过滤群组成员 globalThis.Smack.requestList(MUCOperation.RequestOwnerList);
  29. 拒绝加入群组 globalThis.Smack.declineInvitation("888_room@"+Constant.SERVICE_NAME+"."+Constant.HOST_DOMAIN, "888@"+Constant.HOST_DOMAIN, "room inviation refuesd");
  30. 创建并加入群组 globalThis.Smack.createOrJoinRoom("room4", Constant.HOST_DOMAIN, Constant.SERVICE_NAME, "123");
  31. 加入密码群组时使用密码 globalThis.Smack.setPassword("123123");
  32. 获取加入群聊的群组信息 globalThis.Smack.getRoomInfo();
  33. 获取群组配置 globalThis.Smack.requestRoomConfig();
  34. 设置群聊配置 globalThis.Smack.setRoomConfig(JSON.stringify(this.roomConfig));
  35. 从该聊天室踢出用户群 globalThis.Smack.bans("888,555", "bans");
  36. 更改聊天室成员的昵称 globalThis.Smack.setNick("new_nike_name");
  37. 目前是否在多人聊天中 globalThis.Smack.isJoined();
  38. 返回房间里用户的昵称 globalThis.Smack.nick();
  39. 是否连接 globalThis.Smack.isConnected();
  40. 用户名称 globalThis.Smack.username();
  41. 建立连接 globalThis.Smack.connect();
  42. 设置域名或ip globalThis.Smack.setServer(Constant.HOST_IP);
  43. 输入用户名和密码 globalThis.Smack.setUsernameAndPassword("zhang", "123456");
  44. 设置端口号 globalThis.Smack.setPort(Constant.HOST_PORT);
  45. 获取密码 globalThis.Smack.password();
  46. 设置Resource globalThis.Smack.setResource(Constant.HOST_RES.replace("/",""));
  47. 多人角色设置 globalThis.Smack.setRoles(this.getUsers(), MUCRoomRole.RoleParticipant, "RoleParticipant");
  48. 多人语音授权 globalThis.Smack.grantVoices(this.getUsers(), "grantVoices");
  49. 多人语音授权撤销 globalThis.Smack.revokeVoices(this.getUsers(), "revokeVoices");
  50. 多人从属关系设置 globalThis.Smack.setAffiliations("555,333", MUCRoomAffiliation.AffiliationOwner, "AffiliationOwner");
  51. 获取端口号 globalThis.Smack.port();
  52. 获取ip或域名 globalThis.Smack.server();
  53. 接受好友添加请求 globalThis.Smack.receiveFriends("444@"+Constant.HOST_DOMAIN, "group", msg: "accept")
  54. 拒绝好友添加请求 globalThis.Smack.rejectFriends("444@"+Constant.HOST_DOMAIN, “reject”)
  
 ```


## 接口说明

1. 注册用户 `globalThis.Smack.registers("dongpo_003","test2");`
2. 注销用户 `globalThis.Smack.unregister();`
3. 用户登录 `globalThis.Smack.Login(this.userName + '@' + Constant.HOST_IP, this.passWord);`
4. 用户登出 `globalThis.Smack.loginout();`
5. 修改密码 `globalThis.Smack.changPwd('123456')`
6. 设置用户状态（空闲、在线、离开等） `globalThis.Smack.changePresence(presenceType, this.states[this.select]);`
7. 发送消息 `globalThis.Smack.send(userName, msg)`
8. 接收消息 `globalThis.Smack.registerMessageCallback((id, msg)=>{})`
9. 添加好友到指定分组 `globalThis.Smack.addFriends(this.name + "@" + Constant.HOST_DOMAIN, this.name, this.group);`
10. 删除好友 `globalThis.Smack.delfriend(this.userName + '@' + Constant.HOST_IP);`
11. 好友列表 `globalThis.Smack.getFriendList();`
12. 更改分组名称 `globalThis.Smack.changeGroup(this.oldName, this.newName);`
13. 更改好友分组 `globalThis.Smack.changeFriendGroup(name + "@" + Constant.HOST_DOMAIN, this.newGroup);`
14. 创建群聊群组 `globalThis.Smack.createRoom("444@"+Constant.HOST_IP+Constant.HOST_RES, "room1", Constant.HOST_DOMAIN, Constant.SERVICE_NAME);`
15. 加入群组 `globalThis.Smack.join();`
16. 离开群组 `globalThis.Smack.leave("leave msg");`
17. 发送群组消息 `globalThis.Smack.sendGroupMessage("group msg test");`
18. 设置群组主题 `globalThis.Smack.setSubject("subject");`
19. 销毁群组 `globalThis.Smack.destroy("444@"+Constant.HOST_IP+Constant.HOST_RES, "123");`
20. 踢出群组 `globalThis.Smack.kick("555", "kick");`
21. 踢出群组并拉进黑名单 `globalThis.Smack.ban("555", "ban");`
22. 授予发言权限 `globalThis.Smack.grantVoice("555", "grantVoice");`
23. 移除发言权限 `globalThis.Smack.revokeVoice("555", "revokeVoice");`
24. 岗位设置 `globalThis.Smack.setAffiliation("555", MUCRoomAffiliation.AffiliationOwner, "AffiliationOwner");`
25. 角色设置 `RoleModerator globalThis.Smack.setRole("888", MUCRoomRole.RoleModerator, "RoleModerator");`
26. 邀请成员 `globalThis.Smack.invite("777"+this.service, "invite");`
27. 获取全部群组成员 `globalThis.Smack.getRoomItems();`
28. 过滤群组成员 `globalThis.Smack.requestList(MUCOperation.RequestOwnerList);`
29. 拒绝加入群组 `globalThis.Smack.declineInvitation("888_room@"+Constant.SERVICE_NAME+"."+Constant.HOST_DOMAIN, "888@"+Constant.HOST_DOMAIN, "room inviation refuesd");`
30. 创建并加入群组 `globalThis.Smack.createOrJoinRoom("room4", Constant.HOST_DOMAIN, Constant.SERVICE_NAME, "123");`
31. 加入密码群组时使用密码 `globalThis.Smack.setPassword("123123");`
32. 获取加入群聊的群组信息 `globalThis.Smack.getRoomInfo();`
33. 获取群组配置 `globalThis.Smack.requestRoomConfig();`
34. 设置群聊配置 `globalThis.Smack.setRoomConfig(JSON.stringify(this.roomConfig));`
35. 从该聊天室踢出用户群 `globalThis.Smack.bans("888,555", "bans");`
36. 更改聊天室成员的昵称 `globalThis.Smack.setNick("new_nike_name");`
37. 目前是否在多人聊天中 `globalThis.Smack.isJoined();`
38. 返回房间里用户的昵称 `globalThis.Smack.nick();`
39. 是否连接 `globalThis.Smack.isConnected();`
40. 用户名称 `globalThis.Smack.username();`
41. 建立连接 `globalThis.Smack.connect();`
42. 设置域名或ip `globalThis.Smack.setServer(Constant.HOST_IP);`
43. 输入用户名和密码 `globalThis.Smack.setUsernameAndPassword("zhang", "123456");`
44. 设置端口号 `globalThis.Smack.setPort(Constant.HOST_PORT);`
45. 获取密码 `globalThis.Smack.password();`
46. 设置Resource `globalThis.Smack.setResource(Constant.HOST_RES.replace("/",""));`
47. 多人角色设置 `globalThis.Smack.setRoles(this.getUsers(), MUCRoomRole.RoleParticipant, "RoleParticipant");`
48. 多人语音授权 `globalThis.Smack.grantVoices(this.getUsers(), "grantVoices");`
49. 多人语音授权撤销 `globalThis.Smack.revokeVoices(this.getUsers(), "revokeVoices");`
50. 多人从属关系设置 `globalThis.Smack.setAffiliations("555,333", MUCRoomAffiliation.AffiliationOwner, "AffiliationOwner");`
51. 获取端口号 `globalThis.Smack.port();`
52. 获取ip或域名 `globalThis.Smack.server();`
53. 接受好友添加请求 `globalThis.Smack.receiveFriends("444@"+Constant.HOST_DOMAIN, "group", msg: "accept")`
54. 拒绝好友添加请求 `globalThis.Smack.rejectFriends("444@"+Constant.HOST_DOMAIN, “reject”)`


## 兼容性
支持 OpenHarmony API version 9 及以上版本。

## 目录结构
```
|---- smack  
|     |---- entry  # 示例代码文件夹
|     |---- smack  # smack库文件夹
|               |----cpp # C++代码文件夹
|                    |----gloox # C++代码实现文件夹
|                    |----types # 对外接口
|               |----ets # 对外接口
|           |---- index.ets  # 对外接口
|     |---- README.MD  # 安装使用方法
```

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/hihopeorg/smack/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/hihopeorg/smack/pulls) 。

## 开源协议
本项目基于 [Apache License 2.0](https://gitee.com/hihopeorg/smack/blob/master/LICENSE) ，请自由地享受和参与开源。