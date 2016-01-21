#include "ofMain.h"

#include "ofxUSBDeviceTree.h"

class ofApp : public ofBaseApp
{
    
    ofxUSBDeviceTree manager;
    vector<string> allDevices;
    vector<unsigned int> allLocationsIDs;
public:
    
    void exit(){
        std::exit(1);
    }
    void setup() {
        ofSetLogLevel(OF_LOG_VERBOSE);
        
        allDevices = manager.listDevices(""); //HD Pro Webcam C920");
        
        if(allDevices.size() > 0){
            for(int i=0; i<allDevices.size();i++){
                ofLog()<<" device "<<i<<" = "<<allDevices[i];
            }
        }else{
            ofLog()<<"no devices found";
        }
        allLocationsIDs = manager.getLocationIDs(""); //HD Pro Webcam C920");
        if(allDevices.size() > 0){
            for(int i=0; i<allDevices.size();i++){
                ofLog()<<" locationsID "<<i<<" = "<<allLocationsIDs[i];
            }
        }else{
            ofLog()<<"no location IDs found";
        }
    }
    
    void update() {
        
    }
    
    void draw() {
        
    }
    
    void keyReleased(int key) {
        
    }
};



#pragma mark -
#pragma mark main
int main(){
    ofSetupOpenGL(800, 600, OF_WINDOW);
    ofRunApp(new ofApp());
}
