
//
//
// Created by Raymond Xie on 2015-05-05
//
//

#import <AdSupport/ASIdentifierManager.h>

#import "SmartAdServerPlugin.h"
#import "SASBannerView.h"
#import "SASInterstitialView.h"

#define TEST_SITE_ID            73569
#define TEST_BASE_URL           @"http://mobile.smartadserver.com"
#define TEST_BANNER_ID           @"549527/15140"
#define TEST_INTERSTITIALID      @"549527/12145"

#define BANNER_AD_WIDTH         320
#define BANNER_AD_HEIGHT        50

@interface SmartAdServerPlugin()<SASAdViewDelegate>

@property (assign) int mSiteId;
@property (nonatomic, retain) NSString* mBaseURL;

@property (nonatomic, retain) NSString* mBannerPageId;
@property (assign) int mBannerFormatId;

@property (nonatomic, retain) NSString* mInterstitialPageId;
@property (assign) int mInterstitialFormatId;

@end

@implementation SmartAdServerPlugin

- (void)pluginInitialize
{
    [super pluginInitialize];

    self.adWidth = BANNER_AD_WIDTH;
    self.adHeight = BANNER_AD_HEIGHT;

    self.mSiteId = TEST_SITE_ID;
    self.mBaseURL = TEST_BASE_URL;

    self.testTraffic = FALSE;
}

- (NSString*) __getProductShortName { return @"SmartAdServer"; }

- (NSString*) __getTestBannerId {
    return TEST_BANNER_ID;
}
- (NSString*) __getTestInterstitialId {
    return TEST_INTERSTITIALID;
}

- (void) parseOptions:(NSDictionary *)options
{
    [super parseOptions:options];

    if(self.isTesting) {
        [SASAdView setLoggingEnabled:YES];
        [SASAdView setTestModeEnabled:YES];
    }

    NSString* str = [options objectForKey:OPT_SITE_ID];
    if(str) self.mSiteId = [str intValue];

    str = [options objectForKey:OPT_BASE_URL];
    if(str) self.mBaseURL = str;

    [SASAdView setSiteID:self.mSiteId baseURL:self.mBaseURL];
}

- (UIView*) __createAdView:(NSString*)adId {
    
    NSArray* fields = [adId componentsSeparatedByString:@"/"];
    if([fields count] >= 2) {
        self.mBannerPageId = [fields objectAtIndex:0];
        self.mBannerFormatId = [[fields objectAtIndex:1] intValue];
    }
    
    UIView * parentView = [self getView];
    CGRect rect = CGRectMake(0, 0, parentView.frame.size.width, BANNER_AD_HEIGHT);
    SASBannerView *ad = [[SASBannerView alloc] initWithFrame:rect
                                                      loader:SASLoaderActivityIndicatorStyleWhite];

    ad.expandsFromTop = YES;
    ad.modalParentViewController = [self getViewController];
    ad.delegate = self;
    
    return ad;
}

- (void) __showBanner:(int) position atX:(int)x atY:(int)y
{
    SASBannerView* ad = (SASBannerView*) self.banner;
    
    if([self __isLandscape]) {
    } else {
    }
    
    [super __showBanner:position atX:x atY:y];
}

- (int) __getAdViewWidth:(UIView*)view {
    return view.frame.size.width;
}

- (int) __getAdViewHeight:(UIView*)view {
    return view.frame.size.height;
}

- (void) __loadAdView:(UIView*)view {
    
    if(self.isTesting) NSLog(@"__loadAdView");

    SASBannerView* ad = (SASBannerView*) view;
    if(ad) {
        [ad loadFormatId:self.mBannerFormatId
                  pageId:self.mBannerPageId
                  master:YES
                  target:nil];
    }
}

- (void) __pauseAdView:(UIView*)view {
}

- (void) __resumeAdView:(UIView*)view {
}

- (void) __destroyAdView:(UIView*)view {
    if(! view) return;
    [view removeFromSuperview];
    
    SASBannerView* ad = (SASBannerView*) view;
    ad.delegate = nil;
    ad.modalParentViewController = nil;
    ad = nil;
}

- (NSObject*) __createInterstitial:(NSString*)adId {
    NSArray* fields = [adId componentsSeparatedByString:@"/"];
    if([fields count] >= 2) {
        self.mInterstitialPageId = [fields objectAtIndex:0];
        self.mInterstitialFormatId = [[fields objectAtIndex:1] intValue];
    }
    
    UIView * parentView = [self getView];
    SASInterstitialView *ad = [[SASInterstitialView alloc] initWithFrame:parentView.bounds
                                                                  loader:SASLoaderNone];
    ad.delegate = self;
    ad.modalParentViewController = [self getViewController];
    return ad;
}

