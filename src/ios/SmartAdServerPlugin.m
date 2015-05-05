
//
//
// Created by Raymond Xie on 2015-05-05
//
//

#import <AdSupport/ASIdentifierManager.h>

#import "SmartAdServerPlugin.h"
#import "SASBannerView.h"
#import "SASInterstitialView.h"

#define kBannerHeight           50
#define kBannerFormatID         15140
#define kInterstitialFormatID   12167
#define kPageID                 @"35176"

#define TEST_BANNER_ID           @"35176/(news_activity)/15140"
#define TEST_INTERSTITIALID      @"35176/(news_activity)/12167"

@interface SmartAdServerPlugin()<SASAdViewDelegate>

- (NSString *) __getAdMobDeviceId;

@end

@implementation SmartAdServerPlugin

- (void)pluginInitialize
{
    [super pluginInitialize];

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

    // parse my options
}

- (UIView*) __createAdView:(NSString*)adId {
    
    UIView * parentView = [self getView];
    CGRect rect = CGRectMake(0, 0, parentView.frame.size.width, kBannerHeight);
    SASBannerView *ad = [[SASBannerView alloc] initWithFrame:rect
                                                             loader:SASLoaderActivityIndicatorStyleWhite];

    ad.expandsFromTop = YES;
    ad.modalParentViewController = [self getViewController];
    ad.delegate = self;
    
    return ad;
}

- (NSString *) __getAdMobDeviceId
{
    NSUUID* adid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    return [self md5:adid.UUIDString];
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
    if(! view) return;
    
    SASBannerView* ad = (SASBannerView*) view;
    [ad loadFormatId:kBannerFormatID pageId:kPageID master:NO target:nil];
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
    UIView * parentView = [self getView];
    SASInterstitialView *ad = [[SASInterstitialView alloc] initWithFrame:parentView.bounds loader:SASLoaderNone];
    ad.delegate = self;
    ad.modalParentViewController = [self getViewController];
    return ad;
}

- (void) __loadInterstitial:(NSObject*)interstitial {
    SASInterstitialView* ad = (SASInterstitialView*) interstitial;
    if(ad) {
        [ad loadFormatId:kInterstitialFormatID pageId:kPageID master:YES target:nil timeout:5];
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
    
    // TODO: we need tell whether it's banner or interstitial Ad
    
    if((! self.bannerVisible) && self.autoShowBanner) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __showBanner:self.adPosition atX:self.posX atY:self.posY];
        });
    }
    [self fireAdEvent:EVENT_AD_LOADED withType:ADTYPE_BANNER];
}

//Called when the SASAdView instance failed to download the ad
- (void)adViewDidFailToLoad:(SASAdView *)adView error:(NSError *)error {
    
    // TODO: we need tell whether it's banner or interstitial Ad
    
    [self fireAdErrorEvent:EVENT_AD_FAILLOAD withCode:(int)error.code withMsg:[error localizedDescription] withType:ADTYPE_BANNER];
}

@end
