import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tubes_app_7/location.dart';
import 'package:tubes_app_7/review.dart';
import 'package:tubes_app_7/firebase_api.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? file;
  File? url;
  firebase_storage.UploadTask? task;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

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
    setState(() {});
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() => url = File(urlDownload));
    // ignore: avoid_print
    print(urlDownload);
  }

  late DatabaseReference ref;

  List<Map<dynamic, dynamic>> data = [];
  List<String> dataKeys = [];
  var nameinput = TextEditingController();
  var locationinput = TextEditingController();
  var detailinput = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref = FirebaseDatabase.instance.ref('place');
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

  @override
  Widget build(BuildContext context) {


    // ignore: unused_local_variable
    final urlname = url != null ? basename(url!.path) : 'No File Selected';
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 29),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    hintText: "Where to go next ?",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    iconColor: Colors.black),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 100),
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                        margin: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: ClipRRect(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Map detail = data[index];
                                  String datakeys = dataKeys[index];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Detail(detail, datakeys),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    data[index]["img"],
                                    fit: BoxFit.cover,
                                    height: 300,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                bottom: 10,
                                child: Container(
                                  height: 40,
                                  width: 90,
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    onPressed: () {
                                      Map detail = data[index];
                                      String datakeys = dataKeys[index];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Review(detail, datakeys),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Review',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    height: 40,
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 14),
                                    alignment: Alignment.centerLeft,
                                    child: Row(children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 9.52,
                                      ),
                                      TextButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                          ),
                                          onPressed: () {
                                            Map detail = data[index];
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Location(detail),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            data[index]["name"],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  }),
            ),
          ],
        ),
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
