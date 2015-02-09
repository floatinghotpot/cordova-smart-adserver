# cordova-smart-adserver

Cordova/PhoneGap Plugin for [Smart Ad Server](http://smartadserver.com/).

### Show Mobile Ad with single line of javascript code ###

Step 1: Prepare Ad Unit Id, in [Smart Ad Server portal](http://manage.smartadserver.com/), then write it in your javascript code.

```javascript
	var ad_units = {};
	if( /(android)/i.test(navigator.userAgent) ) { 
		ad_units = { // for Android, in pattern "siteId/pageId/formatId"
			banner: '35176/(news_activity)/15140',
			interstitial: '35176/(news_activity)/12167'
		};
	} else if(/(ipod|iphone|ipad)/i.test(navigator.userAgent)) {
		alert('iOS not implemented');
		return;
	} else {
		alert('Windows phone not supported');
		return;
	}
```

Step 2: Want a banner? single line of javascript code.

```javascript
// it will display smart banner at top center, using the default options
if(SmartAdServer) SmartAdServer.createBanner( {
	adId: ad_units.banner, 
	position: SmartAdServer.AD_POSITION.TOP_CENTER, 
	autoShow: true 
} );
```

Step 3: Want full screen Ad? Easy. 

```javascript
// load and display full screen Ad
if(SmartAdServer) SmartAdServer.prepareInterstitial( {
	adId: ad_units.interstitial, 
	autoShow: true
} );
```

### Features ###

Platforms supported:
- [x] Android
- [ ] iOS (not implemented yet)

Highlights:
- [x] Easy-to-use: Display Ad with single line of javascript code.
- [x] Powerful: Support banner, interstitial.
- [x] Smart: Auto fit on orientation change.
- [x] Same API: Exactly same API with other RjFun Ad plugins, easy to switch from one Ad service to another.

## How to use? ##

* If use with Cordova CLI:
```bash
cordova plugin add com.rjfun.cordova.smartadserver
```

* If use with PhoneGap Buid, just configure in config.xml:
```javascript
<gap:plugin name="com.rjfun.cordova.smartadserver" source="plugins.cordova.io"/>
```

* If use with Intel XDK:
Project -> CORDOVA 3.X HYBRID MOBILE APP SETTINGS -> PLUGINS AND PERMISSIONS -> Third-Party Plugins ->
Add a Third-Party Plugin -> Get Plugin from the Web, input:
```
Name: AdMobPluginPro
Plugin ID: com.rjfun.cordova.smartadserver
[x] Plugin is located in the Apache Cordova Plugins Registry
```

## Quick start with cordova CLI ##
```bash
	# create a demo project
    cordova create test1 com.rjfun.test1 Test1
    cd test1
    cordova platform add android

    # now add the plugin, cordova CLI will handle dependency automatically
    cordova plugin add com.rjfun.cordova.smartadserver

    # now remove the default www content, copy the demo html file to www
    rm -r www/*;
    cp plugins/com.rjfun.cordova.smartadserver/test/* www/;

	# now build and run the demo in your device or emulator
    cordova prepare; 
    cordova run android; 
    # or import into eclipse
```

## Javascript API Overview ##

Methods:
```javascript
// use banner
createBanner(adId/options, success, fail);
removeBanner();
showBanner(position);
showBannerAtXY(x, y);
hideBanner();

// use interstitial
prepareInterstitial(adId/options, success, fail);
showInterstitial();

// set default value for other methods
setOptions(options, success, fail);
```

## Screenshots ##

Banner Bottom | Banner Top
-------|----------
![ScreenShot](docs/banner_bottom.jpg) | ![ScreenShot](docs/banner_top.jpg)
Banner Toast | Interstitial
![ScreenShot](docs/banner_toast.jpg) | ![ScreenShot](docs/interstitial.jpg)

## Credits ##

This Cordova plugin is developed by Raymond Xie for Groupe Express-Roularta.

[Groupe Express-Roularta](http://www.expressroulartaservices.fr/groupe/presentation-du-groupe/) is the sponsor of this project, and agrees to publish as open source to benefit the community.

## See Also ##

Ad PluginPro series for the world leading Mobile Ad services:

* [GoogleAds PluginPro](https://github.com/floatinghotpot/cordova-admob-pro), for Google AdMob/DoubleClick.
* [iAd PluginPro](https://github.com/floatinghotpot/cordova-iad-pro), for Apple iAd. 
* [FacebookAds PluginPro](https://github.com/floatinghotpot/cordova-plugin-facebookads), for Facebook Audience Network.
* [FlurryAds PluginPro](https://github.com/floatinghotpot/cordova-plugin-flurry), for Flurry Ads.
* [mMedia PluginPro](https://github.com/floatinghotpot/cordova-plugin-mmedia), for Millennial Meida.
* [MobFox PluginPro](https://github.com/floatinghotpot/cordova-mobfox-pro), for MobFox.
* [MoPub PluginPro](https://github.com/floatinghotpot/cordova-plugin-mopub), for MoPub.

More Cordova/PhoneGap plugins by Raymond Xie, [find them in plugin registry](http://plugins.cordova.io/#/search?search=rjfun).

If use in commercial project and need email/skype support, please [buy a license](http://rjfun.github.io/), you will be supported with high priority.

Project outsourcing and consulting service is also available. Please [contact us](mailto:rjfun.mobile@gmail.com) if you have the business needs.

