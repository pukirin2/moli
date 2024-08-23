import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moli/model/home/home_page_data.dart';
import 'package:moli/screens/categories/salon_by_cat_screen.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class CategoriesGridWidget extends StatelessWidget {
  final List<Categories> categories;

  const CategoriesGridWidget({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      // height: Get.height * 0.25,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, childAspectRatio: 1.2 / 1),
        // itemCount: categories.length >= 4 ? 4 : categories.length,
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          Categories category = categories[index];
          return CustomCircularInkWell(
            onTap: () {
              Get.to(
                () => const CategoryDetailScreen(),
                arguments: category,
              );
            },
            child: Card(
              elevation: 1,
              surfaceTintColor: context.colorScheme.onSurface,
              margin: const EdgeInsets.all(2.5),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: CachedNetworkImage(
                          imageUrl: '${ConstRes.itemBaseUrl}${category.icon}',
                          placeholder: (context, url) => const Loading(),
                          errorWidget: errorBuilderForImage,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      category.title ?? '',
                      style: context.bodyMedium!.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
