import 'dart:io';

import 'package:flutter/cupertino.dart';

class Friend with ChangeNotifier {
  final String id;
  final String name;
  final String about;
  final File? image;
  final int rating;
  final String wNumber;
  final String birthDay;
  //////CHANGE IMAGEURL TO IMAGE PICKER

  Friend({
    required this.id,
    required this.name,
    required this.about,
    required this.image,
    required this.rating,
    required this.wNumber,
    required this.birthDay,
  });
}
