/*
  Copyright (C) 2022 Huawei Device Co., Ltd.

  This software is distributed under a license. The full license
  agreement can be found in the file LICENSE in this distribution.
  This software may not be copied, modified, sold or distributed
  other than expressed in the named license agreement.
  This software is distributed without any warranty.
*/

#include <string>
#include <thread>
#include <src/base64.h>
#include <src/message.h>
#include <unistd.h>
#include "Smack.h"
#include <ctime>
#include "gloox/src/disco.h"

#include "log.h"
#include "src/gloox.h"

/**
 *
 * @param jidStr 当前登陆用的地址 例如：user@10.50.40.65/gloox
 * @param pwd  当前用户的登陆密码
 *
 * 注：当前的返回值没有添加
 *  返回-1 表示登陆失败
 *  返回 1 表示登陆成功
 */
int UserState = -1;
void delay_msec(int msec) {
    clock_t now = clock();
    while (clock() - now < msec)
        ;
}

Smack::Smack() {
    j = new Client("");
};
bool Smack::connect() {
    if (userName == "" || userName.empty()) {
        throw "userName empty,set userName!!!";
    }
    std::string server = j->server();
    if (server == "" || server.empty()) {
        throw "server empty,set server!!!";
    }
    std::string resource = j->resource();
    if (resource.empty()) {
        throw "resource empty,set resource!!!";
    }
    JID jids(userName + "@" + server + "/" + resource);
    j->setJID(jids);
    j->registerConnectionListener(this);

    j->logInstance().registerLogHandler(LogLevelDebug, LogAreaAll, this);
    if (j->connect(false)) {
    }
    return isConnected();
}

bool Smack::isConnected() {
    ConnectionState state = j->state();
     return state >= StateConnected;
}

std::string Smack::username() {
    return j->username();
}
void Smack::setServer(const std::string &server) {
    j->setServer(server);
}

void Smack::setUsernameAndPassword(std::string username, std::string pwd) {
    userName = username;
    setPassword(pwd);
}

void Smack::setPassword(const std::string &password) {
    j->setPassword(password);
}

void Smack::setPort(int port) {
    j->setPort(port);
}
std::string Smack::password() {
    return j->password();
}

std::string Smack::resource() {
    return j->resource();
}
void Smack::setResource(const std::string &resource) {
    j->setResource(resource);
}
JID &Smack::getMyJID() {
    return m_jid;
}
Client *Smack::getClent() {
    return j;
}
bool Smack::login() {
    //Registration
    m_reg = new Registration(j);
    m_reg->registerRegistrationHandler(this);

    MUCInvitationHandler *handler = new MyMUCInvitationHandler(j);
    //注册房间邀请监听
    j->registerMUCInvitationHandler(handler);

    //rosterManager
    j->rosterManager()->registerRosterListener(this);

    j->registerSubscriptionHandler(this);

    j->registerPresenceHandler(this);
    j->registerMessageHandler(this);
    j->registerMessageSessionHandler(this, 0);
    //    j->logInstance().registerLogHandler( LogLevelDebug, LogAreaAll, this );
    j->disco()->setVersion("messageTest", GLOOX_VERSION, "OHOS");
    j->disco()->setIdentity("client", "bot");
    j->disco()->addFeature(XMLNS_CHAT_STATES);

    {
        std::thread t1(&Smack::loop, this);
        t1.detach();
    }

    delay_msec(5 * 1000 * 60); //延时5秒
    return presenceType == 0;
}
std::string Smack::server() {
    return j->server();
}
int Smack::authed() {
    return j->authed() ? 1 : 0;
}
int Smack::port() {
    return j->port();
}
int Smack::compression() {
    return j->compression() ? 1 : 0;
}

int Smack::login(const std::string &jidStr, const std::string &pwd) {
    UserState = -1;

    JID jid(jidStr);
    m_jid = jid;
    j = new Client(jid, pwd);

    j->registerConnectionListener(this);

    //Registration
    m_reg = new Registration(j);
    m_reg->registerRegistrationHandler(this);

    MUCInvitationHandler *handler = new MyMUCInvitationHandler(j);
    //注册房间邀请监听
    j->registerMUCInvitationHandler(handler);

    //rosterManager
    j->rosterManager()->registerRosterListener(this);

    j->registerSubscriptionHandler(this);

    j->registerPresenceHandler(this);
    j->registerMessageHandler(this);
    j->registerMessageSessionHandler(this, 0);
    j->logInstance().registerLogHandler(LogLevelDebug, LogAreaAll, this);
    j->disco()->setVersion("messageTest", GLOOX_VERSION, "OHOS");
    j->disco()->setIdentity("client", "bot");
    j->disco()->addFeature(XMLNS_CHAT_STATES);

    bool value = j->connect(false);
    if (value) {
        std::thread t1(&Smack::loop, this);
        t1.detach();
    }
    delay_msec(5 * 1000 * 500);

    return UserState;
}

