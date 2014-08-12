//
//  Guest.h
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
namespace ofxMultipeerConnectivity{
    class Guest;
}

using namespace ofxMultipeerConnectivity;

@interface GuestController : NSObject  {
    ofxMultipeerConnectivitySession *session;
    Guest * guestRef;
}

-(void)initWithDisplayName:(NSString*)displayName;
-(void)startAdvertisingForServiceType:(NSString*)serviceType;
-(void)stopAdvertising;
-(void)sendMessage:(NSString*)message;
//-(void)inviteWithViewController:(UIViewController*)viewController;

@end
namespace ofxMultipeerConnectivity {
    using namespace std;
    
    class Guest {
    public:
        Guest();
        ~Guest();
        void setup(string displayName);
        void startAdvertising(string serviceType);
        void stopAdvertising();
        void invite();
        void sendMessage(string message);
        void hasMessage(string message);
        void hasData(void *data, int length);
        void hasStatusChanged(MCSessionState state);
        protected :
        GuestController * controller;
    };
}