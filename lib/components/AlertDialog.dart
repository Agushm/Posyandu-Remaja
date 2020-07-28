// import 'package:flutter/material.dart';

// class AlertDialogPopUp{
//   static Future<void> alertReSendPin(
//       BuildContext context, ResMessage data, String hp) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: data.status
//               ? Text('Berhasil Kirim Ulang Pin')
//               : Text('Gagal Kirim Ulang Pin'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 height: 200,
//                 child: data.status
//                     ? FlareActor(
//                         "assets/flare/succes.flr",
//                         animation: "succes",
//                         fit: BoxFit.fitHeight,
//                         alignment: Alignment.center,
//                         callback: (value) {
//                           if (data.err == 'aktivasi') {
//                             navigateToVerfication(context, hp);
//                           } else {
//                             Navigator.pop(context);
//                           }
//                         },
//                       )
//                     : FlareActor(
//                         "assets/flare/fail.flr",
//                         animation: "Failure",
//                         fit: BoxFit.fitHeight,
//                         alignment: Alignment.center,
//                         callback: (value) {
//                           Navigator.pop(context);
//                         },
//                       ),
//               ),
//               Text(data.message),
//             ],
//           ),
//           // actions: <Widget>[
//           //   FlatButton(
//           //       onPressed: () {
//           //         if (data.err == 'verification') {
//           //           navigateToVerfication(context, hp);
//           //         } else {
//           //           Navigator.pop(context);
//           //         }
//           //       },
//           //       child: Text('OK'))
//           // ],
//         );
//       },
//     );
//   }

// }