#include "ofApp.h"
int n;

//--------------------------------------------------------------
void ofApp::setup(){
    n = ofGetWidth()*ofGetHeight();
    ofSetLogLevel(OF_LOG_VERBOSE);
    ofAddListener(ofxMultipeerConnectivity::Events().onMessageReceived, this,  &ofApp::gotPeerMessage);
    ofAddListener(ofxMultipeerConnectivity::Events().onStatusChanged, this,  &ofApp::statusChanged);
    ofAddListener(ofxMultipeerConnectivity::Events().onDataReceived, this, &ofApp::gotData);
    host.startHosting("Host");
    
    bgColor.setSaturation(1);
    bgColor.setBrightness(0.85);
    bgColor.setHue(1);
    bgColor.set(255,0,0);
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
    
	ofDrawBitmapString("Double Tap to invite guest", 20,20);
    
}

//--------------------------------------------------------------
void ofApp::exit(){
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    //    host.sendMessage("x:"+ofToString(touch.x)+"y:"+ofToString(touch.y));
    float i = ((float)touch.x*touch.y)/(float)n;
    bgColor.setHsb(i*360, 255 , 200);
    unsigned char d[3];
    d[0] = bgColor.r;
    d[1] = bgColor.g;
    d[2] = bgColor.b;
    host.sendData(d,3);
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    //    host.sendMessage("x:"+ofToString(touch.x)+"y:"+ofToString(touch.y));
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    host.invite("dance-party");
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
            
            break;
        case MCSessionStateConnected:
            
            break;
        case MCSessionStateConnecting:
            
            break;
            
        default:
            break;
    }
}
void ofApp::gotData(Data &dataArgs)
{
    
}