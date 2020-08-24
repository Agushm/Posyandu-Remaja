import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/ViewModel/CustomMenu.dart';
import 'package:posyandu_kuncup_melati/components/FormInputDecoration.dart';
import 'package:posyandu_kuncup_melati/models/menu.dart';
import 'package:posyandu_kuncup_melati/widgets/LoadingCenter.dart';
import 'package:provider/provider.dart';

class MenuPickerScreen extends StatefulWidget {
  final String jenis;
  final String menu;
  MenuPickerScreen({this.jenis,this.menu});


  @override
  _MenuPickerScreenState createState() => _MenuPickerScreenState();
}

class _MenuPickerScreenState extends State<MenuPickerScreen> {
  final TextEditingController cariController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<CustomMenu>(context, listen: false)
        .getPilihanMenu(widget.jenis)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Menu"),
      ),
      body: isLoading
          ? LoadingCenter()
          : Consumer<CustomMenu>(
              builder: (context, prov, _) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: TextFormField(
                          controller: cariController,
                          decoration: FromInputDecoration.outlineInputCari(
                              null, "Tulis nama menu..."),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: cariController.text.trim().length != 0
                            ? prov.filterPilihanMenu(cariController.text).length
                            : prov.pilihanMenu.length,
                        itemBuilder: (context, i) {
                          Menu d = prov.pilihanMenu[i];
                          if (cariController.text.trim().length != null) {
                            d = prov.filterPilihanMenu(cariController.text)[i];
                          }
                          return Container(
                            color: i%2 == 0 ?ColorBase.pink.withAlpha(50):Colors.white,
                            child: ListTile(
                              
                              onTap: (){
                                prov.updateMenu(widget.jenis, widget.menu, d);
                                Navigator.pop(context);
                              },
                              title: Text(d.namaMakanan),
                              subtitle: Text(d.jenis[0].toUpperCase()+d.jenis.substring(1)),
                              trailing: Text('${d.jmlKalori} kkal',style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
    );
  }
}
