import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nsfbobdylanquoteslyrics/data.dart';
import 'package:nsfbobdylanquoteslyrics/sabitler.dart';

class BildirimDetay extends StatefulWidget {
  //const BildirimDetay({Key? key}) : super(key: key);
  String bildirimQuote;
  BildirimDetay(this.bildirimQuote);

  @override
  State<BildirimDetay> createState() => _BildirimDetayState();
}

class _BildirimDetayState extends State<BildirimDetay> {
  Random random = new Random();
  bool refresh = false;
  int index = 0;

  bool _isBannerAdReady = false;
  late BannerAd _bannerAd;

  void initState() {
    // _createInterstitialAd();
    loadBanneAdsDetay();
    // super.initState();
  }

  void dispose() {
    //  super.dispose();
    _bannerAd.dispose();
  }

  void loadBanneAdsDetay() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: bobdylanbannerdetay,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          print('Failed to load Banner Ad${error.message}');
          _isBannerAdReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();
  }

  butonklik() {
    refresh = true;
    index = random.nextInt(quoteslist.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Today's Bob Dylan Quote"),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.direction > 0) {
            setState(() {
              butonklik();
            });
          } else if (details.delta.direction <= 0) {
            setState(() {
              butonklik();
            });
          }
        },
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Image.asset('assets/images/bob2.png')),
                ),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Text(
                          refresh ? quoteslist[index] : widget.bildirimQuote,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: _bannerAd.size.height.toDouble(),
                    width: _bannerAd.size.width.toDouble(),
                    child: AdWidget(
                      ad: _bannerAd,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.refresh, size: 50),
                    onPressed: () {
                      setState(() {
                        butonklik();
                      });
                    },
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
