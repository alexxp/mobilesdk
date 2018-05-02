//
//  TLAdViewTest.m
//  TripleLiftSDKTests
//
//  Created by Alexander Prokofiev on 10/6/17.
//  Copyright © 2017 TripleLift. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TLAdView.h"
#import "TLAdSignals.h"


@interface TLAdView ()
@property (nonatomic) UIWebView *webview;
- (NSString *)generateURL:(NSString *)placementURLString;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

@interface TLAdViewTest : XCTestCase <TLAdLoadDelegate>
@property (nonatomic) TLAdView *adView;
@property (nonatomic) BOOL adReadySignal;

@end

@implementation TLAdViewTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.adView = [[TLAdView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 100.0)];
    self.adView.adLoadDelegate = self;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testWebViewSetup {
    XCTAssert(!self.adView.webview.scrollView.bounces, @"WebView shouldn't bounce");
    XCTAssert(!self.adView.webview.scrollView.scrollEnabled, @"WebView shouldn't scroll");
}

- (void)testResizing {
    CGRect adViewFrame =  self.adView.frame;
    
    adViewFrame.size.height = 200.0;
    self.adView.frame = adViewFrame;
    
    CGSize adViewSize = self.adView.frame.size;
    XCTAssert(_adView.webview.frame.size.height == adViewSize.height, @"TLAdView not resized!");
}

- (void)testParamsHandling {
    self.adView.tagURLString = nil;
    XCTAssert (![self.adView loadAd], @"Adview should return NO if try to load it with nil url string");

    self.adView.tagURLString = @"";
    XCTAssert (![self.adView loadAd], @"Adview should return NO if try to load it with empty url string");

    self.adView.tagURLString = @"http://localhost";
    self.adView.adLoadDelegate = self;
    self.adView.adSignals = [[[TLAdSignals alloc] init] appSignalsData];
    XCTAssert ([self.adView loadAd], @"Adview should return YES if all required params available");
}


- (void)testGenerateURL {
    
    NSString *urlErrorString = [self.adView generateURL:@""];
    XCTAssert(!urlErrorString, @"Should not generate URL if placement string is missing");
    NSString *urlString = [self.adView generateURL:@"http://localhost"];
    XCTAssert(urlString, @"Should generate URL if placement is valid URL");
    
    NSURL *url = [NSURL URLWithString:urlString];
    XCTAssert(url, @"Generated string should be valid URL");
}


- (void)testWebViewResponses {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/"]];
    self.adReadySignal = NO;
    BOOL response = [self.adView webView:self.adView.webview shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeOther];
    
    XCTAssert(response, @"Should load regular URL");
    XCTAssert( !self.adReadySignal, @" Should not set Ad ready signal");
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/someparam=1&js-3lift:ad_ready"]];
    self.adReadySignal = NO;
    response = [self.adView webView:self.adView.webview shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeOther];
    
    XCTAssert(!response, @"Should not load URL with Ad ready signal");
    XCTAssert( self.adReadySignal, @"Should set Ad ready signal");

}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)adReady:(TLAdView *)adView {
    self.adReadySignal = YES;
}
- (void)adLoadFailed:(TLAdError)error {
    
}

@end
