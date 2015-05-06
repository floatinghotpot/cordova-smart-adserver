package com.rjfun.cordova.smartadserver;

import com.rjfun.cordova.ad.GenericAdPlugin;

import org.json.JSONObject;

import android.util.DisplayMetrics;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.ads.AdSize;
import com.smartadserver.android.library.SASBannerView;
import com.smartadserver.android.library.SASInterstitialView;
import com.smartadserver.android.library.model.SASAdElement;
import com.smartadserver.android.library.ui.SASAdView;
import com.smartadserver.android.library.ui.SASAdView.StateChangeEvent;
import com.smartadserver.android.library.util.SASUtil;

public class SmartAdServerPlugin extends GenericAdPlugin {

    private static final String LOGTAG = "SmartAdServer";
    
    private static final int TEST_SITE_ID = 35176;
    private static final String TEST_BASE_URL = "";
    private static final String TEST_BANNER_ID = "(news_activity)/15140";
    private static final String TEST_INTERSTITIAL_ID = "(news_activity)/12167";

	//Constants for phone sized ads (320x50)
	private static final int BANNER_AD_WIDTH = 320;
	private static final int BANNER_AD_HEIGHT = 50;
    
    private static final String OPT_SITE_ID = "siteId";
    private static final String OPT_BASE_URL = "baseUrl";

    private float screenDensity = 1.0f;

    private int siteId;
    private String baseUrl;

    private String mBannerPageId;
    private int mBannerFormatId;

    private String mInterstitialPageId;
    private int mInterstitialFormatId;

    @Override
    protected void pluginInitialize() {
    	super.pluginInitialize();
    	
    	SASUtil.enableLogging();
    	
        siteId = TEST_SITE_ID;
        baseUrl = TEST_BASE_URL;

    	adWidth = BANNER_AD_WIDTH;
    	adHeight = BANNER_AD_HEIGHT;

    	DisplayMetrics metrics = new DisplayMetrics();
        getActivity().getWindowManager().getDefaultDisplay().getMetrics(metrics);
        screenDensity = metrics.density;

        testTraffic = false;
	}
    
	@Override
	protected String __getProductShortName() {
		return "SmartAdServer";
	}

	@Override
	protected String __getTestBannerId() {
		return TEST_BANNER_ID;
	}

	@Override
	protected String __getTestInterstitialId() {
		return TEST_INTERSTITIAL_ID;
	}

    private AdSize adSize = AdSize.SMART_BANNER;

    public static AdSize adSizeFromString(String size) {
        if ("BANNER".equals(size)) {
            return AdSize.BANNER;
        } else if ("SMART_BANNER".equals(size)) {
            return AdSize.SMART_BANNER;
        } else if ("MEDIUM_RECTANGLE".equals(size)) {
            return AdSize.MEDIUM_RECTANGLE;
        } else if ("FULL_BANNER".equals(size)) {
            return AdSize.FULL_BANNER;
        } else if ("LEADERBOARD".equals(size)) {
            return AdSize.LEADERBOARD;
        } else if ("SKYSCRAPER".equals(size)) {
            return AdSize.WIDE_SKYSCRAPER;
        } else {
            return null;
        }
    }

	@Override
	public void setOptions(JSONObject options) {
		super.setOptions(options);
		
     	if(options.has(OPT_AD_SIZE)) this.adSize = adSizeFromString( options.optString(OPT_AD_SIZE) );
    	if(options.has(OPT_WIDTH)) this.adWidth = options.optInt( OPT_WIDTH );
    	if(options.has(OPT_HEIGHT)) this.adHeight = options.optInt( OPT_HEIGHT );
    	if(this.adSize == null) {
    		this.adSize = new AdSize(this.adWidth, this.adHeight);
    	}

        if(options.has( OPT_SITE_ID )) this.siteId = options.optInt( OPT_SITE_ID );

        if(options.has(OPT_BASE_URL)) {
            this.baseUrl = options.optString( OPT_BASE_URL );
            SASAdView.setBaseUrl( this.baseUrl );
        }
	}
	
