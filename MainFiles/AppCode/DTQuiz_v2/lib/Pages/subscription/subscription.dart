
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/login/login.dart';
import 'package:quizapp/Pages/subscription/allpayment.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';
import '../../Model/packagesmodel.dart';
import '../../widget/myappbar.dart';
import '../../widget/mytext.dart';
import 'consumable_store.dart';

final bool _kAutoConsume = Platform.isIOS || true;

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  String? userId;
  SharePref sharePref = SharePref();
  List<Result>? packagelist;
  late int selectIndex;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final List<ProductDetails> _products = <ProductDetails>[];
  final List<String> _kProductIds = <String>[];
  final List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    log("userid is ${Constant.userID}");
    userId = Constant.userID;
    getUserId();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
    super.initState();
  }

  _checkAndPay(List<Result>? packageList, int index) async {
    log("message");
    if (Constant.userID != null) {
      if (packageList?[index].isDelete == 0) {
        log("message");
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return   AllPayment(
          payType: 'Package',
          itemId: packageList?[index].id.toString() ?? '',
          price: packageList?[index].price.toString() ?? '',
          itemTitle: packageList?[index].name.toString() ?? '',
          typeId: '',
          point: packagelist?[index].point.toString() ?? "",
          productPackage: (!kIsWeb)
              ? (Platform.isIOS
                  ? (packageList?[index].iosProductPackage.toString() ??
                      '')
                  : (packageList?[index]
                          .androidProductPackage
                          .toString() ??
                      ''))
              : '',
          currency: '',
        );
        }));
       
      }
    } else {
      if ((kIsWeb || Constant.isTV)) {
        Utility.buildWebAlertDialog(context, "login", "");
        return;
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const Login();
          },
        ),
      );
    }
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        log("===> ${productDetailResponse.error!.message}");
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;

        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        log("===> ${productDetailResponse.productDetails}");
        _queryProductError = null;
        _isAvailable = isAvailable;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      log("===> 2 ${productDetailResponse.productDetails}");
      _purchasePending = false;
      _loading = false;
    });
  }

  getUserId() async {
    log("package api calling");
    final packageProvider = Provider.of<ApiProvider>(context, listen: false);
    await packageProvider.getPackage();
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final packageProvider = Provider.of<ApiProvider>(context);
    if (packageProvider.loading) {
      log("length of data ==>>> ${packageProvider.packagesModel.result?.length}");
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appBgColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 260,
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
                    const MyAppbar(title: "subscription"),
                    Center(
                      child: SizedBox(
                        height: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: MyImage(
                            imagePath: "assets/images/ic_subscription.png",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            subscriptionshimmer(),
          ],
        ),
      );
    } else {
      if (packageProvider.packagesModel.status == 200 &&
          (packageProvider.packagesModel.result?.length ?? 0) > 0) {
        packagelist = packageProvider.packagesModel.result;
        log("===>package ${packagelist?.length}");
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: appBgColor,
          body: Stack(
            children: [Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 320,
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
                        const MyAppbar(title: "Subscription"),
                        Center(
                          child: SizedBox(
                            height: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/images/ic_subscription.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
               
                Expanded(
                  child: ListView.builder(
                    itemCount: packagelist?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          selectIndex = index;
                          _kProductIds.clear();
                          log('===> 11${packagelist?[index].androidProductPackage}');
                          _kProductIds.add(
                              packagelist?[index].androidProductPackage ?? "");
                          log("===> ${_kProductIds.length}");
                          addPurchase(packagelist, index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 8, right: 20, bottom: 8),
                          child: Container(
                            height: 130,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/ic_packagebg.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                 MyText(
                                      maltilanguage: false,
                                      title: "${Constant.currencySymbol}  ${packageProvider
                                          .packagesModel.result?[index].price
                                          .toString()}",
                                      size: 25,
                                      fontWeight: FontWeight.w600,
                                      colors: white,
                                    ),
                                     const SizedBox(height: 5),
                                Row(
                                  children: [
                                    MyText(
                                      maltilanguage: false,
                                      title: packageProvider.packagesModel
                                              .result?[index].point ??
                                          "",
                                      size: 20,
                                      fontWeight: FontWeight.w500,
                                      colors: white,
                                    ),
                                    MyText(
                                      maltilanguage: true,
                                      title: "coins",
                                      size: 20,
                                      fontWeight: FontWeight.w500,
                                      colors: white,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                               Row(
                                 children: [
                                   MyText(
                                        maltilanguage: false,
                                        title: (packageProvider
                                                .packagesModel.result?[index].name ??
                                            ""),
                                        size: 24,
                                        fontWeight: FontWeight.w500,
                                        colors: white,
                                        maxline: 2,
                                      ),
                                          const Spacer(),
                                    MyText(
                                      maltilanguage: true,
                                      title: "selectplan",
                                      size: 18,
                                      fontWeight: FontWeight.w600,
                                      colors: sharebg,
                                    ),
                                    MyText(
                                      title: " ->",
                                      maltilanguage: false,
                                      size: 18,
                                      fontWeight: FontWeight.w600,
                                      colors: sharebg,
                                    )
                                 ],
                               ),
                               
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
         Align(
          alignment: Alignment.bottomCenter,
            child: adview()),] ),
        );
      } else {
        return Center(
          child:MyImage(
            imagePath: "assets/images/nodata.png",
            height: 350,
            width: 350,
          ),
        );
      }
    }
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

  Widget subscriptionshimmer() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 160,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        );
      },
    );
  }

  purchaseItem() async {
    log("starting the payment process");
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kProductIds.toSet());
    if (response.notFoundIDs.isNotEmpty) {
      Utility.toastMessage("Please check SKU");
      return;
    }
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: response.productDetails[0]);
    InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          log("===> status ${purchaseDetails.status}");
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume &&
              purchaseDetails.productID ==
                  packagelist?[selectIndex].androidProductPackage) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          log("===> pendingCompletePurchase ${purchaseDetails.pendingCompletePurchase}");
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    log("===> productID ${purchaseDetails.productID}");
    if (purchaseDetails.productID ==
        packagelist?[selectIndex].androidProductPackage) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      log("===> consumables $consumables");
      addPurchase(packagelist, selectIndex);
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      log("===> consumables else $purchaseDetails");
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    log("===> invalid Purchase $purchaseDetails");
  }

  addPurchase(packagelist, index) async {
    final provider = Provider.of<ApiProvider>(context, listen: false);
    debugPrint('===>get responce${provider.successModel.status}');
    log('===>get id${packagelist?[selectIndex].id.toString()}');
    log('===>${packagelist?[selectIndex].price.toString()}');
    log('===>${packagelist?[selectIndex].point.toString()}');

        _checkAndPay(packagelist, index);
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
