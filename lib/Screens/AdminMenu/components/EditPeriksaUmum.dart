import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/ViewModel/Periksa.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/models/Periksa.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';
import 'package:provider/provider.dart';

class EditPeriksaUmum extends StatefulWidget {
  final Periksa periksaData;
  final UserClass userData;
  EditPeriksaUmum({this.periksaData, this.userData});
  @override
  _EditPeriksaUmumState createState() => _EditPeriksaUmumState();
}

class _EditPeriksaUmumState extends State<EditPeriksaUmum> {
  final _form = GlobalKey<FormState>();
  final _tbFocusNode = FocusNode();
  final _imtFocusNode = FocusNode();
  final _tdFocusNode = FocusNode();
  final _lilaFocusNode = FocusNode();
  final _ttdFocusNode = FocusNode();
  final _hpmtFocusNode = FocusNode();
  final _tindakanFocusNode = FocusNode();

  TextEditingController _bbController = TextEditingController();
  TextEditingController _tbController = TextEditingController();
  TextEditingController _imtController = TextEditingController();
  TextEditingController _tdController = TextEditingController();
  TextEditingController _lilaController = TextEditingController();
  TextEditingController _ttdController = TextEditingController();
  TextEditingController _hpmtController = TextEditingController();
  TextEditingController _tindakanController = TextEditingController();
  DateTime tglPeriksa = DateTime.now();

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    //_editPeriksaUmum.id : widget.userId;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.periksaData != null) {
        setState(() {
          _bbController.text = widget.periksaData.bb.toString();
          _tbController.text = widget.periksaData.tb.toString();
          _imtController.text = widget.periksaData.imt.toString();
          _tdController.text = widget.periksaData.td.toString();
          _lilaController.text = widget.periksaData.lila.toString();
          _hpmtController.text = widget.periksaData.hpmt.toString();
          _ttdController.text = widget.periksaData.ttd.toString();
          _tindakanController.text = widget.periksaData.tindakan.toString();
          tglPeriksa = DateTime.parse(widget.periksaData.tglPeriksa);
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (widget.periksaData != null) {
      await Provider.of<PeriksaProvider>(context, listen: false)
          .updatePeriksa(dataPeriksa: {
          "periksa_ID":widget.periksaData.periksaId,
        "user_ID": widget.userData.userID,
        "tb": _tbController.text,
        "bb": _bbController.text,
        "td": _tdController.text,
        "lila": _lilaController.text,
        "hpmt": null,
        "ttd": _ttdController.text,
        "tindakan": _tindakanController.text,
        "tglPeriksa": tglPeriksa.toString(),
      });
    } else if (widget.periksaData == null) {
      try {
        await Provider.of<PeriksaProvider>(context, listen: false)
            .tambahPeriksa(dataPeriksa: {
          "user_ID": widget.userData.userID,
          "tb": _tbController.text,
          "bb": _bbController.text,
          "td": _tdController.text,
          "lila": _lilaController.text,
          "hpmt": null,
          "ttd": _ttdController.text,
          "tindakan": _tindakanController.text
        });
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Ooops Error!'),
                  content: Text('Terjadi suatu kesalahan.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _isLoading = false;
                      },
                    ),
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.periksaData == null?
        'Tambah Pemeriksaan ':'Edit Pemeriksaan'),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/helicopter.png',
                    scale: 5,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildKategoriIMT(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        children: <Widget>[
                          _buildTglPeriksa(),
                          _bbTextFormField(),
                          _tbTextFormField(),
                          _imtTextFormField(),
                          _tdTextFormField(),
                          _lilaTextFormField(),
                          _ttdTextFormField(),
                          //_hpmtTextFormField(),
                          _tindakanTextFormField(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveForm();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _bbTextFormField() {
    return TextFormField(
      controller: _bbController,
      decoration: InputDecoration(labelText: 'Berat Badan (kg)'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_tbFocusNode);
      },
      validator: (v) {
        if (v.isEmpty) {
          return 'Berat Badan harus diisi.';
        } else if (v.length >= 4) {
          return 'Maksimal 4 digit';
        }
        return null;
      },
    );
  }

  Widget _tbTextFormField() {
    return TextFormField(
      controller: _tbController,
      decoration: InputDecoration(labelText: 'Tinggi Badan (cm)'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: _tbFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_imtFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Tinggi Badan harus diisi.';
        } else if (value.length >= 4) {
          return 'Maksimal 4 digit';
        }
        return null;
      },
    );
  }

  Widget _imtTextFormField() {
    return widget.periksaData ==null?Container():TextFormField(
      enabled: false,
      controller: _imtController,
      decoration: InputDecoration(labelText: 'Index Massa Tubuh'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: _imtFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_tdFocusNode);
      },
      validator: (v) {
        if (v.isEmpty) {
          return 'Index Massa Tubuh harus diisi.';
        }
        return null;
      },
    );
  }

  Widget _tdTextFormField() {
    return TextFormField(
      controller: _tdController,
      decoration: InputDecoration(labelText: 'Tensi Darah'),
      textInputAction: TextInputAction.next,
      focusNode: _tdFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_lilaFocusNode);
      },
      validator: (v) {
        if (v.isEmpty) {
          return 'Tensi Darah harus diisi.';
        }
        return null;
      },
    );
  }

