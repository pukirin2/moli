import 'dart:io';
import 'dart:ui';

import 'package:moli/bloc/login/login_bloc.dart';
import 'package:moli/screens/login/email_login_screen.dart';
import 'package:moli/screens/web/web_view_screen.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/route_manager.dart';

class LoginOptionScreen extends StatelessWidget {
  const LoginOptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            const Image(
              image: AssetImage(AssetRes.bg1),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: ColorRes.charcoal50),
                child: SafeArea(
                  left: false,
                  right: false,
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return Stack(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      child: Center(
                                        child: AppLogo(
                                          textSize: 40,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .signInToContinue,
                                      style: kSemiBoldWhiteTextStyle.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .findAndBookHairCutMassageSpaWaxingColoringServicesAnytime,
                                      style: kLightWhiteTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    Visibility(
                                      visible: Platform.isIOS,
                                      child: IconWithTextButton(
                                        image: AssetRes.icApple,
                                        text: AppLocalizations.of(context)!
                                            .signInWithApple,
                                        onPressed: () {
                                          context
                                              .read<LoginBloc>()
                                              .add(LoginClickEvent(0));
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    IconWithTextButton(
                                      image: AssetRes.icGoogle,
                                      text: AppLocalizations.of(context)!
                                          .signInWithGoogle,
                                      iconPadding: 8,
                                      onPressed: () {
                                        context
                                            .read<LoginBloc>()
                                            .add(LoginClickEvent(1));
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    IconWithTextButton(
                                      image: AssetRes.icEmail,
                                      text: AppLocalizations.of(context)!
                                          .signInWithEmail,
                                      iconPadding: 6,
                                      onPressed: () {
                                        Get.to(() => const EmailLoginScreen());
                                      },
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .byContinuingWithAnyOptions,
                                      style: kLightWhiteTextStyle,
                                    ),
                                    Row(children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .youAgreeTo,
                                        style: kLightWhiteTextStyle,
                                      ),
                                      const SizedBox(width: 5),
                                      CustomCircularInkWell(
                                          onTap: () {
                                            Get.to(
                                              () => const WebViewScreen(),
                                              arguments:
                                                  AppLocalizations.of(context)!
                                                      .termsOfUse,
                                            );
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .termsOfUse,
                                              style:
                                                  kBoldWhiteTextStyle.copyWith(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                      const SizedBox(width: 5),
                                      Text(AppLocalizations.of(context)!.and,
                                          style: kLightWhiteTextStyle),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: CustomCircularInkWell(
                                              onTap: () {
                                                Get.to(
                                                  () => const WebViewScreen(),
                                                  arguments:
                                                      AppLocalizations.of(
                                                              context)!
                                                          .privacyPolicy,
                                                );
                                              },
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .privacyPolicy,
                                                  style: kBoldWhiteTextStyle
                                                      .copyWith(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .bold))))
                                    ]),
                                    const SizedBox(height: 35)
                                  ])),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: BackButton(
                              color: ColorRes.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IconWithTextButton extends StatelessWidget {
  final String image;
  final String text;
  final double? iconPadding;
  final Function()? onPressed;

  const IconWithTextButton({
    Key? key,
    required this.image,
    required this.text,
    this.iconPadding,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: TextButton(
        style: kButtonWhiteStyle,
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 90,
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: iconPadding ?? 0),
              child: Image(image: AssetImage(image)),
            ),
            Center(
              child: Text(
                text,
                style: kBlackButtonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