/**
 * 修改用户状态
 * @param pres
 * @param priority
 * @param status
 */
void Smack::changePresence(const std::string &statusType, const std::string &status) {
    if (statusType.compare("0") == 0) {
        j->setPresence(Presence::PresenceType::Chat, 50, status);
    } else if (statusType.compare("1") == 0) {
        j->setPresence(Presence::PresenceType::Available, 50, status);
    } else if (statusType.compare("2") == 0) {
        j->setPresence(Presence::PresenceType::Away, 50, status);
    } else if (statusType.compare("3") == 0) {
        j->setPresence(Presence::PresenceType::XA, 50, status);
    } else if (statusType.compare("4") == 0) {
        j->setPresence(Presence::PresenceType::DND, 50, status);
    }
}

/**
 * 获取好友以及分组信息
 * @param jidStr
 */
std::string Smack::getFriendList() {
    RosterManager *rosterManager = j->rosterManager();
    Roster *roster = rosterManager->roster();
    Roster::const_iterator it = roster->begin();
    std::string name;
    name.append("[");
    for (; it != roster->end(); ++it) {
        name.append("{");
        name.append("\"jid\":");
        name.append("\"");
        name.append((*it).second->jidJID().full().c_str());
        name.append("\"");
        name.append(",\"name\":");
        name.append("\"");
        name.append((*it).second->name().c_str());
        name.append("\"");

        StringList g = (*it).second->groups();
        StringList::const_iterator it_g = g.begin();
        for (; it_g != g.end(); ++it_g) {
            name.append(",\"group\":");
            name.append("\"");
            name.append((*it_g).c_str());
            name.append("\"");
        }
        name.append("},");
        RosterItem::ResourceMap::const_iterator rit = (*it).second->resources().begin();
    }
    name.append("]");
    return name.c_str();
}

/**
 * 用户注销 接口
 * 无返回值
 */
void Smack ::Loginout() {
    j->disconnect();
}

void Smack::receiveMsg(const std::string &jidStr, const std::string &msg) {
}

void Smack::changePasswords(const std::string &password) {
    m_reg->changePassword(j->username(), password);
}

void Smack::loop() {
    ConnectionError ce = ConnNoError;
    while (ce == ConnNoError) {
        ce = j->recv();
    }
}

/**
 * 消息发送 接口
 * @param jidStr  指定的用户地址 例如 ：user@he-202101111234/HE-202101111234   拼接规则 用户名称 + 主机名称 +随便加
 * @param text   需要发送的消息
 *
 * 无返回值
 */
void Smack::send(const std::string &jidStr, const std::string &text) {
    JID to(jidStr);
    Message msg(Message::MessageType::Chat, to, text);
    j->send(msg);
}

/**
 * 添加好友到指定分组
 * @param jidStr
 * @param username
 * @param group
 * @return
 */
void Smack::addFriends(const std::string &jidStr, const std::string &username, const std::string &group) {
    RosterManager *rosterManager = j->rosterManager();
    StringList gl;
    gl.clear();
    gl.push_back(group);
    JID jid(jidStr);
    rosterManager->subscribe(JID(jidStr), username, gl);
}

/**
 * 删除好友
 * @param jidStr
 */
void Smack::delfriends(const std::string &jidStr) {
    RosterManager *rosterManager = j->rosterManager();
    rosterManager->fill();
    JID jid(jidStr);
    rosterManager->remove(jid);
}

void Smack::changeFriendGroup(const std::string &jidStr, const std::string &group) {
    RosterManager *rosterManager = j->rosterManager();
    StringList gl;
    gl.clear();
    gl.push_back(group);
    JID jid(jidStr);
    rosterManager->add(jid, jid.username(), gl);
    rosterManager->fill();
}

void Smack::changeGroup(const std::string &oldGroup, const std::string &newGroup) {
    RosterManager *rosterManager = j->rosterManager();
    Roster *roster = rosterManager->roster();
    Roster::const_iterator it = roster->begin();

    StringList gl;
    gl.clear();
    gl.push_back(newGroup);
    for (; it != roster->end(); ++it) {
        StringList g = (*it).second->groups();
        StringList::const_iterator it_g = g.begin();
        for (; it_g != g.end(); ++it_g) {
            if ((*it_g).compare(oldGroup) == 0) {
                rosterManager->add((*it).second->jidJID(), (*it).second->name().c_str(), gl);
            }
        }
        RosterItem::ResourceMap::const_iterator rit = (*it).second->resources().begin();
    }
}

/**
 * 创建分组
 * @param group
 */
