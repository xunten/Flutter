import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/Home.dart';
import 'package:quizapp/Pages/forgotpass.dart';
import 'package:quizapp/Pages/login/otp.dart';
import 'package:quizapp/Pages/login/signup.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';
import '../../Model/SuccessModel.dart';
import '../../Theme/config.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  List<SuccessModel>? loginList;

  SharePref sharePref = SharePref();

  final loginuser = GetStorage();

  bool _isObscure = true;
  bool isloading = false;
  bool isChecked = true;
  String? strDeviceToken, platformType;
  File? mProfileImg;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userEmail = "";

  @override
  void initState() {
    AdHelper.getAds();
    _getDeviceToken();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  _getDeviceToken() async {
    if (Platform.isAndroid) {
      strDeviceToken = await FirebaseMessaging.instance.getToken();
      platformType = "1";
    } else {
      final status = await OneSignal.shared.getDeviceState();
      strDeviceToken = status?.userId;
      platformType = "2";
    }
    log("===>strDeviceToken $strDeviceToken");
  }

  normalLogin(String email, String password, String type) async {
    var provider = Provider.of<ApiProvider>(context, listen: false);

    await provider.login(
        email, "", null, password, type, strDeviceToken, platformType);

    if (!provider.loading) {
      isloading = false;
      setState(() {});

      log("===>reference ${provider.loginModel.result?[0].referenceCode.toString()}");

      if (provider.loginModel.status == 200) {
        await sharePref.save('is_login', "1");
        await sharePref.save(
            'userId', provider.loginModel.result?[0].id.toString() ?? "");
        await sharePref.save('reference',
            provider.loginModel.result?[0].referenceCode.toString() ?? "");

        // Set UserID for Next
        Constant.userID = provider.loginModel.result?[0].id.toString();
        debugPrint('Constant userID ==>> ${Constant.userID}');

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const Home()),
          (Route<dynamic> route) => false,
        );
      } else {
        log("${provider.loginModel.message}");
        Utility.toastMessage("${provider.loginModel.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
              Expanded(
                flex: 7,
                child: ClipRRect(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/login_bg_white.png"),
                            fit: BoxFit.cover)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey)),
                              ),
                              Divider(
                                thickness: 0.5,
                                height: size.height * 0.01,
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: (() {
                                    debugPrint('Test');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPass()));
                                  }),
                                  child: MyText(
                                    title: "forgotpassword",
                                    maltilanguage: true,
                                    size: 14,
                                    colors: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        MaterialButton(
                          onPressed: () {
                            String email = emailController.text.trim();
                            String pass = passController.text.trim();
                            if (email.isEmpty) {
                              Utility.toastMessage(
                                  "Please enter email address");
                            } else if (pass.isEmpty) {
                              Utility.toastMessage("Please enter passoword");
                            } else {
                              isloading = true;
                              setState(() {});
                              normalLogin(email, pass, "1");
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
                                  title: "login",
                                  fontWeight: FontWeight.bold,
                                  size: 14,
                                  colors: Colors.white,
                                ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              color: Colors.grey,
                              height: 1,
                              width: 70,
                            ),
                            MyText(
                              maltilanguage: true,
                              title: "loginwith",
                              size: 14,
                              colors: Colors.grey,
                            ),
                            Container(
                              color: Colors.grey,
                              height: 1,
                              width: 70,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                iconSize: 70,
                                onPressed: () {
                                  _gmailLogin();
                                },
                                icon: MyImage(
                                  imagePath: "assets/images/icon_gm.png",
                                  height: 50,
                                  width: 50,
                                )),
                            Platform.isIOS
                                ? InkWell(
                                    onTap: () {
                                      signInWithApple();
                                    },
                                    child: Container(
                                        width: 55,
                                        height: 55,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: white, width: 1),
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.apple,
                                          size: 30,
                                          color: black,
                                        )),
                                  )
                                : const SizedBox.shrink(),
                            IconButton(
                                iconSize: 70,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const OTP()));
                                },
                                icon: MyImage(
                                    height: 50,
                                    width: 50,
                                    imagePath:
                                        "assets/images/icon_mobile.png")),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 5),
                          child: GestureDetector(
                              onTap: (() {
                                debugPrint('Test');
                              }),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    MyText(
                                      title: "dontaccount",
                                      maltilanguage: true,
                                      size: 10,
                                      colors: Config().appaccentColor,
                                    ),
                                    const SizedBox(width: 5),
                                    MyText(
                                      title: "signup",
                                      size: 10,
                                      maltilanguage: true,
                                      fontWeight: FontWeight.bold,
                                      colors: Config().appColor,
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  /* Google Login */
  Future<void> _gmailLogin() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    GoogleSignInAccount user = googleUser;

    debugPrint('GoogleSignIn ===> id : ${user.id}');
    debugPrint('GoogleSignIn ===> email : ${user.email}');
    debugPrint('GoogleSignIn ===> displayName : ${user.displayName}');
    debugPrint('GoogleSignIn ===> photoUrl : ${user.photoUrl}');

    if (!mounted) return;
    isloading = true;
    setState(() {});

    UserCredential userCredential;
    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await user.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      userCredential = await _auth.signInWithCredential(credential);
      assert(await userCredential.user?.getIdToken() != null);
      debugPrint("User Name: ${userCredential.user?.displayName}");
      debugPrint("User Email ${userCredential.user?.email}");
      debugPrint("User photoUrl ${userCredential.user?.photoURL}");
      debugPrint("uid ===> ${userCredential.user?.uid}");
      String firebasedid = userCredential.user?.uid ?? "";
      debugPrint('firebasedid :===> $firebasedid');

      /* Save PhotoUrl in File */
      mProfileImg =
          await Utility.saveImageInStorage(userCredential.user?.photoURL ?? "");
      debugPrint('mProfileImg :===> $mProfileImg');

      checkAndNavigate(user.email, user.displayName ?? "", "2");
    } on FirebaseAuthException catch (e) {
      debugPrint('===>Exp${e.code.toString()}');
      debugPrint('===>Exp${e.message.toString()}');
      if (e.code.toString() == "user-not-found") {
      } else if (e.code == 'wrong-password') {
        // Hide Progress Dialog
        isloading = false;
        setState(() {});
        debugPrint('Wrong password provided.');
      } else {
        // Hide Progress Dialog
        isloading = false;
        setState(() {});
      }
    }
  }

  /* Apple Login */
  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      debugPrint(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult = await _auth.signInWithCredential(oauthCredential);

      String? displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      userEmail = authResult.user?.email.toString() ?? "";
      debugPrint("===>userEmail $userEmail");
      debugPrint("===>displayName $displayName");

      final firebaseUser = authResult.user;

      dynamic firebasedId;
      if (userEmail.isNotEmpty || userEmail != 'null') {
        await firebaseUser?.updateDisplayName(displayName);
        await firebaseUser
            ?.updateEmail(authResult.user?.email.toString() ?? "");
      } else {
        userEmail = firebaseUser?.email.toString() ?? "";
        firebasedId = firebaseUser?.uid.toString();
        displayName = firebaseUser?.displayName.toString();
        debugPrint("===>userEmail-else $userEmail");
        debugPrint("===>displayName-else $displayName");
      }

      debugPrint("userEmail =====FINAL==> $userEmail");
      debugPrint("firebasedId ===FINAL==> $firebasedId");
      debugPrint("displayName ===FINAL==> $displayName");

      checkAndNavigate(userEmail, displayName ?? "", "5");
    } catch (exception) {
      debugPrint("Apple Login exception =====> $exception");
    }
    return null;
  }

  checkAndNavigate(String mail, String displayName, String type) async {
    final generalProvider = Provider.of<ApiProvider>(context, listen: false);
    debugPrint('checkAndNavigate email ==>> $mail');
    debugPrint('checkAndNavigate userName ==>> $displayName');
    debugPrint('checkAndNavigate strType ==>> $type');
    debugPrint('checkAndNavigate mProfileImg :===> $mProfileImg');

    if (!isloading) {
      isloading = true;
      setState(() {});
    }
    await generalProvider.login(mail, displayName, mProfileImg, "", type,
        strDeviceToken, platformType ?? "");
    debugPrint('checkAndNavigate loading ==>> ${generalProvider.loading}');

    if (!generalProvider.loading) {
      if (!mounted) return;
      isloading = false;
      setState(() {});
      if (generalProvider.loginModel.status == 200) {
        debugPrint('Login Successfull!');

        log("===>reference ${generalProvider.loginModel.result?[0].referenceCode.toString()}");

        await sharePref.save('is_login', "1");
        await sharePref.save('userId',
            generalProvider.loginModel.result?[0].id.toString() ?? "");
        await sharePref.save(
            'reference',
            generalProvider.loginModel.result?[0].referenceCode.toString() ??
                "");

        // Set UserID for Next
        Constant.userID = generalProvider.loginModel.result?[0].id.toString();
        debugPrint('Constant userID ==>> ${Constant.userID}');

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const Home()),
          (Route<dynamic> route) => false,
        );
      } else {
        if (!mounted) return;
        Utility.showSnackbar(
            context, "fail", "${generalProvider.loginModel.message}", false);
      }
    }
  }
}
