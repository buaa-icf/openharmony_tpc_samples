/*
  Copyright (C) 2022 Huawei Device Co., Ltd.

  This software is distributed under a license. The full license
  agreement can be found in the file LICENSE in this distribution.
  This software may not be copied, modified, sold or distributed
  other than expressed in the named license agreement.
  This software is distributed without any warranty.
*/

#ifndef ohosXmppClient_Smack_H
#define ohosXmppClient_Smack_H

#include "src/messageeventfilter.h"
#include <src/connectionlistener.h>
#include <src/loghandler.h>
#include <src/presencehandler.h>
#include <src/messagehandler.h>
#include <src/messagesessionhandler.h>
#include <src/client.h>
#include <src/chatstatehandler.h>
#include <src/messageeventhandler.h>
#include <src/chatstatefilter.h>

#include <src/registration.h>
#include <src/rostermanager.h>
#include <src/subscription.h>

#include <src/mucinvitationhandler.h>
#include <src/mucroom.h>
#include "MyMUCInvitationHandler.h"

using namespace gloox;

class Smack : PresenceHandler, ConnectionListener, LogHandler, MessageHandler, MessageEventHandler, MessageSessionHandler, ChatStateHandler, RegistrationHandler, RosterListener, SubscriptionHandler {
  public:
    Smack();
    int login(const std::string &jid, const std::string &pwd);
    void loop();
    void Loginout();
    void send(const std::string &jidStr, const std::string &msg);
    void receiveMsg(const std::string &jidStr, const std::string &msg);
    void removeAccounts();
    void changePasswords(const std::string &password);
    void addFriends(const std::string &jidStr, const std::string &username, const std::string &group);
    void createGroup(const std::string &group);
    void delfriends(const std::string &jidStr);
    std::string getFriendList();
    void changeGroup(const std::string &oldGroup, const std::string &newGroup);

    void declineInvitation(const std::string & /*JID&*/ room, const std::string & /*JID&*/ invitor,
                           const std::string &reason);
    bool isConnected();
    std::string username();
    void setUsernameAndPassword(std::string username, std::string pwd);
    void setPort(int port);
    bool connect();
    void setServer(const std::string &server);
    void setPassword(const std::string &password);
    std::string password();
    std::string resource();
    void setResource(const std::string &resource);
    bool login();
    void receiveFriends( const std::string &jidStr,const std::string &groupName, const std::string &hello);
    void rejectFriends( const std::string &jidStr, const std::string &reason);
    std::string server();
    int authed();
    int port();
    int compression();
    //获取当前登录的JID
    JID &getMyJID();
    //获取clent
    Client *getClent();

    //变更用户状态
    void changePresence(const std::string &statusType, const std::string &status);
    void changeFriendGroup(const std::string &jidStr, const std::string &group);

    virtual void handlePresence(const Presence &presence);
    virtual void onConnect();
    virtual void onDisconnect(ConnectionError e);
    virtual void onResourceBind(const std::string &resource);
    virtual void onResourceBindError(const Error *error);
    virtual void onSessionCreateError(const Error *error);
    virtual bool onTLSConnect(const CertInfo &info);
    virtual void onStreamEvent(StreamEvent event);

    virtual void handleLog(LogLevel level, LogArea area, const std::string &message);
    virtual void handleMessage(const Message &msg, MessageSession *session = 0);
    virtual void handleMessageEvent(const JID &from, MessageEventType event);
    virtual void handleMessageSession(MessageSession *session);
    virtual void handleChatState(const JID &from, ChatStateType state);

    /****************账户管理***********************/
    virtual void handleRegistrationFields(const JID &from, int fields,
                                          std::string instructions);
    virtual void handleAlreadyRegistered(const JID &from);
    virtual void handleRegistrationResult(const JID &from, RegistrationResult regResult);
    virtual void handleDataForm(const JID &from, const DataForm &form);
    virtual void handleOOB(const JID &from, const OOB &oob);

    /****************用户管理***********************/
    virtual void handleItemAdded(const JID &jid);
    virtual void handleItemSubscribed(const JID &jid);
    virtual void handleItemRemoved(const JID &jid);
    virtual void handleItemUpdated(const JID &jid);
    virtual void handleItemUnsubscribed(const JID &jid);
    virtual void handleRoster(const Roster &roster);
    virtual void handleRosterPresence(const RosterItem &item, const std::string &resource,
                                      Presence::PresenceType presence, const std::string &msg);
    virtual void handleSelfPresence(const RosterItem &item, const std::string &resource,
                                    Presence::PresenceType presence, const std::string &msg);
    virtual bool handleSubscriptionRequest(const JID &jid, const std::string &msg);
    virtual bool handleUnsubscriptionRequest(const JID &jid, const std::string &msg);
    virtual void handleNonrosterPresence(const Presence &presence);
    virtual void handleRosterError(const IQ &iq);
    virtual void handleSubscription(const Subscription &subscription);

  private:
    Client *j = nullptr;
    MessageSession *m_session = nullptr;
    MessageEventFilter *m_messageEventFilter = nullptr;
    ChatStateFilter *m_chatStateFilter = nullptr;
    JID m_jid;
    Registration *m_reg;
    int32_t presenceType = -1;
    std::string userName = "";
};
#endif //ohosXmppClient_Smack_H
