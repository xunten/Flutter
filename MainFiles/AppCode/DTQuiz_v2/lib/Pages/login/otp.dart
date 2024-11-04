// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/Home.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/mytext.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OTP extends StatefulWidget {
  const OTP({Key? key}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final numberController = TextEditingController();
  final pinPutController = TextEditingController();
  ScrollController scollController = ScrollController();
  SharePref sharePref = SharePref();
  String? mobileNumber;
  bool otpUI = true;
  bool isLoading = false;
  String? verificationId;
  String? strDeviceToken;
  dynamic platformType;
  @override
  void initState() {
    super.initState();
    _getDeviceToken();
  }

  _getDeviceToken() async {
    if (Platform.isAndroid) {
      strDeviceToken = await FirebaseMessaging.instance.getToken();
      platformType = 1;
    } else {
      final status = await OneSignal.shared.getDeviceState();
      strDeviceToken = status?.userId;
      platformType = 2;
    }
    log("===>strDeviceToken $strDeviceToken");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(top: 70),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/login_logo.png"),
                          fit: BoxFit.fitHeight)),
                )),
            otpUI
                ? Expanded(
                    flex: 3,
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/login_bg_white.png"),
                              fit: BoxFit.fill)),
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                  title: "mobilenumber",
                                  maltilanguage: true,
                                )),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: IntlPhoneField(
                                disableLengthCheck: true,
                                textAlignVertical: TextAlignVertical.center,
                                autovalidateMode: AutovalidateMode.disabled,
                                controller: numberController,
                                style:
                                    const TextStyle(fontSize: 14, color: black),
                                showCountryFlag: false,
                                showDropdownIcon: false,
                                initialCountryCode: 'IN',
                                dropdownTextStyle: GoogleFonts.inter(
                                    color: black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: false,
                                  hintStyle: GoogleFonts.inter(
                                      color: textColorGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  hintText: "MobileNumber",
                                ),
                                onChanged: (phone) {
                                  log('===> ${phone.completeNumber}');
                                  log('===> ${numberController.text}');
                                  mobileNumber = phone.completeNumber;
                                  log('===>mobileNumber $mobileNumber');
                                },
                                onCountryChanged: (country) {
                                  log('===> ${country.name}');
                                  log('===> ${country.code}');
                                },
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              height: 1,
                            ),
                            const SizedBox(height: 15),
                            MaterialButton(
                              onPressed: () {
                                if (numberController.text.toString().isEmpty) {
                                  Utility.toastMessage(
                                      "Please enter mobile number");
                                } else {
                                  codeSend();
                                }
                              },
                              height: 45,
                              minWidth: MediaQuery.of(context).size.width / 1.4,
                              shape: const StadiumBorder(),
                              color: primary,
                              child: const Text(
                                "Send OTP",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 5),
                            isLoading == true
                                ? const CircularProgressIndicator()
                                : Container(),
                          ],
                        ),
                      ),
                    ))
                : Expanded(
                    flex: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/login_bg_white.png"),
                              fit: BoxFit.fill)),
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: MyText(
                                maltilanguage: true,
                                title: "sendmobilenumber",
                                size: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Pinput(
                                length: 6,
                                keyboardType: TextInputType.number,
                                controller: pinPutController,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                defaultPinTheme: PinTheme(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: otpBg,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    textStyle: GoogleFonts.inter(
                                      color: white,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w800,
                                    )),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Center(
                              child: MyText(
                                maltilanguage: true,
                                title: "resend",
                                size: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            MaterialButton(
                              onPressed: () {
                                if (pinPutController.text.isEmpty) {
                                  Utility.toastMessage("Otp is blanked");
                                } else {
                                  isLoading = true;
                                  setState(() {});
                                  String otp = pinPutController.text;
                                  _login(mobileNumber.toString());
                                }
                              },
                              height: 45,
                              minWidth: MediaQuery.of(context).size.width / 1.4,
                              shape: const StadiumBorder(),
                              color: primary,
                              child: MyText(
                                maltilanguage: true,
                                title: "submit",
                                size: 16,
                                fontWeight: FontWeight.bold,
                                colors: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            isLoading == true
                                ? const CircularProgressIndicator()
                                : Container(),
                          ],
                        ),
                      ),
                    )),
            Expanded(flex: 2, child: Container())
          ],
        ),
      ),
    );
  }

  codeSend() async {
    isLoading = true;
    setState(() {});
    await phoneSignIn(phoneNumber: mobileNumber.toString());
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    log(" Verification Started");
    log(" Verification of ====>>> $phoneNumber");
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
    log(" Verification of  completed====>>> $phoneNumber");
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    log("verification completed ${authCredential.smsCode}");
    log("verification completed ======> ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      pinPutController.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try {
        UserCredential? credential =
            await user?.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await _auth.signInWithCredential(authCredential);
        }
      }
      isLoading = false;
      setState(() {});
      log("Firebase Verification Complated");
      _login(mobileNumber.toString());
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      log("The phone number entered is invalid!");
      Utility.toastMessage("The phone number entered is invalid!");
      isLoading = false;
      setState(() {});
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    log(forceResendingToken.toString());
    log("code sent");

    isLoading = false;
    setState(() {
      otpUI = false;
    });
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  _login(String mobile) async {
    log("click on Submit");
    var loginprovider = Provider.of<ApiProvider>(context, listen: false);
    await loginprovider.loginwithotp(3, mobile, strDeviceToken, platformType);
    if (loginprovider.loading) {
      isLoading = false;
      setState(() {});
      for (var i = 0; i < (loginprovider.loginModel.result?.length ?? 0); i++) {
        await sharePref.save('is_login', "1");
        await sharePref.save(
            "userId", loginprovider.loginModel.result?[i].id.toString() ?? 0);
        await sharePref.save('reference',
            loginprovider.loginModel.result?[0].referenceCode.toString() ?? "");
        await sharePref.save(
            "fullname", loginprovider.loginModel.result?[i].fullname ?? "");
        await sharePref.save(
            "image", loginprovider.loginModel.result?[i].profileImg ?? "");
        await sharePref.save(
            "email", loginprovider.loginModel.result?[i].email ?? "");
        await sharePref.save(
            "password", loginprovider.loginModel.result?[i].password ?? "");
        await sharePref.save(
            "mobile", loginprovider.loginModel.result?[i].mobileNumber ?? "");
        await sharePref.save(
            "type", loginprovider.loginModel.result?[i].type.toString() ?? "");
        await sharePref.save(
            "status", loginprovider.loginModel.result?[i].status ?? "");
      }
      Constant.userID = loginprovider.loginModel.result?[0].id.toString() ?? "";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }
}
