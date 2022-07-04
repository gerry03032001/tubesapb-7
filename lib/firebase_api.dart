import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';


class FirebaseApi {
  // static Future<String> UploadImage(File imagefile) async {
  //   String filename = basename(imagefile);
    
  //   FirebaseStorage.instance
  // }

  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException {
      return null;
    }
  }
}