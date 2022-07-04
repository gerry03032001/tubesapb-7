import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tubes_app_7/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'users.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Review extends StatefulWidget {
  const Review(this.detail, this.datakeys, {Key? key}) : super(key: key);
  final Map detail;
  final String datakeys;
  @override
  _Reviewstate createState() => _Reviewstate();
}

class _Reviewstate extends State<Review> {
  final user = FirebaseAuth.instance.currentUser;
  Future<users?> readUser(String idUser) async {
    final docUser =
        FirebaseFirestore.instance.collection('userData').doc(idUser);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return users.fromJson(snapshot.data()!);
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  String? Getuid() {
    if (user != null) {
      final uid = user?.uid;
      return uid;
    } else {
      const uid = 'user?.uid;';
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
  }

  late DatabaseReference ref;

  List<Map<dynamic, dynamic>> data = [];
  List<String> dataKeys = [];
  var textreview = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref = FirebaseDatabase.instance.ref('place/' + widget.datakeys + '/review');
    ref.onValue.listen((event) {
      final rows = event.snapshot.value as Map;
      List<Map> d = [];
      List<String> k = [];
      rows.forEach((key, value) {
        d.add(value as Map);
        k.add(key);
      });

      setState(() {
        data = d;
        dataKeys = k;
      });
    });
  }

  double rating = 0;
  @override
  Widget build(BuildContext context) {
    final urlname = url != null ? basename(url!.path) : 'No File Selected';
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0)
                    ]),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                    child: Image(
                      image: NetworkImage(widget.detail['img']),
                      fit: BoxFit.cover,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 30.0),
                child: Row(children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 40.0,
                    color: Colors.black,
                    onPressed: () => Navigator.pop(context),
                  )
                ]),
              ),
              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.detail['name'],
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on_sharp,
                          size: 10.0,
                          color: Colors.white70,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Bandung",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Masukan Pengalaman Anda :",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                TextField(
                  controller: textreview,
                  maxLines: 4,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    hintText: "Enter Your Text Here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RatingBar.builder(
                    itemSize: 40,
                    minRating: 1,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) => setState(() {
                      this.rating = rating;
                    }),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ]),
                _photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          _photo!,
                          fit: BoxFit.cover,
                          height: 200,
                          width: 200,
                        ),
                      )
                    : const SizedBox(
                        height: 10.0,
                      ),
                task != null ? buildUploadStatus(task!) : Container(),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 35,
                  width: 150,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_outlined),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: imgFromCamera,
                        child: const Text(
                          'Add Photo',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 35,
                  width: 300,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder<users?>(
                          future: readUser(Getuid().toString()),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('snapsot.');
                            } else if (snapshot.hasData) {
                              final user = snapshot.data;
                              return user == null
                                  ? const Center(
                                      child: Text('Not Have Account'),
                                    )
                                  : TextButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                      ),
                                      onPressed: () async {
                                        var newdata = {
                                          'textreview': textreview.text,
                                          'img': urlname,
                                          'name': user.fname + ' ' + user.lname,
                                          'rating': rating,
                                          'imgprofile': user.img
                                        };
                                        await ref.push().set(newdata);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Add Review',
                                        textDirection: TextDirection.ltr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.0),
                                      ),
                                    );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
      
    );

  }

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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
  
}
