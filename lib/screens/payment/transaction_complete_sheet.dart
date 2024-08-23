import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/extensions.dart';

class TransactionCompleteSheet extends StatelessWidget {
  const TransactionCompleteSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2),
          child: Column(
            children: [
              Container(
                height: Get.height / 3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.colorScheme.tertiary,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      AppLocalizations.of(Get.context!)!.transactionSuccessful,
                      style: context.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)
                          .copyWith(
                            fontSize: 20,
                          ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      AssetRes.icRoundVerifiedBig,
                      width: Get.width / 4,
                      height: Get.width / 4,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                AppLocalizations.of(Get.context!)!
                    .fundsHaveBeenAddedntoYourAccountSuccessfully,
                textAlign: TextAlign.center,
                style: context.bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith(
                      fontSize: 18,
                      color: ColorRes.darkGray,
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(Get.context!)!
                    .nowYouCanBookAppointmentsnwithSingleClickToAvoidDisturbance,
                textAlign: TextAlign.center,
                style: context.bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith(
                      color: ColorRes.charcoal,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(
                height: 80,
              ),
              SafeArea(
                top: false,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.continue_,
                      style: context.bodyMedium,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        )
      ],
    );
  }
}
