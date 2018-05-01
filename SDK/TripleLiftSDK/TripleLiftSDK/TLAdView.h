//
//  TLAdViewL.h
//  Pods
//
//  Created by Alexander Prokofiev on 8/1/17.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TLAdError) {
    ParamsMissing,
    ConnectionError,
    NoContent
};

@class TLAdView;

@protocol TLAdLoadDelegate <NSObject>
/**
 This method is called one Ad is loaded and redy to be presented
 */
- (void)adReady:(TLAdView *)adView;

/**
 This method is called when there is Ad load error, includein no-ad response, and any parameters missing error
 */
- (void)adLoadFailed:(TLAdError)error;

/**
 This method is called to request if external browser needs to be opened for click through URL.
 */
- (BOOL)shouldLoadExternalBrowser:(NSURL *)url;

@end

@interface TLAdView : UIView <UIWebViewDelegate>


@property (nonatomic, weak) id<TLAdLoadDelegate> adLoadDelegate;
@property (nonatomic) NSString *tagURLString;
@property (nonatomic) NSDictionary *adSignals;

/**
 If sets to YES, TLAdView will try to detect it's position relatively to first available UIScrollView
*/
@property (nonatomic) BOOL detectViewability;


/**
    Inform TLAdView it's position relative to it's parrent view. This is needed to detect viewability
 
 @param adViewPosition position of the TLAdview relatively to its host view (usually UIScrollView based)
 @param hostViewSize parrent's view  dimmension
 */
- (void)reportPosition:(CGPoint)adViewPosition hostViewSize:(CGSize)hostViewSize;

/**
Initiates Ad loading
 
 @return YES if all require parameters verified, and ad loading is started
 */
- (BOOL)loadAd;

- (void)dispose;
@end
