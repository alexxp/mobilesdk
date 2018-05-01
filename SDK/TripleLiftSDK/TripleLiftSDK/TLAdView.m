//
//  TLAdViewL.m
//  Pods
//
//  Created by Alexander Prokofiev on 8/1/17.
//
//

#import "TLAdView.h"

@interface TLAdView ()
@property (nonatomic) UIWebView *webview;
@property (nonatomic) dispatch_source_t dispatchSource;
@property (nonatomic) BOOL adVisible;
@end

@implementation TLAdView

- (void)dealloc {

    if (self.dispatchSource) {
        dispatch_source_cancel(_dispatchSource);
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _webview = [[UIWebView alloc] initWithFrame:frame];
        _webview.allowsInlineMediaPlayback = YES;
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _webview = [[UIWebView alloc] initWithFrame:self.frame];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [_webview setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    _webview.delegate = self;
    _webview.scrollView.bounces = NO;
    _webview.scrollView.scrollEnabled = NO;
    [self addSubview:_webview];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSLog(@"%@", request.URL);
    printf("%s\n", [request.URL.absoluteString cStringUsingEncoding:NSUTF8StringEncoding]);
    NSString *urlString = [[request URL] absoluteString];
    if (![urlString length]) {
        [_adLoadDelegate adLoadFailed:ParamsMissing];
        return NO;
    }
    
    if ([urlString containsString:@"js-3lift:ad_ready"]) {
        [_adLoadDelegate adReady:self];
        if (self.detectViewability) {
            [self setupViewabilityCheck];
        }
        return NO;
    }

    if ([urlString containsString:@"js-3lift:no_content"]) {
        [_adLoadDelegate adLoadFailed:NoContent];
        return NO;
    }
    if ([urlString containsString:@"tl_clickthrough=true"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.adLoadDelegate adLoadFailed:ConnectionError];
}

- (BOOL)loadAd {
    if (!_adLoadDelegate) {
        NSLog(@"AdLoad delegate can't be nil");
        return NO;
    }
    if (!self.adSignals) {
        NSLog(@"AdSignals is not set");
        return NO;
    }

    NSURL *url = [NSURL URLWithString:[self generateURL:self.tagURLString]];
    if (!url) {
        NSLog(@"urlString is not valid URL");
       return NO;
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    return YES;
}

- (NSString *)generateURL:(NSString *)placementURLString {
    if (![placementURLString length]) {
        return nil;
    }
    
    NSMutableString *params = [NSMutableString stringWithString:@"&ad_ready_signal=true"];
    for (NSString *key in [self.adSignals allKeys]) {
        NSString *value = self.adSignals[key];
        [params appendFormat:@"&%@=%@", key, value];
    }
    NSString *resultURL = [NSString stringWithFormat:@"%@%@", placementURLString, params];
    return resultURL;
}

- (void)setupViewabilityCheck {
    if (self.dispatchSource) {
        dispatch_suspend(self.dispatchSource);
    }
    self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                                              dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    
    double interval = 0.2;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 0);
    uint64_t intervalTime = (int64_t)(interval * NSEC_PER_SEC);
    dispatch_source_set_timer(self.dispatchSource, startTime, intervalTime, 0);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.dispatchSource, ^{
        [weakSelf checkViewability];
    });
    dispatch_resume(self.dispatchSource);
}

- (void)checkViewability {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = weakSelf.frame;
        UIView *parrentView = weakSelf.superview;
        do {
            frame.origin.x += parrentView.frame.origin.x;
            frame.origin.y += parrentView.frame.origin.y;
            parrentView = parrentView.superview;
        } while (parrentView != nil && ![parrentView isKindOfClass:[UIScrollView class]]);

        if (parrentView != nil) {
            UIScrollView *scrollView = (UIScrollView *)parrentView;
            
            CGPoint offset =  scrollView.contentOffset;
            CGFloat topPoint = frame.origin.y - offset.y;
            CGPoint position = CGPointMake(self.frame.origin.x, topPoint);
            [self reportPosition:position hostViewSize:scrollView.bounds.size];
        }
    });
}

- (void)reportPosition:(CGPoint)adViewPosition hostViewSize:(CGSize)hostViewSize {
    
    CGRect rect = CGRectMake(adViewPosition.x, adViewPosition.y, self.frame.size.width, self.frame.size.height);
    NSString *positionString = [self jsonPositionString:rect];
    NSString *dimmensionString = [self jsonDimmensionString:hostViewSize];
    NSString *jsCommand = [NSString stringWithFormat:@"_tlWebViewUpdatePosition(%@,%@);", positionString, dimmensionString];
    [self.webview stringByEvaluatingJavaScriptFromString:jsCommand];
}

- (NSString *)jsonPositionString:(CGRect)rect {
    NSString *jsonString = [NSString stringWithFormat:@"{\"x\" : %f, \"y\" : %f, \"width\" : %f, \"height\" : %f }",
                            rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
    return jsonString;
}

- (NSString *)jsonDimmensionString:(CGSize)size {
    NSString *jsonString = [NSString stringWithFormat:@"{\"width\" : %f, \"height\" : %f }",
                            size.width, size.height];
    return jsonString;
}

- (UIView *)parentScrollViewForView:(UIView *)view {
    UIView *parrentView = view.superview;
    do {
        parrentView = parrentView.superview;
    } while (parrentView != nil && ![parrentView isKindOfClass:[UIScrollView class]]);
    return parrentView;
}


- (void)dispose {
    [_webview removeFromSuperview];
}
@end