  Widget _lilaTextFormField() {
    return TextFormField(
      controller: _lilaController,
      decoration: InputDecoration(labelText: 'Lingkar Lengan Atas'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: _lilaFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_ttdFocusNode);
      },
      validator: (String v) {
        if (v.isEmpty) {
          return 'Lingkar Lengan Atas harus diisi.';
        }
        return null;
      },
    );
  }

  Widget _ttdTextFormField() {
    return TextFormField(
      controller: _ttdController,
      decoration: InputDecoration(labelText: 'Tablet Tambah Darah'),
      textInputAction: TextInputAction.next,
      focusNode: _ttdFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_hpmtFocusNode);
      },
      validator: (v) {
        if (v.isEmpty) {
          return 'Tablet Tambah Darah harus diisi.';
        }
        return null;
      },
    );
  }

  Widget _hpmtTextFormField() {
    return TextFormField(
      controller: _hpmtController,
      decoration: InputDecoration(labelText: 'Hari Pertama Menstruasi'),
      textInputAction: TextInputAction.next,
      focusNode: _hpmtFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_tindakanFocusNode);
      },
      validator: (v) {
        if (v.isEmpty) {
          return 'Hari pertama menstruasi harus diisi.';
        }
        return null;
      },
    );
  }

  Widget _tindakanTextFormField() {
    return TextFormField(
      controller: _tindakanController,
      decoration: InputDecoration(labelText: 'Tindakan'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      focusNode: _tindakanFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_tbFocusNode);
      },
      validator: (v) {
        if (v.isEmpty) {
          return 'Tindakan harus di isi';
        }
        return null;
      },
    );
  }

  Widget _buildTglPeriksa() {
    return widget.periksaData ==null?Container():Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text('Tanggal Periksa',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: ColorBase.pink)),
        FlatButton(
          child: Text(
            formatTgl(tglPeriksa),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () => _selectTglPemeriksaan(context),
        ),
      ],
    );
  }

  Future<Null> _selectTglPemeriksaan(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tglPeriksa,
      firstDate: DateTime(1990),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return child;
      },
    );
    if (picked != null) {
      setState(() {
        tglPeriksa = picked;
      });
    }
  }

  Widget _buildKategoriIMT(){
    return  widget.periksaData ==null?Container():Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 150,
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      color: widget.periksaData.kategoriImt == "normal"
                          ? Colors.blue
                          : ColorBase.pink,
                    ),
                    child: Text(
                      widget.periksaData.kategoriImt[0].toUpperCase() +
                          widget.periksaData.kategoriImt.substring(1),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  );
  }
}

