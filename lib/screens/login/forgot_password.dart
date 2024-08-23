import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/route_manager.dart';
import 'package:moli/bloc/forgot/forgot_password_bloc.dart';
import 'package:moli/screens/login/email_registration_screen.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/extensions.dart';

class ForgotPasswordBottomSheet extends StatelessWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SafeArea(
          child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
            builder: (context, state) {
              ForgotPasswordBloc forgotPasswordBloc =
                  context.read<ForgotPasswordBloc>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.forgotYourPassword,
                        style: context.titleStyleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: const BoxDecoration(
                            color: ColorRes.lavender,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.close_rounded,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .enterYourEmailAddressOnWhichWeWillSendYouTheLinkToResetThePassword,
                    style: context.bodyMedium,
                  ),
                  const Spacer(),
                  TextWithTextFieldSmokeWhiteWidget(
                    title: AppLocalizations.of(context)!.emailAddress,
                    controller: forgotPasswordBloc.emailTextController,
                  ),
                  const Spacer(),
                  SizedBox(
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
                        forgotPasswordBloc.add(ContinueForgotPasswordEvent());
                      },
                      child: Text(
                        AppLocalizations.of(context)!.continue_,
                        style:
                            context.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
