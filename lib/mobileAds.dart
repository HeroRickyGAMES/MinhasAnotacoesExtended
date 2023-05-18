import 'package:flutter/material.dart';
import 'package:startapp_sdk/startapp.dart';

class mobileAds extends StatefulWidget {
  const mobileAds({Key? key}) : super(key: key);

  @override
  State<mobileAds> createState() => _mobileAdsState();
}

class _mobileAdsState extends State<mobileAds> {
  var startAppSdk = StartAppSdk();

  StartAppBannerAd? bannerAd;

  @override
  void initState() {
    super.initState();

    // TODO make sure to comment out this line before release
    //startAppSdk.setTestAdsEnabled(false);

    // TODO use one of the following types: BANNER, MREC, COVER
    startAppSdk.loadBannerAd(StartAppBannerType.BANNER).then((bannerAd) {
      setState(() {
        this.bannerAd = bannerAd;
      });
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Banner ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Banner ad: $error");
    });
  }



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [bannerAd != null ? StartAppBanner(bannerAd!) : Container()],
      ),
    );
  }
}
