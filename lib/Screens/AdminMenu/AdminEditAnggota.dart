import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';
import 'package:posyandu_kuncup_melati/Environment/Environment.dart';
import 'package:posyandu_kuncup_melati/ViewModel/Auth.dart';
import 'package:posyandu_kuncup_melati/Providers/Auth.dart';
import 'package:posyandu_kuncup_melati/Providers/DaftarAnggota.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Screens/WelcomeScreen.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatText.dart';
import 'package:posyandu_kuncup_melati/Providers/http_exception.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';
import 'package:posyandu_kuncup_melati/widgets/Toast.dart';
import 'package:provider/provider.dart';

class AdminEditAnggota extends StatefulWidget {
  final UserClass userData;
  AdminEditAnggota({@required this.userData});
  @override
  _AdminEditAnggotaState createState() => _AdminEditAnggotaState();
}

class _AdminEditAnggotaState extends State<AdminEditAnggota> {
  FocusNode _passwordFocusNode = FocusNode();

  FocusNode _cpasswordFocusNode = FocusNode();

  FocusNode _namaFocusNode = FocusNode();
  FocusNode _roleFocusNode = FocusNode();

  FocusNode _activeFocusNode = FocusNode();

  var _isLoading = false;

  String _tglText;

  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _tempatLahirController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  TextEditingController _activeController = TextEditingController();

  DateTime _tglLahir = DateTime.now();
  String _gender;

  Map<String, dynamic> _regisData = {
    'email': '',
    'password': '',
    'nama': '',
    'role': 'user',
    'tglLahir': DateTime.now(),
    'gender': '',
  };

  @override
  void initState() {
    if (widget.userData != null) {
      setState(() {
        _emailController.text = widget.userData.email;
        _namaController.text = widget.userData.nama;
        _tempatLahirController.text = widget.userData.tempatLahir;
        _roleController.text = widget.userData.role;
        _activeController.text = widget.userData.active;
        _tglLahir = DateTime.parse(widget.userData.tglLahir);
        _gender = widget.userData.jnsKelamin;
        _tglText = tanggal(DateTime.parse(widget.userData.tglLahir));
      });
    } else {
      _tglText = FormatText.formatTgl(DateTime.now());
    }

    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Terjadi Kesalahan Daftar'),
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
        _tglLahir = picked;
        _tglText = FormatText.formatTgl(_tglnow);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.userData == null?"Tambah Anggota":"Edit Anggota"),
      ),
      backgroundColor: Colors.white,
      body: _formRegister(),
    );
  }

  Widget _formRegister() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
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
                  style: TextStyle(
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
                widget.userData == null
                    ? Column(
                        children: <Widget>[
                          _passwordTextFormField(),
                          SizedBox(
                            height: 8.0,
                          ),
                          _confirmPasswordTextFormField(),
                          SizedBox(
                            height: 8.0,
                          ),
                        ],
                      )
                    : Container(),
                _namaTextFormField(),
                SizedBox(
                  height: 8.0,
                ),
                _tempatLahirTextFormField(),
                SizedBox(
                  height: 8.0,
                ),
                _roleTextFormField(),
                SizedBox(
                  height: 8.0,
                ),
                _activeTextFormField(),
                
                SafeArea(child: _buildTglLahir()),
                _buildGender(),
                SizedBox(
                  height: 24.0,
                ),
                _isLoading
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
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          color: ColorBase.pink,
                          onPressed: () {
                            _submit();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              widget.userData == null ?Dictionary.tambahAnggota:Dictionary.editAnggota,
                              style: ConsTextStyle.judulWelcomeScreen,
                            ),
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
      controller: _namaController,
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
        if (value.isEmpty || value.trim().length == 0) {
          return 'Masukan Nama Lengkap Anda';
        }
        return null;
      },
      onSaved: (value) {
        _regisData['nama'] = value;
      },
    );
  }

  Widget _roleTextFormField() {
    return TextFormField(
      controller: _roleController,
      cursorColor: ColorBase.pink,
      decoration: InputDecoration(
        labelText: 'Role ("anggota","petugas","konsultan")',
        hintText: 'Masukan role anggota',
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
        if (value.isEmpty || value.trim().length == 0) {
          return 'Masukan role anggota';
        }
        if(value != "anggota" &&value != "petugas"&& value != "konsultan"){
          return 'Role hanya ada anggota, petugas, konsultan';
        }
        return null;
      },
      
    );
  }

  Widget _activeTextFormField() {
    return TextFormField(
      controller: _activeController,
     
      cursorColor: ColorBase.pink,
      decoration: InputDecoration(
        labelText: 'Active ("active","deactive")',
        hintText: 'Aktifasi akun anggota',
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
        if (value.isEmpty || value.trim().length == 0) {
          return 'Masukan role anggota';
        }
        if(value != "active" && value != "deactive"){
          return 'active atau deactive';
        }
        return null;
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
                  color: _gender == 'L' ? const Color(0xFF6fa1ea) : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _gender = 'L';
                  });
                },
                label: Text(
                  'Laki-Laki',
                  style: TextStyle(
                      color: _gender == 'L' ? Colors.blueAccent : Colors.black),
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
                  color: _gender == 'P' ? const Color(0xFFf5bad3) : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _gender = 'P';
                  });
                },
                label: Text('Perempuan',
                    style: TextStyle(
                        color:
                            _gender == 'P' ? Colors.pinkAccent : Colors.black)),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _emailTextFormField() {
    return TextFormField(
      controller: _emailController,
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
        if (value.isEmpty || !value.contains('@') || value.trim().length == 0) {
          return 'Masukan E-mail yang benar';
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

  Widget _tempatLahirTextFormField() {
    return TextFormField(
      controller: _tempatLahirController,
      textInputAction: TextInputAction.next,
      cursorColor: ColorBase.pink,
      decoration: InputDecoration(
        labelText: 'Tempat Lahir',
        hintText: 'Tempat kelahiran anda',
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
        if (value.isEmpty || value.trim().length == 0) {
          return 'Tempat lahir harus diisi';
        }
        return null;
      },
      onSaved: (value) {
        _regisData['tempatLahir'] = value;
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
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    if (widget.userData == null) {
      await Provider.of<DaftarAnggotaProvider>(context, listen: false)
          .tambahAnggota(
              email: _emailController.text,
              password: _passwordController.text,
              nama: _namaController.text,
              gender: _gender,
              tglLahir: _tglLahir,
              tempatLahir: _tempatLahirController.text,
              role: _roleController.text,
              active: _activeController.text
              )
          .then((value) {
        if (value == "OK") {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
    if (widget.userData != null) {
      await Provider.of<DaftarAnggotaProvider>(context, listen: false)
          .editAnggota(
              userID: widget.userData.userID,
              email: _emailController.text,
              nama: _namaController.text,
              gender: _gender,
              tglLahir: _tglLahir,
              tempatLahir: _tempatLahirController.text,
              role:_roleController.text,
              active: _activeController.text,
              )
          .then((value) {
        if (value == "OK") {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  DateTime _tglnow = DateTime.now();
}
