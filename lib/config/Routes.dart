
import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Navigation.dart';
import 'package:posyandu_kuncup_melati/Screens/Admin%20Menu/AdminPemeriksaanScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/Admin%20Menu/BuatPengumuman.dart';
import 'package:posyandu_kuncup_melati/Screens/Admin%20Menu/DaftarAnggotaScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/IndexScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/User%20Menu/PemeriksaanLainScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/User%20Menu/PemeriksaanUmumScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/User%20Menu/Remainder.dart';
import 'package:posyandu_kuncup_melati/Screens/WelcomeScreen.dart';
import 'package:posyandu_kuncup_melati/components/InWebView.dart';
import 'package:posyandu_kuncup_melati/components/infromationDetail.dart';

Route generateRoutes(RouteSettings settings) {
  // getting arguments passed
  final args = settings.arguments;

  switch (settings.name) {
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
