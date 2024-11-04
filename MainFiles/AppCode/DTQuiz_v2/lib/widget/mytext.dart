// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  String? title;
  double? size;

  var maxline, fontstyle, fontWeight, textalign, maltilanguage,fontfamilyInter;
  Color? colors;
  var overflow;

  MyText(
      {Key? key,
      required this.title,
      required this.maltilanguage,
      this.fontfamilyInter,
      this.colors,
      this.size,
      this.maxline,
      this.overflow,
      this.textalign,
      this.fontWeight,
      this.fontstyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return maltilanguage == true
        ? LocaleText(
            title.toString(),
            textAlign: textalign,
            overflow: overflow,
            maxLines: maxline,
            style: fontfamilyInter == true
                ? GoogleFonts.rubik(
                    fontSize: size,
                    fontStyle: fontstyle,
                    color: colors,
                    fontWeight: fontWeight)
                : GoogleFonts.poppins(
                    fontSize: size,
                    fontStyle: fontstyle,
                    color: colors,
                    fontWeight: fontWeight),
          )
        : Text(
            title.toString(),
            textAlign: textalign,
            overflow: overflow,
            maxLines: maxline,
            style: GoogleFonts.rubik(
                fontSize: size,
                fontStyle: fontstyle,
                color: colors,
                fontWeight: fontWeight),
          );
  }
}
