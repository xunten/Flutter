// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/sharepref.dart';

class AdHelper {
  static int interstialcnt = 0;
  static int rewardcnt = 0;

  int maxFailedLoadAttempts = 3;
  static SharePref sharePref = SharePref();

  static String? banneradid;
  static String? banneradid_ios;
  static String? interstitaladid;
  static String? interstitaladid_ios;
  static String? rewardadid;
  static String? rewardadid_ios;

  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  static int? maxInterstitialAdclick;

  static int _numRewardAttempts = 0;
  static int maxRewardAdclick = 0;
  static int maxIosRewardAdclick = 0;

  static var bannerad = "";
  static var banneradIos = "";

  static var interstialad = "";
  static var interstialadIos = "";

  static var rewardAd = "";
  static var rewardadIos = "";

  static RewardedAd? _rewardedAd;

  static AdRequest request = const AdRequest(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    nonPersonalizedAds: true,
  );

  static initialize() {
    MobileAds.instance.initialize();
  }

  static getAds() async {
    banneradid = await sharePref.read("banner_adid") ?? "";
    banneradid_ios = await sharePref.read("ios_banner_adid") ?? "";

    interstitaladid = await sharePref.read("interstital_adid") ?? "";
    interstitaladid_ios = await sharePref.read("ios_interstital_adid") ?? "";

    rewardadid = await sharePref.read("reward_adid") ?? "";
    rewardadid_ios = await sharePref.read("ios_reward_adid") ?? "";

    bannerad = await sharePref.read("banner_ad") ?? "";
    banneradIos = await sharePref.read("ios_banner_ad") ?? "";

    interstialad = await sharePref.read("interstital_ad") ?? "";
    interstialadIos = await sharePref.read("ios_interstital_ad") ?? "";

    rewardAd = await sharePref.read("reward_ad") ?? "";
    rewardadIos = await sharePref.read("ios_reward_ad") ?? "";

    maxInterstitialAdclick =
        int.parse(await sharePref.read("interstital_adclick") ?? "0");
    maxRewardAdclick = int.parse(await sharePref.read("reward_adclick") ?? "0");
     maxIosRewardAdclick = int.parse(await sharePref.read("ios_reward_adclick") ?? "0");

    log("maxInterstitialAdclick $maxInterstitialAdclick");

    log("reward ad value $rewardadIos");
    log("maxRewardAdclick $maxRewardAdclick");
    log("maxIosRewardAdclick $maxIosRewardAdclick");

    log("Banner ads $banneradid");
  }

