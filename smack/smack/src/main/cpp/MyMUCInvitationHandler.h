#ifndef ohosXmppClient_MyMUCInvitationHandler_H
#define ohosXmppClient_MyMUCInvitationHandler_H


#include <src/mucinvitationhandler.h>
#include <src/clientbase.h>
#include <string>

using namespace gloox;


  class MyMUCInvitationHandler : public MUCInvitationHandler
  {
    public:

    MyMUCInvitationHandler(ClientBase *parent);

    /**
       * This function is called for incoming invitations to MUC rooms.
       * @param room The JID of the room you're being invited to.
       * @param from The JID of the inviter.
       * @param reason A reason for the invitation.
       * @param body The body of the message. May contain a MUC-service generated invitation message.
       * @param password Optionally, a password for the room.
       * @param cont Indicates whether or not the multi-user chat is a continuation of a private chat.
       * @param thread An optional thread identifier in case this is a
       * continued chat.
       */
      virtual void handleMUCInvitation( const JID& room, const JID& from, const std::string& reason,
                                        const std::string& body, const std::string& password,
                                        bool cont, const std::string& thread );

  private:
      ClientBase * clientBase;
  };

#endif //ohosXmppClient_MyMUCInvitationHandler_H