- (void) __loadInterstitial:(NSObject*)interstitial {
    if(self.isTesting) NSLog(@"__loadInterstitial");

    SASInterstitialView* ad = (SASInterstitialView*) interstitial;
    if(ad) {
        [ad loadFormatId:self.mInterstitialFormatId
                  pageId:self.mInterstitialPageId
                  master:YES
                  target:nil];
    }
}

- (void) __showInterstitial:(NSObject*)interstitial {
    SASInterstitialView* ad = (SASInterstitialView*) interstitial;
    if(ad) {
        [[self getView] addSubview:ad];
    }
}

- (void) __destroyInterstitial:(NSObject*)interstitial {
    SASInterstitialView* ad = (SASInterstitialView*) interstitial;
    if(ad) {
        [ad dismissalAnimations];

        ad.delegate = nil;
        ad.modalParentViewController = nil;
        ad = nil;
    }
}

#pragma mark GADBannerViewDelegate implementation

/**
 * document.addEventListener('onAdLoaded', function(data));
 * document.addEventListener('onAdFailLoad', function(data));
 * document.addEventListener('onAdPresent', function(data));
 * document.addEventListener('onAdDismiss', function(data));
 * document.addEventListener('onAdLeaveApp', function(data));
 */
//Called when your ad is ready to be displayed or is displayed if you already called [self.view addSubview:myBanner];
- (void)adViewDidLoad:(SASAdView *)adView {
    if(self.isTesting) NSLog(@"adViewDidLoad");

    if([adView isKindOfClass:[SASBannerView class]]) {
        if((! self.bannerVisible) && self.autoShowBanner) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self __showBanner:self.adPosition atX:self.posX atY:self.posY];
            });
        }
        [self fireAdEvent:EVENT_AD_LOADED withType:ADTYPE_BANNER];

    } else if([adView isKindOfClass:[SASInterstitialView class]]) {
        if (self.interstitial && self.autoShowInterstitial) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self __showInterstitial:self.interstitial];
            });
        }
        [self fireAdEvent:EVENT_AD_LOADED withType:ADTYPE_INTERSTITIAL];

    }

}

//Called when the SASAdView instance failed to download the ad
- (void)adViewDidFailToLoad:(SASAdView *)adView error:(NSError *)error {
    
    NSLog(@"%d - %@", (int)error.code, [error localizedDescription]);

    if([adView isKindOfClass:[SASBannerView class]]) {
        [self fireAdErrorEvent:EVENT_AD_FAILLOAD withCode:(int)error.code withMsg:[error localizedDescription] withType:ADTYPE_BANNER];

    } else if([adView isKindOfClass:[SASInterstitialView class]]) {
        [self fireAdErrorEvent:EVENT_AD_FAILLOAD withCode:(int)error.code withMsg:[error localizedDescription] withType:ADTYPE_INTERSTITIAL];

    }
}

- (void)adViewDidDisappear:(SASAdView *)adView {
    if([adView isKindOfClass:[SASBannerView class]]) {
        [self fireAdEvent:EVENT_AD_DISMISS withType:ADTYPE_BANNER];

    } else if([adView isKindOfClass:[SASInterstitialView class]]) {
        [self fireAdEvent:EVENT_AD_DISMISS withType:ADTYPE_INTERSTITIAL];

        if(self.interstitial) {
            [self __destroyInterstitial:self.interstitial];
            self.interstitial = nil;
        }

    }
}

- (void)adViewWillPresentModalView:(SASAdView *)adView {
    if([adView isKindOfClass:[SASBannerView class]]) {
        [self fireAdEvent:EVENT_AD_PRESENT withType:ADTYPE_BANNER];

    } else if([adView isKindOfClass:[SASInterstitialView class]]) {
        [self fireAdEvent:EVENT_AD_PRESENT withType:ADTYPE_INTERSTITIAL];

    }
}

- (void)adViewWillDismissModalView:(SASAdView *)adView {
    if([adView isKindOfClass:[SASBannerView class]]) {
        [self fireAdEvent:EVENT_AD_WILLDISMISS withType:ADTYPE_BANNER];

    } else if([adView isKindOfClass:[SASInterstitialView class]]) {
        [self fireAdEvent:EVENT_AD_WILLDISMISS withType:ADTYPE_INTERSTITIAL];

    }
}

- (void)adView:(SASAdView *)adView willPerformActionWithExit:(BOOL)willExit {
    if(willExit) {
        if([adView isKindOfClass:[SASBannerView class]]) {
            [self fireAdEvent:EVENT_AD_LEAVEAPP withType:ADTYPE_BANNER];

        } else if([adView isKindOfClass:[SASInterstitialView class]]) {
            [self fireAdEvent:EVENT_AD_LEAVEAPP withType:ADTYPE_INTERSTITIAL];

        }
    }
}


@end
