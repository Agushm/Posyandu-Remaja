import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Providers/PemeriksaanLain.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:provider/provider.dart';

class EditPeriksaLain extends StatefulWidget {
  final PeriksaLainModel periksaData;
  final UserModel userData;
  EditPeriksaLain({this.periksaData, this.userData});
  @override
  _EditPeriksaLainState createState() => _EditPeriksaLainState();
}

class _EditPeriksaLainState extends State<EditPeriksaLain> {
  final _form = GlobalKey<FormState>();
  final _ketPeriksaFocusNode = FocusNode();

  TextEditingController _jnsPeriksaController = TextEditingController();
  TextEditingController _keteranganController = TextEditingController();
  
  DateTime tglPeriksa = DateTime.now();
  
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    //_EditPeriksaLain.id : widget.userId;
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.periksaData != null) {
          setState(() {
            _jnsPeriksaController.text = widget.periksaData.jenisPeriksa;
            _keteranganController.text = widget.periksaData.ketPeriksa;
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
      await Provider.of<PemeriksaanLainProvider>(context, listen: false)
          .updateProduct(widget.periksaData.id, PeriksaLainModel(
            id: widget.periksaData.id,
            jenisPeriksa: _jnsPeriksaController.text,
            ketPeriksa: _keteranganController.text,
            userId: widget.userData.userId,
            tglPeriksa: tglPeriksa,
            
          ));
    } else if (widget.periksaData == null) {
      try {
        await Provider.of<PemeriksaanLainProvider>(context, listen: false)
            .addPeriksa( PeriksaLainModel(
            id: null,
            jenisPeriksa: _jnsPeriksaController.text,
            ketPeriksa: _keteranganController.text,
            userId: widget.userData.userId,
            tglPeriksa: tglPeriksa,
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
        title: Text('Edit Pemeriksaan Lain'),
        
      ),
      body:  _isLoading
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
          :Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    _buildTglPeriksa(),
                    _jenisPeriksaTextFormField(),
                    _ketPeriksaTextFormField(),
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
  Widget _jenisPeriksaTextFormField(){
    return TextFormField(
      controller: _jnsPeriksaController,
      decoration: InputDecoration(labelText: 'Jenis Pemeriksaan'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textInputAction:TextInputAction.done,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_ketPeriksaFocusNode);
      },
      validator: (v) {
        if (v.isEmpty) {
          return 'Jenis Pemeriksaan harus di isi';
        }
        return null;
      },
    );
  }
  
  Widget _ketPeriksaTextFormField(){
    return TextFormField(
      controller: _keteranganController,
      decoration: InputDecoration(labelText: 'Keterangan Pemeriksaan'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textInputAction:TextInputAction.done,
      focusNode: _ketPeriksaFocusNode,
      validator: (v) {
        if (v.isEmpty) {
          return 'Keterangan Pemeriksaan harus di isi';
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

