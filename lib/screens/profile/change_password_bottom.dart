import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moli/bloc/chnagepassword/change_password_bloc.dart';
import 'package:moli/screens/login/email_registration_screen.dart';
import 'package:moli/screens/search/filter_bottom_sheet.dart';
import 'package:moli/utils/extensions.dart';

class ChangePasswordBottomSheet extends StatelessWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordBloc(),
      child: SafeArea(
        bottom: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
            builder: (context, state) {
              ChangePasswordBloc changePasswordBloc =
                  context.read<ChangePasswordBloc>();
              return Column(
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.changePassword,
                        style: context.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const CloseButtonWidget(),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          TextWithTextFieldSmokeWhiteWidget(
                            title: AppLocalizations.of(context)!.oldPassword,
                            isPassword: true,
                            controller:
                                changePasswordBloc.oldPasswordController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextWithTextFieldSmokeWhiteWidget(
                            title: AppLocalizations.of(context)!.newPassword,
                            isPassword: true,
                            controller:
                                changePasswordBloc.newPasswordController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextWithTextFieldSmokeWhiteWidget(
                            title:
                                AppLocalizations.of(context)!.confirmPassword,
                            isPassword: true,
                            controller:
                                changePasswordBloc.confirmPasswordController,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
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
                      onPressed: changePasswordBloc.onTapContinue,
                      child: Text(
                        AppLocalizations.of(context)!.continue_,
                        style: context.bodyMedium,
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
