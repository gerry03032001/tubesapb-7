import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Media extends StatefulWidget {
  const Media(this.detail, this.datakeys, {Key? key}) : super(key: key);
  final Map detail;
  final String datakeys;

  @override
  State<Media> createState() => _MediaState();
}

class _MediaState extends State<Media> {
  late DatabaseReference ref;
  List<Map<dynamic, dynamic>> data = [];
  List<String> dataKeys = [];
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media'),
      ),
      body: 
          GridView.builder(
            padding: const EdgeInsets.all(5),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 0.8,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: FullScreenWidget(
                      child: ClipRRect(
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/tubes-apb-120e9.appspot.com/o/' +
                                data[index]['img']),
                      ),
                    ),
                  ),
                );
              })
    );
    ;
  }
}
