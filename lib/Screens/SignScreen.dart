import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';
import 'package:posyandu_kuncup_melati/Environment/Environment.dart';
import 'package:posyandu_kuncup_melati/Providers/Auth.dart';
import 'package:posyandu_kuncup_melati/Screens/WelcomeScreen.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatText.dart';
import 'package:posyandu_kuncup_melati/Providers/http_exception.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FocusNode _passwordFocusNode = FocusNode();

  FocusNode _cpasswordFocusNode = FocusNode();

  FocusNode _namaFocusNode = FocusNode();

  var _isLoading = false;

  String _tglText;

  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController _passwordController = TextEditingController();

  Map<String, dynamic> _regisData = {
    'email': '',
    'password': '',
    'nama': '',
    'role':'user',
    'tglLahir': DateTime.now(),
    'gender': '',
  };

  @override
  void initState() {
    _tglText = FormatText.formatTgl(DateTime.now());
    super.initState();
  }

    void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Terjadi Kesalahan Login'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
            );
  }

  Future<Null> _selectTglPemeriksaan(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tglnow,
      firstDate: DateTime(1990),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return child;
      },
    );
    if (picked != null) {
      setState(() {
        _tglnow = picked;
        _regisData['tglLahir'] = picked;
        _tglText = FormatText.formatTgl(_tglnow);
      });
    }
  }

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
          : _formRegister(),
    );
  }

  Widget _formRegister() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 100),
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 100.0,
                  child: Image.asset('assets/images/hospital.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  Dictionary.appName,
                  style: TextStyle(
                    color: ColorBase.pink,
                    fontFamily: FontsFamily.productSans,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  Dictionary.desa,
                  style:TextStyle(
                    color: ColorBase.pink,
                    fontFamily: FontsFamily.productSans,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                _emailTextFormField(),
                SizedBox(
                  height: 8.0,
                ),
                _passwordTextFormField(),
                SizedBox(
                  height: 8.0,
                ),
                _confirmPasswordTextFormField(),
                SizedBox(
                  height: 10.0,
                ),
                _namaTextFormField(),
                SafeArea(child: _buildTglLahir()),
                _buildGender(),
                SizedBox(
                  height: 24.0,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: RaisedButton(
                                    elevation: 5,
                                    color: ColorBase.pink,
                    onPressed: (){
                      _submit();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical:15),
                      child: Text(Dictionary.signUp,style: ConsTextStyle.judulWelcomeScreen,),
                    ),
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaTextFormField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      focusNode: _namaFocusNode,
      cursorColor: ColorBase.pink,
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        hintText: 'Masukan Nama Lengkap',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.pink, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.pink, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'Masukan Nama Lengkap Anda';
        }
        return null;
      },
      onSaved: (value) {
        _regisData['nama'] = value;
      },
    );
  }

  Widget _buildGender() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Jenis Kelamin'.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17.0,
                color: ColorBase.pink),
          ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: FlatButton.icon(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: SvgPicture.asset(
                  '${Environment.iconAssets}male.svg',
                  height: 20.0,
                  width: 20.0,
                  color: _regisData['gender'] == 'laki-laki'
                      ? const Color(0xFF6fa1ea)
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _regisData['gender'] = 'laki-laki';
                  });
                },
                label: Text(
                  'Laki-Laki',
                  style: TextStyle(
                      color: _regisData['gender'] == 'laki-laki'
                          ? Colors.blueAccent
                          : Colors.black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: FlatButton.icon(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: SvgPicture.asset(
                  '${Environment.iconAssets}female.svg',
                  height: 20.0,
                  width: 20.0,
                  color: _regisData['gender'] == 'perempuan'
                      ? const Color(0xFFf5bad3)
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _regisData['gender'] = 'perempuan';
                  });
                },
                label: Text('Perempuan',
                    style: TextStyle(
                        color: _regisData['gender'] == 'perempuan'
                            ? Colors.pinkAccent
                            : Colors.black)),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _emailTextFormField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      cursorColor: ColorBase.pink,
      decoration: InputDecoration(
        labelText: 'E mail',
        hintText: 'Masukan E-mail',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.pink, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.pink, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty || !value.contains('@')) {
          return 'Masukan E-mail';
        }
        return null;
      },
      onSaved: (value) {
        _regisData['email'] = value;
      },
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
    );
  }

  Widget _passwordTextFormField() {
    return TextFormField(
      cursorColor: ColorBase.pink,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Masukan password',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.pink, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.pink, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      controller: _passwordController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password yang anda masukan terlalu pendek!';
        }
        return null;
      },
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_cpasswordFocusNode);
      },
      onSaved: (value) {
        _regisData['password'] = value;
      },
    );
  }

  Widget _confirmPasswordTextFormField() {
    return TextFormField(
      cursorColor: ColorBase.pink,
      focusNode: _cpasswordFocusNode,
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Konfirmasi Password',
        hintText: 'Masukan password yang sama',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.pink, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.pink, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Password yang anda masukan tidak sama';
        }
        return null;
      },
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_namaFocusNode);
      },
    );
  }

  Widget _buildTglLahir() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Tanggal Lahir'.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17.0,
                color: ColorBase.pink)),
        FlatButton(
          child: Text(
            _tglText,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () => _selectTglPemeriksaan(context),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).signup(
          _regisData['email'],
          _regisData['password'],
          _regisData['nama'],
          _regisData['gender'],
          _regisData['tglLahir'],
          _regisData['role']
          );
        showDialog(context: context,
          builder: (ctx) => AlertDialog(
              title: Text('Berhasil Daftar'),
              content: Text('Silahkan login di halaman login'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                  },
                )
              ],
            ),
        );
      }on HttpException catch (error){
      var errorMessage = 'Tidak Dapat Sign Up';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Email telah terdaftar';
      } else if ( error.toString().contains('WEAK_PASSWORD')){
        errorMessage = 'Password yang anda masukan terlalu lemah';
      }else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Email yang anda masukan tidak valid';
      }
      _showErrorDialog(errorMessage);
    } 
    catch (error) {
    const errorMessage = 'Tidak dapat sing up . Tolong coba lagi nanti';
    _showErrorDialog(errorMessage);
    }
    
    setState(() {
      _isLoading = false;
    });
    
  }

  DateTime _tglnow = DateTime.now();

  
}
