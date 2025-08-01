import 'dart:io';

import 'package:animal_market/core/constants.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/app_update_provider/app_update_provider.dart';
import 'package:animal_market/modules/appointment/providers/appointment_provider.dart';
import 'package:animal_market/modules/auth/providers/auth_provider.dart';
import 'package:animal_market/modules/auth/views/splash_view.dart';
import 'package:animal_market/modules/buy/providers/buy_provider.dart';
import 'package:animal_market/modules/buy_crop/providers/buy_crop_provider.dart';
import 'package:animal_market/modules/buy_pet/providers/buy_pet_provider.dart';
import 'package:animal_market/modules/category/providers/category_provider.dart';
import 'package:animal_market/modules/cattle_heath/providers/cattle_health_provider.dart';
import 'package:animal_market/modules/community/providers/community_provider.dart';
import 'package:animal_market/modules/dashboard/providers/dashboard_provider.dart';
import 'package:animal_market/modules/doctor/providers/doctor_profile_dashboard_provider.dart';
import 'package:animal_market/modules/doctor/providers/doctor_provider.dart';
import 'package:animal_market/modules/doctor/providers/time_slot_provider.dart';
import 'package:animal_market/modules/doctor_list/providers/doctor_list_provider.dart';
import 'package:animal_market/modules/event/providers/event_provider.dart';
import 'package:animal_market/modules/faq/providers/faq_provider.dart';
import 'package:animal_market/modules/full_view_image/providers/full_image_view_controller.dart';
import 'package:animal_market/modules/know_education/providers/know_education_provider.dart';
import 'package:animal_market/modules/market/providers/market_provider.dart';
import 'package:animal_market/modules/market_pet/providers/market_pet_provider.dart';
import 'package:animal_market/modules/my_favorite/providers/my_favorite_provider.dart';
import 'package:animal_market/modules/notifications/providers/notifications_providers.dart';
import 'package:animal_market/modules/other_seller_profile/providers/other_seller_profile_provider.dart';
import 'package:animal_market/modules/sell/providers/sell_products_provider.dart';
import 'package:animal_market/modules/sell_crop/providers/sell_crop_products_provider.dart';
import 'package:animal_market/modules/sell_pet/providers/pet_sell_products_provider.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:animal_market/routes/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:overlay_support/overlay_support.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuyProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuyCropProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppointmentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationsProviders(),
        ),
        ChangeNotifierProvider(
          create: (_) => CommunityProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DoctorListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MarketProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SellProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SellCropProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DoctorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EventProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CattleHealthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppUpdateProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DoctorProfileDashboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TimeSlotProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => KnowEducationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuyPetProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MarketPetProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PetSellProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FullImageViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FaqProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyFavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TranslationsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OtherSellerProvider(),
        ),
      ],
      child: OverlaySupport.global(
        child: OKToast(
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: false,
            useInheritedMediaQuery: true,
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              bottom: false,
              child: AnnotatedRegion(
                value: const SystemUiOverlayStyle(
                  statusBarColor: ColorConstant.darkAppCl,
                  statusBarIconBrightness: Brightness.light,
                ),
                child: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                  child: MaterialApp(
                    title: appName,
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      bottomSheetTheme: const BottomSheetThemeData(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: ColorConstant.darkAppCl,
                      ),
                      useMaterial3: true,
                    ),
                    navigatorKey: Constants.navigatorKey,
                    onGenerateRoute: RouteGenerator.generateRoute,
                    home: const SplashView(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
