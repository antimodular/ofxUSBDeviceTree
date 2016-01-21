#include "ofxUSBDeviceTree.h"
#include "ofLog.h"
#include "ofAppRunner.h"
#include "ofGraphics.h"
#include "ofSystemUtils.h"

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark public



ofxUSBDeviceTree::ofxUSBDeviceTree() {
#ifndef TARGET_OSX
    ofSystemAlertDialog("Sorry! ofxUSBDeviceTree supports only MacOS.");
#endif
}

vector<string> ofxUSBDeviceTree::listDevices(string specificDevice){
    
    vector<string> allDeviceNames;
    
    CFMutableDictionaryRef matchingDict;
    io_iterator_t iter;
    kern_return_t kr;
    io_service_t usbDevice;
    
    IOCFPlugInInterface **plugInInterface = NULL;
    SInt32              score;
    HRESULT             res;
    
    /* set up a matching dictionary for the class */
    matchingDict = IOServiceMatching(kIOUSBDeviceClassName);
    if (matchingDict == NULL)
    {
        return; // fail
    }
    
    /* Now we have a dictionary, get an iterator.*/
    kr = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iter);
    if (kr != KERN_SUCCESS)
    {
        return;
    }
    


    
    /* iterate */
    while ((usbDevice = IOIteratorNext(iter)))
    {
        io_name_t       deviceName;
        CFStringRef     deviceNameAsCFString;
        //MyPrivateData   *privateDataRef = NULL;
        UInt32          locationID;
        IOUSBDeviceInterface    **deviceInterface;
        
        // Get the USB device's name.
        kr = IORegistryEntryGetName(usbDevice, deviceName);
        if (KERN_SUCCESS != kr) {
            deviceName[0] = '\0';
        }
        
        deviceNameAsCFString = CFStringCreateWithCString(kCFAllocatorDefault, deviceName,
                                                         kCFStringEncodingASCII);
        
        // Dump our data to stderr just to see what it looks like.
        fprintf(stderr, "deviceName: ");
        CFShow(deviceNameAsCFString);
        
      
        const char *cs = CFStringGetCStringPtr( deviceNameAsCFString, kCFStringEncodingMacRoman ) ;
 
        if(specificDevice == ""){
            fprintf( stderr, "Device Name is %s\n", (const char*)deviceName );
            
            allDeviceNames.push_back((const char*)deviceName);
            //}else if(strcmp(deviceName, specificDevice) == true){
            // }else if(CFStringCompare(deviceNameAsCFString, CFSTR("HD Pro Webcam C920"), 0) == kCFCompareEqualTo){
        }else if(cs != NULL && std::string(cs) == specificDevice){
            allDeviceNames.push_back((const char*)deviceName);
        }
    
        
        //if(strcmp( deviceName, "Super Disk Brand" ))
        
        //http://www.cocoabuilder.com/archive/xcode/270303-comparing-cfstringref-with-string-literal.html
        if (CFStringCompare(deviceNameAsCFString, CFSTR("HD Pro Webcam C920"), 0) == kCFCompareEqualTo) {
           ofLogNotice("ofxUSBDeviceTree")<<"found one";
            
          
            // Save the device's name to our private data.
           // privateDataRef->deviceName = deviceNameAsCFString;
            
            // Now, get the locationID of this device. In order to do this, we need to create an IOUSBDeviceInterface
            // for our device. This will create the necessary connections between our userland application and the
            // kernel object for the USB Device.
            kr = IOCreatePlugInInterfaceForService(usbDevice, kIOUSBDeviceUserClientTypeID, kIOCFPlugInInterfaceID,
                                                   &plugInInterface, &score);
            
            if ((kIOReturnSuccess != kr) || !plugInInterface) {
                fprintf(stderr, "ofxUSBDeviceTree: IOCreatePlugInInterfaceForService returned 0x%08x.\n", kr);
                continue;
            }
            
            // Use the plugin interface to retrieve the device interface.
            res = (*plugInInterface)->QueryInterface(plugInInterface, CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID),
                                                     (LPVOID*) &deviceInterface);
            
            // Now done with the plugin interface.
            (*plugInInterface)->Release(plugInInterface);
            
            if (res || deviceInterface == NULL) {
                fprintf(stderr, "ofxUSBDeviceTree: QueryInterface returned %d.\n", (int) res);
                continue;
            }
            
            // Now that we have the IOUSBDeviceInterface, we can call the routines in IOUSBLib.h.
            // In this case, fetch the locationID. The locationID uniquely identifies the device
            // and will remain the same, even across reboots, so long as the bus topology doesn't change.
            
            NSLog( @"currentLocationID %d ", locationID );
            
            kr = (*deviceInterface)->GetLocationID(deviceInterface, &locationID);
            if (KERN_SUCCESS != kr) {
                fprintf(stderr, "ofxUSBDeviceTree: GetLocationID returned 0x%08x.\n", kr);
                continue;
            }
            else {
                fprintf(stderr, "ofxUSBDeviceTree: Location ID: 0x%lx\n\n", locationID);
            }
            
        }
        
   
        /* do something with device, eg. check properties */
        /* ... */
        /* And free the reference taken before continuing to the next item */
        IOObjectRelease(usbDevice);
    }
    
    /* Done, release the iterator */
    IOObjectRelease(iter);
    
    return allDeviceNames;
}

 vector<unsigned int> ofxUSBDeviceTree::getLocationIDs(string specificDevice){
    
    vector<unsigned int> allLocationIDs;
    
    CFMutableDictionaryRef matchingDict;
    io_iterator_t iter;
    kern_return_t kr;
    io_service_t usbDevice;
    
    IOCFPlugInInterface **plugInInterface = NULL;
    SInt32              score;
    HRESULT             res;
    
    /* set up a matching dictionary for the class */
    matchingDict = IOServiceMatching(kIOUSBDeviceClassName);
    if (matchingDict == NULL)
    {
        return; // fail
    }
    
    /* Now we have a dictionary, get an iterator.*/
    kr = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iter);
    if (kr != KERN_SUCCESS)
    {
        return;
    }
    
    
    
    
    /* iterate */
    while ((usbDevice = IOIteratorNext(iter)))
    {
        io_name_t       deviceName;
        CFStringRef     deviceNameAsCFString;
        //MyPrivateData   *privateDataRef = NULL;
        UInt32          locationID;
        IOUSBDeviceInterface    **deviceInterface;
        
        // Get the USB device's name.
        kr = IORegistryEntryGetName(usbDevice, deviceName);
        if (KERN_SUCCESS != kr) {
            deviceName[0] = '\0';
        }
        
        deviceNameAsCFString = CFStringCreateWithCString(kCFAllocatorDefault, deviceName,
                                                         kCFStringEncodingASCII);
        
        // Dump our data to stderr just to see what it looks like.
     //   fprintf(stderr, "deviceName: ");
     //   CFShow(deviceNameAsCFString);
        

            
            // Save the device's name to our private data.
            // privateDataRef->deviceName = deviceNameAsCFString;
            
            // Now, get the locationID of this device. In order to do this, we need to create an IOUSBDeviceInterface
            // for our device. This will create the necessary connections between our userland application and the
            // kernel object for the USB Device.
            kr = IOCreatePlugInInterfaceForService(usbDevice, kIOUSBDeviceUserClientTypeID, kIOCFPlugInInterfaceID,
                                                   &plugInInterface, &score);
            
            if ((kIOReturnSuccess != kr) || !plugInInterface) {
                fprintf(stderr, "IOCreatePlugInInterfaceForService returned 0x%08x.\n", kr);
                continue;
            }
            
            // Use the plugin interface to retrieve the device interface.
            res = (*plugInInterface)->QueryInterface(plugInInterface, CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID),
                                                     (LPVOID*) &deviceInterface);
            
            // Now done with the plugin interface.
            (*plugInInterface)->Release(plugInInterface);
            
            if (res || deviceInterface == NULL) {
                fprintf(stderr, "QueryInterface returned %d.\n", (int) res);
                continue;
            }
            
            // Now that we have the IOUSBDeviceInterface, we can call the routines in IOUSBLib.h.
            // In this case, fetch the locationID. The locationID uniquely identifies the device
            // and will remain the same, even across reboots, so long as the bus topology doesn't change.
            
            kr = (*deviceInterface)->GetLocationID(deviceInterface, &locationID);
            if (KERN_SUCCESS != kr) {
                fprintf(stderr, "GetLocationID returned 0x%08x.\n", kr);
                continue;
            }
            else {
              //  fprintf(stderr, "Location ID: 0x%lx\n\n", locationID);
            }
            

        const char *cs = CFStringGetCStringPtr( deviceNameAsCFString, kCFStringEncodingMacRoman ) ;
        
        if(specificDevice == ""){
           // fprintf( stderr, "Device Name is %s\n", locationID );
            
            allLocationIDs.push_back(locationID);
            //}else if(strcmp(deviceName, specificDevice) == true){
            // }else if(CFStringCompare(deviceNameAsCFString, CFSTR("HD Pro Webcam C920"), 0) == kCFCompareEqualTo){
        }else if(cs != NULL && std::string(cs) == specificDevice){
            allLocationIDs.push_back(locationID);
        }

        
        
        /* do something with device, eg. check properties */
        /* ... */
        /* And free the reference taken before continuing to the next item */
        IOObjectRelease(usbDevice);
    }
    
    /* Done, release the iterator */
    IOObjectRelease(iter);
     
     return allLocationIDs;
}