import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moli/screens/search/filter_bottom_sheet.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/extensions.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrCodeBottomSheet extends StatelessWidget {
  const MyQrCodeBottomSheet({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: context.sizeDevice.height * 0.6,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.showThisQRAtSalon,
                  style: context.titleStyleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const CloseButtonWidget(),
              ],
            ),
            Text(
              AppLocalizations.of(context)!
                  .offerThisQRAtSalonShopTheyWillScanItAndWillHaveAllTheDetails,
              style: context.bodyMedium!.copyWith(
                color: context.bodyMedium!.color!.withOpacity(0.6),
                fontSize: 18,
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ColorRes.smokeWhite,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: QrImageView(
                      data: bookingId,
                      errorCorrectionLevel: 2,
                      eyeStyle: const QrEyeStyle(
                        color: ColorRes.black,
                        eyeShape: QrEyeShape.square,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        color: ColorRes.black,
                        dataModuleShape: QrDataModuleShape.square,
                      ),
                    ),
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
