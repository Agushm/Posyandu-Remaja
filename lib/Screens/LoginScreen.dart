import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Constants/Navigation.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';
import 'package:posyandu_kuncup_melati/ViewModel/Auth.dart';
import 'package:posyandu_kuncup_melati/Providers/Auth.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Screens/IndexScreen.dart';
import 'package:provider/provider.dart';
import 'package:posyandu_kuncup_melati/Providers/http_exception.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode _passwordFocusNode = FocusNode();

  var _isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    
      await Provider.of<AuthProvider>(context, listen: false)
          .login(email :emailController.text, password:passwordController.text).then((value) {
            if(value == "OK"){
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>IndexScreen()));
            }
          });
      
    

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBase.pink,
      body: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                        Text(
                          Dictionary.posyandu,
                          style: ConsTextStyle.judulLoginScreen,
                        ),
                        Text(
                          Dictionary.posName,
                          style: ConsTextStyle.judulLoginScreen,
                        ),
                        Text(
                          Dictionary.desa,
                          style: ConsTextStyle.subJudulLoginScreen,
                        ),
                        SizedBox(
                          height: 48.0,
                        ),
                        _emailTextFormField(),
                        SizedBox(
                          height: 10,
                        ),
                        _passwordTextFormField(),
                        SizedBox(
                          height: 24.0,
                        ),
                        _isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/helicopter.png',
                    scale: 5,
                  ),
                ),
                Center(child: CircularProgressIndicator()),
              ],
            )
          : Container(
                          width: double.infinity,
                          child: RaisedButton(
                            shape: StadiumBorder(),
                            onPressed: () {
                              //Navigator.pushReplacementNamed(context, NavigationConstants.Home);
                              _submit();
                            },
                            color: ColorBase.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                Dictionary.login,
                                style: ConsTextStyle.btnLogin,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _emailTextFormField() {
    return TextFormField(
      controller: emailController,
      style: ConsTextStyle.loginScreenInput,
      cursorColor: ColorBase.white,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.orange, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        errorStyle: ConsTextStyle.loginScreenErrTextField,
        labelText: 'E mail',
        labelStyle: ConsTextStyle.loginScreenTextField,
        hintStyle: ConsTextStyle.loginScreenHint,
        hintText: 'Masukan E-mail',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.white, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.white, width: 2.0),
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
      
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
    );
  }

  Widget _passwordTextFormField() {
    return TextFormField(
      controller: passwordController,
      cursorColor: ColorBase.white,
      style: ConsTextStyle.loginScreenInput,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.orange, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        errorStyle: ConsTextStyle.loginScreenErrTextField,
        labelText: 'Password',
        hintText: 'Masukan password',
        labelStyle: ConsTextStyle.loginScreenTextField,
        hintStyle: ConsTextStyle.loginScreenHint,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.white, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.white, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
      
    );
  }
}
