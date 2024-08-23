import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/model/home/home_page_data.dart';
import 'package:moli/screens/categories/salon_by_cat_screen.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Categories> categories = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ToolBarWidget(
            title: AppLocalizations.of(context)!.categories,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1.2,
              ),
              itemCount: categories.length,
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              itemBuilder: (context, index) {
                Categories category = categories[index];
                return CustomCircularInkWell(
                  onTap: () {
                    Get.to(
                      () => const CategoryDetailScreen(),
                      arguments: category,
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ColorRes.lavender,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: const EdgeInsets.all(2.5),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: CachedNetworkImage(
                                    height: double.infinity,
                                    width: double.infinity,
                                    imageUrl:
                                        '${ConstRes.itemBaseUrl}${category.icon}',
                                    placeholder: (context, url) =>
                                        const Loading(),
                                    errorWidget: errorBuilderForImage,
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            category.title ?? '',
                            style: context.bodyMedium!.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
