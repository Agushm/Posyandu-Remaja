import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Providers/DaftarAnggota.dart';
import 'package:posyandu_kuncup_melati/Providers/PemeriksaanUmum.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:provider/provider.dart';

class EditPeriksaUmum extends StatefulWidget {
  final PeriksaUmumModel periksaData;
  final UserModel userData;
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
            tglPeriksa = widget.periksaData.tglPeriksa;
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
      await Provider.of<PemeriksaanUmumProvider>(context, listen: false)
          .updateProduct(widget.periksaData.id, PeriksaUmumModel(
            id: widget.periksaData.id,
            bb: double.parse(_bbController.text),
            tb: double.parse(_tbController.text),
            imt: double.parse(_imtController.text),
            td: _tdController.text,
            hpmt: _hpmtController.text,
            lila: double.parse(_lilaController.text),
            ttd: _ttdController.text,
            userId: widget.userData.userId,
            tglPeriksa: tglPeriksa,
            tindakan: _tindakanController.text,
          ));
    } else if (widget.periksaData == null) {
      try {
        await Provider.of<PemeriksaanUmumProvider>(context, listen: false)
            .addPeriksa( PeriksaUmumModel(
            id: null,
            bb: double.parse(_bbController.text),
            tb: double.parse(_tbController.text),
            imt: double.parse(_imtController.text),
            td: _tdController.text,
            hpmt: _hpmtController.text,
            lila: double.parse(_lilaController.text),
            ttd: _ttdController.text,
            userId: widget.userData.userId,
            tglPeriksa: tglPeriksa,
            tindakan: _tindakanController.text,
          ));
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
                )
          );
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
        title: Text('Edit Pemeriksaan Umum'),
        
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
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    _buildTglPeriksa(),
                    _bbTextFormField(),
                    _tbTextFormField(),
                    _imtTextFormField(),
                    _tdTextFormField(),
                    _lilaTextFormField(),
                    _ttdTextFormField(),
                    _hpmtTextFormField(),
                    _tindakanTextFormField(),
                    
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton( 
              

              onPressed: () {
              _saveForm();
            }, child: Icon(Icons.save),),
    );
  }

  Widget _bbTextFormField() {
    return TextFormField(
      controller: _bbController,
      decoration: InputDecoration(labelText: 'Berat Badan'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_tbFocusNode);
      },
      validator: (v) {
        if (v.isEmpty) {
          return 'Berat Badan harus diisi.';
        }else if (v.length >=4){
          return 'Maksimal 4 digit';
        }
        return null;
      },
    );
  }

  Widget _tbTextFormField() {
    return TextFormField(
      controller: _tbController,
      decoration: InputDecoration(labelText: 'Tinggi Badan'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: _tbFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_imtFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Tinggi Badan harus diisi.';
        }else if (value.length >=4){
          return 'Maksimal 4 digit';
        }
        return null;
      },
    );
  }

  Widget _imtTextFormField() {
    return TextFormField(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text('Tanggal Periksa',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
                color: Colors.pink[200])),
        FlatButton(
          child: Text(
            formatTgl(tglPeriksa),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
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

  
}

