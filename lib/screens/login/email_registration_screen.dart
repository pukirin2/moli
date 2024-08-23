import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/registration/registration_bloc.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class EmailRegistrationScreen extends StatelessWidget {
  const EmailRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: Scaffold(
        body: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            RegistrationBloc registrationBloc =
                context.read<RegistrationBloc>();
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCircularInkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back_ios_rounded),
                        ),
                        const SizedBox(height: 30),
                        Text(AppLocalizations.of(context)!.emailRegistration,
                            style: context.bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!
                              .enterYourDetailsAndCompleteProfileForBetterExperience,
                          style: context.bodyMedium!
                              .copyWith(color: context.colorScheme.outline),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            TextWithTextFieldSmokeWhiteWidget(
                              title: AppLocalizations.of(context)!.fullName,
                              controller:
                                  registrationBloc.fullNameTextController,
                            ),
                            const SizedBox(height: 20),
                            TextWithTextFieldSmokeWhiteWidget(
                              title: AppLocalizations.of(context)!.emailAddress,
                              controller: registrationBloc.emailTextController,
                            ),
                            const SizedBox(height: 20),
                            TextWithTextFieldSmokeWhiteWidget(
                              isPassword: true,
                              title: AppLocalizations.of(context)!.password,
                              controller:
                                  registrationBloc.passwordTextController,
                            ),
                            const SizedBox(height: 20),
                            TextWithTextFieldSmokeWhiteWidget(
                              title:
                                  AppLocalizations.of(context)!.confirmPassword,
                              controller: registrationBloc
                                  .confirmPasswordTextController,
                              isPassword: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red),
                          shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () {
                          context
                              .read<RegistrationBloc>()
                              .add(ContinueRegistrationEvent());
                        },
                        child: Text(
                          AppLocalizations.of(context)!.continue_,
                          style:
                              context.bodyMedium!.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TextWithTextFieldSmokeWhiteWidget extends StatelessWidget {
  final String title;
  final bool? isPassword;
  final TextEditingController? controller;
  final TextInputType? textInputType;

  const TextWithTextFieldSmokeWhiteWidget({
    super.key,
    required this.title,
    this.isPassword,
    this.controller,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.bodyMedium,
        ),
        const SizedBox(height: 10),
        TextField(
            controller: controller,
            style: context.bodyMedium,
            decoration:
                const InputDecoration(border: InputBorder.none, filled: false),
            keyboardType: textInputType,
            obscureText: isPassword ?? false,
            enableSuggestions: isPassword != null ? !isPassword! : true,
            autocorrect: isPassword != null ? !isPassword! : true),
      ],
    );
  }
}
