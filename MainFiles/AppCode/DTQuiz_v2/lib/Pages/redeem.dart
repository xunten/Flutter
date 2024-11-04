import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/Wallet.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/myappbar.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';

class Redeem extends StatefulWidget {
  const Redeem({Key? key}) : super(key: key);

  @override
  State<Redeem> createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  String redeemvalue = 'Paypal';
  final controller = TextEditingController();
  final amountcontroller = TextEditingController();
  late ApiProvider withdrwalprovider;
  int? index;
  int? _value;

  @override
  void initState() {
    super.initState();
  }

  List images = [
    "assets/images/pg_paypal.png",
    "assets/images/pg_paytm.png",
    "assets/images/pg_payumoney.png",
    "assets/images/pg_razorpay.png",
    "assets/images/pg_stripe.png"
  ];
  List name = ["Paypal", "Paytm", "Payumoney", "Razorpay", "Stripe"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(children: [
          Column(
            children: [
              const MyAppbar(title: "Redeem", height: 50),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            MyText(
                              colors: black,
                              title: "amount",
                              maltilanguage: true,
                              size: 25,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 150,
                              child: TextFormField(
                                textAlign: TextAlign.left,
                                obscureText: false,
                                controller: amountcontroller,
                                textInputAction: TextInputAction.go,
                                cursorColor: appDarkColor,
                                style: GoogleFonts.montserrat(
                                    fontSize: 25,
                                    fontStyle: FontStyle.normal,
                                    color: appDarkColor,
                                    fontWeight: FontWeight.w700),
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                  hintStyle: GoogleFonts.montserrat(
                                      fontSize: 25,
                                      fontStyle: FontStyle.normal,
                                      color: appDarkColor,
                                      fontWeight: FontWeight.w500),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MyText(
                              colors: appDarkColor,
                              title: "Select Payment Type ",
                              maltilanguage: false,
                              size: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.only(left: 18, right: 18),
                              itemCount: images.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 15),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          width: 2, color: appDarkColor)),
                                  child: ChoiceChip(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    pressElevation: 0.0,
                                    selectedColor: withdrawal,
                                    backgroundColor: white,
                                    label: Container(
                                      height: 150,
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          MyImage(
                                              width: 90,
                                              height: 80,
                                              imagePath: images[index]),
                                          MyText(
                                            title: name[index],
                                            size: 14,
                                            fontWeight: FontWeight.w500,
                                            colors: _value == index
                                                ? appDarkColor
                                                : appDarkColor,
                                            maltilanguage: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    selected: _value == index,
                                    onSelected: (selected) {
                                      setState(() {
                                        _value = (selected ? index : null)!;
                                        log("====>>>>>${_value! + 1}");
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 150,
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                maxLines: 8,
                                keyboardType: TextInputType.multiline,
                                textAlign: TextAlign.left,
                                obscureText: false,
                                controller: controller,
                                textInputAction: TextInputAction.newline,
                                cursorColor: appDarkColor,
                                style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    color: appDarkColor,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: withdrawal,
                                  labelText: "",
                                  labelStyle: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      color: appDarkColor,
                                      fontWeight: FontWeight.w500),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        color: appDarkColor, width: 1.5),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        color: appDarkColor, width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                                onPressed: () async {
                                  if (controller.text == "") {
                                    Utility.toastMessage(
                                        "Please Enter the details");
                                  } else {
                                    if (redeemvalue == "Paypal") {
                                      index == 1;
                                    } else if (redeemvalue == "Paytm") {
                                      index == 2;
                                    } else {
                                      index == 3;
                                    }
                                    log("Index is == ${redeemvalue.indexOf(redeemvalue)}");
                                    final withdrwalprovider =
                                        Provider.of<ApiProvider>(context,
                                            listen: false);
                                    await withdrwalprovider
                                        .getWithdrawalRequest(
                                            Constant.userID ?? "",
                                            controller.text,
                                            (_value! + 1).toString(),
                                            amountcontroller.text);
                                    log("Called the Withdrawal Request Api ");
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return const Wallet();
                                    }));
                                  }
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0))),
                                    backgroundColor: MaterialStateProperty.all(
                                        appDarkColor)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: MyText(
                                    maltilanguage: true,
                                    title: 'submit',
                                    size: 16,
                                    fontWeight: FontWeight.w500,
                                    colors: white,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: adview(),
            ),
          )
        ]),
      ),
    );
  }

  Widget adview() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        color: Colors.transparent,
        height: 60,
        child: AdHelper().bannerAd(),
      ),
    );
  }
}
