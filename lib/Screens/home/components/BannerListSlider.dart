import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Dimens.dart';
import 'package:posyandu_kuncup_melati/Environment/Environment.dart';
import 'package:posyandu_kuncup_melati/ViewModel/Banner.dart';
import 'package:posyandu_kuncup_melati/components/Skeleton.dart';
import 'package:posyandu_kuncup_melati/models/banner.dart' as banner;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerListSlider extends StatefulWidget {
  @override
  BannerListSliderState createState() => BannerListSliderState();
}

class BannerListSliderState extends State<BannerListSlider> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BannerProvider>(
      
      builder: (context, prov,_) {
        if(prov.banner == null){
          prov.getBanner();
          return _buildLoading();
        } 
            return _buildSlider(prov.banner);
        
      },
    );
  }

  Widget _buildLoading() {
    return AspectRatio(
      aspectRatio: 21 / 9,
      child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Skeleton(
                    width: MediaQuery.of(context).size.width,
                  ),
                ));
          }),
    );
  }

  _buildSlider(List<banner.Banner> data) {
    return CarouselSlider(
      initialPage: 0,
      enableInfiniteScroll: data.length > 1 ? true : false,
      aspectRatio: 21 / 9,
      viewportFraction: data.length > 1 ? 0.8 : 0.95,
      autoPlay: data.length > 1 ? true : false,
      autoPlayInterval: Duration(seconds: 5),
      items: data.map((banner.Banner document) {
        return Builder(builder: (BuildContext context) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                    imageUrl: document.imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    placeholder: (context, url) => Center(
                        heightFactor: 10.2,
                        child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
                        ),
                        child: Image.asset(
                            '${Environment.imageAssets}placeholder.png',
                            fit: BoxFit.fitWidth))),
              ),
            ),
            onTap: () {
              if (document.content != null) {
                _clickAction(document.content);
                // AnalyticsHelper.setLogEvent(Analytics.tappedBanner,
                //     <String, dynamic>{'url': document['action_url']});
              }
            },
          );
        });
      }).toList(),
    );
  }

  _clickAction(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
