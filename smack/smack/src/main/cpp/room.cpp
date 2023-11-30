#include "room.h"

#include "log.h"
#include <string.h>
#include <string>
#include <thread>

#include <cstdio> // [s]print[f]
#include <forward_list>

void room::createRoom(ClientBase *client, const std::string &jidStr, const std::string &roomName, const std::string &domain, const std::string &serviceName) {
    JID jid(jidStr);
    JID nicks( roomName+"@"+serviceName+"."+domain+"/"+ jid.username());//65地址替换
    m_room = new MUCRoom( client, nicks, this, this );

    // cleanup
    //    delete m_room;
    //    delete j;
}

void room::loop() {
    LOGD("loop...");
    ConnectionError ce = ConnNoError;
    while (ce == ConnNoError) {
        LOGD("calling recv");
        ce = j->recv();
    }
    LOGD("recv error: %d", ce);
}

void room::createOrJoinRoom(ClientBase *client, const std::string &roomStr, const std::string &domain, const std::string &serviceName,
                            const std::string &nick, const std::string &password) {
    JID roomJID(roomStr + "@" + serviceName + "." + domain + "/" + nick);
    m_room = new MUCRoom(client, roomJID, this, this);
    if (password != "") {
        m_room->setPassword(password);
    }
    m_room->join();
}

void room::destroy(const std::string &reason /* = EmptyString*/,
                   const JID &alternate /* = JID()*/, const std::string &password /* = EmptyString*/) {
    m_room->destroy(reason, alternate, password);
}

void room::setPassword(const std::string &password) {
    m_room->setPassword(password);
}

void room::join() {
    m_room->join();
}

void room::leave(const std::string &msg) {
    m_room->leave(msg);
}

void room::setNick(const std::string &nick) {
    LOGD("setNick  start %s", nick.c_str());
    m_room->setNick(nick);
    LOGD("setNick  end");
}

void room::bans(const std::string &nicks, const std::string &reason) {
    LOGD("bans  start   nicks=%s  reason=%s", nicks.c_str(), reason.c_str());
    m_room->bans(nicks, reason);
    LOGD("bans  end");
}

std::string room::isJoined() {
    return m_room->isJoined();
}

void room::invite(const JID &invitee, const std::string &reason) {
    m_room->invite(invitee, reason);
}

std::string room::nick() {
    return m_room->nick();
}

std::string room::getRoomInfo() {
    room_info = "";
    LOGD("getRoomInfo handleMUCInfo");
    m_room->getRoomInfo();
    while (room_info.empty()) {
    }

    LOGD("getRoomInfo handleMUCInfo 11 result:%s", room_info.c_str());
    return room_info;
}

void room::kick(const std::string &nick, const std::string &reason) {
    m_room->kick(nick, reason);
}

void room::ban(const std::string &nick, const std::string &reason) {
    m_room->ban(nick, reason);
}

void room::grantVoice(const std::string &nick, const std::string &reason) {
    m_room->grantVoice(nick, reason);
}
void room::grantVoices(const std::string &nicks, const std::string &reason) {
    m_room->setRoles( nicks, RoleParticipant, reason );
}
Message *room::createDataForm(const JID &room, const DataForm *df) {
    return m_room->createDataForm(room, df);
}

void room::revokeVoice(const std::string &nick, const std::string &reason) {
    m_room->revokeVoice(nick, reason);
}
void room::revokeVoices(const std::string &nicks, const std::string &reason) {
    m_room->setRoles( nicks, RoleVisitor, reason );
}
void room::setRole(const std::string &nick, const std::string &roleStr, const std::string &reason) {
    MUCRoomRole role;
    if (roleStr == "0") {
        role = MUCRoomRole::RoleNone;
    } else if (roleStr == "1") {
        role = MUCRoomRole::RoleVisitor;
    } else if (roleStr == "2") {
        role = MUCRoomRole::RoleParticipant;
    } else if (roleStr == "3") {
        role = MUCRoomRole::RoleModerator;
    } else if (roleStr == "4") {
        role = MUCRoomRole::RoleInvalid;
    }

    m_room->setRole(nick, role, reason);
}
void room::setRoles(const std::string &nick, const std::string &roleStr, const std::string &reason) {
    MUCRoomRole role;
    if (roleStr == "0") {
        role = MUCRoomRole::RoleNone;
    }else if(roleStr == "1") {
        role = MUCRoomRole::RoleVisitor;
    }else if(roleStr == "2") {
        role = MUCRoomRole::RoleParticipant;
    }else if(roleStr == "3") {
        role = MUCRoomRole::RoleModerator;
    }else if(roleStr == "4") {
        role = MUCRoomRole::RoleInvalid;
    }

    m_room->setRoles(nick, role, reason);
}