void Smack::createGroup(const std::string &group) {
    RosterManager *rosterManager = j->rosterManager();
    rosterManager->fill();
    RosterItem *m_self = new RosterItem(j->jid().bare());

    StringList gl;
    gl.clear();
    gl.push_back(group);
    m_self->setGroups(gl);
}

void Smack::removeAccounts() {
    m_reg->removeAccount();
}

void Smack::onConnect() {
    LOGW("onConnect!!!\n");
}

void Smack::onDisconnect(ConnectionError e) {
    LOGW("onDisconnect: %d\n", e);
    if (e == ConnAuthenticationFailed)
        LOGD("auth failed. reason: %d\n", j->authError());
}

bool Smack::onTLSConnect(const CertInfo &info) {
    time_t from(info.date_from);
    time_t to(info.date_to);

    LOGW("onTLSConnect status: %d\nissuer: %s\npeer: %s\nprotocol: %s\nmac: %s\ncipher: %s\ncompression: %s\n"
         "from: %s\nto: %s\n",
         info.status, info.issuer.c_str(), info.server.c_str(),
         info.protocol.c_str(), info.mac.c_str(), info.cipher.c_str(),
         info.compression.c_str(), ctime(&from), ctime(&to));
    return true;
}

void Smack::onResourceBind(const std::string &resource) {
    LOGW("onResourceBind: %s", resource.c_str());
}

void Smack::onResourceBindError(const Error *error) {
    LOGW("onResourceBindError: %d\n", error);
}

void Smack::onSessionCreateError(const Error *error) {
    LOGW("onSessionCreateError: %d\n", error);
}

void Smack::handleLog(LogLevel level, LogArea area, const std::string &message) {
    LOGW("handleLog area: 0x%x, msg: %s", area, message.c_str());
}

void message_received(const std::string &id, const std::string &msg);
void Smack::handleMessage(const Message &msg, MessageSession *session) {
    auto body = msg.body();
    LOGW("handleLog area: handleMessage msg: %s", msg.from().full().c_str());
    message_received(msg.from().full().c_str(), body.c_str());
}

void Smack::handleMessageEvent(const JID &from, MessageEventType event) {
    LOGW("received event: %d from: %s\n", event, from.full().c_str());
}

void Smack::handleChatState(const JID &from, ChatStateType state) {
    LOGW("received state: %d from: %s\n", state, from.full().c_str());
}

void Smack::handleMessageSession(MessageSession *session) {
    LOGW("got new session");
    j->disposeMessageSession(m_session);
    m_session = session;
    m_session->registerMessageHandler(this);
    m_messageEventFilter = new MessageEventFilter(m_session);
    m_messageEventFilter->registerMessageEventHandler(this);
    m_chatStateFilter = new ChatStateFilter(m_session);
    m_chatStateFilter->registerChatStateHandler(this);
}

void Smack::declineInvitation(const std::string &roomStr, const std::string &invitorStr, const std::string &reason) {

    LOGD("smark declineInvitation roomStr:%s, invitorStr:%s, reason:%s,", roomStr.c_str(), invitorStr.c_str(), reason.c_str());
    JID room(roomStr);
    JID invitor(invitorStr);
    Message *msg = MUCRoom::declineInvitation(room, invitor, reason);
    LOGD("smark declineInvitation result msg:%s", msg->tag()->xml().c_str());

    Tag *tag = msg->tag();
    j->send(tag);
}

void Smack::onStreamEvent(StreamEvent event) {
    LOGW("onStreamEvent");
}
void Smack::handlePresence(const Presence &presence) {
    UserState = 1;
    LOGW("handlePresence roster: %s state: %d", presence.from().full().c_str(), presence.presence());
    presenceType = presence.presence();
}

/****************账户管理开始***********************/
void Smack::handleRegistrationFields(const JID &from, int fields,
                                     std::string instructions) {
    LOGW("handleRegistrationFields fields: %d instructions: %s ", fields, instructions.c_str());
}

void Smack::handleRegistrationResult(const JID & /*from*/, RegistrationResult result) {
    LOGW("result: %d\n", result);
}

void Smack::handleAlreadyRegistered(const JID & /*from*/) {
    LOGW("handleAlreadyRegistered the account already exists.\n");
}

void Smack::handleDataForm(const JID & /*from*/, const DataForm & /*form*/) {
    LOGW("handleDataForm datForm received\n");
}

void Smack::handleOOB(const JID & /*from*/, const OOB &oob) {
    LOGW("handleOOB OOB registration requested. %s: %s\n", oob.desc().c_str(), oob.url().c_str());
}

/****************用户管理开始***********************/
void Smack::handleItemSubscribed(const JID &jid) {
    LOGW("handleItemSubscribed subscribed %s\n", jid.bare().c_str());
}

void Smack::handleItemAdded(const JID &jid) {
    LOGW("handleItemAdded added %s\n", jid.bare().c_str());
}

