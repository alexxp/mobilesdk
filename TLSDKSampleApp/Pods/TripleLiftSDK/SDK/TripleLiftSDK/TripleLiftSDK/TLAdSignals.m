//
//  TLAdSignals.m
//  Pods
//
//  Created by Alexander Prokofiev on 8/1/17.
//
//

#import "TLAdSignals.h"
#import <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>

@import SystemConfiguration;
@import CoreTelephony;
@import AdSupport;
@import Foundation;
@import SystemConfiguration;

const NSString *IDFA = @"ifa";
const NSString *ConnType = @"conntype";
const NSString *AppVersion = @"v";
const NSString *Carrier = @"carrier";
const NSString *Location = @"loc";
const NSString *bundleID = @"bundle";

typedef struct {
    ConnectionStatus connection;
    ConnectionType type;
}ReachabilityStatus;

@implementation TLAdSignals

- (NSDictionary *)appSignalsData {
    NSMutableDictionary *appSignals = [NSMutableDictionary dictionary];
    
    ReachabilityStatus reachability = [self reachability];
    //ConnectionType connectionType = reachability.type;
    
    
    switch (reachability.type) {
        case WIFI:
            appSignals[ConnType] = @"2";
            break;
        case Cell_Unknown:
            appSignals[ConnType] = @"3";
            break;
        case WWAN_2G:
            appSignals[ConnType] = @"4";
            break;
        case WWAN_3G:
            appSignals[ConnType] = @"5";
            break;
        case WWAN_4G:
            appSignals[ConnType] = @"6";
            break;
        default:
            appSignals[ConnType] = @"0";
            break;
    }
    
    NSString *carrierName = [self carrierName];
    
    switch (reachability.type) {
        case WWAN_4G:
        case WWAN_3G:
        case WWAN_2G:
        case Cell_Unknown:
            if ([carrierName length]) {
                appSignals[Carrier] = carrierName;
            }
            break;
        case WIFI:
            appSignals[Carrier] = @"WIFI";
            break;
        default:
            break;
    }
    
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        NSString *IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        appSignals[IDFA] = IDFA;
    }
    else {
        //IDFA is not enabled
    }
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleID  length]) {
        appSignals[bundleID] = bundleID;
    }
    
    NSString *bundleVer =[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if ([bundleVer length]) {
        appSignals[AppVersion] = bundleVer;
    }
    
    if (self.location != nil) {
        CLLocationDegrees latitude = self.location.coordinate.latitude;
        CLLocationDegrees longitude = self.location.coordinate.longitude;
        
        if (latitude != 0 || longitude != 0) {
            appSignals[Location] = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
        }
    }
    return appSignals;
    
}

- (ReachabilityStatus)reachability {
    ReachabilityStatus status;
    status.connection = Online;
    status.type = Cell_Unknown;
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
        SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        status.connection = Offline;
    }
    else {
        status.connection = Online;
        
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    
    BOOL  isWWAN = (flags & kSCNetworkReachabilityFlagsIsWWAN);
    if (!(isReachable && !needsConnection)) {
        status.connection = Offline;
        return status;
    }
    
    if (isWWAN) {
        
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *networkString = networkInfo.currentRadioAccessTechnology;
        
        if ([networkString  isEqualToString:CTRadioAccessTechnologyLTE]) {
            status.connection = Online;
            status.type = WWAN_4G;
            return status;
        }
        else if ([networkString isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            status.connection = Online;
            status.type = WWAN_3G;
            return status;
        }
        else if ([networkString isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
            status.connection = Online;
            status.type = WWAN_3G;
            return status;
        }
        else if ([networkString isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
            status.connection = Online;
            status.type = WWAN_3G;
            return status;
        }
        else if ([networkString isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
            status.connection = Online;
            status.type = WWAN_3G;
            return status;
        }
        else if ([networkString isEqualToString:CTRadioAccessTechnologyHSUPA]) {
            status.connection = Online;
            status.type = WWAN_3G;
            return status;
        }
        else if ([networkString isEqualToString:CTRadioAccessTechnologyHSDPA]) {
            status.connection = Online;
            status.type = WWAN_3G;
            return status;
        }
        else if ([networkString isEqualToString:CTRadioAccessTechnologyWCDMA]) {
            status.connection = Online;
            status.type = WWAN_3G;
            return status;
        }
        else if ([networkString isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            status.connection = Online;
            status.type = WWAN_2G;
            return status;
        }
        else if ([networkString isEqualToString:CTRadioAccessTechnologyGPRS]) {
            status.connection = Online;
            status.type = WWAN_2G;
            return status;
        }
        else if ([networkString isEqualToString:CTRadioAccessTechnologyEdge]) {
            status.connection = Online;
            status.type = WWAN_2G;
            return status;
        }
        else {
            status.connection = Online;
            status.type = Cell_Unknown;
            return status;
        }
    }
    else {
        status.connection = Online;
        status.type = WIFI;
        return status;
    }
}

- (NSString *)carrierName {
    CTTelephonyNetworkInfo *phoneInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *phoneCarrier = phoneInfo.subscriberCellularProvider;
    NSString *carrierName = phoneCarrier.carrierName;
    return carrierName;
}
@end


