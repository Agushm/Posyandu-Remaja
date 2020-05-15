// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';

// class BrowserScreen extends StatefulWidget {
//    final String url;

//    BrowserScreen({
//      Key key,
//      @required this.url,
//    });

//    @override
//    _BrowserScreenState createState() => _BrowserScreenState();
//  }

//  class _BrowserScreenState extends State<BrowserScreen> {
//    double progress = 0.0;
//    InAppWebViewController webView;

//    @override
//    void initState() {
//      super.initState();
//    }

//    @override
//    void dispose() {
//      super.dispose();
//    }

//    @override
//    Widget build(BuildContext context) {
//      return Scaffold(
//        appBar: AppBar(
//          title: Text(Dictionary.appName),
//        ),
//        body: Column(
//          children: <Widget>[
//            Container(
//                padding: progress < 1.0 ? EdgeInsets.symmetric(vertical: 5.0) : null,
//                child: progress < 1.0
//                    ? LinearProgressIndicator(value: progress)
//                    : Container()),
//            Expanded(
//              child: Container(
//                child: InAppWebView(
//                  initialUrl: widget.url,
//                  initialHeaders: {},
//                  initialOptions: InAppWebViewWidgetOptions(
//                      inAppWebViewOptions: InAppWebViewOptions(
//                        debuggingEnabled: true,
//                      )
//                  ),
//                  onWebViewCreated: (InAppWebViewController controller) {
//                    webView = controller;
//                  },
//                  onProgressChanged: (InAppWebViewController controller, int progress) {
//                    setState(() {
//                      this.progress = progress / 100;
//                    });
//                  },
//                ),
//              ),
//            ),
//          ],
//        ),
//      );
//    }
//  }