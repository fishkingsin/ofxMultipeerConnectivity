//
//  Host.h
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


@interface HostController : NSObject  {
    ofxMultipeerConnectivitySession *session;
}

-(void)initWithPeerDisplayName:(NSString*)name;
-(void)sendMessage:(NSString*)message;
-(void) inviteWithViewController:(UIViewController*)viewController serviceType:(NSString*)serviceType;

@end
namespace ofxMultipeerConnectivity {
    using namespace std;
    
    class Host {
    public:
        Host();
        ~Host();
        
        void startHosting(string displayName);
        void invite(string serviceName);
        void sendMessage(string message);
        void hasMessage(string message);
        void hasData(void *data, int length);
        void hasStatusChanged(MCSessionState state);

        protected :
        
        HostController * controller;
    };
}