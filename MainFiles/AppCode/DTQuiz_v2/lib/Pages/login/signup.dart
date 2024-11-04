import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Model/SuccessModel.dart';
import 'package:quizapp/Pages/Home.dart';
import 'package:quizapp/Theme/config.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/mytext.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController referController = TextEditingController();

  List<SuccessModel>? loginList;

  final loginuser = GetStorage();

  SharePref sharePref = SharePref();

  bool _isObscure = true;
  bool isloading = false;
  bool isChecked = true;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _registration() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String pass = passController.text.trim();
    String phone = phonenumberController.text.trim();
    String refer = referController.text.trim();

    if (username.isEmpty) {
      Utility.toastMessage("Please enter username");
    } else if (email.isEmpty) {
      Utility.toastMessage("Please enter email");
    } else {
      var provider = Provider.of<ApiProvider>(context, listen: false);
      await provider.registration(context, email, pass, username, username,
          phone, refer, username, username);
      if (!provider.loading) {
        isloading = false;
        setState(() {});
        log("==>${provider.registrationModel.status}");
        if (provider.registrationModel.status == 200) {
          sharePref.save('is_login', "1");
          sharePref.save('userId',
              provider.registrationModel.result?[0].id.toString() ?? "");
          Constant.userID = provider.registrationModel.result?[0].id.toString();
          log("user id is =======>>>>>> ${Constant.userID}");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home()));
        } else {
          log("${provider.registrationModel.message}");
          Utility.toastMessage('${provider.registrationModel.message}');
        }
      }
    }
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.06,
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: MyText(
                      title: "signup",
                      size: 20,
                      colors: Colors.white,
                      maltilanguage: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/login_bg_white.png"),
                        fit: BoxFit.fill)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 30),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                                labelText: "User Name",
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                hintText: "User Name",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                          Divider(
                            thickness: 0.5,
                            height: size.height * 0.01,
                          ),
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
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                          Divider(
                            thickness: 0.5,
                            height: size.height * 0.01,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          TextField(
                            obscureText: _isObscure,
                            controller: passController,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    }),
                                  },
                                  icon: Icon(_isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: const TextStyle(color: Colors.grey)),
                          ),
                          Divider(
                            thickness: 0.5,
                            height: size.height * 0.01,
                          ),
                          TextField(
                            obscureText: _isObscure,
                            controller: confirmController,
                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                suffixIcon: IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    }),
                                  },
                                  icon: Icon(_isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                hintText: "Confirm Password",
                                hintStyle: const TextStyle(color: Colors.grey)),
                          ),
                          Divider(
                            thickness: 0.5,
                            height: size.height * 0.01,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: phonenumberController,
                            decoration: const InputDecoration(
                                labelText: "Phone Number",
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                hintText: "Phone Number",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                          Divider(
                            thickness: 0.5,
                            height: size.height * 0.01,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          TextField(
                            controller: referController,
                            decoration: const InputDecoration(
                                labelText: "Referral Code",
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                hintText: "Referral Code",
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
                              String pass = passController.text.trim();
                              String confirm = confirmController.text.trim();
                              if (pass == confirm) {
                                isloading = true;
                                setState(() {});
                                _registration();
                              } else {
                                Utility.toastMessage(
                                    "Please check confirm password");
                              }
                            },
                            height: 45,
                            minWidth: MediaQuery.of(context).size.width / 1.4,
                            shape: const StadiumBorder(),
                            color: Config().appColor,
                            child: isloading
                                ? const CircularProgressIndicator()
                                : MyText(
                                    maltilanguage: true,
                                    title: "signup",
                                    colors: Colors.white,
                                    size: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 5),
                            child: GestureDetector(
                              onTap: (() {
                                debugPrint('Test');
                              }),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MyText(
                                    title: "alreadyaccount",
                                    maltilanguage: true,
                                    size: 10,
                                    colors: Config().appaccentColor,
                                  ),
                                  const SizedBox(width: 5),
                                  MyText(
                                    title: "signin",
                                    size: 10,
                                    maltilanguage: true,
                                    fontWeight: FontWeight.bold,
                                    colors: Config().appColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