void room::setAffiliation(const std::string &nick, const std::string &affiliationStr, const std::string &reason) {
    MUCRoomAffiliation affiliation;
    if (affiliationStr == "0") {
        affiliation = MUCRoomAffiliation::AffiliationNone;
    } else if (affiliationStr == "1") {
        affiliation = MUCRoomAffiliation::AffiliationOutcast;
    } else if (affiliationStr == "2") {
        affiliation = MUCRoomAffiliation::AffiliationMember;
    } else if (affiliationStr == "3") {
        affiliation = MUCRoomAffiliation::AffiliationOwner;
    } else if (affiliationStr == "4") {
        affiliation = MUCRoomAffiliation::AffiliationAdmin;
    } else if (affiliationStr == "5") {
        affiliation = MUCRoomAffiliation::AffiliationInvalid;
    }

    m_room->setAffiliation(nick, affiliation, reason);
}
void room::setAffiliations( const std::string& nicks, /*MUCRoomAffiliation*/std::string& affiliationStr,
                           const std::string& reason ){
    MUCRoomAffiliation affiliation;
    if (affiliationStr == "0") {
        affiliation = MUCRoomAffiliation::AffiliationNone;
    }else if(affiliationStr == "1") {
        affiliation = MUCRoomAffiliation::AffiliationOutcast;
    }else if(affiliationStr == "2") {
        affiliation = MUCRoomAffiliation::AffiliationMember;
    }else if(affiliationStr == "3") {
        affiliation = MUCRoomAffiliation::AffiliationOwner;
    }else if(affiliationStr =="4") {
        affiliation = MUCRoomAffiliation::AffiliationAdmin;
    }else if(affiliationStr == "5") {
        affiliation = MUCRoomAffiliation::AffiliationInvalid;
    }

    m_room->setAffiliations(nicks, affiliation, reason);
}

void room::setPresence(const std::string & /*Presence::PresenceType*/ presenceStr, const std::string &msg) {
    Presence::PresenceType presence;

    if (presenceStr == "0") {
        presence = Presence::PresenceType::Available;
    } else if (presenceStr == "1") {
        presence = Presence::PresenceType::Chat;
    } else if (presenceStr == "2") {
        presence = Presence::PresenceType::Away;
    } else if (presenceStr == "3") {
        presence = Presence::PresenceType::DND;
    } else if (presenceStr == "4") {
        presence = Presence::PresenceType::XA;
    } else if (presenceStr == "5") {
        presence = Presence::PresenceType::Unavailable;
    } else if (presenceStr == "6") {
        presence = Presence::PresenceType::Probe;
    } else if (presenceStr == "7") {
        presence = Presence::PresenceType::Error;
    } else if (presenceStr == "8") {
        presence = Presence::PresenceType::Invalid;
    }

    m_room->setPresence(presence, msg);
}

std::string room::requestList(const std::string &operationStr) {
    MUCOperation operation;

    if (operationStr == "0") {
        operation = MUCOperation::RequestVoiceList;
    } else if (operationStr == "1") {
        operation = MUCOperation::RequestBanList;
    } else if (operationStr == "2") {
        operation = MUCOperation::RequestMemberList;
    } else if (operationStr == "3") {
        operation = MUCOperation::RequestModeratorList;
    } else if (operationStr == "4") {
        operation = MUCOperation::RequestOwnerList;
    } else if (operationStr == "5") {
        operation = MUCOperation::RequestAdminList;
    }

    room_opr_list = "";
    m_room->requestList(operation);

    while (room_opr_list.empty()) {
    }

    return room_opr_list;
}

std::string room::getRoomItems() {
    room_item_list = "";
    m_room->getRoomItems();
    while (room_item_list.empty()) {
    }
    return room_item_list;
}

