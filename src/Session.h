//
//  Session.h
//  example
//
//  Created by Kong king sin on 11/8/14.
//
//

#pragma once
#if defined( __APPLE_CC__)
#include <TargetConditionals.h>

#if (TARGET_OS_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE) || (TARGET_IPHONE)
#else

#import <Cocoa/Cocoa.h>
#endif
#endif
#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxMultipeerConnectivity.h"
#include "ofxMultipeerConnectivitySession.h"


@interface SessionController : NSObject  {
    ofxMultipeerConnectivitySession *session;
}

-(void)initWithPeerDisplayName:(NSString*)name;
-(void)startAdvertisingForServiceType:(NSString*)serviceType;
-(void)stopAdvertising;

-(void)sendMessage:(NSString*)message;
-(void)sendData:(void *)data;
-(void) inviteWithViewController:(UIViewController*)viewController serviceType:(NSString*)serviceType;

@end
namespace ofxMultipeerConnectivity {
    using namespace std;
    
    class Session {
    public:
        Session();
        ~Session();
        
        void setDisplayName(string displayName);
        void startAdvertising(string serviceType);
        void stopAdvertising();
        void inviteWithServiceName(string serviceName);
        void sendMessage(string message);
        void sendData(unsigned char* d, int size);
        void hasMessage(string message);
        void hasData(void *data, int length);
        void hasStatusChanged(MCSessionState state);

        protected :
        
        SessionController * controller;
    };
}