import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Navigation.dart';
import 'package:posyandu_kuncup_melati/Screens/AdminMenu/AdminPemeriksaanScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/AdminMenu/DaftarAnggotaScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/AdminMenu/BuatPengumuman.dart';
import 'package:posyandu_kuncup_melati/Screens/IndexScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/SaranMenu/SaranMenuScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/SplashScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/UserMenu/PemeriksaanLainScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/UserMenu/PemeriksaanUmumScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/UserMenu/Remainder.dart';
import 'package:posyandu_kuncup_melati/Screens/WelcomeScreen.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/components/InWebView.dart';
import 'package:posyandu_kuncup_melati/components/infromationDetail.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';

Route generateRoutes(RouteSettings settings) {
  // getting arguments passed
  final args = settings.arguments;

  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) {
        return FutureBuilder<User>(
            future: SharedPref.getUserData(),
            builder: (ctx, snap) {
              print('SNAP DATA =>>>>> ${snap.data}');
              if (snap.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (snap.data == null &&
                  snap.connectionState == ConnectionState.done) {
                return WelcomeScreen();
              }
              if (snap.data != null &&
                  snap.connectionState == ConnectionState.done) {
                return IndexScreen();
              }
              return SplashScreen();
            });
        //IndexScreen();
      });

    case NavigationConstants.Browser:
      return buildRoute(
          settings,
          InWebView(
            url: args,
          ));
    case NavigationConstants.Home:
      return buildRoute(settings, IndexScreen());
    case NavigationConstants.DaftarAnggota:
      return buildRoute(settings, DaftarAnggotaScreen());
    case NavigationConstants.BuatPengumuman:
      return buildRoute(settings, AdminBuatPengumuman());
    case NavigationConstants.PeriksaUmum:
      return buildRoute(settings, UserPemeriksaanUmum());
    case NavigationConstants.Remainder:
      return buildRoute(settings, RemainderWorkout());
    case NavigationConstants.SaranMenu:
      return buildRoute(settings, SaranMenuScreen());
    case NavigationConstants.PeriksaLain:
      return buildRoute(settings, UserPemeriksaanLain());
    case NavigationConstants.AdminPemeriksaan:
      return buildRoute(settings, AdminPemeriksaanScreen());
    case NavigationConstants.Welcome:
      return buildRoute(settings, WelcomeScreen());
    case NavigationConstants.InformationDetail:
      return buildRoute(
          settings,
          InformationDetailScreen(
            document: args,
          ));
    default:
      return null;
  }
}

MaterialPageRoute buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
    settings: settings,
    builder: (BuildContext context) => builder,
  );
}
