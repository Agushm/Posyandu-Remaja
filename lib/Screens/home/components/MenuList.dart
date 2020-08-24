import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/Dimens.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Constants/Navigation.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';
import 'package:posyandu_kuncup_melati/Environment/Environment.dart';
import 'package:posyandu_kuncup_melati/ViewModel/Auth.dart';
import 'package:posyandu_kuncup_melati/components/InWebView.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  String role = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.fromLTRB(Dimens.padding, 10.0, Dimens.padding, 20.0),
      decoration: BoxDecoration(color: ColorBase.grey, boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.05),
          //            blurRadius: 5,
          offset: Offset(0.0, 0.05),
        ),
      ]),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              Dictionary.menu,
              style: ConsTextStyle.judulMenuHome,
            ),
          ),
          SizedBox(height: Dimens.padding),
          _defaultRowMenusOne(),
          _buildAdminMenu(),
        ],
      ),
    );
  }

  _defaultRowMenusOne() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildButtonColumn('${Environment.iconAssets}report.png',
              'Daftar Pemeriksaan', NavigationConstants.PeriksaUmum),
          _buildButtonSVGColumn('${Environment.iconAssets}doctor.svg',
              'Konsultasi', NavigationConstants.Konsultasi),
          _buildButtonSVGColumn('${Environment.iconAssets}food.svg',
              'Saran Menu', NavigationConstants.SaranMenu),
          _buildButtonSVGColumn('${Environment.iconAssets}rating.svg',
              'Custom Menu Makanan', NavigationConstants.SaranCustom),
        ],
      ),
    );
  }

  defaultAdminRowMenusOne() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildButtonColumn('${Environment.iconAssets}team.png',
              'Daftar Anggota', NavigationConstants.DaftarAnggota),
          _buildButtonColumn('${Environment.iconAssets}speaker.png',
              'Pengumuman', NavigationConstants.BuatPengumuman),
        ],
      ),
    );
  }

  _buildButtonColumn(String iconPath, String label, String route,
      {Object arguments, bool openBrowser = false}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 6.0,
                color: Colors.black.withOpacity(.2),
                offset: Offset(2.0, 4.0),
              ),
            ], borderRadius: BorderRadius.circular(8.0), color: Colors.white),
            child: IconButton(
              color: Theme.of(context).textTheme.body1.color,
              iconSize: 32.0,
              icon: Image.asset(
                iconPath,
              ),
              onPressed: () {
                if (route != null) {
                  if (openBrowser) {
                    _launchUrl(route);
                  } else {
                    if (iconPath == '${Environment.iconAssets}help.png') {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InWebView(url: arguments)));

                      //   AnalyticsHelper.setLogEvent(Analytics.tappedDonasi);
                    } else {
                      Navigator.pushNamed(context, route, arguments: arguments);
                    }

                    // record event to analytics

                  }
                }
              },
            ),
          ),
          SizedBox(height: 12.0),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11.0,
                  color: Theme.of(context).textTheme.body1.color,
                  fontFamily: FontsFamily.productSans))
        ],
      ),
    );
  }

  _buildButtonSVGColumn(String iconPath, String label, String route,
      {Object arguments, bool openBrowser = false}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 6.0,
                color: Colors.black.withOpacity(.2),
                offset: Offset(2.0, 4.0),
              ),
            ], borderRadius: BorderRadius.circular(8.0), color: Colors.white),
            child: IconButton(
              color: Theme.of(context).textTheme.body1.color,
              iconSize: 32.0,
              icon: SvgPicture.asset(
                iconPath,
              ),
              onPressed: () {
                if (route != null) {
                  if (openBrowser) {
                    _launchUrl(route);
                  } else {
                    if (iconPath == '${Environment.iconAssets}help.png') {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InWebView(url: arguments)));

                      //   AnalyticsHelper.setLogEvent(Analytics.tappedDonasi);
                    } else {
                      Navigator.pushNamed(context, route, arguments: arguments);
                    }

                    // record event to analytics

                  }
                }
              },
            ),
          ),
          SizedBox(height: 12.0),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11.0,
                  color: Theme.of(context).textTheme.body1.color,
                  fontFamily: FontsFamily.productSans))
        ],
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildAdminMenu() {
    return Consumer<AuthProvider>(builder: (context, userProv, _) {
      if (userProv.user == null) {
        userProv.getOfflineData();
        return Container();
      }
      if (userProv.user != null) {
        return userProv.user.user.role == "petugas" ||
                userProv.user.user.role == "konsultan"
            ? Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Admin Menu",
                        style: ConsTextStyle.judulMenuHome,
                      )),
                  SizedBox(height: Dimens.padding),
                  defaultAdminRowMenusOne()
                ],
              )
            : Container();
      }
      return Container();
    });
  }
}
