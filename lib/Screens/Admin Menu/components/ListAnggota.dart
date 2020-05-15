import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Providers/DaftarAnggota.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Screens/Admin%20Menu/AdminEditAnggota.dart';
import 'package:posyandu_kuncup_melati/Screens/Admin%20Menu/AdminPemeriksaanScreen.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ListAnggota extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DaftarAnggotaProvider>(
      builder: (context, anggotaProv, _) {
        if (anggotaProv.items == null) {
          anggotaProv.fetchDaftarAnggota();
          return _buildShimmer();
        }
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: anggotaProv.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildListTile(context, anggotaProv.items[index]);
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              decoration: BoxDecoration(
                color: ColorBase.pink,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Total Anggota',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: FontsFamily.productSans,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      backgroundColor: ColorBase.orange,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            anggotaProv.items.length.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: FontsFamily.productSans,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListTile(BuildContext context, UserModel anggota) {
    return ListTile(
      leading: anggota.imageUrl == " "
          ? CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Text(
                anggota.nama[0],
                style: TextStyle(color: Colors.white),
              ),
            )
          : CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(anggota.imageUrl),
            ),
      title: Text(anggota.nama),
      subtitle: Text(formatTgl(anggota.tglLahir)),
      trailing: Container(
        width: 90,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminEditAnggota(
                            userData: anggota,
                          )),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Icon(Icons.edit, color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminPemeriksaanScreen(
                    user: anggota,
                  )),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      //enabled: _enabled,
      child: Column(
        children: <int>[0, 1, 2]
            .map((_) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(right: 20),
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 10, right: 40),
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 20),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _itemTotalPeriksa({@required int totalPeriksa}) {
    return Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Total Anggota',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            CircleAvatar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(totalPeriksa.toString()),
                ],
              ),
            ),
          ],
        ));
  }
}