	@Override
	protected View __createAdView(String adId) {
		String[] items = adId.split("/");
		if(items.length >= 2) {
			mBannerPageId = items[0];
			mBannerFormatId = Integer.parseInt(items[1]);
		}
		
		final SASBannerView ad = new SASBannerView(this.getActivity());
		
		if (adSize != null) {
			adWidth = adSize.getWidth();
			adHeight = adSize.getHeight();
		}
		
		if (adWidth < 0) {
			adWidth = (int) (getView().getWidth() / screenDensity);
		}
		if (adHeight < 0) {
			adHeight = (adWidth > 360) ? 90 : 50;
		}
		
		ad.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, adHeight));

		ad.addStateChangeListener(new SASAdView.OnStateChangeListener() {
			@Override
			public void onStateChanged(final StateChangeEvent arg0) {
				// UI sensitive code needs to be executed on UI thread
				ad.executeOnUIThread(new Runnable() {
					@Override
					public void run() {
						switch(arg0.getType()) {
						case SASAdView.StateChangeEvent.VIEW_DEFAULT:
							break;
						case SASAdView.StateChangeEvent.VIEW_EXPANDED:
			            	fireAdEvent(EVENT_AD_PRESENT, ADTYPE_BANNER);
							break;
						case SASAdView.StateChangeEvent.VIEW_HIDDEN:
			            	fireAdEvent(EVENT_AD_DISMISS, ADTYPE_BANNER);
							break;
						case SASAdView.StateChangeEvent.VIEW_RESIZED:
							break;
						}
					}
				});
			}
		});
		
		return ad;
	}

	@Override
	protected int __getAdViewWidth(View view) {
		return (int) (adWidth * screenDensity);
	}

	@Override
	protected int __getAdViewHeight(View view) {
		return (int) (adHeight * screenDensity);
	}

	@Override
	protected void __loadAdView(View view) {
		if(view instanceof SASBannerView) {
			final SASBannerView ad = (SASBannerView)view;
			
			// instantiate the response handler used when loading an ad on the banner
			ad.loadAd(siteId, mBannerPageId, mBannerFormatId, true, "", new SASAdView.AdResponseHandler() {

				@Override
				public void adLoadingCompleted(SASAdElement arg0) {
					// UI sensitive code needs to be executed on UI thread
					ad.executeOnUIThread(new Runnable() {
						@Override
						public void run() {
							// make banner visible
							if((! bannerVisible) && autoShowBanner) {
			    				showBanner(adPosition, posX, posY);
			    			}
			            	fireAdEvent(EVENT_AD_LOADED, ADTYPE_BANNER);
						}
					});
				}

				@Override
				public void adLoadingFailed(Exception arg0) {
					// UI sensitive code needs to be executed on UI thread
					ad.executeOnUIThread(new Runnable() {
						@Override
						public void run() {
			            	fireAdErrorEvent(EVENT_AD_FAILLOAD, -1, "Failed loading ad", ADTYPE_BANNER);
						}
					});
				}
				// ad loading was successful
			});
		}
	}

	@Override
	protected void __pauseAdView(View view) {
		if(view instanceof SASBannerView) {
			SASBannerView ad = (SASBannerView)view;
			//ad.pause();
		}
	}

	@Override
	protected void __resumeAdView(View view) {
		if(view instanceof SASBannerView) {
			SASBannerView ad = (SASBannerView)view;
			//ad.resume();
		}
	}

	@Override
	protected void __destroyAdView(View view) {
		if(view instanceof SASBannerView) {
			SASBannerView ad = (SASBannerView)view;
			ad.onDestroy();
		}
	}

	@Override
	protected Object __createInterstitial(String adId) {
		String[] items = adId.split("/");
		if(items.length >= 2) {
			mInterstitialPageId = items[0];
			mInterstitialFormatId = Integer.parseInt(items[1]);
		}

		final SASInterstitialView ad = new SASInterstitialView(this.getActivity());
		
		ad.addStateChangeListener(new SASAdView.OnStateChangeListener() {
			@Override
			public void onStateChanged(final StateChangeEvent arg0) {
				// UI sensitive code needs to be executed on UI thread
				ad.executeOnUIThread(new Runnable() {
					@Override
					public void run() {
						switch(arg0.getType()) {
						case SASAdView.StateChangeEvent.VIEW_DEFAULT:
							break;
						case SASAdView.StateChangeEvent.VIEW_EXPANDED:
			            	fireAdEvent(EVENT_AD_PRESENT, ADTYPE_INTERSTITIAL);
							break;
						case SASAdView.StateChangeEvent.VIEW_HIDDEN:
			            	fireAdEvent(EVENT_AD_DISMISS, ADTYPE_INTERSTITIAL);
							break;
						case SASAdView.StateChangeEvent.VIEW_RESIZED:
							break;
						}
					}
				});
			}
		});
		
		return ad;
	}

	@Override
	protected void __loadInterstitial(Object interstitial) {
		if(interstitial instanceof SASInterstitialView) {
			final SASInterstitialView ad = (SASInterstitialView)interstitial;
			
			// instantiate the response handler used when loading an ad on the banner
			ad.loadAd(siteId, mInterstitialPageId, mInterstitialFormatId, true, "", new SASAdView.AdResponseHandler() {

				@Override
				public void adLoadingCompleted(SASAdElement arg0) {
					// UI sensitive code needs to be executed on UI thread
					ad.executeOnUIThread(new Runnable() {
						@Override
						public void run() {
			    			if(autoShowInterstitial) {
			                	showInterstitial();
			                }
			            	fireAdEvent(EVENT_AD_LOADED, ADTYPE_INTERSTITIAL);
						}
					});
				}

				@Override
				public void adLoadingFailed(Exception arg0) {
					// UI sensitive code needs to be executed on UI thread
					ad.executeOnUIThread(new Runnable() {
						@Override
						public void run() {
			            	fireAdErrorEvent(EVENT_AD_FAILLOAD, -1, "Failed loading ad", ADTYPE_INTERSTITIAL);
						}
					});
				}
				// ad loading was successful
			});
		}
	}

	@Override
	protected void __showInterstitial(Object interstitial) {
		// automatically show when loaded
	}

	@Override
	protected void __destroyInterstitial(Object interstitial) {
		if(interstitial instanceof SASInterstitialView) {
			SASInterstitialView ad = (SASInterstitialView)interstitial;
			ad.onDestroy();
		}
	}

}
