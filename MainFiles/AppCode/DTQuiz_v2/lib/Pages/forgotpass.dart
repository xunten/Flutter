import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/widget/mytext.dart';
import '../Model/SuccessModel.dart';
import '../Theme/config.dart';
import '../provider/apiprovider.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  List<SuccessModel>? loginList;

  final loginuser = GetStorage();


  bool isChecked = true;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.06,
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(30),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyText(
                   title:  "Forgot Password",
                   maltilanguage: false,colors: white,
                                            size: 26,
                                            fontWeight: FontWeight.bold,
                  ),
                  MyText(
                   title:  "Enter your Email address to reset your password to join the application",
                    maltilanguage: false,colors: white,
                                            size: 14,
                                            fontWeight: FontWeight.w500,
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.0),
                child: Container(
                  color: Colors.white,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              labelText: "Email Address",
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              hintText: "Email ID",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                        Divider(
                          thickness: 0.5,
                          height: size.height * 0.01,
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (emailController.text.toString().isEmpty) {
                              Utility.toastMessage(
                                  "Please enter register email");
                            } else {
                              forgotPass(emailController.text.toString());
                            }
                          },
                          height: 45,
                          minWidth: MediaQuery.of(context).size.width / 1.4,
                          shape: const StadiumBorder(),
                          color: Config().appColor,
                          child:  MyText(
                            title: "Send",
                            colors: white,
                           maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  forgotPass(String email) async {
    var provider = Provider.of<ApiProvider>(context, listen: false);
    await provider.forgotPassword(email);

    if (provider.loading) {
      const CircularProgressIndicator();
    } else {
      log("==>${provider.successModel.status}");
      if (provider.loginModel.status == 200) {
        Utility.toastMessage("${provider.successModel.message}");
        Navigator.of(context).pop();
      } else {
        log("${provider.loginModel.message}");
        Utility.toastMessage("${provider.successModel.message}");
      }
    }
  }
}
