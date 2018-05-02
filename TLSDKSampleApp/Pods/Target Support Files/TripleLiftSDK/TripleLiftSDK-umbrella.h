#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MPBannerCustomEvent.h"
#import "MPBannerCustomEventDelegate.h"
#import "TLAdSignals.h"
#import "TLAdView.h"
#import "TripleLiftSDK.h"
#import "TripleLiftSDKTests-Bridging-Header.h"

FOUNDATION_EXPORT double TripleLiftSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char TripleLiftSDKVersionString[];

