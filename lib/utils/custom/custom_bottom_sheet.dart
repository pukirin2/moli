import 'package:flutter/material.dart';
import 'package:moli/screens/search/filter_bottom_sheet.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/extensions.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final Function()? onButtonClick;
  final Function()? onCloseClick;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    this.onButtonClick,
    this.onCloseClick,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Wrap(
          verticalDirection: VerticalDirection.down,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: context.titleStyleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                CloseButtonWidget(
                  onTap: onCloseClick,
                ),
              ],
            ),
            Visibility(
              visible: description.isNotEmpty,
              child: const SizedBox(
                height: 50,
              ),
            ),
            Visibility(
              visible: description.isNotEmpty,
              child: Text(
                description,
                textAlign: TextAlign.start,
                style: context.bodyMedium!.copyWith(
                  color: ColorRes.mortar,
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                height: 55,
                margin: const EdgeInsets.only(top: 50),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  onPressed: onButtonClick,
                  child: Text(
                    buttonText,
                    style: context.bodyMedium!.copyWith(
                        color: ColorRes.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
