import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class AppointmentBookedScreen extends StatelessWidget {
  const AppointmentBookedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 60),
            decoration: const BoxDecoration(
              color: ColorRes.themeColor20,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.appointmentBooked,
                    style: context.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold)
                        .copyWith(
                          fontSize: 19,
                        ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    AssetRes.icRoundVerifiedBig,
                    width: 110,
                    height: 110,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Text(
            AppLocalizations.of(context)!.appointmentId,
            style: context.bodyMedium!.copyWith(
              fontSize: 18,
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '${Get.arguments}'.toUpperCase(),
            style: context.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold)
                .copyWith(
                  fontSize: 19,
                  color: context.colorScheme.primary,
                  fontFamily: AssetRes.fnProductSansBlack,
                ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            AppLocalizations.of(context)!
                .yourAppointmentnhasBeenBookedSuccessfully,
            textAlign: TextAlign.center,
            style: context.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold)
                .copyWith(
                  fontSize: 20,
                  color: ColorRes.mortar,
                ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            AppLocalizations.of(context)!
                .checkAppointmentsTabnforAllYourUpcomingAppointments,
            textAlign: TextAlign.center,
            style: context.bodyMedium!.copyWith(
              color: ColorRes.charcoal50,
              fontSize: 17,
            ),
          ),
          const Spacer(),
          CustomCircularInkWell(
            onTap: () {
              Get.offAll(() => MainScreen());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: context.colorScheme.primary,
              alignment: Alignment.center,
              child: SafeArea(
                top: false,
                child: Text(
                  AppLocalizations.of(context)!.myBookings,
                  style: context.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w300)
                      .copyWith(
                        fontSize: 17,
                        color: ColorRes.white,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
