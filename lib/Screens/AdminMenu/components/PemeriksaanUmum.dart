import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';
import 'package:posyandu_kuncup_melati/Node_Providers/Periksa.dart';
import 'package:posyandu_kuncup_melati/Screens/AdminMenu/components/EditPeriksaUmum.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/models/Periksa.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';
import 'package:provider/provider.dart';

class PemeriksaanUmum extends StatefulWidget {
  final UserClass user;
  PemeriksaanUmum({this.user});
  @override
  _PemeriksaanUmumState createState() => _PemeriksaanUmumState();
}

class _PemeriksaanUmumState extends State<PemeriksaanUmum> {
  @override
  void initState() {
    final data = Provider.of<PeriksaProvider>(context, listen: false).items;
    if(data != null){
      Provider.of<PeriksaProvider>(context, listen: false).destroy();
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriksaProvider>(
      builder: (context, periksaProv, _) {
        if (periksaProv.items == null) {
          periksaProv.fetchPeriksaByUserID(widget.user.userID);
          return Center(
            child: Text("Loading..."),
          );
        }
        return Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical:15),
                itemCount: periksaProv.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return _itemListView(periksaProv.items[index]);
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
                          Text(periksaProv.items.length.toString(),style: TextStyle(
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
              //Navigator.push(context, MaterialPageRoute(builder: (context) => EditPeriksaUmum(periksaData: null, userData: widget.user)));
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _itemListView(Periksa periksa) {
    return Dismissible(
      key:Key(periksa.periksaId),
          confirmDismiss: (DismissDirection direction)async{
             return await _showDeleteDialog(periksa);
          },
          child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditPeriksaUmum(periksaData: periksa, userData: widget.user)));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal:20),
          child: Card(
            color: Colors.pink[50],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          child: Text(
                        tanggal(DateTime.parse(periksa.tglPeriksa)),
                        style: ConsTextStyle.kTglPeriksaTextStyle,
                      )),
                      Container(
                  margin:EdgeInsets.only(right:5),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: periksa.kategoriImt == "normal"?Colors.blue:Colors.red,
                  ),
                  child: Text(periksa.kategoriImt[0].toUpperCase()+periksa.kategoriImt.substring(1),style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                     
                    ],
                  ),
                  Divider(),
                   Container(
                          child: Text(
                        periksa.petugas.nama,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: FontsFamily.productSans,
                          fontWeight: FontWeight.bold
                        ),
                      )),
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

  Future<bool> _showDeleteDialog(Periksa periksa) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peringatan Hapus Data'),
          content: Text('Yakin data dihapus? Data akan dihapus permanen'),
          actions: <Widget>[
            FlatButton(
              color: Colors.transparent,
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
                return false;
              },
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: Colors.red,
              child: Text(
                'Hapus',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                // await Provider.of<PeriksaProvider>(context,
                //         listen: false)
                //     .deletePeriksaById(periksa.id);
                Navigator.of(context).pop(true);
                return true;
              },
            ),
            
          ],
        );
      },
    );
  }
}
