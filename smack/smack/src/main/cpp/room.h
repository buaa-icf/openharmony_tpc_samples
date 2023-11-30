#ifndef ohosXmppClient_room_H
#define ohosXmppClient_room_H

#include <src/client.h>
#include <src/connectionlistener.h>
#include <src/mucroomhandler.h>
#include <src/mucroom.h>
#include <src/disco.h>
#include <src/presence.h>
#include <src/message.h>
#include <src/dataform.h>
#include <src/gloox.h>
#include <src/lastactivity.h>
#include <src/loghandler.h>
#include <src/logsink.h>

using namespace gloox;

class room : ConnectionListener, LogHandler, MUCRoomHandler, MUCRoomConfigHandler {
  public:
    void loop();

    // First batch completed
    void createRoom(ClientBase *client, const std::string &jid, const std::string &roomName, const std::string &domain, const std::string &serviceName);
    void leave(const std::string &msg);
    void sendGroupMessage(const std::string &message);
    void setSubject(const std::string &subject);
    void join();
    void destroy(const std::string &reason, const JID &alternate, const std::string &password);

    // Second batch completed
    void kick(const std::string &nick, const std::string &reason);
    void ban(const std::string &nick, const std::string &reason);
    void grantVoice(const std::string &nick, const std::string &reason);
    void grantVoices(const std::string &nicks, const std::string &reason);
    void revokeVoice(const std::string &nick, const std::string &reason);
    void revokeVoices(const std::string &nick, const std::string &reason);

    //Third batch completed
    void setRole(const std::string &nick, const std::string &role, const std::string &reason);
    void setRoles(const std::string &nicks, const std::string &role, const std::string &reason);

    void setAffiliation(const std::string &nick, const std::string &affiliation, const std::string &reason);
    void setPresence(const std::string &presence, const std::string &msg);
    void invite(const JID &invitee, const std::string &reason);

    //fourth batch completed
    std::string requestRoomConfig();
    std::string requestList(const std::string &operation);
    std::string getRoomItems();
    std::string getRoomInfo();
    void setAffiliations(const std::string &nicks, /*MUCRoomAffiliation*/ std::string &affiliation,
                         const std::string &reason);

    // fourth batch completed
    void setRoomConfig(const std::string &config);
    void createOrJoinRoom(ClientBase *client, const std::string &room, const std::string &domain, const std::string &serviceName, const std::string &nick, const std::string &password);
    void setPassword(const std::string &password);
    void bans(const std::string &nicks, const std::string &reason);
    void setNick(const std::string &nick);
    std::string isJoined();
    std::string nick();

    Message *createDataForm(const JID &room, const DataForm *df);
    const MUCListItemList &list();
    virtual void onConnect();
    virtual void onDisconnect(ConnectionError e);
    virtual void onResourceBind(const std::string &resource);
    virtual void onResourceBindError(const Error *error);
    virtual void onSessionCreateError(const Error *error);
    virtual bool onTLSConnect(const CertInfo &info);
    virtual void onStreamEvent(StreamEvent event);
    virtual void handleLog(LogLevel level, LogArea area, const std::string &message);
    virtual void handleMUCParticipantPresence(MUCRoom * /*room*/, const MUCRoomParticipant participant, const Presence &presence);
    virtual void handleMUCMessage(MUCRoom * /*room*/, const Message &msg, bool priv);
    virtual void handleMUCSubject(MUCRoom * /*room*/, const std::string &nick, const std::string &subject);
    virtual void handleMUCError(MUCRoom * /*room*/, StanzaError error);
    virtual void handleMUCItems(MUCRoom * /*room*/, const Disco::ItemList &items);
    virtual void handleMUCInviteDecline(MUCRoom * /*room*/, const JID &invitee, const std::string &reason);
    virtual bool handleMUCRoomCreation(MUCRoom *room);
    virtual void handleMUCConfigList(MUCRoom *room, const MUCListItemList &items, MUCOperation operation);
    virtual void handleMUCConfigForm(MUCRoom *room, const DataForm &form);
    virtual void handleMUCConfigResult(MUCRoom *room, bool success, MUCOperation operation);
    virtual void handleMUCRequest(MUCRoom *room, const DataForm &form);
    virtual void handleMUCInfo(MUCRoom * /*room*/, int features, const std::string &name, const DataForm *infoForm);

  private:
    Client *j;
    MUCRoom *m_room;
    std::string room_config = "";
    std::string room_opr_list = "";
    std::string room_item_list = "";
    std::string room_info = "";
};

#endif //ohosXmppClient_room_H
