/*
  Copyright (C) 2022 Huawei Device Co., Ltd.

  This software is distributed under a license. The full license
  agreement can be found in the file LICENSE in this distribution.
  This software may not be copied, modified, sold or distributed
  other than expressed in the named license agreement.
  This software is distributed without any warranty.
*/

#ifndef ohosXmppClient_registration_H
#define ohosXmppClient_registration_H

#include <src/connectionlistener.h>
#include <src/loghandler.h>
#include <src/client.h>
#include <src/registration.h>

using namespace gloox;

class registration : ConnectionListener, LogHandler, RegistrationHandler {
public:

    int createAccounts(const std::string& ip, const std::string& name, const std::string& pwd );

    virtual void onConnect();
    virtual void onDisconnect( ConnectionError e );
    virtual void onResourceBind( const std::string& resource );
    virtual void onResourceBindError( const Error* error );
    virtual void onSessionCreateError( const Error* error );
    virtual bool onTLSConnect( const CertInfo& info );
    virtual void onStreamEvent( StreamEvent event );

    virtual void handleLog( LogLevel level, LogArea area, const std::string& message );
    virtual void handleRegistrationFields( const JID& from, int fields,
                                           std::string instructions );
    virtual void handleAlreadyRegistered( const JID& from );
    virtual void handleRegistrationResult( const JID& from, RegistrationResult regResult );
    virtual void handleDataForm( const JID& from, const DataForm& form );
    virtual void handleOOB( const JID& from, const OOB& oob );

private:
    Client* j = nullptr;
    Registration *m_reg;
    std::string name = "";
    std::string pwd = "";
};
#endif //ohosXmppClient_registration_H
