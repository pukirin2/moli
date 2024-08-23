import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/screens/booking/profile_booking_screen.dart';
import 'package:moli/screens/changelanguage/change_language.dart';
import 'package:moli/screens/help&faq/help_and_faq_screen.dart';
import 'package:moli/screens/login/login_option_screen.dart';
import 'package:moli/screens/salononmap/explore_salon_on_map.dart';
import 'package:moli/screens/web/web_view_screen.dart';
import 'package:moli/screens/welcome/welcome_screen.dart';
import 'package:moli/service/api_service.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';
import 'package:moli/utils/shared_pref.dart';

import '../profile/delete_account_bottom.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Drawer(
          width: context.sizeDevice.width * 0.8,
          child: Column(
            children: [
              const TopBarDrawerWidget(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      DrawerMenuWidget(
                        icons: Icons.location_on_outlined,
                        title: AppLocalizations.of(context)!.exploreSalonsOnMap,
                        imagePadding: 2,
                        onTap: () {
                          Get.to(
                            () => const SalonOnMapScreen(),
                          );
                        },
                      ),
                      DrawerMenuWidget(
                        icons: Icons.language_outlined,
                        title: AppLocalizations.of(context)!.changeLanguage,
                        imagePadding: 4,
                        onTap: () {
                          Get.to(
                            () => const ChangeLanguageScreen(),
                          );
                        },
                      ),
                      DrawerMenuWidget(
                        icons: Icons.playlist_add_check,
                        title: AppLocalizations.of(context)!.bookings,
                        onTap: () {
                          if (ConstRes.userIdValue == -1) {
                            Get.to(() => const LoginOptionScreen());
                            return;
                          }
                          Get.to(
                            () => const ProfileBookingScreen(),
                          );
                        },
                      ),
                      DrawerMenuWidget(
                        icons: Icons.help_outline,
                        title: AppLocalizations.of(context)!.help_FAQ,
                        imagePadding: 3,
                        onTap: () {
                          Get.to(
                            () => const HelpFaqScreen(),
                          );
                        },
                      ),
                      DrawerMenuWidget(
                        icons: Icons.info_outline_rounded,
                        title: AppLocalizations.of(context)!.aboutUs,
                        imagePadding: 3,
                        onTap: () {
                          Get.to(
                            () => const WebViewScreen(),
                            arguments: AppLocalizations.of(context)!.aboutUs,
                          );
                        },
                      ),
                      DrawerMenuWidget(
                        icons: Icons.local_parking_outlined,
                        title: AppLocalizations.of(context)!.termsOfUse,
                        imagePadding: 3,
                        onTap: () {
                          Get.to(
                            () => const WebViewScreen(),
                            arguments: AppLocalizations.of(context)!.termsOfUse,
                          );
                        },
                      ),
                      DrawerMenuWidget(
                        icons: Icons.security_outlined,
                        title: AppLocalizations.of(context)!.privacyPolicy,
                        imagePadding: 3,
                        onTap: () {
                          Get.to(
                            () => const WebViewScreen(),
                            arguments:
                                AppLocalizations.of(context)!.privacyPolicy,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: ConstRes.userIdValue != -1,
                child: CustomCircularInkWell(
                  onTap: () {
                    Get.bottomSheet(
                      ConfirmationBottomSheet(
                        title: AppLocalizations.of(context)!.logOut,
                        description: AppLocalizations.of(context)!.logoutDec,
                        buttonText: AppLocalizations.of(context)!.continue_,
                        onButtonClick: () async {
                          AppRes.showCustomLoader();
                          await ApiService()
                              .editUserDetails(deviceToken: 'none');
                          FirebaseAuth.instance.signOut();
                          AppRes.hideCustomLoader();
                          SharePref sharedPref = await SharePref().init();
                          sharedPref.clear();
                          Get.offAll(() => const WelComeScreen());
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          padding: const EdgeInsets.all(2),
                          child: const Image(
                            image: AssetImage(AssetRes.icLogOut),
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          AppLocalizations.of(context)!.logOut,
                          style: context.bodyMedium!.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DrawerMenuWidget extends StatelessWidget {
  final IconData icons;
  final String title;
  final double? imagePadding;
  final Function()? onTap;

  const DrawerMenuWidget({
    super.key,
    required this.icons,
    required this.title,
    this.imagePadding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCircularInkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: [
            Container(
                height: 30,
                width: 30,
                padding: EdgeInsets.all(imagePadding ?? 0),
                child: Icon(icons, color: context.colorScheme.outline)),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: context.bodyMedium!
                    .copyWith(color: context.colorScheme.outline),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: context.colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}

class TopBarDrawerWidget extends StatelessWidget {
  const TopBarDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        width: double.infinity,
        height: 250,
        child: Stack(
          children: [
            const Image(
              image: AssetImage(AssetRes.icHorizontalBg),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8.0,
                sigmaY: 8.0,
                tileMode: TileMode.mirror,
              ),
              child: Container(
                color: Colors.red,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: SafeArea(
                  bottom: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const AppLogo(textSize: 30),
                        Text(
                          AppLocalizations.of(context)!
                              .findAndBookHairCutMassageSpaWaxingColoringServicesAnytime,
                          style: context.bodySmall,
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
}
