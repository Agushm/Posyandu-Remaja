// import 'package:flutter/material.dart';
// class ItemRoom extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return  GestureDetector(
//                       onTap: () {
//                         if (user.user.role == "konsultan") {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => MessagesScreen(
//                                         groupID: groupId,
//                                         loginId: user.user.userId,
//                                         peerData: peerKonsultan,
//                                       )));
//                         } else {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => MessagesScreen(
//                                         groupID: groupId,
//                                         loginId: user.user.userId,
//                                         peerData: peerUser,
//                                       )));
//                         }
//                       },
//                       child: ListTile(
//                         leading: (user.user.role == 'konsultan')
//                             ? document['imageUser'] == ' '
//                                 ? CircleAvatar(
//                                   radius: 35,
//                                     backgroundColor: Colors.lightBlue,
//                                     child: Text(
//                                       document['namaUser'][0],
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   )
//                                 : CircleAvatar(
//                                   radius: 35,
//                                     backgroundImage:
//                                         NetworkImage(konsultan.imageUrl),
//                                   )
//                             : konsultan.imageUrl == ' '
//                                 ? CircleAvatar(
//                                   radius: 35,
//                                     backgroundColor: Colors.lightBlue,
//                                     child: Text(
//                                       konsultan.nama[0],
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   )
//                                 : CircleAvatar(
//                                   radius: 35,
//                                     backgroundImage:
//                                         NetworkImage(konsultan.imageUrl),
//                                   ),
//                         title: user.user.role == 'konsultan'
//                             ? Text(document['namaUser'])
//                             : Text(konsultan.nama),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               ItemPesanTerbaru(groupId),
//                               Divider(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//   }
// }