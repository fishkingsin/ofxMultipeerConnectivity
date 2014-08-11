//
//  Guest.mm
//  example
//
//  Created by Kong king sin on 11/8/14.
//
//

#include "Guest.h"

using namespace ofxMultipeerConnectivity;
@interface GuestController()<ofxMultipeerConnectivitySessionDelegate>
@property (readwrite) Guest * guestRef;
@end
@implementation GuestController

-(void)setup:(Guest*) guest {
    
    self.guestRef = guest;
    
}

-(void) initWithDisplayName:(NSString *)display
{
    session = [[ofxMultipeerConnectivitySession alloc] initWithPeerDisplayName:display];
//    [session startAdvertisingForServiceType:serviceType discoveryInfo:nil];
    session.delegate = self;
}
-(void)startAdvertisingForServiceType:(NSString*)serviceType
{
    [session startAdvertisingForServiceType:serviceType discoveryInfo:nil];
}

-(void)sendMessage:(NSString*)message
{
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [session sendData:messageData];
}

// MCSession Delegate callback when receiving data from a peer in a given session
- (void)session:(ofxMultipeerConnectivitySession *)session didReceiveData:(NSData *)data{
    // Decode the incoming data to a UTF8 encoded string
    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    // Create an received transcript
    // Notify the delegate that we have received a new chunk of data from a peer
    if(receivedMessage)
    {
        if(self.guestRef)
        {
            self.guestRef->hasMessage([receivedMessage UTF8String]);
        }
    }
}
-(void)session:(ofxMultipeerConnectivitySession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if(self.guestRef)
    {
        self.guestRef->hasStatusChanged(state);
    }
}
-(void)stopAdvertising
{
    [session stopAdvertising];
}
@end


namespace ofxMultipeerConnectivity {
    Guest::Guest()
    {
        controller = [[GuestController alloc] init];
        [controller setup:this];
    }
    Guest::~Guest()
    {
        [controller dealloc];

    }
    void Guest::setup(string displayName)
    {
        [controller initWithDisplayName:[NSString stringWithUTF8String:displayName.c_str()]];
    }
    
    void Guest::startAdvertising(string serviceType)
    {
        [controller startAdvertisingForServiceType:[NSString stringWithUTF8String: serviceType.c_str()]];
    }
     void Guest::stopAdvertising()
     {
         [controller stopAdvertising];
     }
    void Guest::sendMessage(string message)
    {
        [controller sendMessage:[NSString stringWithUTF8String:message.c_str()]];
    }
    void Guest::hasMessage(string message)
    {
        ofNotifyEvent( Events().onMessageReceived, message, this);
    }
    void Guest::hasStatusChanged(MCSessionState state)
    {
        ofNotifyEvent( Events().onStatusChanged, state, this);
    }
    
}