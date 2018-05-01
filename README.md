# Triplelift SDK Lite

The TripleLift SDK Lite allows you to monetize native in-app inventory for both programmatic demand and direct sell campaigns.

This document details the process of integrating the TripleLift SDK Lite with your mobile application.


## Disclosure
TripleLift SDK Lite integrates technology from Mopub and Google DFP.
You have the option to remove or disable these technologies by following the opt-out instructions.

If you do not remove or disable Mopub and/or DFP technology in accordance with these instructions, you agree that Mopubs privacy policy and license and DFP privacy policy, terms, and license, respectively, apply to your integration of these partners' technologies into your application.


## Requirements

iOS 8.0 & up

## Integration options

Here are 2 basic steps to setup your app with TripleLift SDK.

Install TripleLift iOS SDK
Import Header
Create and use TLAdview in your application

**OPTION 1 - INSTALL VIA COCOAPODS**

Add the following to your pod file:
pod 'TripleLiftSDK'

**OPTION 2 - MANUAL INSTALL**

Remove any previously installed version of Triplelift SDK.

Drag TripleliftSDK.framework file into your project.

Open project's target settings.

Select the Build Settings tab.

In the Deployment Info section of the General tab, set Deployment Target for your app to 8.0 or higher. (iOS 8 is the minimum supported iOS release for the SDK.)

Add the -objective_c build flag to your linker flags 

Make sure to link against the following frameworks

TripleLift.framework
MediaPlayer.framework
AdSupport.framework
CoreGraphics.framework
UIKit.framework
Foundation.framework
AVKit.framework
AVFoundation.framework
CoreMedia.framework
SafariServices.framework


## App Transport Security Settings
App Transport Security (ATS) setting which requires apps to make network requests only via HTTPS.

To disable ATS, add following key/value in your app’s Info.plist file
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>

It can be also done  directly in XCode.

# Integrate TripleLift Native Ads

## Implement the protocol

In order to show ads, your ViewController needs to impement a protocol that conforms to the TLAdLoadDelegate Protocol which implements 3 require methods:
```
- (void)adReady:(TLAdView *)adView;
- (void)adLoadFailed:(TLAdError)error;
- (BOOL)shouldLoadExternalBrowser:(NSURL *)url;
```
## Setup  TLAdView
TLAdView is a container view which wraps all required rendering and responsible for sending events back to its delegate.

TLAdView can be created programmatically by calling **-(instancetype)initWithFrame:(CGRect)frame** method, or by placing UIView componnent in Interface builder and setting its class to TLAdView

## Setting the delegate.

After TLAdView has been instantiated, its delegate proprty has to be assigned. The delegate is the class which implements TLAdLoadDelegate protocol.  

**OBJC**
```
self.adView = [[TLAdView alloc] initWithFrame:(placeHoldeview.bounds];
```
**Swift**
```
adView = TLAdView(frame: placeHoldeview.bounds)
```

With no delegate property assigned, the TLAdView will not start loading ads and return error.


## Ad loading process
To start Ad loading process the application should provide an Ad Tag and then call **loadAd** method:
**OBJC**
```
NSString *urlTagString = @"%_AD_TAG_GOES_HERE_";
TLAdView adView = [[TLAdView alloc] initWithFrame:(placeholdeView.bounds];
adView.delegate = self; //
adView.tagURLString = urlTagString;
[placeholderView addSubview:adView];
[adView loadAd];
```
**Swift**
```
let adView = TLAdView(frame: placeholdeView.bounds)
adView.tagURLString = "%_AD_TAG_GOES_HERE_"
adView.adLoadDelegate = self
placeHoldeview.addSubview(adView)
adView.loadAd()
```

## Signals 
In order for SDK to properly work it requires to attach Ad signals to every request. Those signals include Application name and version, wifi amd/or cell network type, device advertiser Id number, optional location parameters and others. The SDK has signals handler and by default includes signals into URL request.
Application can override those parameters by supplying its own signals. Signals data is a key/value dictionary with mandatory fields:

**ifa** - Device advertiser ID (String)

**conntype** - Network connection type (Number)

**carrier** - Cell network carrier name, if available (String)

**v** - Application version (String)

**bundle** - Application bundle name

## Optional location parameters
To improve ad's targeting, application can pass location data to the SDK. Location, if available, should be provided to the SDK by passing **CLLocation** object to **setLocation()** method

## Optional automatic viewability tracking
TripleLift SDK Lite, supports mutliple different formats. For some of the formats to work properly information about TLAdView's position is required. This could be done by 2 ways: 

**Position's data provided by the application**

In this case application provides SDK with possitions data by calling **setPosition()** method, and psssing **CGPoint** object into it. The CGREct object should represent the position of the TLAdView, relative to the visible screen;

**Position's data tracked by SDK**


