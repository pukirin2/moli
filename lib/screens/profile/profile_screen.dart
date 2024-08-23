import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/profile/profile_bloc.dart';
import 'package:moli/model/user/salon_user.dart';
import 'package:moli/screens/booking/profile_booking_screen.dart';
import 'package:moli/screens/help&faq/help_and_faq_screen.dart';
import 'package:moli/screens/payoutHistory/payout_history_screen.dart';
import 'package:moli/screens/profile/change_password_bottom.dart';
import 'package:moli/screens/profile/delete_account_bottom.dart';
import 'package:moli/screens/profile/profile_top_bar_widget.dart';
import 'package:moli/screens/web/web_view_screen.dart';
import 'package:moli/screens/welcome/welcome_screen.dart';
import 'package:moli/service/api_service.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';
import 'package:moli/utils/shared_pref.dart';

class ProfileScreen extends StatelessWidget {
  final Function()? onMenuClick;

  const ProfileScreen({super.key, this.onMenuClick});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          SalonUser? salonUser =
              state is UserDataFoundState ? state.salonUser : null;
          return salonUser != null
              ? Column(
                  children: [
                    ProfileTopBarWidget(
                        onMenuClick: onMenuClick, salonUser: salonUser),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(children: [
                                  Icon(
                                    Icons.notifications_outlined,
                                    color: context.bodyMedium!
                                        .copyWith(
                                            color: context.bodyMedium!.color)
                                        .color!
                                        .withOpacity(0.5),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .pushNotification,
                                            style: context.bodyMedium),
                                        Text(
                                            AppLocalizations.of(context)!
                                                .keepItOnIfYouWantToReceiveNotifications,
                                            style: context.bodySmall!.copyWith(
                                                color: context
                                                    .bodyMedium!.color!
                                                    .withOpacity(0.5)))
                                      ])),
                                  ToggleButton(
                                      value:
                                          salonUser.data?.isNotification == 1,
                                      onValueChange: (isEnable) {
                                        ApiService().editUserDetails(
                                            isNotification: isEnable);
                                      })
                                ])),
                            ProfileMenuItemWidget(
                                preIcon: Icons.wallet,
                                title: AppLocalizations.of(context)!.wallet,
                                onTap: () {
                                  // Get.to(() => const WalletScreen());
                                }),
                            ProfileMenuItemWidget(
                              preIcon: Icons.playlist_add_check,
                              title: AppLocalizations.of(context)!.bookings,
                              onTap: () {
                                Get.to(() => const ProfileBookingScreen());
                              },
                            ),
                            ProfileMenuItemWidget(
                              preIcon: Icons.request_page_outlined,
                              title: AppLocalizations.of(context)!
                                  .withdrawRequests,
                              onTap: () {
                                Get.to(() => const PayoutHistoryScreen());
                              },
                            ),
                            Visibility(
                              visible: salonUser.data?.loginType == 3,
                              child: ProfileMenuItemWidget(
                                preIcon: Icons.lock_open_outlined,
                                title: AppLocalizations.of(context)!
                                    .changePassword,
                                onTap: () {
                                  Get.bottomSheet(
                                    const ChangePasswordBottomSheet(),
                                    ignoreSafeArea: false,
                                    isScrollControlled: true,
                                  );
                                },
                              ),
                            ),
                            ProfileMenuItemWidget(
                              preIcon: Icons.info_outline,
                              title: AppLocalizations.of(context)!.termsOfUse,
                              onTap: () {
                                Get.to(
                                  () => const WebViewScreen(),
                                  arguments:
                                      AppLocalizations.of(context)!.termsOfUse,
                                );
                              },
                            ),
                            ProfileMenuItemWidget(
                              preIcon: Icons.security,
                              title:
                                  AppLocalizations.of(context)!.privacyPolicy,
                              onTap: () {
                                Get.to(
                                  () => const WebViewScreen(),
                                  arguments: AppLocalizations.of(context)!
                                      .privacyPolicy,
                                );
                              },
                            ),
                            ProfileMenuItemWidget(
                              preIcon: Icons.help_outline,
                              title: AppLocalizations.of(context)!.help_FAQ,
                              onTap: () {
                                Get.to(() => const HelpFaqScreen());
                              },
                            ),
                            Visibility(
                              visible: ConstRes.userIdValue != -1,
                              child: CustomCircularInkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    ConfirmationBottomSheet(
                                      title: AppLocalizations.of(context)!
                                          .deleteMyAccount,
                                      description: AppLocalizations.of(context)!
                                          .deleteDesc,
                                      buttonText: AppLocalizations.of(context)!
                                          .continue_,
                                      onButtonClick: () async {
                                        AppRes.showCustomLoader();
                                        await ApiService()
                                            .deleteMyUserAccount();
                                        SharePref sharedPref =
                                            await SharePref().init();
                                        sharedPref.clear();
                                        FirebaseAuth.instance.signOut();
                                        AppRes.hideCustomLoader();
                                        Get.offAll(() => const WelComeScreen());
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.red.withOpacity(0.2),
                                  margin: const EdgeInsets.only(bottom: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .deleteMyAccount,
                                        style: context.bodyMedium!.copyWith(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const LoadingData();
        },
      ),
    );
  }
}

class ProfileMenuItemWidget extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final IconData? preIcon;
  final IconData? subIcon;

  const ProfileMenuItemWidget({
    super.key,
    required this.title,
    this.onTap,
    this.preIcon,
    this.subIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCircularInkWell(
      onTap: onTap,
      child: Row(
        children: [
          const SizedBox(width: 20),
          Icon(preIcon,
              color: context.bodyMedium!
                  .copyWith(color: context.bodyMedium!.color)
                  .color!
                  .withOpacity(0.5)),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                title,
                style: context.bodyMedium!.copyWith(fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              subIcon ?? Icons.chevron_right_rounded,
              color: context.bodyMedium!
                  .copyWith(color: context.bodyMedium!.color)
                  .color!
                  .withOpacity(0.5),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class ToggleButton extends StatefulWidget {
  final Function(bool isEnable)? onValueChange;
  final bool? value;

  const ToggleButton({
    super.key,
    this.onValueChange,
    this.value,
  });

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool buttonIsActive = false;

  @override
  void initState() {
    buttonIsActive = widget.value ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: buttonIsActive,
      activeColor: context.colorScheme.primary,
      onChanged: (value) {
        buttonIsActive = value;
        widget.onValueChange?.call(value);
        setState(() {});
      },
    );
  }
}
