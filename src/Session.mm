//
//  Session.mm
//  example
//
//  Created by Kong king sin on 11/8/14.
//
//

#include "Session.h"
using namespace ofxMultipeerConnectivity;
@interface  SessionController()<ofxMultipeerConnectivitySessionDelegate>
@property (readwrite) Session * SessionRef;
@end
@implementation SessionController
-(void)setup:(Session*) Session {

    self.SessionRef = Session;
}

-(void)initWithPeerDisplayName:(NSString*)name
{
    session = [[ofxMultipeerConnectivitySession alloc] initWithPeerDisplayName:name];
    session.delegate = self;
}
-(void)sendMessage:(NSString*)message
{
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [session sendData:messageData];
}
-(void)sendData:(void *)rawData size:(int)size
{
    NSData *data = [NSData dataWithBytes:(const void *)rawData length:sizeof(unsigned char)*size];
    
    [session sendData:data];
}
-(void)startAdvertisingForServiceType:(NSString*)serviceType
{
    [session startAdvertisingForServiceType:serviceType discoveryInfo:nil];
}
-(void)stopAdvertising
{
    [session stopAdvertising];
}

// MCSession Delegate callback when receiving data from a peer in a given session
- (void)session:(ofxMultipeerConnectivitySession *)session didReceiveData:(NSData *)data{

    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    if(nil != receivedMessage)
    {
        if(self.SessionRef)
        {
            self.SessionRef->hasMessage([receivedMessage UTF8String]);
        }
    }
    self.SessionRef->hasData((void*)[data bytes],[data length]);

}
-(void)session:(ofxMultipeerConnectivitySession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if(self.SessionRef)
    {
        self.SessionRef->hasStatusChanged(state);
    }
}
-(void) inviteWithViewController:(UIViewController*)viewController serviceType:(NSString*)serviceType
{
    if(session)
    {
        [viewController presentViewController:[session browserViewControllerForSeriviceType:serviceType] animated:YES completion:^{
        }];
    }

}


-(void)dealloc {
    [super dealloc];
}
@end

namespace ofxMultipeerConnectivity {

    Session::Session()
    {
        controller = [[SessionController alloc] init];
        [controller setup:this];

    }
    Session::~Session()
    {
        [controller dealloc];
    }
    void Session::inviteWithServiceName(string serviceName)
    {
        [controller inviteWithViewController:(UIViewController*)ofxiOSGetViewController() serviceType:[NSString stringWithUTF8String:serviceName.c_str()]];
    }
    void Session::setDisplayName(string displayName)
    {
        [controller initWithPeerDisplayName:[NSString stringWithUTF8String:displayName.c_str()]];
    }
    void Session::startAdvertising(string serviceType)
    {
        [controller startAdvertisingForServiceType:[NSString stringWithUTF8String: serviceType.c_str()]];
    }
    void Session::stopAdvertising()
    {
        [controller stopAdvertising];
    }

    void Session::sendMessage(string message)
    {
        [controller sendMessage:[NSString stringWithUTF8String:message.c_str()]];
    }
    void Session::sendData(unsigned char* d, int size)
    {
        [controller sendData:d size:size];
    }
    
    void Session::hasMessage(string message)
    {
        ofNotifyEvent( Events().onMessageReceived, message, this);
    }
    void Session::hasData(void *data, int length)
    {
        Data dataArgs;
        dataArgs.data = data;
        dataArgs.length = length;
        ofNotifyEvent( Events().onDataReceived, dataArgs, this);
    }
    void Session::hasStatusChanged(MCSessionState state)
    {
        ofNotifyEvent( Events().onStatusChanged, state, this);
    }
}