void room::setRoomConfig(const std::string &config) {
    
    std::map<std::string, std::string> map;
    std::string str = config.c_str();

    char *p1 = (char *) str.c_str();
    int len = strlen(p1);   
    char *p2;
    char *p3;

    int pos = 1;
    while((len > 0) && (p2 = strtok(p1, ",")) != (char *)NULL)
    {
        p1 += strlen(p2) + 1;
        len -= strlen(p2) + 1;

        char *k, * v;
        while((p3 = strtok(p2, ":")) != (char *)NULL)
        {
            p2 = (char *)NULL;
            if(pos%2==1){
                k = p3;
            }else{
                v = p3;
            }
            pos++;
        }
        if(k && v){
            map[k] = v;
        }
    }

    if (map.size() > 0) {
        DataForm *form = new DataForm(TypeSubmit);
//        form->setTitle("房间配置");
        form->addField(DataFormField::TypeHidden, "FORM_TYPE", XMLNS_MUC_REQUEST);

        if (map.find("roomname") != map.end()) {
            std::string room = map["roomname"]; //"room3";
            form->addField(DataFormField::TypeTextSingle, "muc#roomconfig_roomname", room, "房间名称");
        }
        if (map.find("roomdesc") != map.end()) {
            std::string roomdesc = map["roomdesc"]; //"room description";
            form->addField(DataFormField::TypeTextSingle, "muc#roomconfig_roomdesc", roomdesc, "房间描述");
        }
        if (map.find("changesubject") != map.end()) {
            std::string changesubject = map["changesubject"]; //"1";
            form->addField(DataFormField::TypeBoolean, "muc#roomconfig_changesubject", changesubject, "允许成员更改主题");
        }
        if (map.find("maxusers") != map.end()) {
            std::string maxusers = map["maxusers"]; //"28";
            form->addField(DataFormField::TypeTextSingle, "muc#roomconfig_maxusers", maxusers, "最大房间成员人数");
        }
        if (map.find("presencebroadcast") != map.end()) {
            StringList *list = new StringList();
            char *s = (char *)map["presencebroadcast"].c_str();
            const char *d = " ";
            char *p;
            p = strtok(s, d);

            int i = 0;
            while (p) {
                list->push_back(p);
                p = strtok(NULL, d);
                i++;
            }

            if (list->size() > 0) {
                StringList::const_iterator it = list->begin();
                DataFormField *filds;
                int in = 0;
                for (; it != list->end(); ++it) {
                    if (in == 0) {
                        filds = form->addField(DataFormField::TypeTextMulti, "muc#roomconfig_presencebroadcast", it->c_str(), "广播其存在的角色");
                    } else {
                        filds->addValue(it->c_str());
                    }
                    in++;
                }
            }
        }
        if (map.find("publicroom") != map.end()) {
            std::string publicroom = map["publicroom"]; //"1";
            form->addField(DataFormField::TypeBoolean, "muc#roomconfig_publicroom", publicroom, "在目录中列出房间");
        }
        if (map.find("persistentroom") != map.end()) {
            std::string persistentroom = map["persistentroom"]; //"1";
            LOGW("SETROOMconfig---- persistentroom %s",persistentroom.c_str());
            form->addField(DataFormField::TypeBoolean, "muc#roomconfig_persistentroom", persistentroom, "永久房间");
        }
        if (map.find("moderatedroom") != map.end()) {
            std::string moderatedroom = map["moderatedroom"]; //"1";
            form->addField(DataFormField::TypeBoolean, "muc#roomconfig_moderatedroom", moderatedroom, "房间需要审核");
        }
        if (map.find("membersonly") != map.end()) {
            std::string membersonly = map["membersonly"]; //"1";
            form->addField(DataFormField::TypeBoolean, "muc#roomconfig_membersonly", membersonly, "房间仅对成员开放");
        }
        if (map.find("allowinvites") != map.end()) {
            std::string allowinvites = map["allowinvites"]; //"1";
            form->addField(DataFormField::TypeBoolean, "muc#roomconfig_allowinvites", allowinvites, "允许成员邀请其他人");
        }
        if (map.find("passwordprotectedroom") != map.end()) {
            std::string passwordprotectedroom = map["passwordprotectedroom"]; //"1";
            form->addField(DataFormField::TypeBoolean, "muc#roomconfig_passwordprotectedroom", passwordprotectedroom, "需要密码才能进入房间");
        }
        if (map.find("roomsecret") != map.end()) {
            std::string roomsecret = map["roomsecret"]; //"123";
            form->addField(DataFormField::TypeTextPrivate, "muc#roomconfig_roomsecret", roomsecret, "密码");
        }
        if (map.find("whois") != map.end()) {
            std::string whois = map["whois"]; //"anyone";
            form->addField(DataFormField::TypeTextSingle, "muc#roomconfig_whois", whois, "能够发现成员真实 JID 的角色"); 
        }
        if (map.find("allowpm") != map.end()) {
            std::string allowpm = map["allowpm"]; //"anyone";
            form->addField(DataFormField::TypeTextSingle, "muc#roomconfig_allowpm", allowpm, "Allowed to Send Private Messages");
        }
        if (map.find("enablelogging") != map.end()) {
            std::string enablelogging = map["enablelogging"]; //"1";
            form->addField(DataFormField::TypeBoolean, "muc#roomconfig_enablelogging", enablelogging, "记录房间聊天");
        }
        if (map.find("reservednick") != map.end()) {
            std::string reservednick = map["reservednick"]; //"1";
            form->addField(DataFormField::TypeBoolean, "x-muc#roomconfig_reservednick", reservednick, "仅允许注册昵称登录");
        }
        if (map.find("canchangenick") != map.end()) {
            std::string canchangenick = map["canchangenick"]; //"1";
            form->addField(DataFormField::TypeBoolean, "x-muc#roomconfig_canchangenick", canchangenick, "允许成员修改昵称");
        }
        if (map.find("registration") != map.end()) {
            std::string registration = map["registration"]; //"1";
            form->addField(DataFormField::TypeBoolean, "x-muc#roomconfig_registration", registration, "允许用户注册房间");
        }
        if (map.find("roomadmins") != map.end()) {
            std::string roomadmins = map["roomadmins"]; //"555@he-202101111234";
            form->addField(DataFormField::TypeJidMulti, "muc#roomconfig_roomadmins", roomadmins, "房间管理员");
        }
        if (map.find("roomowners") != map.end()) {
            std::string roomowners = map["roomowners"]; //"444@he-202101111234";
            form->addField(DataFormField::TypeJidMulti, "muc#roomconfig_roomowners", roomowners, "房间拥有者");
        }
        m_room->setRoomConfig(form);
    }
}

