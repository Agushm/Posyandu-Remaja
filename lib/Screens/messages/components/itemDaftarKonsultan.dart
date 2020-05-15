import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';

class ItemDaftarKonsltan extends StatelessWidget {
  final UserProvider userProv;
  ItemDaftarKonsltan({this.userProv});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          CachedNetworkImageProvider(userProv.user.imageUrl),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userProv.user.nama,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: FontsFamily.productSans,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Konsultan',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: FontsFamily.productSans,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorBase.green,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "ONLINE",
                      style: TextStyle(
                          fontSize: 10,
                          color: ColorBase.white,
                          fontFamily: FontsFamily.productSans,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: FlatButton(
                        color: ColorBase.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {},
                        child: Text(
                          'Konsultasi',
                          style: TextStyle(
                              color: ColorBase.white,
                              fontFamily: FontsFamily.productSans,
                              fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
