//
//  TLAdConfigL.h
//  Pods
//
//  Created by Alexander Prokofiev on 8/1/17.
//
//

#import <Foundation/Foundation.h>
@import CoreLocation;


/**
 An enumeration that defines the return values of the Connection type
 of the device.
 */
typedef NS_ENUM(NSInteger, ConnectionType) {
    Cell_Unknown,
    Ethernet,
    WIFI,
    WWAN_2G,
    WWAN_3G,
    WWAN_4G,
};

/**
 An enumeration that defines the return values of the Connection status
 of the device.
 */
typedef NS_ENUM(NSInteger, ConnectionStatus)  {
    Offline,
    Online,
    Unknown
};

/**
 The purpose of this class is to collect required Ads signals and construct ad request URL
 */
@interface TLAdSignals : NSObject

/**
 This is optional property to be provided by host application. If provided, location data will be included to URL request
 */
@property (nonatomic) CLLocation *location;

/**
 This is optional property to be provided by host application as key-value pairs.
 If provided by the app shoudl include mandatory parameters:
 ifa: Device IDFA,
 conntype: Connection type,
 v: Application version
 carrier: Cell network carrier name
 bundle: Application bundle ID
 If  not provided, default ads signals will be collected
 */
- (NSDictionary *)appSignalsData;
@end
