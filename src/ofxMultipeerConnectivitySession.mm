//
//  ofxMultipeerConnectivitySession.m
//  example
//
//  Created by Kong king sin on 11/8/14.
//
//


//@import MultipeerConnectivity;

#include "ofxMultipeerConnectivitySession.h"

@interface ofxMultipeerConnectivitySession () <MCSessionDelegate, MCBrowserViewControllerDelegate>


@property (strong, nonatomic) MCAdvertiserAssistant *advertiser;
@property (strong, nonatomic) MCPeerID *peerID;

@end

@implementation ofxMultipeerConnectivitySession

- (instancetype)initWithPeerDisplayName:(NSString *)name
{
    self = [super init];
    if (!self) return nil;
    
    self.peerID = [[MCPeerID alloc] initWithDisplayName:name];
    
    return self;
}

#pragma mark - Properties

- (MCSession *)session
{
    if (!_session) {
        _session = [[MCSession alloc] initWithPeer:self.peerID];
        _session.delegate = self;
    }
    return _session;
}

#pragma mark - MCSessionDelegate methods

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if (state == MCSessionStateConnecting) {
        NSLog(@"Connecting to %@", peerID.displayName);
    } else if (state == MCSessionStateConnected) {
        NSLog(@"Connected to %@", peerID.displayName);
    } else if (state == MCSessionStateNotConnected) {
        NSLog(@"Disconnected from %@", peerID.displayName);
    }
    [self.delegate session:self peer:peerID didChangeState:state];
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    
    [self.delegate session:self didReceiveData:data];
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
//    if ([streamName isEqualToString:@"music"]) {
//        [self.delegate session:self didReceiveAudioStream:stream];
//    }
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

- (NSArray *)connectedPeers
{
    return [self.session connectedPeers];
}

- (NSOutputStream *)outputStreamForPeer:(MCPeerID *)peer
{
    NSError *error = nil;
    NSOutputStream *stream = [self.session startStreamWithName:@"music" toPeer:peer error:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    return stream;
}

- (void)sendData:(NSData *)data
{
    NSError *error = nil;
    [self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

#pragma mark - MCBrowserViewController delegate

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (MCBrowserViewController *)browserViewControllerForSeriviceType:(NSString *)type
{
    MCBrowserViewController *view = [[MCBrowserViewController alloc] initWithServiceType:type session:self.session];
    view.delegate = self;
    return view;
}

#pragma mark - Advertising Assistant

- (void)startAdvertisingForServiceType:(NSString *)type discoveryInfo:(NSDictionary *)info
{
    if (!self.advertiser)
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:type discoveryInfo:info session:self.session];
    
    [self.advertiser start];
}

- (void)stopAdvertising
{
    [self.advertiser stop];
}
@end