  Widget bannerAd() {
    if ((bannerad == "1" && Platform.isAndroid) ||
        (banneradIos == "1" && Platform.isIOS)) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 60,
          child: AdWidget(ad: createBannerAd()..load(), key: UniqueKey()),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  static BannerAd createBannerAd() {
    BannerAd ad = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: bannerAdUnitId,
        request: const AdRequest(),
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) => debugPrint('Ad Loaded'),
            onAdClosed: (Ad ad) => debugPrint('Ad Closed'),
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) => debugPrint('Ad Open')));
    return ad;
  }

  static void createInterstitialAd() {
    if (Platform.isAndroid && interstialad == '1') {
      InterstitialAd.load(
          adUnitId: interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              log('====> ads $ad');
              _interstitialAd = ad;
              _numInterstitialLoadAttempts = 0;
              ad.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              log('InterstitialAd failed to load: $error');
            },
          ));
    }
    if (Platform.isIOS && interstialadIos == '1') {
      InterstitialAd.load(
          adUnitId: interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              log('====> ads $ad');
              _interstitialAd = ad;
              _numInterstitialLoadAttempts = 0;
              ad.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              log('InterstitialAd failed to load: $error');
            },
          ));
    }
  }

  static showInterstitialAd([VoidCallback? callAction]) {
    log('===>$_numInterstitialLoadAttempts');
    log('===>$maxInterstitialAdclick');
    if (_numInterstitialLoadAttempts == maxInterstitialAdclick) {
      _numInterstitialLoadAttempts = 0;
      if (_interstitialAd == null) {
        log('Warning: attempt to show interstitial before loaded.');

        return false;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            log('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          log('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          log('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      return;
    }
    _numInterstitialLoadAttempts += 1;
  }

  static createRewardedAd() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            log('$ad loaded.');
            _rewardedAd = ad;
            // _numRewardAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('RewardedAd failed to load: $error');
            _rewardedAd = null;
            // _numRewardAttempts += 1;
            if (_numRewardAttempts <= maxRewardAdclick) {
              createRewardedAd();
            }
          },
        ));
  }

  static showRewardedAd(VoidCallback callAction) {
    log('num of attempts ===>$_numRewardAttempts');
    log(' max rewards click===>$maxRewardAdclick');
     log(' max Ios rewards click===>$maxIosRewardAdclick');
    if (_numRewardAttempts == maxIosRewardAdclick) {
      if (_rewardedAd == null) {
        log('Warning: attempt to show rewarded before loaded.');
        callAction();
          log("step 8");
        return;
      }
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) =>{
          // _numRewardAttempts = (_numRewardAttempts) + 1 ,
            log('ad onAdShowedFullScreenContent.'),},
            
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          //  _numRewardAttempts = 0;  
          log('$ad onAdDismissedFullScreenContent.');    
         callAction();
          ad.dispose();
          createRewardedAd();
            log("step 9");
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          log('$ad onAdFailedToShowFullScreenContent: $error');
          log('$ad onAdFailedToShowFullScreenContent: $error');
      
          log('$ad onAdFailedToShowFullScreenContent: $error'); 
         callAction();
          ad.dispose();
          createRewardedAd();
            log("step 10");
        },
      );

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        log('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
      });
      _rewardedAd = null;
    } 
    _numRewardAttempts += 1;
    
    
  }

  // Show Fullscreen Ad Function
  static showFullscreenAd(
      BuildContext context, String adType, VoidCallback callAction) async {
    log("=======>>>>rewardedAd add");
    // bool? isBuy = await Utility.checkPremiumUser();
    // debugPrint("showFullscreenAd isBuy ============> $isBuy");
    // if (isBuy) {
    //   callAction();
    //   return;
    // }
    if (!kIsWeb) {
      if (adType == Constant.rewardAdType) {
        if ((rewardAd == "1" && Platform.isAndroid) ||
            (rewardadIos == "1" && Platform.isIOS)) {
          debugPrint("rewardedAd add");
          debugPrint("rewardedAd add===>> ${showRewardedAd(callAction).toString()}");
          log("step 1");
          showRewardedAd(callAction);
          // if(Platform.isAndroid){
          //       if(maxRewardAdclick == _numRewardAttempts){
          //               showRewardedAd(callAction);
          //     }
          //     else{
          //           log("rewardedAd add");
          //     callAction();
          //     }

          // }
          // else{
          //    if(maxIosRewardAdclick == _numRewardAttempts){
               
          //           showRewardedAd(callAction);
          // }
          // else{
          //        log("rewardedAd add");
          //  callAction;
          // }

          // }
        
        
        } else {
          debugPrint("=====>>.rewardedAd action Device");
          callAction();
        }
      } else if (adType == Constant.interstialAdType) {
        if ((interstialad == "1" && Platform.isAndroid) ||
            (interstialadIos == "1" && Platform.isIOS)) {
          showInterstitialAd(callAction);  log("step 2");
        } else {
          debugPrint("rewardedAd action Device");
          callAction();  log("step 3");
        }
      } else {
        if ((rewardAd == "1" && Platform.isAndroid) ||
            (rewardadIos == "1" && Platform.isIOS)) {
          debugPrint("rewardedAd add");
          showRewardedAd(callAction);  log("step 4");
        } else if ((interstialad == "1" && Platform.isAndroid) ||
            (interstialadIos == "1" && Platform.isIOS)) {
          showInterstitialAd(callAction);  log("step 5");
        } else {
          debugPrint("rewardedAd action Device");
          callAction();  log("step 6");
        }
      }
    } else {
      debugPrint("rewardedAd action Device");
      callAction();  log("step 7");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return banneradid.toString();
    } else if (Platform.isIOS) {
      return banneradid_ios.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return interstitaladid.toString();
    } else if (Platform.isIOS) {
      return interstitaladid_ios.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return rewardadid.toString();
    } else if (Platform.isIOS) {
      return rewardadid_ios.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