void Smack::handleItemUnsubscribed(const JID &jid) {
    LOGW("handleItemUnsubscribed unsubscribed %s\n", jid.bare().c_str());
}

void Smack::handleItemRemoved(const JID &jid) {
    LOGW("handleItemRemoved removed %s\n", jid.bare().c_str());
}

void Smack::handleItemUpdated(const JID &jid) {
    LOGW("handleItemUpdated updated %s\n", jid.bare().c_str());
}

void Smack::handleRoster(const Roster &roster) {
    LOGW("roster arriving    \nitems:\n");
    Roster::const_iterator it = roster.begin();
    for (; it != roster.end(); ++it) {
        LOGW("roster arriving       jid: %s, name: %s, subscription: %d\n",
             (*it).second->jidJID().full().c_str(), (*it).second->name().c_str(),
             (*it).second->subscription());
        StringList g = (*it).second->groups();
        StringList::const_iterator it_g = g.begin();
        for (; it_g != g.end(); ++it_g) {
            LOGW("\t roster arriving    group: %s\n", (*it_g).c_str());
        }
        RosterItem::ResourceMap::const_iterator rit = (*it).second->resources().begin();
        for (; rit != (*it).second->resources().end(); ++rit) {
            LOGW("roster arriving      resource: %s\n", (*rit).first.c_str());
        }
    }
}

void Smack::handleRosterError(const IQ &) {
    LOGW("a roster-related error occured\n");
}

void Smack::handleRosterPresence(const RosterItem &item, const std::string &resource,
                                 Presence::PresenceType presence, const std::string & /*msg*/) {
    LOGW("handleRosterPresence received: %s/%s -- %d\n", item.jidJID().full().c_str(), resource.c_str(), presence);
}

void Smack::handleSelfPresence(const RosterItem &item, const std::string &resource,
                               Presence::PresenceType presence, const std::string & /*msg*/) {
    LOGW("handleSelfPresence received: %s/%s -- %d\n", item.jidJID().full().c_str(), resource.c_str(), presence);
}

void handleSubscriptionCall(const std::string &resultStr);

bool Smack::handleSubscriptionRequest(const JID &jid, const std::string &msg) {
//    LOGW("smack handleSubscriptionRequest jid:%s, name:%s, msg:%s\n", jid.bare().c_str(), jid.username().c_str(), msg.c_str());
    std::string resultStr = "";
    resultStr.append("{");
    resultStr.append("\"jid\":");
    resultStr.append("\"");
    resultStr.append(jid.bare().c_str());
    resultStr.append("\"");
    resultStr.append(",\"name\":");
    resultStr.append("\"");
    resultStr.append(jid.username().c_str());
    resultStr.append("\"");
    resultStr.append(",\"msg\":");
    resultStr.append("\"");
    resultStr.append(msg.c_str());
    resultStr.append("\"");
    resultStr.append("}");
    
//    LOGW("smack handleSubscriptionRequest resultStr:%s", resultStr.c_str());
    handleSubscriptionCall(resultStr);
    return true;
}

void Smack::receiveFriends(const std::string &jidStr, const std::string &groupName, const std::string &hello = EmptyString) {
    JID jid(jidStr);
    StringList groups;
    groups.clear();

    RosterManager *rosterManager = j->rosterManager();

    Roster *roster = rosterManager->roster();
    Roster::const_iterator it = roster->begin();

    bool has = false;
    for (; it != roster->end(); ++it) {
        std::string fjid = (*it).second->jidJID().full();
        int result = fjid.compare(jid.full());

        if (result == 0) {
            StringList g = (*it).second->groups();
            StringList::const_iterator it_g = g.begin();
            for (; it_g != g.end(); ++it_g) {
                groups.push_back((*it_g).c_str());
                has = true;
            }
            break;
        }
    }

    if (!has) {
        groups.push_back(groupName);
    }

    rosterManager->subscribe(jid, jid.username().c_str(), groups, hello);
}



void Smack::rejectFriends(const std::string &jidStr, const std::string &reason = EmptyString) {
    JID jid(jidStr);
    RosterManager *rosterManager = j->rosterManager();
    rosterManager->unsubscribe(jid, reason);
    rosterManager->remove(jid);

}

bool Smack::handleUnsubscriptionRequest(const JID &jid, const std::string & /*msg*/) {
    LOGW("unsubscription: %s\n", jid.bare().c_str());
    return true;
}

void Smack::handleNonrosterPresence(const Presence &presence) {
    LOGW("handleNonrosterPresence received presence from entity not in the roster: %s to %s state: %d\n", presence.from().full().c_str(), presence.to().full().c_str(), presence.presence());
}

void Smack::handleSubscription(const Subscription &subscription) {
    LOGW("handleSubscription subscription type: %d", subscription.subtype());
}
