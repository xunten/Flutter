// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as number;

import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:path/path.dart' as path;
import 'package:quizapp/widget/mytext.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../Theme/config.dart';

class Utility {
  static getsvgimage(String assetName) {
    return SvgPicture.asset(
      'assets/images/$assetName',
      allowDrawingOutsideViewBox: true,
    );
  }

  static getpngimage(String folder, String assetName) {
    return ExactAssetImage('assets/$folder/$assetName');
  }

  static setpngimage(String assetName) {
    return Image.asset('assets/images/$assetName');
  }

  static dateConversation(String cDate) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(cDate.toString()); // <-- dd/MM 24H format

    var outputFormat = DateFormat('dd-MMM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    debugPrint(outputDate);
    return outputDate;
  }

  static setUserId(userID) async {
    SharePref sharedPref = SharePref();
    if (userID != null) {
      await sharedPref.save("userId", userID);
    } else {
      await sharedPref.remove("userId");
      await sharedPref.remove("fullname");
      await sharedPref.remove("image");
      await sharedPref.remove("email");
      await sharedPref.remove("password");
      await sharedPref.remove("mobile");
      await sharedPref.remove("type");
      await sharedPref.remove("status");
    }
    Constant.userID = await sharedPref.read("userid");
    debugPrint('setUserId userID ==> ${Constant.userID}');
  }

  dateConvert(String date, String format) {
    final DateTime now = DateTime.parse(date);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(now);
  }

  static progressbarShow(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  static showAlertDialog(BuildContext context, String message) {
    // Create button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(Config().appName),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static snackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    ));
  }

  static toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  /* ***************** generate Unique OrderID START ***************** */
  static String generateRandomOrderID() {
    int getRandomNumber;
    String? finalOID;
    debugPrint("fixFourDigit =>>> ${Constant.fixFourDigit}");
    debugPrint("fixSixDigit =>>> ${Constant.fixSixDigit}");

    number.Random r = number.Random();
    int ran5thDigit = r.nextInt(9);
    debugPrint("Random ran5thDigit =>>> $ran5thDigit");

    int randomNumber = number.Random().nextInt(9999999);
    debugPrint("Random randomNumber =>>> $randomNumber");
    if (randomNumber < 0) {
      randomNumber = -randomNumber;
    }
    getRandomNumber = randomNumber;
    debugPrint("getRandomNumber =>>> $getRandomNumber");

    finalOID = "${Constant.fixFourDigit.toInt()}"
        "$ran5thDigit"
        "${Constant.fixSixDigit.toInt()}"
        "$getRandomNumber";
    debugPrint("finalOID =>>> $finalOID");

    return finalOID;
  }
  /* ***************** generate Unique OrderID END ***************** */

// String Image Url Convert To File Variable And Pass Login With Gmail Method
  static Future<File?> saveImageInStorage(imgUrl) async {
    try {
      var response = await http.get(Uri.parse(imgUrl));
      Directory? documentDirectory;
      if (Platform.isAndroid) {
        documentDirectory = await getExternalStorageDirectory();
      } else {
        documentDirectory = await getApplicationDocumentsDirectory();
      }
      File file = File(path.join(documentDirectory?.path ?? "",
          '${DateTime.now().millisecondsSinceEpoch.toString()}.png'));
      file.writeAsBytesSync(response.bodyBytes);
      // This is a sync operation on a real
      // app you'd probably prefer to use writeAsByte and handle its Future
      return file;
    } catch (e) {
      debugPrint("saveImageInStorage Exception ===> $e");
      return null;
    }
  }

  static void showSnackbar(BuildContext context, String showFor, String message,
      bool multilanguage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: showFor == "fail"
            ? black
            : showFor == "info"
                ? white
                : showFor == "success"
                    ? white
                    : white,
        content: MyText(
          title: message,
          size: 14,
          maltilanguage: multilanguage,
          fontstyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          colors: white,
          textalign: TextAlign.center,
        ),
      ),
    );
  }

  static void showProgress(
      BuildContext context, ProgressDialog prDialog) async {
    prDialog = ProgressDialog(context);
    //For normal dialog
    prDialog = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false, showLogs: false);

    prDialog.style(
      message: "pleaseWait",
      borderRadius: 5,
      progressWidget: Container(
        padding: const EdgeInsets.all(8),
        child: const CircularProgressIndicator(),
      ),
      maxProgress: 100,
      progressTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      backgroundColor: white,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: const TextStyle(
        color: black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );

    await prDialog.show();
  }

  static AppBar myAppBarWithBack(
      BuildContext context, String appBarTitle, bool multilanguage) {
    return AppBar(
      elevation: 5,
      backgroundColor: appBgColor,
      centerTitle: true,
      leading: IconButton(
          autofocus: true,
          focusColor: white.withOpacity(0.5),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: appDarkColor,
            size: 20,
          )),
      title: MyText(
        title: appBarTitle,
        maltilanguage: multilanguage,
        size: 22,
        fontstyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        textalign: TextAlign.center,
        colors: appDarkColor,
      ),
    );
  }

  static Widget pageLoader() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: appBgColor,
      ),
    );
  }

  static BoxDecoration setBackground(Color color, double radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static void getCurrencySymbol() async {
    SharePref sharedPref = SharePref();
    Constant.currencySymbol = await sharedPref.read("currency_code") ?? "";
    debugPrint('Constant currencySymbol ==> ${Constant.currencySymbol}');
    Constant.currency = await sharedPref.read("currency") ?? "";
    debugPrint('Constant currency ==> ${Constant.currency}');
  }

  static Future<void> buildWebAlertDialog(
      BuildContext context, String pageName, String? reqData) async {
    Widget? child;
    // if (pageName == "login") {
    //   child = const LoginSocialWeb();
    // } else if (pageName == "profile") {
    //   child = const ProfileEditWeb();
    // } else if (pageName == "otp") {
    //   child = OTPVerifyWeb(reqData ?? "");
    // }
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          insetPadding: const EdgeInsets.fromLTRB(100, 25, 100, 25),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: black,
          child: child,
        );
      },
    );
  }

  
}
