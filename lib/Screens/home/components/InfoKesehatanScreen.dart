import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Environment/Environment.dart';
import 'package:posyandu_kuncup_melati/ViewModel/InformasiProvider.dart';
import 'package:posyandu_kuncup_melati/Screens/info_kesehatan/DetailInfoKesehatan.dart';
import 'package:posyandu_kuncup_melati/Screens/info_kesehatan/InfoKesehatan.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/components/RoundedButton.dart';
import 'package:posyandu_kuncup_melati/components/Skeleton.dart';
import 'package:posyandu_kuncup_melati/components/infromationDetail.dart';
import 'package:posyandu_kuncup_melati/models/informasi.dart';
import 'package:provider/provider.dart';

class InfoKesehatanScreen extends StatefulWidget {
  final String kesehatan;
  final int maxLength;
  InfoKesehatanScreen({
    @required this.kesehatan,
     this.maxLength
  });
  @override
  _InfoKesehatanScreenState createState() => _InfoKesehatanScreenState();
}

class _InfoKesehatanScreenState extends State<InfoKesehatanScreen> {
  @override
  Widget build(BuildContext context) {
     return Consumer<InformasiProvider>(
      builder: (context,prov,_) {
        if(prov.informasi == null){
          prov.getInformasi();
          return _buildLoading();
        }
            return widget.maxLength != null
                ? _buildContent(prov.informasi)
                : _buildContentList(prov.informasi);
        
      },
    );
  }

  _buildContent(List<Informasi> data) {
    return Container(
      width: MediaQuery.of(context).size.width-80,
      child: Card(
        margin: EdgeInsets.only(bottom: 10.0),
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length > 3
                    ? 3
                    : data.length,
                padding: const EdgeInsets.only(bottom: 10.0),
                itemBuilder: (BuildContext context, int index) {
                  var document = data[index];
                  return designNewsHome(document);
                },
                separatorBuilder: (BuildContext context, int dex) => Divider()),
            Container(
              margin: EdgeInsets.only(bottom: 20, top: 5),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: RoundedButton(
                  height: 60,
                  minWidth: MediaQuery.of(context).size.width,
                  title: Dictionary.more,
                  borderRadius: BorderRadius.circular(5.0),
                  color: ColorBase.pink,
                  textStyle: Theme.of(context).textTheme.subhead.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoKesehatan(materi: widget.kesehatan),
                      ),
                    );

                    //AnalyticsHelper.setLogEvent(Analytics.tappedMore);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget designNewsHome(Informasi document) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
          elevation: 0,
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailInfoKesehatan(documents: document, info: widget.kesehatan),
              ),
            );

            },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: document.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                          heightFactor: 4.2,
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
                Container(
                  padding: const EdgeInsets.only(left: 10.0,right:10.0),
                  width: (MediaQuery.of(context).size.width -(MediaQuery.of(context).size.width/2))+30,
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        document.judul,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width-100,
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              
                                  Text(
                                    document.kategori,
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                
                              Text(
                                tanggal(document.createdAt),
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget designListNews(Informasi document) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          elevation: 0,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 17, bottom: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: document.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                          heightFactor: 4.2,
                          child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => Container(
                          height: MediaQuery.of(context).size.height / 3.3,
                          color: Colors.grey[200],
                          child: Image.asset(
                              '${Environment.iconAssets}pikobar.png',
                              fit: BoxFit.fitWidth)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  width: MediaQuery.of(context).size.width - 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        document.judul,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                  Text(
                                    document.kategori,
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                
                              Text(tanggal(document.createdAt),
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailInfoKesehatan(documents: document, info: widget.kesehatan),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildContentList(List<Informasi> data) {
    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.only(bottom: 10.0),
      itemBuilder: (BuildContext context, int index) {
        var document = data[index];
        return designListNews(document);
      },
    );
  }

   _buildLoading() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.only(left: 10.0, right: 5.0, bottom: 10.0),
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 90.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Skeleton(
                              height: 300.0,
                              width: MediaQuery.of(context).size.width / 3),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  child: Skeleton(
                                height: 20.0,
                                width: MediaQuery.of(context).size.width,
                              )),
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Skeleton(
                                      height: 35.0,
                                      width: 35.0,
                                    ),
                                    Skeleton(
                                      height: 25.0,
                                      width: 100.0,
                                      margin: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int dex) => Divider()),
          ],
        ),
      ),
    );
  }
}