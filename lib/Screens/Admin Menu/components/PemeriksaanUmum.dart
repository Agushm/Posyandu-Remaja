import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';
import 'package:posyandu_kuncup_melati/Providers/DaftarAnggota.dart';
import 'package:posyandu_kuncup_melati/Providers/PemeriksaanUmum.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Screens/Admin%20Menu/components/EditPeriksaUmum.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:provider/provider.dart';

class PemeriksaanUmum extends StatefulWidget {
  final UserModel user;
  PemeriksaanUmum({this.user});
  @override
  _PemeriksaanUmumState createState() => _PemeriksaanUmumState();
}

class _PemeriksaanUmumState extends State<PemeriksaanUmum> {
  @override
  void initState() {
    final data = Provider.of<PemeriksaanUmumProvider>(context, listen: false)
        .items;
    if(data != null){
      Provider.of<PemeriksaanUmumProvider>(context, listen: false)
        .resetData(widget.user.userId);
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PemeriksaanUmumProvider>(
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditPeriksaUmum(periksaData: null, userData: widget.user)));
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _itemListView(PeriksaUmumModel periksa) {
    return Dismissible(
      key:Key(periksa.id),
          confirmDismiss: (DismissDirection direction)async{
             return await _showDeleteDialog(periksa);
          },
          child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditPeriksaUmum(periksaData: periksa, userData: widget.user)));
        },
        child: Card(
          color: Colors.pink[50],
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text(
                  formatTgl(periksa.tglPeriksa),
                  style: ConsTextStyle.kTglPeriksaTextStyle,
                )),
                Divider(),
                //Text(periksa.id),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _itemRowText(text: 'BB', text2: periksa.bb.toString()),
                    _itemRowText(text: 'TB', text2: periksa.tb.toString()),
                    _itemRowText(text: 'IMT', text2: periksa.imt.toString()),
                    _itemRowText(text: 'TD', text2: periksa.td),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _itemRowText(text: 'LILA', text2: periksa.lila.toString()),
                    _itemRowText(text: 'TTD', text2: periksa.ttd),
                    _itemRowText(text: 'HPMT', text2: periksa.hpmt),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Tindakan:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(periksa.tindakan),
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

  Future<bool> _showDeleteDialog(PeriksaUmumModel periksa) async {
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
                await Provider.of<PemeriksaanUmumProvider>(context,
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
