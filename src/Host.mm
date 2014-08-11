//
//  Host.mm
//  example
//
//  Created by Kong king sin on 11/8/14.
//
//

#include "Host.h"
using namespace ofxMultipeerConnectivity;
@interface  HostController()<ofxMultipeerConnectivitySessionDelegate>
@property (readwrite) Host * hostRef;
@end
@implementation HostController
-(void)setup:(Host*) host {

    self.hostRef = host;
}

-(void)initWithPeerDisplayName:(NSString*)name
{
    session = [[ofxMultipeerConnectivitySession alloc] initWithPeerDisplayName:name];
}
- (void)sendMessage:(NSString *)message
{
    // Convert the string into a UTF8 encoded data
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
        if(self.hostRef)
        {
            self.hostRef->hasMessage([receivedMessage UTF8String]);
        }
    }
}
-(void)session:(ofxMultipeerConnectivitySession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if(self.hostRef)
    {
        self.hostRef->hasStatusChanged(state);
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

    Host::Host()
    {
        controller = [[HostController alloc] init];
        [controller setup:this];

    }
    Host::~Host()
    {
        [controller dealloc];
    }
    void Host::invite(string serviceName)
    {
        [controller inviteWithViewController:(UIViewController*)ofxiOSGetViewController() serviceType:[NSString stringWithUTF8String:serviceName.c_str()]];
    }
    void Host::startHosting(string displayName)
    {
        [controller initWithPeerDisplayName:[NSString stringWithUTF8String:displayName.c_str()]];
    }
    void Host::sendMessage(string message)
    {
        [controller sendMessage:@"Hello"];
    }
    
    void Host::hasMessage(string message)
    {
        ofNotifyEvent( Events().onMessageReceived, message, this);
    }
    void Host::hasStatusChanged(MCSessionState state)
    {
        ofNotifyEvent( Events().onStatusChanged, state, this);
    }
}
