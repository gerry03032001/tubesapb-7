import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'displayimage.dart';
import 'package:tubes_app_7/firebase_api.dart';
import 'users.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget buildUploadStatus(firebase_storage.UploadTask task) =>
      StreamBuilder<firebase_storage.TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
  final user = FirebaseAuth.instance.currentUser;
  Future<users?> readUser(String idUser) async {
    final docUser =
        FirebaseFirestore.instance.collection('userData').doc(idUser);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return users.fromJson(snapshot.data()!);
    }
  }

  String? Getuid() {
    if (user != null) {
      final uid = user?.uid;
      return uid;
    } else {
      final uid = 'user?.uid;';
      return uid;
    }
  }

  File? file;
  File? url;
  firebase_storage.UploadTask? task;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {}
    });
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {}
    });
  }

  Future uploadFile() async {
    file = _photo;
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = fileName;

    task = FirebaseApi.uploadFile(destination, file!);
    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() => url = File(urlDownload));
    // ignore: avoid_print
    print(urlDownload);
  }

  @override
  Widget build(BuildContext context) {
    final urlname = url != null ? basename(url!.path) : 'No File Selected';
    return FutureBuilder<users?>(
        future: readUser(Getuid().toString()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('snapsot.');
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            return user == null
                ? Center(
                    child: Text('Not Have Account'),
                  )
                : SafeArea(
                    child: Scaffold(
                    body: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            toolbarHeight: 10,
                          ),
                          Center(
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    'Your Profile',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(64, 105, 225, 1),
                                    ),
                                  ))),
                          InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return SimpleDialog(
                                        title: Center(
                                            child: Text('Add Profile Picture')),
                                        children: [
                                          Column(
                                            children: [
                                              _photo != null
                                                  ? ClipRRect(
                                                      child: Image.file(
                                                        _photo!,
                                                        fit: BoxFit.cover,
                                                        height: 120,
                                                        width: 120,
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      height: 10.0,
                                                    ),
                                                                                                                                            task != null
                                                  ? buildUploadStatus(task!)
                                                  : Container(),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                            ),
                                            child: Column(
                                              children: [
                                                ElevatedButton(
                                                  child: const Text(
                                                      'Add Image From Galery'),
                                                  onPressed: () {
                                                    imgFromGallery();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ElevatedButton(
                                                  child: const Text(
                                                      'Add Image From Camera'),
                                                  onPressed: () async {
                                                    imgFromCamera();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                ElevatedButton(
                                                  child: const Text('Upload'),
                                                  onPressed: () async {
                                                    final docUser =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'userData')
                                                            .doc(Getuid()
                                                                .toString());
                                                    docUser.update(
                                                        {'img': urlname});
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                );
                              },
                              child: DisplayImage(
                                imagePath:
                                    'https://firebasestorage.googleapis.com/v0/b/tubes-apb-120e9.appspot.com/o/' +
                                        user.img,
                                onPressed: () {},
                              )),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Container(
                                      width: 350,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ))),
                                      child: Row(children: [
                                        Expanded(
                                            child: TextButton(
                                                onPressed: () {},
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    user.fname +
                                                        ' ' +
                                                        user.lname,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        height: 1.4,
                                                        color: Colors.black),
                                                  ),
                                                ))),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.grey,
                                          size: 40.0,
                                        )
                                      ]))
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Container(
                                      width: 350,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ))),
                                      child: Row(children: [
                                        Expanded(
                                            child: TextButton(
                                                onPressed: () {},
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    user.email,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        height: 1.4,
                                                        color: Colors.black),
                                                  ),
                                                ))),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.grey,
                                          size: 40.0,
                                        )
                                      ]))
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Container(
                                      width: 350,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ))),
                                      child: Row(children: [
                                        Expanded(
                                            child: TextButton(
                                                onPressed: () {
                                                  FirebaseAuth.instance
                                                      .signOut();
                                                  Navigator.pushNamed(
                                                      context, '/login');
                                                },
                                                child: Text(
                                                  'Logut',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      height: 1.4),
                                                ))),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.grey,
                                          size: 40.0,
                                        )
                                      ]))
                                ],
                              ))
                        ],
                      ),
                    ),
                  ));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
