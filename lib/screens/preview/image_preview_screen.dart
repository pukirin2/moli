import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/extensions.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String? imageUrl;

  const ImagePreviewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 38,
                height: 38,
                margin: const EdgeInsets.only(left: 20, top: 10),
                decoration: BoxDecoration(
                  color: context.colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: ColorRes.white,
                  size: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: PhotoView(
              imageProvider: NetworkImage(
                '${ConstRes.itemBaseUrl}$imageUrl',
              ),
              filterQuality: FilterQuality.high,
            ),
          ),
        ],
      ),
    );
  }
}
