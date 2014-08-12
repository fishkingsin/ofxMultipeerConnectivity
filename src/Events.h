//
//  Events.h
//  exampleHost
//
//  Created by Kong king sin on 11/8/14.
//
//

#pragma once

#include "ofEvents.h"

#if defined( __APPLE_CC__)
#include <TargetConditionals.h>

#if (TARGET_OS_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE) || (TARGET_IPHONE)
#else

#import <Cocoa/Cocoa.h>

#endif

#endif
#include <MultipeerConnectivity/MultipeerConnectivity.h>

namespace ofxMultipeerConnectivity {
    struct Data
    {
        void *data;
        int length;
    };
    class ofxMultipeerConnectivityEvents {
    public:
        ofEvent<string> onMessageReceived;
        ofEvent<Data> onDataReceived;
        ofEvent<MCSessionState> onStatusChanged;
    };
    
    ofxMultipeerConnectivityEvents & Events();
}
