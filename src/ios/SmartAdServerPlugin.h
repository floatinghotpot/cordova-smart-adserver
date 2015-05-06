
//
//
// Created by Raymond Xie on 2015-05-05
//
//

#import "GenericAdPlugin.h"

#define OPT_SITE_ID     @"siteId"
#define OPT_BASE_URL    @"baseURL"

@interface SmartAdServerPlugin : GenericAdPlugin

- (void)pluginInitialize;

- (void) parseOptions:(NSDictionary *)options;

- (NSString*) __getProductShortName;

- (UIView*) __createAdView:(NSString*)adId;
- (int) __getAdViewWidth:(UIView*)view;
- (int) __getAdViewHeight:(UIView*)view;
- (void) __loadAdView:(UIView*)view;
- (void) __pauseAdView:(UIView*)view;
- (void) __resumeAdView:(UIView*)view;
- (void) __destroyAdView:(UIView*)view;

- (NSObject*) __createInterstitial:(NSString*)adId;
- (void) __loadInterstitial:(NSObject*)interstitial;
- (void) __showInterstitial:(NSObject*)interstitial;
- (void) __destroyInterstitial:(NSObject*)interstitial;

@end