std::string room::requestRoomConfig() {
    room_config = "";
    m_room->requestRoomConfig();
    while (room_config.empty()) {
    }   
    return room_config;
}

const MUCListItemList &room::list() {
}

void room::onConnect() {   
    LOGD("connected!!!\n");
}

void room::sendGroupMessage(const std::string &message) {
    m_room->send(message);
}

void room::setSubject(const std::string &subject) {
    m_room->setSubject(subject);
}

void room::onDisconnect(ConnectionError e) {
    LOGD("message_test: disconnected: %d\n", e);
    if (e == ConnAuthenticationFailed)
        LOGD("onDisconnect auth failed. reason: %d\n", j->authError());
}

void room::onResourceBind(const std::string &resource) {
    LOGD("onResourceBind");
}

void room::onResourceBindError(const Error *error) {
    LOGD("onResourceBindError");
}

void room::onSessionCreateError(const Error *error) {
    LOGD("onSessionCreateError");
}

void room::onStreamEvent(StreamEvent event) {
    LOGD("onStreamEvent");
}

bool room::onTLSConnect(const CertInfo &info) {
    LOGD("onTLSConnect status: %d\nissuer: %s\npeer: %s\nprotocol: %s\nmac: %s\ncipher: %s\ncompression: %s\n",
         info.status, info.issuer.c_str(), info.server.c_str(),
         info.protocol.c_str(), info.mac.c_str(), info.cipher.c_str(),
         info.compression.c_str());
    return true;
}

void room::handleLog(LogLevel level, LogArea area, const std::string &message) {
    LOGD("handleLog log: level: %d, area: %d, %s\n", level, area, message.c_str());
}

void handleMUCParticipantPresenceListener(const std::string &nike, const std::string &presenceType);

