#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetLogLevel(OF_LOG_SILENT);
    ofAddListener(ofxMultipeerConnectivity::Events().onMessageReceived, this,  &ofApp::gotPeerMessage);
    ofAddListener(ofxMultipeerConnectivity::Events().onStatusChanged, this,  &ofApp::statusChanged);
    ofAddListener(ofxMultipeerConnectivity::Events().onDataReceived, this, &ofApp::gotData);
    session.setDisplayName("Guest");
    session.startAdvertising("dance-party");
    stateColor = ofColor(255,0,0);

}

//--------------------------------------------------------------
void ofApp::update(){
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofPushStyle();
    
    ofSetColor(bgColor);
    ofRect(0, 0, ofGetWidth() , ofGetHeight());
    ofPopStyle();
    ofPushStyle();
    ofSetColor(stateColor);
	ofRect(0, 0, ofGetWidth(), 20);
    ofPopStyle();
}

//--------------------------------------------------------------
void ofApp::exit(){
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    session.sendMessage("Hello");
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    session.startAdvertising("dance-party");
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    
}

void ofApp::gotPeerMessage(string &message)
{
    ofLogVerbose(__PRETTY_FUNCTION__) << message;
}
void ofApp::statusChanged(MCSessionState &state)
{
    switch (state) {
        case MCSessionStateNotConnected:
            stateColor = ofColor(255,0,0);
            
            break;
        case MCSessionStateConnected:
            stateColor = ofColor(0,255,0);
            session.stopAdvertising();
            break;
        case MCSessionStateConnecting:
            stateColor = ofColor(255,255,0);
            break;
            
        default:
            break;
    }
}
void ofApp::gotData(Data &dataArgs)
{
 if(dataArgs.length ==3)
 {
     unsigned char *tempBuffer = new unsigned char [3];
     memcpy(tempBuffer, dataArgs.data, dataArgs.length);
     bgColor.r = tempBuffer[0];
     bgColor.g = tempBuffer[1];
     bgColor.b = tempBuffer[2];
 }
}