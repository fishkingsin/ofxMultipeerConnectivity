//
//  Events.mm
//  exampleHost
//
//  Created by Kong king sin on 11/8/14.
//
//

#include "Events.h"

namespace ofxMultipeerConnectivity {
    ofxMultipeerConnectivityEvents & Events (){
        static ofxMultipeerConnectivityEvents * events = new ofxMultipeerConnectivityEvents;
        return * events;
    }
}