void room::handleMUCParticipantPresence(MUCRoom * /*room*/, const MUCRoomParticipant participant, const Presence &presence) {
    
     LOGD("handleMUCParticipantPresence Presence is %d of nick:%s, reason:%s,status：%s, affiliation:%d, role:%d, flag:%d", presence.presence(),
             participant.nick->resource().c_str(), participant.reason.c_str(), participant.status.c_str(), participant.affiliation, participant.role, participant.flags);
    
    LOGD("handleMUCParticipantPresence Presence MUCUserFlag UserSelf:%d, UserNickChanged:%d, UserKicked:%d, UserBanned:%d, "
         "UserAffiliationChanged:%d, UserRoomDestroyed:%d, UserNickAssigned:%d, "
         "UserNewRoom:%d, UserMembershipRequired:%d, UserRoomShutdown:%d,  UserAffiliationChangedWNR:%d",
         MUCUserFlag::UserSelf, MUCUserFlag::UserNickChanged, MUCUserFlag::UserKicked,
         MUCUserFlag::UserBanned, MUCUserFlag::UserAffiliationChanged, MUCUserFlag::UserRoomDestroyed,
         MUCUserFlag::UserNickAssigned,
         MUCUserFlag::UserNewRoom, MUCUserFlag::UserMembershipRequired, MUCUserFlag::UserRoomShutdown,
         MUCUserFlag::UserAffiliationChangedWNR);
             
             
    std::string nick = participant.nick->resource().c_str(); // 用户昵称
       std::string presenceType;                                // 用户状态
       std::string affiliationType;                             // 岗位从属关系
       std::string roleType;
       std::string flagType;
       std::string jsonStr;
   
       if (presence.presence() == Presence::Available) {
           presenceType = "0";
       } else if (presence.presence() == Presence::Chat) {
           presenceType = "1";
       } else if (presence.presence() == Presence::Away) {
           presenceType = "2";
       } else if (presence.presence() == Presence::DND) {
           presenceType = "3";
       } else if (presence.presence() == Presence::XA) {
           presenceType = "4";
       } else if (presence.presence() == Presence::Unavailable) {
           presenceType = "5";
       } else if (presence.presence() == Presence::Probe) {
           presenceType = "6";
       } else if (presence.presence() == Presence::Error) {
           presenceType = "7";
       } else if (presence.presence() == Presence::Invalid) {
           presenceType = "8";
       }
   
       if (participant.affiliation == MUCRoomAffiliation::AffiliationNone) {
           affiliationType = "0";
       } else if (participant.affiliation == MUCRoomAffiliation::AffiliationOutcast) {
           affiliationType = "1";
       } else if (participant.affiliation == MUCRoomAffiliation::AffiliationMember) {
           affiliationType = "2";
       } else if (participant.affiliation == MUCRoomAffiliation::AffiliationOwner) {
           affiliationType = "3";
       } else if (participant.affiliation == MUCRoomAffiliation::AffiliationAdmin) {
           affiliationType = "4";
       } else if (participant.affiliation == MUCRoomAffiliation::AffiliationInvalid) {
           affiliationType = "5";
       }
   
       if (participant.role == MUCRoomRole::RoleNone) {
           roleType = "0";
       } else if (participant.role == MUCRoomRole::RoleVisitor) {
           roleType = "1";
       } else if (participant.role == MUCRoomRole::RoleParticipant) {
           roleType = "2";
       } else if (participant.role == MUCRoomRole::RoleModerator) {
           roleType = "3";
       } else if (participant.role == MUCRoomRole::RoleInvalid) {
           roleType = "4";
       }
   
       if (participant.flags == MUCUserFlag::UserSelf) {
           flagType = "1"; //Other flags relate to the current user him/herself
       } else if (participant.flags == MUCUserFlag::UserNickChanged) {
           nick = participant.newNick;
           flagType = "2"; //The user changed his/her nickname
       } else if (participant.flags == MUCUserFlag::UserKicked) {
           flagType = "3"; //The user has been kicked
       } else if (participant.flags == MUCUserFlag::UserBanned) {
           flagType = "4"; //The user has been banned
       } else if (participant.flags == MUCUserFlag::UserAffiliationChanged) {
           flagType = "5"; //The user's affiliation with the room changed and as a result he/she has been removed from the room.
       } else if (participant.flags == MUCUserFlag::UserRoomDestroyed) {
           flagType = "6"; //The room has been destroyed
       } else if (participant.flags == MUCUserFlag::UserNickAssigned) {
           flagType = "7"; //Service has assigned or modified occupant's roomnick.
       } else if (participant.flags == MUCUserFlag::UserNewRoom) {
           flagType = "8"; //The room has been newly created.
       } else if (participant.flags == MUCUserFlag::UserMembershipRequired) {
           flagType = "9"; //User is being removed from the room because the room has been changed to members-only and the user is not a member.
       } else if (participant.flags == MUCUserFlag::UserRoomShutdown) {
           flagType = "10"; //User is being removed from the room because of a system shutdown.
       } else if (participant.flags == MUCUserFlag::UserAffiliationChangedWNR) {
           flagType = "11"; //The user's affiliation changed While Not in the Room
       } else {
           flagType = "0";
       }
   
       jsonStr.append("{");
       jsonStr.append("\"presenceType\":\"");
       jsonStr.append(presenceType.c_str());
       jsonStr.append("\",");
       jsonStr.append("\"affiliationType\":\"");
       jsonStr.append(affiliationType.c_str());
       jsonStr.append("\",");
       jsonStr.append("\"roleType\":\"");
       jsonStr.append(roleType.c_str());
       jsonStr.append("\",");
       jsonStr.append("\"flagType\":\"");
       jsonStr.append(flagType.c_str());
       jsonStr.append("\"");
       jsonStr.append("}");
       LOGD("handleMUCParticipantPresence ===>>>> %s  %s \n", nick.c_str(), flagType.c_str());
       handleMUCParticipantPresenceListener(nick.c_str(), jsonStr.c_str());
}

