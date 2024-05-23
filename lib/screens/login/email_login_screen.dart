import 'dart:ui';

import 'package:moli/bloc/emaillogin/email_login_bloc.dart';
import 'package:moli/screens/login/email_registration_screen.dart';
import 'package:moli/screens/login/forgot_password.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/route_manager.dart';

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailLoginBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SafeArea(
                  child: BlocBuilder<EmailLoginBloc, EmailLoginState>(
                    builder: (context, state) {
                      EmailLoginBloc emailLoginBloc =
                          context.read<EmailLoginBloc>();
                      return Column(
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
                            AppLocalizations.of(context)!.signInToContinue,
                            style: kSemiBoldWhiteTextStyle,
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
                          TextWithTextFieldWidget(
                            title: AppLocalizations.of(context)!.emailAddress,
                            controller: emailLoginBloc.emailTextController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextWithTextFieldWidget(
                              title: AppLocalizations.of(context)!.password,
                              isPassword: true,
                              controller:
                                  emailLoginBloc.passwordTextController),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                  const ForgotPasswordBottomSheet());
                            },
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword_,
                                style: kRegularWhiteTextStyle,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: double.infinity,
                            height: 55,
                            child: TextButton(
                              style: kButtonWhiteStyle,
                              onPressed: () {
                                emailLoginBloc.add(ContinueLoginEvent());
                              },
                              child: Text(
                                AppLocalizations.of(context)!.continue_,
                                style: kThemeButtonTextStyle,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => const EmailRegistrationScreen())
                                  ?.then(
                                (value) {
                                  SystemChrome.setSystemUIOverlayStyle(
                                    SystemUiOverlayStyle.light,
                                  );
                                },
                              );
                            },
                            child: Align(
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .newUserRegisterHere,
                                style: kRegularWhiteTextStyle,
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).viewInsets.bottom == 0
                                    ? 20
                                    : MediaQuery.of(context).viewInsets.bottom,
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

class TextWithTextFieldWidget extends StatelessWidget {
  final String title;
  final bool? isPassword;
  final TextEditingController? controller;

  const TextWithTextFieldWidget({
    Key? key,
    required this.title,
    this.isPassword,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kRegularWhiteTextStyle,
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorRes.white.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: ColorRes.smokeWhite,
              width: 0.5,
            ),
          ),
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(border: InputBorder.none),
            style: kRegularWhiteTextStyle,
            obscureText: isPassword ?? false,
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: isPassword != null ? !isPassword! : true,
            autocorrect: isPassword != null ? !isPassword! : true,
          ),
        ),
      ],
    );
  }
}
