import 'dart:io';

class AdMobService {

  final debug = true;

  String getAdMobAppId() {
    if (Platform.isIOS) {
      return null; // test: ca-app-pub-3940256099942544~1458002511
    }
    else if (Platform.isAndroid) {
      return 'ca-app-pub-4496581272931045~9570112611';
    }

    return null;
  }

  String getBannerAdId() {
    if (debug && Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (debug && Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }

    if (Platform.isIOS) {
      return null;
    }
    else if (Platform.isAndroid) {
      return 'ca-app-pub-4496581272931045/3551499177';
    }

    return null;
  }
  String getInterstitialAdId() {
    if (debug && Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (debug && Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }

    if (Platform.isIOS) {
      return null;
    }
    else if (Platform.isAndroid) {
      return 'ca-app-pub-4496581272931045/6687447332';
    }

    return null;
  }

  String getRewardAdId() {
    if (debug && Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else if (debug && Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }

    if (Platform.isIOS) {
      return null;
    }
    else if (Platform.isAndroid) {
      return '';
    }

    return null;
  }
}