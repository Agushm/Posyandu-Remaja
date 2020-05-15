import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';
import 'package:posyandu_kuncup_melati/Providers/DaftarAnggota.dart';
import 'package:posyandu_kuncup_melati/Providers/PemeriksaanLain.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Screens/Admin%20Menu/components/EditPeriksaLain.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:provider/provider.dart';

class PemeriksaanLain extends StatefulWidget {
  final UserModel user;
  PemeriksaanLain({
    this.user
  });
  @override
  _PemeriksaanLainState createState() => _PemeriksaanLainState();
}

class _PemeriksaanLainState extends State<PemeriksaanLain> {
  @override
  void initState() {
    final data = Provider.of<PemeriksaanLainProvider>(context, listen: false)
        .items;
    if(data != null){
      Provider.of<PemeriksaanLainProvider>(context, listen: false)
        .resetData(widget.user.userId);
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PemeriksaanLainProvider>(
      builder: (context, umumProv, _) {
        if (umumProv.items == null) {
          umumProv.fetchPeriksaByUserId(widget.user.userId);
          return Center(
            child: Text("Loading..."),
          );
        }
        return Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                itemCount: umumProv.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return _itemListView(umumProv.items[index]);
                },
              )),
              Container(
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: ColorBase.pink,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Total',
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
                          Text(umumProv.items.length.toString(),style: TextStyle(
                            color:Colors.white,
                            fontFamily: FontsFamily.productSans,
                            fontWeight: FontWeight.bold
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditPeriksaLain(periksaData: null, userData: widget.user)));
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _itemListView(PeriksaLainModel periksa) {
    return Dismissible(
      key:Key(periksa.id),
          confirmDismiss: (DismissDirection direction){
            return _showDeleteDialog(periksa);
          },
          child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditPeriksaLain(periksaData: periksa, userData: widget.user)));
        },
        child: Card(
          color: Colors.pink[50],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(formatTgl(periksa.tglPeriksa),style: ConsTextStyle.kTglPeriksaTextStyle,),
                Divider(),
                Text('Jenis Pemeriksaan : ',style: TextStyle(fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text(periksa.jenisPeriksa),
                ),
                SizedBox(
                  height: 5,
                ),
                Text('Keterangan Pemeriksaan : ',style: TextStyle(fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text(periksa.ketPeriksa),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemRowText({
    @required String text,
    @required String text2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          '$text : ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(text2)
      ],
    );
  }

  Future<bool> _showDeleteDialog(PeriksaLainModel periksa) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peringatan Hapus Data'),
          content: Text('Yakin data dihapus? Data akan dihapus permanen'),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              child: Text(
                'Hapus',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await Provider.of<PemeriksaanLainProvider>(context,
                        listen: false)
                    .deletePeriksaById(periksa.id);
                 Navigator.of(context).pop(true);
                return true;
              },
            ),
            FlatButton(
              color: Colors.blue,
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
               Navigator.of(context).pop(false);
                return false;
              },
            ),
          ],
        );
      },
    );
  }
}