import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextTheme {
  static TextTheme lightTextTheme = TextTheme(
      headline2: GoogleFonts.ubuntu(
        color: Colors.black87,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      subtitle1: GoogleFonts.lato(
        color: Colors.black,
        fontSize: 18,
      ),
      bodyText2: GoogleFonts.lato(
        color: Colors.black87,
        fontSize: 20,
        height: 1.3,
      ),
      headline1: GoogleFonts.pacifico(
        color: Colors.black,
        fontSize: 27,
      ));
  static TextTheme darkTextTheme = TextTheme(
      headline2: GoogleFonts.ubuntu(
        color: Colors.black87,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      subtitle1: GoogleFonts.lato(
        color: Colors.black,
        fontSize: 18,
      ),
      bodyText2: GoogleFonts.lato(
        color: Colors.black87,
        fontSize: 20,
        height: 1.3,
      ));
}
