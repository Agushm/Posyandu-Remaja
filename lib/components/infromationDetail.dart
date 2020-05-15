import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/Dimens.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationDetailScreen extends StatefulWidget {
  final DocumentSnapshot document;
  InformationDetailScreen({this.document});

  @override
  _InformationDetailScreenState createState() => _InformationDetailScreenState();
}

class _InformationDetailScreenState extends State<InformationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(Dictionary.information)),
      body:  ListView(
      padding: EdgeInsets.all(Dimens.padding),
      children: <Widget>[
        
        _buildText(
            Text(
              widget.document['title'],
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            context),
      
        _buildText(
            Text(
               unixTimeStampToDateTime(
                               widget.document['published_at'].seconds),
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            context),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 6, bottom: Dimens.padding),
          child: Html(
              data: widget.document['content'],
              defaultTextStyle: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14.0,
                  fontFamily: FontsFamily.productSans),
              customTextAlign: (dom.Node node) {
                return TextAlign.justify;
              },
              onLinkTap: (url) {
                _launchURL(url);
              },
              customTextStyle: (dom.Node node, TextStyle baseStyle) {
                if (node is dom.Element) {
                  switch (node.localName) {
                    case "p":
                      return baseStyle.merge(TextStyle(height: 1.3));
                  }
                }
                return baseStyle;
              }),
        ),
        
        SizedBox(
          height: Dimens.sbHeight,
        ),
      ],
    ));
  }

  

  _buildText(Text text, context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 10.0),
      child: text,
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