void message_received_group(const std::string &id, const std::string &msg);

void room::handleMUCMessage(MUCRoom * /*room*/, const Message &msg, bool priv) {
    LOGD("handleMUCMessage %s said: '%s' (history: %s, private: %s)\n",
         msg.from().resource().c_str(),
         msg.body().c_str(),
         msg.when() ? "yes" : "no", priv ? "yes" : "no");

    message_received_group(msg.from().resource().c_str(), msg.body().c_str());
}

void room::handleMUCSubject(MUCRoom * /*room*/, const std::string &nick, const std::string &subject) {
    if (nick.empty())
        LOGD("handleMUCSubject Subject: %s\n", subject.c_str());
    else
        LOGD("handleMUCSubject %s has set the subject to: '%s'\n", nick.c_str(),
             subject.c_str());
}

void room::handleMUCError(MUCRoom * /*room*/, StanzaError error) {
    LOGD("handleMUCError !!!!!!!!got an error: %d", error);
}

void room::handleMUCInfo(MUCRoom * /*room*/, int features, const std::string &name,
                         const DataForm *infoForm) {
    //todo 房间信息获取
    LOGD("handleMUCInfo features: %d, name: %s, form xml: %s\n",
         features, name.c_str(), infoForm->tag()->xml().c_str());

    room_info = infoForm->tag()->xml().c_str();
}

void room::handleMUCInviteDecline(MUCRoom * /*room*/, const JID &invitee, const std::string &reason) {
    LOGD("handleMUCInviteDecline Invitee %s declined invitation. reason given: %s\n",
         invitee.full().c_str(), reason.c_str());
}

bool room::handleMUCRoomCreation(MUCRoom *room) {
    LOGD("handleMUCRoomCreation room %s didn't exist, beeing created.\n",
         room->name().c_str());
    return true;
}

void room::handleMUCConfigForm(MUCRoom *room, const DataForm &form) {
    //todo 房间配置信息处理处
    LOGD("requestRoomConfig handleMUCConfigForm room:%s, title:%s, form:%s", room->name().c_str(), form.title().c_str(), form.filterString().c_str());
    LOGD("requestRoomConfig handleMUCConfigForm tag:%s", form.tag()->xml().c_str());
    room_config = form.tag()->xml().c_str();
}

void room::handleMUCItems(MUCRoom * /*room*/, const Disco::ItemList &items) {
    //todo 房间成员信息处理
    LOGD("handleMUCItems start");
    std::string name;
    name.append("[");

    Disco::ItemList::const_iterator it = items.begin();
    for (; it != items.end(); ++it) {
        LOGD("handleMUCItems %s -- %s is an item here\n", (*it)->jid().full().c_str(),
             (*it)->name().c_str());

        name.append("{");
        name.append("\"room\":");
        name.append("\"");
        name.append((*it)->jid().full().c_str());
        name.append("\"");
        name.append("},");
    }

    name.append("]");
    room_item_list = name;
}

void room::handleMUCConfigList(MUCRoom *room, const MUCListItemList &items,
                               MUCOperation operation) {
    //todo 房间岗位列表
    LOGD("handleMUCConfigList room:%s", room->name().c_str());

    std::string name;
    name.append("[");
    MUCListItemList::const_iterator it = items.begin();
    for (; it != items.end(); ++it) {
        LOGD("handleMUCConfigList item jid: %s , nick:%s ", (*it).jid().full().c_str(), (*it).nick().c_str());
        name.append("{");
        name.append("\"jid\":");
        name.append("\"");
        name.append((*it).jid().full().c_str());
        name.append("\"");
        name.append("},");
    }
    name.append("]");
    room_opr_list = name;
}

void room::handleMUCConfigResult(MUCRoom *room, bool success, MUCOperation operation) {
    LOGD("handleMUCConfigResult room:%s", room->name().c_str());
}
void room::handleMUCRequest(MUCRoom *room, const DataForm &form) {
    LOGD("handleMUCRequest room:%s", room->name().c_str());
}
