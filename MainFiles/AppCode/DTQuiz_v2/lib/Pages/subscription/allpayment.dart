// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/provider/paymentprovider.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';
import 'package:razorpay_web/razorpay_web.dart';

class AllPayment extends StatefulWidget {
  final String? payType,
      itemId,
      price,
      itemTitle,
      typeId,
      productPackage,
      point,
      currency;
  const AllPayment({
    Key? key,
    required this.payType,
    required this.itemId,
    required this.price,
    required this.itemTitle,
    required this.typeId,
    required this.productPackage,
    required this.currency,
    required this.point,
  }) : super(key: key);

  @override
  State<AllPayment> createState() => AllPaymentState();
}

class AllPaymentState extends State<AllPayment> {
  final couponController = TextEditingController();
  late ProgressDialog prDialog;
  late PaymentProvider paymentProvider;

  SharePref sharePref = SharePref();
  String? userId, userName, userEmail, userMobileNo, paymentId;
  String? strCouponCode = "";
  bool isPaymentDone = false;

  /* Paytm */
  String paytmResult = "";

  /* Stripe */
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    prDialog = ProgressDialog(context);
    _getData();
    super.initState();
  }

  _getData() async {
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    await paymentProvider.getPaymentOption();
    await paymentProvider.setFinalAmount(widget.price ?? "");

    /* PaymentID */
    paymentId = Utility.generateRandomOrderID();
    debugPrint('paymentId =====================> $paymentId');

    userId = await sharePref.read("userId");
    userName = await sharePref.read("fullname");
    userEmail = await sharePref.read("email");
    userMobileNo = await sharePref.read("mobile");
    debugPrint('getUserData userId ==> $userId');
    debugPrint('getUserData userName ==> $userName');
    debugPrint('getUserData userEmail ==> $userEmail');
    debugPrint('getUserData userMobileNo ==> $userMobileNo');

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    paymentProvider.clearProvider();
    couponController.dispose();
    super.dispose();
  }

  /* add_transaction API */
  Future addTransaction(userID, packageId, amount, point, transactionid) async {
    final profileProvider = Provider.of<ApiProvider>(context, listen: false);
    Utility.showProgress(context, prDialog);
    await paymentProvider.addTransaction(Constant.userID, widget.itemId,
        paymentProvider.finalAmount, widget.point, paymentId);

    if (!paymentProvider.payLoading) {
      await prDialog.hide();

      if (paymentProvider.successModel.status == 200) {
        isPaymentDone = true;
        if (!mounted) return;
        await profileProvider.getProfile(context, Constant.userID ?? "");
        if (!mounted) return;

        Navigator.pop(context, isPaymentDone);
      } else {
        isPaymentDone = false;
        if (!mounted) return;
        Utility.showSnackbar(
            context, "info", paymentProvider.successModel.message ?? "", false);
      }
    }
  }

  openPayment({required String pgName}) async {
    debugPrint("finalAmount =============> ${paymentProvider.finalAmount}");
    if (paymentProvider.finalAmount != "0") {
      if (pgName == "paypal") {
        _paypalInit();
      } else if (pgName == "razorpay") {
        _initializeRazorpay();
      } else if (pgName == "flutterwave") {
      } else if (pgName == "payumoney") {
      } else if (pgName == "paytm") {
        _paytmInit();
      } else if (pgName == "stripe") {
        _stripeInit();
      } else if (pgName == "cash") {
        if (!mounted) return;
        Utility.showSnackbar(context, "info", "cash_payment_msg", true);
      }
    } else {
      addTransaction(
        Constant.userID,
        widget.itemId,
        paymentProvider.finalAmount,
        widget.point,
        paymentId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: _buildPage(),
    );
  }

  Widget _buildPage() {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: (kIsWeb || Constant.isTV)
          ? null
          : Utility.myAppBarWithBack(context, "paymentdetails", true),
      body: SafeArea(
        child: Center(
          child: _buildMobilePage(),
        ),
      ),
    );
  }

  Widget _buildMobilePage() {
    return Container(
      width:
          ((kIsWeb || Constant.isTV) && MediaQuery.of(context).size.width > 720)
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width,
      margin: (kIsWeb || Constant.isTV)
          ? const EdgeInsets.fromLTRB(50, 0, 50, 50)
          : const EdgeInsets.all(0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: (kIsWeb || Constant.isTV) ? 40 : 0),
          /* Coupon Code Box & Total Amount */
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              color: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(minHeight: 50),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      constraints: const BoxConstraints(minHeight: 50),
                      decoration: Utility.setBackground(appBgColor, 0),
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      alignment: Alignment.centerLeft,
                      child: Consumer<PaymentProvider>(
                        builder: (context, paymentProvider, child) {
                          return RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: "Payable Amount is ",
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  color: black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      "${Constant.currencySymbol}${paymentProvider.finalAmount ?? ""}",
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /* PGs */
          Expanded(
            child: SingleChildScrollView(
                child: paymentProvider.loading
                    ? Container(
                        height: 230,
                        padding: const EdgeInsets.all(20),
                        child: Utility.pageLoader(),
                      )
                    : paymentProvider.paymentOptionModel.status == 200
                        ? paymentProvider.paymentOptionModel.result != null
                            ? ((kIsWeb)
                                ? _buildWebPayments()
                                : _buildPayments())
                            : MyImage(
                                imagePath: "assets/images/nodata.png",
                                height: 250,
                                width: 250,
                              )
                        : MyImage(
                            imagePath: "assets/images/nodata.png",
                            height: 250,
                            width: 250,
                          )),
          ),
        ],
      ),
    );
  }

  /* NOT USED */
  Widget buildWebTVPage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /* Coupon Code Box & Total Amount */
        Container(
          margin: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.height * 0.7,
          constraints: const BoxConstraints(minHeight: 0),
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            color: black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(minHeight: 50),
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  // _buildCouponBox(),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    constraints: const BoxConstraints(minHeight: 50),
                    decoration: Utility.setBackground(appBgColor, 0),
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    alignment: Alignment.centerLeft,
                    child: Consumer<PaymentProvider>(
                      builder: (context, paymentProvider, child) {
                        return RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "payableAmountIs",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.5,
                              ),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    "${Constant.currencySymbol}${paymentProvider.finalAmount ?? ""}",
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    color: black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /* PGs */
        Expanded(
          child: SingleChildScrollView(
            child: paymentProvider.loading
                ? Container(
                    height: 230,
                    padding: const EdgeInsets.all(20),
                    child: Utility.pageLoader(),
                  )
                : paymentProvider.paymentOptionModel.status == 200
                    ? paymentProvider.paymentOptionModel.result != null
                        ? ((kIsWeb) ? _buildWebPayments() : _buildPayments())
                        : MyImage(
                            imagePath: 'assets/images/nodata.png',
                            height: 400,
                            width: 400,
                          )
                    : MyImage(
                        imagePath: 'assets/images/nodata.png',
                        height: 400,
                        width: 400,
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayments() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyText(
            colors: black,
            title: "payment_methods",
            size: 15,
            maxline: 1,
            maltilanguage: true,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w600,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(height: 5),
          MyText(
            colors: black,
            title: "choose_a_payment_methods_to_pay",
            maltilanguage: true,
            size: 13,
            maxline: 2,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(height: 15),
          MyText(
            colors: appDarkColor,
            title: "pay_with",
            maltilanguage: true,
            size: 16,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w700,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(height: 20),

          /* /* Payments */ */
          // /* In-App purchase */
          paymentProvider.paymentOptionModel.result?.inAppPurchage != null
              ? paymentProvider.paymentOptionModel.result?.inAppPurchage
                          ?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("inapp");
                          openPayment(pgName: "inapppurchage");
                        },
                        child: _buildPGButton("assets/images/pg_inapp.png",
                            "InApp Purchase", 35, 110),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* Paypal */
          paymentProvider.paymentOptionModel.result?.paypal != null
              ? paymentProvider.paymentOptionModel.result?.paypal?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("paypal");
                          openPayment(pgName: "paypal");
                        },
                        child: _buildPGButton(
                            "assets/images/pg_paypal.png", "Paypal", 35, 130),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* Razorpay */
          paymentProvider.paymentOptionModel.result?.razorpay != null
              ? paymentProvider
                          .paymentOptionModel.result?.razorpay?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("razorpay");
                          openPayment(pgName: "razorpay");
                        },
                        child: _buildPGButton("assets/images/pg_razorpay.png",
                            "Razorpay", 35, 130),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* Paytm */
          paymentProvider.paymentOptionModel.result?.payTm != null
              ? paymentProvider.paymentOptionModel.result?.payTm?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("paytm");
                          openPayment(pgName: "paytm");
                        },
                        child: _buildPGButton(
                            "assets/images/pg_paytm.png", "Paytm", 30, 90),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* Flutterwave */
          paymentProvider.paymentOptionModel.result?.flutterWave != null
              ? paymentProvider
                          .paymentOptionModel.result?.flutterWave?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider
                              .setCurrentPayment("flutterwave");
                          openPayment(pgName: "flutterwave");
                        },
                        child: _buildPGButton(
                            "assets/images/pg_flutterwave.png",
                            "Flutterwave",
                            35,
                            130),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* Stripe */
          paymentProvider.paymentOptionModel.result?.stripe != null
              ? paymentProvider.paymentOptionModel.result?.stripe?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("stripe");
                          openPayment(pgName: "stripe");
                        },
                        child: _buildPGButton(
                            "assets/images/pg_stripe.png", "Stripe", 35, 100),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* PayUMoney */
          paymentProvider.paymentOptionModel.result?.payUMoney != null
              ? paymentProvider
                          .paymentOptionModel.result?.payUMoney?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("payumoney");
                          openPayment(pgName: "payumoney");
                        },
                        child: _buildPGButton("assets/images/pg_payumoney.png",
                            "PayU Money", 35, 130),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),

          /* Cash */
          paymentProvider.paymentOptionModel.result?.cash != null
              ? paymentProvider.paymentOptionModel.result?.cash?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("cash");
                          openPayment(pgName: "cash");
                        },
                        child: _buildPGButton(
                            "assets/images/pg_cash.png", "Cash", 50, 50),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildWebPayments() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyText(
            colors: white,
            title: "payment_methods",
            size: 15,
            maxline: 1,
            maltilanguage: true,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w600,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(height: 5),
          MyText(
            colors: Colors.grey,
            title: "choose_a_payment_methods_to_pay",
            maltilanguage: true,
            size: 13,
            maxline: 2,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(height: 15),
          MyText(
            colors: appBgColor,
            title: "pay_with",
            maltilanguage: true,
            size: 16,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w700,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(height: 20),

          /* Razorpay */
          paymentProvider.paymentOptionModel.result?.razorpay != null
              ? paymentProvider
                          .paymentOptionModel.result?.razorpay?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("razorpay");
                          openPayment(pgName: "razorpay");
                        },
                        child: _buildPGButton(
                            "pg_razorpay.png", "Razorpay", 35, 130),
                      ),
                    )
                  : const SizedBox.shrink()
              : MyImage(
                  imagePath: 'assets/images/nodata.png',
                  height: 400,
                  width: 400,
                ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildPGButton(
      String imageName, String pgName, double imgHeight, double imgWidth) {
    return Container(
      constraints: const BoxConstraints(minHeight: 85),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MyImage(
            imagePath: imageName,
            fit: BoxFit.fill,
            height: imgHeight,
            width: imgWidth,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: MyText(
              colors: appBgColor,
              title: pgName,
              maltilanguage: false,
              size: 14,
              maxline: 2,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              textalign: TextAlign.end,
              fontstyle: FontStyle.normal,
            ),
          ),
          const SizedBox(width: 15),
          MyImage(
            imagePath: "assets/images/ic_arrow_right.png",
            fit: BoxFit.fill,
            height: 22,
            width: 20,
          ),
        ],
      ),
    );
  }

  /* ********* Razorpay START ********* */
  void _initializeRazorpay() {
    if (paymentProvider.paymentOptionModel.result?.razorpay != null) {
      Razorpay razorpay = Razorpay();
      var options = {
        'key': paymentProvider.paymentOptionModel.result?.razorpay?.key1 ?? "",
        ""
            'currency': Constant.currency,
        'amount': (double.parse(paymentProvider.finalAmount ?? "") * 100),
        'name': widget.itemTitle ?? "",
        'description': widget.itemTitle ?? "",
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {'contact': userMobileNo, 'email': userEmail},
        'external': {
          'wallets': ['paytm']
        }
      };
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);

      try {
        razorpay.open(options);
      } catch (e) {
        debugPrint('Razorpay Error :=========> $e');
      }
    } else {
      Utility.showSnackbar(context, "", "payment_not_processed", true);
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) async {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    Utility.showSnackbar(context, "fail", "payment_fail", true);
    await paymentProvider.setCurrentPayment("");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    debugPrint("paymentId ========> $paymentId");
    Utility.showSnackbar(context, "success", "payment_success", true);
    addTransaction(Constant.userID, widget.itemId, paymentProvider.finalAmount,
        widget.point, paymentId);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    debugPrint("============ External Wallet Selected ============");
  }
  /* ********* Razorpay END ********* */

  /* ********* Paytm START ********* */
  Future<void> _paytmInit() async {
    if (paymentProvider.paymentOptionModel.result?.payTm != null) {
      bool payTmIsStaging;
      String payTmMerchantID,
          payTmOrderId,
          payTmCustmoreID,
          payTmChannelID,
          payTmTxnAmount,
          payTmWebsite,
          payTmCallbackURL,
          payTmIndustryTypeID;

      payTmOrderId = paymentId ?? "";
      payTmCustmoreID = "${Constant.userID}_$paymentId";
      payTmChannelID = "WAP";
      payTmTxnAmount = "${(paymentProvider.finalAmount ?? "")}.00";
      payTmIndustryTypeID = "Retail";

      if (paymentProvider.paymentOptionModel.result?.payTm?.isLive == "1") {
        payTmMerchantID =
            paymentProvider.paymentOptionModel.result?.payTm?.key1 ?? "";
        payTmIsStaging = false;
        payTmWebsite = "DEFAULT";
        payTmCallbackURL =
            "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$payTmOrderId";
      } else {
        payTmMerchantID =
            paymentProvider.paymentOptionModel.result?.payTm?.key1 ?? "";
        payTmIsStaging = true;
        payTmWebsite = "WEBSTAGING";
        payTmCallbackURL =
            "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$payTmOrderId";
      }
      var sendMap = <String, dynamic>{
        "mid": payTmMerchantID,
        "orderId": payTmOrderId,
        "amount": payTmTxnAmount,
        "txnToken": paymentProvider.payTmModel.result?.paytmChecksum ?? "",
        "callbackUrl": payTmCallbackURL,
        "isStaging": payTmIsStaging,
        "restrictAppInvoke": true,
        "enableAssist": true,
      };
      debugPrint("sendMap ===> $sendMap");

      /* Generate CheckSum from Backend */
      await paymentProvider.getPaytmToken(
        payTmMerchantID,
        payTmOrderId,
        payTmCustmoreID,
        payTmChannelID,
        payTmTxnAmount,
        payTmWebsite,
        payTmCallbackURL,
        payTmIndustryTypeID,
      );

      if (!paymentProvider.loading) {
        if (paymentProvider.payTmModel.result != null) {
          if (paymentProvider.payTmModel.result?.paytmChecksum != null) {
            try {
              var response = AllInOneSdk.startTransaction(
                payTmMerchantID,
                payTmOrderId,
                payTmTxnAmount,
                paymentProvider.payTmModel.result?.paytmChecksum ?? "",
                payTmCallbackURL,
                payTmIsStaging,
                true,
                true,
              );
              response.then((value) {
                debugPrint("value ====> $value");
                setState(() {
                  paytmResult = value.toString();
                });
              }).catchError((onError) {
                if (onError is PlatformException) {
                  setState(() {
                    paytmResult = "${onError.message} \n  ${onError.details}";
                  });
                } else {
                  setState(() {
                    paytmResult = onError.toString();
                  });
                }
              });
            } catch (err) {
              paytmResult = err.toString();
            }
          } else {
            if (!mounted) return;
            Utility.showSnackbar(context, "", "payment_not_processed", true);
          }
        } else {
          if (!mounted) return;
          Utility.showSnackbar(context, "", "payment_not_processed", true);
        }
      }
    } else {
      Utility.showSnackbar(context, "", "payment_not_processed", true);
    }
  }
  /* ********* Paytm END ********* */

  /* ********* Paypal START ********* */
  Future<void> _paypalInit() async {
    if (paymentProvider.paymentOptionModel.result?.paypal != null) {
      log("sandboxmode === >>> ${paymentProvider.paymentOptionModel.result?.paypal?.isLive.toString()}");
      log("client ID === >>> ${paymentProvider.paymentOptionModel.result?.paypal?.key1.toString()}");
      log("secretkey id === >>> ${paymentProvider.paymentOptionModel.result?.paypal?.key2.toString()}");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UsePaypal(
              sandboxMode:
                  (paymentProvider.paymentOptionModel.result?.paypal?.isLive ??
                              "") ==
                          "1"
                      ? false
                      : true,
              clientId:
                  paymentProvider.paymentOptionModel.result?.paypal?.key1 ?? "",
              secretKey:
                  paymentProvider.paymentOptionModel.result?.paypal?.key2 ?? "",
              returnURL: "return.example.com",
              cancelURL: "cancel.example.com",
              transactions: [
                {
                  "amount": {
                    "total": '${paymentProvider.finalAmount}',
                    "currency": "USD" /* Constant.currency */,
                    "details": {
                      "subtotal": '${paymentProvider.finalAmount}',
                      "shipping": '0',
                      "shipping_discount": 0
                    }
                  },
                  "description": "The payment transaction description.",
                  "item_list": {
                    "items": [
                      {
                        "name": "${widget.itemTitle}",
                        "quantity": 1,
                        "price": '${paymentProvider.finalAmount}',
                        "currency": "USD" /* Constant.currency */
                      }
                    ],
                  }
                }
              ],
              note: "Contact us for any questions on your order.",
              onSuccess: (params) async {
                debugPrint("onSuccess: ${params["paymentId"]}");
                addTransaction(
                    Constant.userID,
                    widget.itemId,
                    paymentProvider.finalAmount,
                    params["paymentId"],
                    widget.currency);
              },
              onError: (params) {
                debugPrint("onError: ${params["message"]}");
                Utility.showSnackbar(
                    context, "fail", params["message"].toString(), false);
              },
              onCancel: (params) {
                debugPrint('cancelled: $params');
                Utility.showSnackbar(context, "fail", params.toString(), false);
              }),
        ),
      );
    } else {
      Utility.showSnackbar(context, "", "payment_not_processed", true);
    }
  }
  /* ********* Paypal END ********* */

  /* ********* Stripe START ********* */
  Future<void> _stripeInit() async {
    if (paymentProvider.paymentOptionModel.result?.stripe != null) {
      stripe.Stripe.publishableKey =
          paymentProvider.paymentOptionModel.result?.stripe?.isLive == "1"
              ? paymentProvider.paymentOptionModel.result?.stripe?.key1 ?? ""
              : paymentProvider.paymentOptionModel.result?.stripe?.key2 ?? "";
      try {
        //STEP 1: Create Payment Intent
        paymentIntent = await createPaymentIntent(
            paymentProvider.finalAmount ?? "", Constant.currency);

        //STEP 2: Initialize Payment Sheet
        await stripe.Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: stripe.SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent?['client_secret'],
              style: ThemeMode.light,
              merchantDisplayName: Constant.appName,
            ))
            .then((value) {});

        //STEP 3: Display Payment sheet
        displayPaymentSheet();
      } catch (err) {
        throw Exception(err);
      }
    } else {
      Utility.showSnackbar(context, "", "payment_not_processed", true);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'description': widget.itemTitle,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer ${paymentProvider.paymentOptionModel.result?.stripe?.isLive == "1" ? paymentProvider.paymentOptionModel.result?.stripe?.key2 ?? "" : paymentProvider.paymentOptionModel.result?.stripe?.key2 ?? ""}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  displayPaymentSheet() async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet().then((value) {
        Utility.showSnackbar(context, "success", "payment_success", true);
        addTransaction(
          Constant.userID,
          widget.itemId,
          paymentProvider.finalAmount,
          widget.point,
          paymentId,
        );

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on stripe.StripeException catch (e) {
      debugPrint('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('$e');
    }
  }
  /* ********* Stripe END ********* */

  Future<bool> onBackPressed() async {
    if (!mounted) return Future.value(false);
    Navigator.pop(context, isPaymentDone);
    return Future.value(isPaymentDone == true ? true : false);
  }
}
