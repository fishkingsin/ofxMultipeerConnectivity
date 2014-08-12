//
//  Guest.mm
//  example
//
//  Created by Kong king sin on 11/8/14.
//
//
#include "ofMain.h"
#include "Guest.h"
#include "Events.h"
using namespace ofxMultipeerConnectivity;
@interface GuestController()<ofxMultipeerConnectivitySessionDelegate>
@property (readwrite, retain)  ofxMultipeerConnectivitySession *session;
@property (readwrite) Guest * guestRef;
@end
@implementation GuestController
@synthesize session;
@synthesize guestRef;
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
    
//    NSMutableDictionary *info = [NSMutableDictionary dictionary];
//    info[@"message"]=message;
//    [session sendData:[NSKeyedArchiver archivedDataWithRootObject:[info copy]]];
    
    [session sendData:messageData];
}
-(void)sendData:(void *)rawData size:(int)size
{
    NSData *data = [NSData dataWithBytes:(const void *)rawData length:sizeof(unsigned char)*size];
    
    [session sendData:data];
}
// MCSession Delegate callback when receiving data from a peer in a given session
- (void)session:(ofxMultipeerConnectivitySession *)session didReceiveData:(NSData *)data{
    // Decode the incoming data to a UTF8 encoded string
//    NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    if( nil != [info objectForKey:@"message"])
//    {
//        NSString *receivedMessage = [info objectForKey:@"message"];
//        //    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
//        // Create an received transcript
//        // Notify the delegate that we have received a new chunk of data from a peer
//        if(receivedMessage)
//        {
//            if(self.guestRef)
//            {
//                self.guestRef->hasMessage([receivedMessage UTF8String]);
//            }
//        }
//    }
    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    //    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    // Create an received transcript
    // Notify the delegate that we have received a new chunk of data from a peer
    if(nil != receivedMessage)
    {
        if(self.guestRef)
        {
            self.guestRef->hasMessage([receivedMessage UTF8String]);
        }
    }
//    else
    {
        self.guestRef->hasData((void *)[data bytes],[data length]);
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
    void Guest::sendData(unsigned char* d , int size)
    {
        [controller sendData:(void *)d size:size];
    }
    void Guest::hasMessage(string message)
    {
        ofNotifyEvent( Events().onMessageReceived, message, this);
    }
    void Guest::hasData(void *data, int length)
    {
        Data dataArgs;
        dataArgs.data = data;
        dataArgs.length = length;
        ofNotifyEvent( Events().onDataReceived, dataArgs, this);
    }
    void Guest::hasStatusChanged(MCSessionState state)
    {
        ofNotifyEvent( Events().onStatusChanged, state, this);
    }
    
}