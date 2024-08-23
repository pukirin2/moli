import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/extensions.dart';

class ImageSendSheet extends StatelessWidget {
  final String image;
  final Function(String image) onSendMediaTap;
  final TextEditingController sendMediaController;

  const ImageSendSheet(
      {super.key,
      required this.image,
      required this.onSendMediaTap,
      required this.sendMediaController});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.only(top: AppBar().preferredSize.height),
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.sendMedia,
                        style: context.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
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
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(image),
                        height: Get.width / 2,
                        width: Get.width / 2.6,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: ColorRes.mortar,
                          height: Get.width / 2,
                          width: Get.width / 2.6,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: Get.width / 2,
                        decoration: BoxDecoration(
                            color: ColorRes.smokeWhite,
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          controller: sendMediaController,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          cursorColor: ColorRes.charcoal,
                          cursorHeight: 15,
                          style: context.bodyMedium!.copyWith(
                            color: ColorRes.charcoal,
                            fontSize: 16,
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: AppBar().preferredSize.height / 2,
                ),
                SafeArea(
                  top: false,
                  child: InkWell(
                    onTap: () => onSendMediaTap(''),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.send,
                        style: context.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppBar().preferredSize.height,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
