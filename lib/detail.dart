


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'media.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class Detail extends StatefulWidget {
  const Detail(this.detail, this.datakeys, {Key? key}) : super(key: key);
  final Map detail;
  final String datakeys;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late DatabaseReference ref;
  List<Map<dynamic, dynamic>> data = [];
  List<String> dataKeys = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                  )
                ]),
                child: Container(
                    decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.blue.withOpacity(0.4), BlendMode.dstATop),
                    image: NetworkImage(widget.detail['img']),
                  ),
                )),
              ),
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.6),
                    offset: const Offset(0.0, 2.0),
                  )
                ]),
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
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: Center(
                  child: Positioned(
                      bottom: MediaQuery.of(context).size.width / 2,
                      child: IconButton(
                        icon: Icon(
                          Icons.insert_photo,
                          color: Colors.white.withOpacity(0.8),
                          size: 60,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Media(widget.detail, widget.datakeys),
                            ),
                          );
                        },
                      )),
                ),
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
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(),
                child: Text(
                   widget.detail['detail'],
                    style: GoogleFonts.lato(fontSize: 15
                    )
                  ),
              ),
              const SizedBox(height: 5),
              const Divider(color: Colors.black),
              Container(
                padding: const EdgeInsets.only(left: 25),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Tanggapan & Ulasan",
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              const Divider(color: Colors.black),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    
                    if (data[index]['textreview'] != '') {
                      int rate = data[index]['rating'];
                      double rating = rate.toDouble();
                      return Column(
                        children: [
                          const SizedBox(height: 25),
                          Container(
                            padding: const EdgeInsets.only(left: 25),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    data[index]["imgprofile"]),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(data[index]['name'],
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 10),
                                    RatingBarIndicator(
                                      rating: rating,
                                      itemSize: 18,
                                      itemPadding:
                                          const EdgeInsets.symmetric(horizontal: 0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, bottom: 25),
                            child: Text(data[index]['textreview'],
                                style: GoogleFonts.tinos(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18)),
                          ),
                          const SizedBox(
                            width: 40,
                            height: 25,
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  })
            ],
          ),
        ],
      ),
    ));
  }
}
