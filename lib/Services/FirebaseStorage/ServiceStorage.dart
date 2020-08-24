import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
class ServiceStorage{
  static Future<String> uploadImageToFirebase(File imageFile,String username) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(username).child('Images').child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    
    return imageUrl;
  }
  static Future<String> uploadCoverImageToFirebase(File imageFile,String username) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(username).child('Cover Images').child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    
    return imageUrl;
  }
  static Future<String> uploadAudioToFirebase(File audioFile,String username) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(username).child('Voice Note').child(fileName);
    StorageUploadTask uploadTask = reference.putFile(audioFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    // storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
    //   imageUrl = downloadUrl;
    //   return downloadUrl;
      
    // }, onError: (err) {
    //    Fluttertoast.showToast(msg: 'Gagal Upload Image');
    //   //return null;
     
    // });
    return imageUrl;
  }
}
