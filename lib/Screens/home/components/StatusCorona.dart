import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';
import 'package:posyandu_kuncup_melati/Environment/Environment.dart';
import 'package:posyandu_kuncup_melati/Providers/Corona.dart';
import 'package:provider/provider.dart';

class StatusCorona extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Consumer<CoronaProvider>(
      builder: (context,coronaProv,_){
        if(coronaProv.coronaData == null){
          coronaProv.getCorona();
          return Container();
        }else{
          CoronaModel data = coronaProv.findByProv('Jawa Tengah');
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical:10),
          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom:10),
                              child: Text(Dictionary.corona,style: ConsTextStyle.judulMenuHome),
                            ),
                            Row(
                              children: <Widget>[
                                _buildStatusCorona(deviceSize: deviceSize,status: "Positif",src: "cough.svg",jumlah: data.kasusPositif),
                                SizedBox(width: 10,),
                                _buildStatusCorona(deviceSize: deviceSize,status: "Sembuh",src: "mask-man.svg",jumlah: data.kasusSembuh),
                                SizedBox(width: 10,),
                                _buildStatusCorona(deviceSize: deviceSize,status: "Meninggal",src: "dead.svg",jumlah: data.kasusMeinggal),
                              ],
                            ),
                          ],
                        ),
        );
        }
      },
    );
  }

  Widget _buildStatusCorona({Size deviceSize,String status, String src, String jumlah}){
    
    return Container(
      width: (deviceSize.width-60)/3,
      padding: EdgeInsets.only(left: 5,top:10),
                              decoration: BoxDecoration( 
                                borderRadius: BorderRadius.circular(10),
                                color: status == "Sembuh"?ColorBase.green:status == "Positif"?ColorBase.pink:ColorBase.orange,
                              ),
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[
                                  Container(
                                    child: SvgPicture.asset('${Environment.iconAssets}'+src,color: Colors.white60, width: 80, height: 60,),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(bottom:10),
                                        child: Text(
                                          status,
                                          style: ConsTextStyle.statusCorona,
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(vertical:10),
                                          child: Row(
                                            children: <Widget>[
                                              Text(jumlah,style: ConsTextStyle.jumlahCorona,),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("Orang",style: ConsTextStyle.statusCorona,),
                                            ],
                                          )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
  }
}