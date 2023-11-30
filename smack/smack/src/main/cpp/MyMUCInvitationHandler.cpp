

#include "MyMUCInvitationHandler.h"
#include "log.h"

using namespace gloox;

void handleMUCInvitationListener(const std::string &v0);

void MyMUCInvitationHandler::handleMUCInvitation(const JID &room, const JID &from, const std::string &reason,
                                                 const std::string &body, const std::string &password,
                                                 bool cont, const std::string &thread) {

    std::string jsonStr;
       jsonStr.append("{");
       jsonStr.append("\"room\":\"");
       jsonStr.append(room.full().c_str());
       jsonStr.append("\",");
       jsonStr.append("\"from\":\"");
       jsonStr.append(from.full().c_str());
       jsonStr.append("\",");
       jsonStr.append("\"reason\":\"");
       jsonStr.append(reason.c_str());
       jsonStr.append("\",");
       jsonStr.append("\"body\":\"");
       jsonStr.append(body.c_str());
       jsonStr.append("\",");
       jsonStr.append("\"password\":\"");
       jsonStr.append(password.c_str());
       jsonStr.append("\",");
       jsonStr.append("\"cont\":\"");
       jsonStr.append("");
       jsonStr.append("\",");
       jsonStr.append("\"thread\":\"");
       jsonStr.append(thread.c_str());
   
       jsonStr.append("\"");
       jsonStr.append("}");
       LOGW("Test MyMUCInvitationHandler %s",jsonStr.c_str());
   
       LOGW("Test MyMUCInvitationHandler handleMUCInvitation room: %s, from:%s, reason:%s, body:%s, password:%s, cont:%s, thread:%s", room.full().c_str(), from.full().c_str(), reason.c_str(), body.c_str(), password.c_str(), cont, thread.c_str());
       handleMUCInvitationListener(jsonStr.c_str());
}

MyMUCInvitationHandler::MyMUCInvitationHandler(ClientBase *parent) : MUCInvitationHandler(parent) {
    clientBase = parent;
}
