import 'dart:io';

class AdHelper{
    static String get interstitialAdUnitId{
        if(Platform.isAndroid){
            return 'ca-app-pub-3940256099942544/1033173712';
        }else if(Platform.isIOS){
            return 'ca-app-pub-3940256099942544/2934735716';
        }else{
            throw new UnsupportedError('Unsupported platform');
        }
    }
}
// BannerAd(
//   //adUnitId: AdsHelper.getBannerAdUnitId(),
//   adUnitId: 'ca-app-pub-3940256099942544/6300978111',
//   size: AdSize.banner,
//   request: AdRequest(),
//   listener: BannerAdListener(
//     onAdLoaded: (Ad ad) {
//       setState(() {
//         _bannerAd = ad as BannerAd;
//       });
//     },
//     onAdFailedToLoad: (Ad ad, LoadAdError error) {
//       print('Ad failed to load: $error');
//       ad.dispose();
//     },
//   ),
// )..load();
