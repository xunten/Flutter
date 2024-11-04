import 'package:flutter/material.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/widget/mytext.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final color;
  final double? height;

  const MyAppbar({
    Key? key,
    required this.title,
    this.color,
    this.height,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height!);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AppBar(
        title: MyText(
          title: title,
          maltilanguage: true,
          fontfamilyInter: false,
          colors: white,
          size: 20,
          // style: GoogleFonts.poppins(
          //     color: white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
