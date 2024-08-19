import 'dart:async';
import 'dart:ui';

import 'package:moli/model/user/salon_user.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/screens/salon/salon_details_screen.dart';
import 'package:moli/screens/service/service_detail_screen.dart';
import 'package:moli/service/api_service.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/shared_pref.dart';
import 'package:moli/utils/style_res.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/route_manager.dart';

class WelComeScreen extends StatefulWidget {
  const WelComeScreen({super.key});

  @override
  State<WelComeScreen> createState() => _WelComeScreenState();
}

class _WelComeScreenState extends State<WelComeScreen> {
  bool isLoading = false;

  @override
  void initState() {
    FlutterAppBadger.removeBadge();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    manageNotification();
    return Scaffold(
        body: Stack(children: [
      const Image(
          image: AssetImage(AssetRes.bg1),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity),
      Align(
          alignment: Alignment.bottomCenter,
          child: Column(children: [
            const Expanded(
                child: SafeArea(
                    bottom: false,
                    child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: AppLogo(textSize: 40)))),
            ClipRect(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                        height: 240,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: ColorRes.black.withOpacity(0.4)),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SafeArea(
                            top: false,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      AppLocalizations.of(context)!
                                          .premiumBeautyServices,
                                      style: kSemiBoldWhiteTextStyle),
                                  const SizedBox(height: 10),
                                  Text(
                                      AppLocalizations.of(context)!
                                          .findAndBookHairCutMassageSpaWaxingColoringServicesAnytime,
                                      style: kLightWhiteTextStyle),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 55,
                                      child: TextButton(
                                          style: kButtonWhiteStyle,
                                          onPressed: () async {
                                            if (isLoading) return;
                                            isLoading = true;
                                            setState(() {});
                                            String? token =
                                                await FirebaseMessaging.instance
                                                    .getToken();
                                            await ApiService()
                                                .fetchGlobalSettings();
                                            SharePref sharedPref =
                                                await SharePref().init();
                                            sharedPref.saveString(
                                                ConstRes.deviceToken, token);
                                            AppRes.currency = sharedPref
                                                    .getSettings()
                                                    ?.data
                                                    ?.currency ??
                                                '';
                                            SalonUser? salon =
                                                sharedPref.getSalonUser();
                                            ConstRes.userIdValue =
                                                salon?.data?.id?.toInt() ?? -1;
                                            // if (salon != null) {
                                            Get.off(() => MainScreen());
                                            // } else {
                                            //   Get.off(() => const LoginOptionScreen());
                                            // }
                                          },
                                          child: isLoading
                                              ? const Center(
                                                  child: LoadingData())
                                              : Text(
                                                  AppLocalizations.of(context)!
                                                      .continue_,
                                                  style:
                                                      kThemeButtonTextStyle)))
                                ])))))
          ]))
    ]));
  }

  final firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<bool> manageNotification() async {
    FlutterBranchSdk.listSession().listen((data) {
      if (data.containsKey("+clicked_branch_link") &&
          data["+clicked_branch_link"] == true) {
        //Link clicked. Add logic to get link data
        if (data.containsKey(ConstRes.salonId_)) {
          Get.to(
            () => const SalonDetailsScreen(),
            arguments: int.parse(data[ConstRes.salonId_].toString()),
          );
        } else if (data.containsKey(ConstRes.serviceId)) {
          Get.to(() => const ServiceDetailScreen(),
              arguments: int.parse(data[ConstRes.serviceId].toString()));
        }
      }
    }, onError: (error) {});
    SharePref sharePref = await SharePref().init();
    // Stripe.publishableKey =
    //     sharePref.getSettings()?.data?.stripePublishableKey ?? '';
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance.subscribeToTopic(AppRes.topicName);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'moli', // id
      'Notification', // title
      // 'This channel is used for bubbly notifications.', // description
      importance: Importance.max,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification == null) return;
      var initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = const DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      FlutterLocalNotificationsPlugin().initialize(initializationSettings);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? apple = message.notification?.apple;

      if (notification != null && apple != null) {
        flutterLocalNotificationsPlugin.show(
            0,
            notification.title,
            notification.body,
            const NotificationDetails(iOS: DarwinNotificationDetails()));
      }
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            1,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                // other properties...
              ),
            ));
      }
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    return true;
  }
}
