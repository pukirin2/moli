import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moli/bloc/withdraw/withdraw_bloc.dart';
import 'package:moli/screens/login/email_registration_screen.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class WithDrawScreen extends StatelessWidget {
  const WithDrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WithdrawBloc(),
      child: Scaffold(
        body: Column(
          children: [
            ToolBarWidget(
              title: AppLocalizations.of(context)!.withdrawRequest,
            ),
            BlocBuilder<WithdrawBloc, WithdrawState>(
              builder: (context, state) {
                WithdrawBloc withdrawBloc = context.read<WithdrawBloc>();
                return Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.amount,
                            style: context.bodyMedium,
                          ),
                          Text(
                            '${withdrawBloc.userData?.wallet ?? ''} ${AppRes.currency}',
                            style: context.bodyMedium!.copyWith(
                              color: context.colorScheme.tertiary,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextWithTextFieldSmokeWhiteWidget(
                            title: AppLocalizations.of(context)!.bankName,
                            controller: withdrawBloc.bankNameController,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextWithTextFieldSmokeWhiteWidget(
                            title: AppLocalizations.of(context)!.accountNumber,
                            controller: withdrawBloc.accountNumberController,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextWithTextFieldSmokeWhiteWidget(
                            title: AppLocalizations.of(context)!
                                .reEnterAccountNumber,
                            controller: withdrawBloc.reAccountNumberController,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextWithTextFieldSmokeWhiteWidget(
                            title: AppLocalizations.of(context)!.holdersName,
                            controller: withdrawBloc.holdersNameController,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextWithTextFieldSmokeWhiteWidget(
                            title: AppLocalizations.of(context)!.swiftCode,
                            controller: withdrawBloc.swiftCodeController,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<WithdrawBloc, WithdrawState>(
              builder: (context, state) {
                return SafeArea(
                  top: false,
                  child: Container(
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
                      onPressed: () {
                        context.read<WithdrawBloc>().tapOnContinue(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.continue_,
                        style:
                            context.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
