import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/utils/extensions.dart';

class BottomSelectedItemBar extends StatelessWidget {
  final VoidCallback onBackTap;
  final int selectedItemCount;
  final VoidCallback onItemDelete;

  const BottomSelectedItemBar(
      {super.key,
      required this.onBackTap,
      required this.selectedItemCount,
      required this.onItemDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      width: Get.width,
      decoration: BoxDecoration(color: context.colorScheme.surface),
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Directionality.of(context) == TextDirection.rtl
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: InkWell(
                onTap: onBackTap,
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(
                    '$selectedItemCount\t\t',
                    key: ValueKey<int>(selectedItemCount),
                    style: context.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.selectMsg,
                  style:
                      context.bodyLarge!.copyWith(fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Align(
              alignment: Directionality.of(context) == TextDirection.rtl
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: InkWell(
                onTap: onItemDelete,
                child: Icon(
                  Icons.delete,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
