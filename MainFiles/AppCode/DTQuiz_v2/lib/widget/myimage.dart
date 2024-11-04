import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyImage extends StatelessWidget {
  double? height;
  double? width;
  String imagePath;
  var fit;

  MyImage(
      {Key? key,
       this.width,
       this.height,
      required this.imagePath,
      // this.alignment,
      this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      // alignment: alignment,
    );
  }
}
