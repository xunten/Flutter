
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/splash.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/firebase_options.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/provider/commanprovider.dart';
import 'package:quizapp/provider/paymentprovider.dart';
import 'Theme/theme_model.dart';

bool? isviewed;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'ar', 'hi']);
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(Constant().oneSignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    debugPrint("Accepted permission: $accepted");
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiProvider()),
        ChangeNotifierProvider(create: (_) => CommanProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        title: 'home',
        home: const Splash(),
        theme: ThemeModel().lightMode, // Provide light theme.
        darkTheme: ThemeModel().darkMode,
      ),
    );
  }
}
