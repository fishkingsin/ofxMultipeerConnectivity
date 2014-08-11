//
//  ofxMultipeerConnectivitySession.h
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

#import <Foundation/Foundation.h>


#endif
#endif
#ifndef TARGET_OS_IPHONE
#import <Cocoa/Cocoa.h>
#endif

#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class ofxMultipeerConnectivitySession, MCPeerID, MCBrowserViewController;
@protocol ofxMultipeerConnectivitySessionDelegate <NSObject>

- (void)session:(ofxMultipeerConnectivitySession *)session didReceiveAudioStream:(NSInputStream *)stream;
- (void)session:(ofxMultipeerConnectivitySession *)session didReceiveData:(NSData *)data;
- (void)session:(ofxMultipeerConnectivitySession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;

@end

@interface ofxMultipeerConnectivitySession : NSObject

@property (nonatomic, assign) id<ofxMultipeerConnectivitySessionDelegate> delegate;
@property (strong, nonatomic) MCSession *session;
- (instancetype)initWithPeerDisplayName:(NSString *)name;

- (void)startAdvertisingForServiceType:(NSString *)type discoveryInfo:(NSDictionary *)info;
- (void)stopAdvertising;
- (MCBrowserViewController *)browserViewControllerForSeriviceType:(NSString *)type;

- (NSArray *)connectedPeers;
//- (NSOutputStream *)outputStreamForPeer:(MCPeerID *)peer;

- (void)sendData:(NSData *)data;

@end
