import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


class AdminBuatPengumuman extends StatefulWidget {
  @override
  _AdminBuatPengumumanState createState() => _AdminBuatPengumumanState();
}

class _AdminBuatPengumumanState extends State<AdminBuatPengumuman> {
  var _isLoading = false;
  File _image;
  String title = "Pengumuman";
  String content = "Pengumuman";
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 30);

    setState(() {
      _image = image;
    });
  }
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController contentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
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
          :Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              _previewPengumuman(),
              SizedBox(height: 10),
              _formPengumuman(),
              SizedBox(height: 10),
              _pickImage(),
              FlatButton(onPressed: (){
                _submit();
              }, child: Text("Kirim"))
            ],
          ),
        ),
      ),
    );
  }

  Widget _previewPengumuman(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Container(
          height: 80,
          child: Row(
            children: <Widget>[
              Container(width: 90,height: 80,
              color:Colors.red,
              child: _image==null?Image.asset('assets/images/no-image.png',fit: BoxFit.fill,): Image.file(_image,fit:BoxFit.fill),
              ),
              Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(titleTextController.text == ''||titleTextController.text == null?'Judul Pengumuman': titleTextController.text,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(contentTextController.text == ''||contentTextController.text == null?'Isi Pengumuman': contentTextController.text)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formPengumuman(){
    return Form(
      key: _formKey,
        child: Container(padding: EdgeInsets.symmetric(horizontal: 24),child: Column(
          children: <Widget>[
            _titleTextFormField(),
            SizedBox(
                  height: 8.0,
                ),
            _contentTextFormField(),
          ],
        ),),
    );
  }

  Widget _titleTextFormField() {
    return TextFormField(
      controller: titleTextController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Judul Pengumuman',
        hintText: 'Masukan judul pengumuman',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink[100], width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink[100], width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (titleTextController.text.isEmpty) {
          return 'Tidak boleh kosong';
        }
      },
      onChanged: (value){
        setState(() {
          title = value;
        });
      },
    );
  }

  Widget _contentTextFormField() {
    return TextFormField(
      controller: contentTextController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Isi Pengumuman',
        hintText: 'Masukan isi pengumuman',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink[100], width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink[100], width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (contentTextController.text.isEmpty) {
          return 'Tidak boleh kosong';
        }
      },
      onChanged: (value){
        setState(() {
          content = value;
        });
      },
    );
  }
  Widget _pickImage(){
    return FlatButton(
      color: Colors.pinkAccent,
      textColor: Colors.white,
      child: Text('Ambil Gambar',),
      onPressed: (){
        getImage();
      },
    );

  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    
    try{
      await onSendPengumuman();
      
      Fluttertoast.showToast(msg: 'Pengumuman berhasil di upload');
    }catch(err){
      setState(() {
      _isLoading = false;
    });
      Fluttertoast.showToast(msg: 'Terjadi kesalahan saat mengupoad pengumuman');
      throw err;    
    }
  }
  
  Future<String> _uploadPengumuman() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      setState(() {
        _isLoading = false;
        
      });
      return downloadUrl;
    }, onError: (err) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }
  Future<void> onSendPengumuman(){
    var documentReference = Firestore.instance
    .collection('pengumuman')
    .document(DateTime.now().millisecondsSinceEpoch.toString());
    Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'title':title,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
          },
        );
      });
  }
}