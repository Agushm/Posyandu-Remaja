import 'package:html/dom.dart' as dom;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Environment/Environment.dart';
import 'package:posyandu_kuncup_melati/Screens/info_kesehatan/InfoKesehatan.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatText.dart';
import 'package:posyandu_kuncup_melati/components/ImagePreviewScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailInfoKesehatan extends StatefulWidget {
  final DocumentSnapshot documents;
  final String info;
  DetailInfoKesehatan({this.documents, this.info});
  @override
  _DetailInfoKesehatanState createState() => _DetailInfoKesehatanState();
}

class _DetailInfoKesehatanState extends State<DetailInfoKesehatan> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          Dictionary.information,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: FontsFamily.productSans,
              fontSize: 17.0),
        )),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: Hero(
                      tag: Dictionary.imageTag,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        child: CachedNetworkImage(
                          imageUrl: widget.documents['imageUrl'],
                          placeholder: (context, url) => Center(
                              heightFactor: 10.2,
                              child: CupertinoActivityIndicator()),
                          errorWidget: (context, url, error) => Container(
                              height: MediaQuery.of(context).size.height / 3.3,
                              color: Colors.grey[200],
                              child: Image.asset(
                                  '${Environment.iconAssets}logo.png',
                                  fit: BoxFit.fitWidth)),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ImagePreviewScreen(
                                    Dictionary.imageTag,
                                    imageUrl: widget.documents['imageUrl'],
                                  )));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.documents['title'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              FormatText.kategoriKesehatan(widget.documents['category']),
                              style: TextStyle(fontSize: 12.0),
                            ),
                            Text(
                                formatTglFromUnix(
                                    int.parse(widget.documents['published_at'])),
                                style: TextStyle(fontSize: 12.0))
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Html(
                            data: widget.documents['content'],
                            defaultTextStyle:
                                TextStyle(color: Colors.black, fontSize: 15.0),
                            customTextAlign: (dom.Node node) {
                              return TextAlign.justify;
                            },
                            onLinkTap: (url) {
                              _launchURL(url);
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 15.0, right: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(height: 25.0),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 5.0, bottom: 20.0),
                          child: OutlineButton(
                            borderSide: BorderSide(color: Colors.grey[600]),
                            child: Text(Dictionary.otherInfo,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: FontsFamily.sourceSansPro,
                                    color: Colors.grey[700])),
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InfoKesehatan(materi:widget.info)));
                            },
                          ),
                        ),
//                        _latestNews(state),
                        SizedBox(height: 10.0)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
