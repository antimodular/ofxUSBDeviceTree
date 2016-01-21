#pragma once

#include <iostream>
#include <vector>
#include "ofRectangle.h"

#include <CoreFoundation/CoreFoundation.h>

#include <IOKit/IOKitLib.h>
#include <IOKit/IOMessage.h>
#include <IOKit/IOCFPlugIn.h>
#include <IOKit/usb/IOUSBLib.h>

using namespace std;


class ofxUSBDeviceTree{
	
public:
	

    ofxUSBDeviceTree();
    vector<string> listDevices(string specificDevice = "");
     vector<unsigned int> getLocationIDs(string specificDevice = "");
    
private:
	
};

