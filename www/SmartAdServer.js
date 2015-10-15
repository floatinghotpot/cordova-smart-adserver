
var SmartAdServer = function() {
};

SmartAdServer.prototype.AD_POSITION = {
	NO_CHANGE: 0,
	TOP_LEFT: 1,
	TOP_CENTER: 2,
	TOP_RIGHT: 3,
	LEFT: 4,
	CENTER: 5,
	RIGHT: 6,
	BOTTOM_LEFT: 7,
	BOTTOM_CENTER: 8,
	BOTTOM_RIGHT: 9,
	POS_XY: 10
};

SmartAdServer.prototype.AD_SIZE = {
	SMART_BANNER: 'SMART_BANNER',
	BANNER: 'BANNER',
	MEDIUM_RECTANGLE: 'MEDIUM_RECTANGLE',
	FULL_BANNER: 'FULL_BANNER',
	LEADERBOARD: 'LEADERBOARD',
	SKYSCRAPER: 'SKYSCRAPER'
};

/*
 * set options:
 *  {
 *    adSize: string,	// banner type size
 *    width: integer,	// banner width, if set adSize to 'CUSTOM'
 *    height: integer,	// banner height, if set adSize to 'CUSTOM'
 *    position: integer, // default position
 *    x: integer,	// default X of banner
 *    y: integer,	// default Y of banner
 *    isTesting: boolean,	// if set to true, to receive test ads
 *    autoShow: boolean,	// if set to true, no need call showBanner or showInterstitial
 *    adExtra: {
 *    }
 *   }
 */
SmartAdServer.prototype.setOptions = function(options, successCallback, failureCallback) {
	if (typeof options === 'object') {
  		cordova.exec(successCallback, failureCallback, 'SmartAdServer', 'setOptions', [options]);
	} else {
  		if(typeof failureCallback === 'function') {
	  		failureCallback('options should be specified.');
  		}
	}
};

SmartAdServer.prototype.createBanner = function(args, successCallback, failureCallback) {
	var options = {};
	if (typeof args === 'object') {
		for (var k in args) {
			if(k === 'success') { if(args[k] === 'function') successCallback = args[k]; }
			else if(k === 'error') { if(args[k] === 'function') failureCallback = args[k]; }
			else {
				options[k] = args[k];
			}
		}
	} else if(typeof args === 'string') {
		options = { adId: args };
	}
	cordova.exec( successCallback, failureCallback, 'SmartAdServer', 'createBanner', [ options ] );
};

SmartAdServer.prototype.removeBanner = function(successCallback, failureCallback) {
	cordova.exec( successCallback, failureCallback, 'SmartAdServer', 'removeBanner', [] );
};

SmartAdServer.prototype.hideBanner = function(successCallback, failureCallback) {
	cordova.exec( successCallback, failureCallback, 'SmartAdServer', 'hideBanner', [] );
};

SmartAdServer.prototype.showBanner = function(position, successCallback, failureCallback) {
	if(typeof position === 'undefined') position = 0;
	cordova.exec( successCallback, failureCallback, 'SmartAdServer', 'showBanner', [ position ] );
};

SmartAdServer.prototype.showBannerAtXY = function(x, y, successCallback, failureCallback) {
	if(typeof x === 'undefined') x = 0;
	if(typeof y === 'undefined') y = 0;
	cordova.exec( successCallback, failureCallback, 'SmartAdServer', 'showBannerAtXY', [{x:x, y:y}] );
};

SmartAdServer.prototype.prepareInterstitial = function(args, successCallback, failureCallback) {
	var options = {};
	if(typeof args === 'object') {
		for(var k in args) {
			if(k === 'success') { if(args[k] === 'function') successCallback = args[k]; }
			else if(k === 'error') { if(args[k] === 'function') failureCallback = args[k]; }
			else {
				options[k] = args[k];
			}
		}
	} else if(typeof args === 'string') {
		options = { adId: args };
	}
	cordova.exec(successCallback, failureCallback, 'SmartAdServer', 'prepareInterstitial', [ args ] );
};

SmartAdServer.prototype.showInterstitial = function(successCallback, failureCallback) {
	cordova.exec( successCallback, failureCallback, 'SmartAdServer', 'showInterstitial', [] );
};

//-------------------------------------------------------------------

if(!window.plugins)
    window.plugins = {};

if (!window.plugins.SmartAdServer)
    window.plugins.SmartAdServer = new SmartAdServer();

if (typeof module != 'undefined' && module.exports)
    module.exports = SmartAdServer;

