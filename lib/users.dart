import 'package:cloud_firestore/cloud_firestore.dart';

class users {
  final String fname;
  final String lname;
  final String email;
  final String img;

  users({
    required this.fname,
    required this.lname,
    required this.email,
    required this.img,
  });

  Map<String, dynamic> toJson() => {
        'fname': fname,
        'lname': lname,
        'email': email,
        'img': img,
      };
  static users fromJson(Map<String, dynamic> json) =>
      users(
        fname: json['fname'], 
        lname: json['lname'],
        email: json['email'],
        img: json['img']
      );
}
