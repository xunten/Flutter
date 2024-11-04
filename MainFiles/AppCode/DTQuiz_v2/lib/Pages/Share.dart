import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/widget/myappbar.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';

bool topBar = false;

class Share extends StatefulWidget {
  const Share({Key? key}) : super(key: key);

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  @override
  Widget build(BuildContext context) {
    return buildViewPager();
  }

  buildViewPager() {
    return Scaffold(
      backgroundColor: appBgColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/dash_bg.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(50.0, 50.0)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getAppbar(),
                  buildBody(),
                ],
              ),
            ]),
          ),
          buildShareIcon()
        ],
      ),
    );
  }

  getAppbar() {
    return const MyAppbar(title: "shareapp");
  }

  buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(height: 20),
        MyImage(imagePath: 'assets/images/ic_share.png', height: 100),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: MyText(title: 
              "Share the love by inviting your friends and both of you will get points",
              maltilanguage: false,colors: white,
                                            size: 16,
                                            fontWeight: FontWeight.w500,),
        ),
        const SizedBox(height: 30),
        DottedBorder(
          dashPattern: const [4, 4],
          strokeWidth: 1,
          color: white,
          child: Container(
            height: 60,
            width: 280,
            color: tabbarunselect,
            child: Center(
              child: MyText(
                maltilanguage: false,
                title: "VhoWIH",
                size: 24,
                fontWeight: FontWeight.w600,
                colors: white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: MyText(
            title: "copycode",
            size: 16,
            fontWeight: FontWeight.normal,
            colors: white,
            maltilanguage: true,
            fontfamilyInter: false,
          ),
        ),
      ]),
    );
  }

  buildShareIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        MyText(
            maltilanguage: true,
            title: "sharefriend",
            size: 18,
            fontWeight: FontWeight.w500),
        const SizedBox(height: 20),
        Row(
          children: [
            const Spacer(),
            Column(
              children: [
                MyImage(
                  imagePath: "assets/images/ic_fb.png",
                  height: 60,
                ),
                const SizedBox(height: 5),
                MyText(
                    maltilanguage: true,
                    title: "facebook",
                    size: 16,
                    fontWeight: FontWeight.w500)
              ],
            ),
            const Spacer(),
            Column(
              children: [
               MyImage(
                  imagePath: "assets/images/ic_tw.png",
                  height: 60,
                ),
                const SizedBox(height: 5),
                MyText(
                    maltilanguage: true,
                    title: "twitter",
                    size: 16,
                    fontWeight: FontWeight.w500)
              ],
            ),
            const Spacer(),
            Column(
              children: [
                MyImage(
                  imagePath: "assets/images/ic_gp.png",
                  height: 60,
                ),
                const SizedBox(height: 5),
                MyText(
                    maltilanguage: true,
                    title: "google",
                    size: 16,
                    fontWeight: FontWeight.w500)
              ],
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const Spacer(),
            Column(
              children: [
                MyImage(
                  imagePath: "assets/images/ic_line.png",
                  height: 60,
                ),
                const SizedBox(height: 5),
                MyText(
                  title: "line",
                  size: 16,
                  fontWeight: FontWeight.w500,
                  maltilanguage: true,
                )
              ],
            ),
            const Spacer(),
            Column(
              children: [
                MyImage(
                  imagePath: "assets/images/ic_wp.png",
                  height: 60,
                ),
                const SizedBox(height: 5),
                MyText(
                    maltilanguage: true,
                    title: "whatsapp",
                    size: 16,
                    fontWeight: FontWeight.w500)
              ],
            ),
            const Spacer(),
            Column(
              children: [
               MyImage(
                  imagePath: "assets/images/ic_sms.png",
                  height: 60,
                ),
                const SizedBox(height: 5),
                MyText(
                  title: "sms",
                  size: 16,
                  fontWeight: FontWeight.w500,
                  maltilanguage: true,
                )
              ],
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
