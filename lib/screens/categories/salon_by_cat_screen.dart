import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/salonbycat/salon_by_cat_bloc.dart';
import 'package:moli/model/home/home_page_data.dart' as home_data;
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/fav/service_screen.dart';
import 'package:moli/screens/salon/salon_details_screen.dart';
import 'package:moli/screens/toprated/top_rated_salon_screen.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalonByCatBloc(),
      child: Scaffold(
        body: Column(
          children: [
            const TopBarOfCatDetailWidget(),
            BlocBuilder<SalonByCatBloc, SalonByCatState>(
              builder: (context, state) {
                SalonByCatBloc salonByCatBloc = context.read<SalonByCatBloc>();
                return state is FetchSalonByCatState
                    ? salonByCatBloc.topRatedSalons.isEmpty &&
                            salonByCatBloc.services.isEmpty
                        ? const Expanded(child: DataNotFound())
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                      visible: salonByCatBloc
                                          .topRatedSalons.isNotEmpty,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      ColorRes.pancho,
                                                      ColorRes.fallow
                                                    ],
                                                    begin: Alignment(1, -1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 8,
                                                ),
                                                margin: const EdgeInsets.only(
                                                    left: 15, right: 5),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .topRated
                                                      .toUpperCase(),
                                                  style: context.bodyMedium!
                                                      .copyWith(
                                                    color: ColorRes.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .salons,
                                                style: context.bodyMedium,
                                              ),
                                              const Spacer(),
                                              CustomCircularInkWell(
                                                onTap: () {
                                                  Get.to(
                                                      () =>
                                                          const TopRatedSalonScreen(),
                                                      arguments: Get.arguments);
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .seeAll,
                                                        style: context
                                                            .bodySmall!
                                                            .copyWith(
                                                                color: ColorRes
                                                                    .empress)),
                                                    const SizedBox(width: 3),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 8,
                                                      color: context
                                                          .colorScheme.outline,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            child: Text(
                                              'Offering best ${salonByCatBloc.category.title} services',
                                              style:
                                                  context.bodyMedium!.copyWith(
                                                color:
                                                    context.colorScheme.outline,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: ListView.builder(
                                              itemCount: salonByCatBloc
                                                  .topRatedSalons.length,
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                SalonData salonData =
                                                    salonByCatBloc
                                                        .topRatedSalons[index];
                                                return ItemTopRatedSalon(
                                                  salonData: salonData,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )),
                                  Visibility(
                                    visible: salonByCatBloc.services.isNotEmpty,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .services,
                                            style: context.bodyMedium!.copyWith(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SafeArea(
                                          top: false,
                                          child: ListView.builder(
                                            itemCount:
                                                salonByCatBloc.services.length,
                                            primary: false,
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            itemBuilder: (context, index) {
                                              return ItemService(
                                                services: salonByCatBloc
                                                    .services[index],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                    : const Expanded(
                        child: Center(
                          child: LoadingData(
                            color: ColorRes.white,
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

class ItemTopRatedSalon extends StatelessWidget {
  final SalonData? salonData;

  const ItemTopRatedSalon({
    super.key,
    this.salonData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CustomCircularInkWell(
        onTap: () {
          Get.to(() => const SalonDetailsScreen(),
              arguments: salonData?.id?.toInt());
        },
        child: AspectRatio(
          aspectRatio: 1 / 1.2,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Stack(
              children: [
                CachedNetworkImage(
                    height: double.infinity,
                    width: double.infinity,
                    imageUrl:
                        '${ConstRes.itemBaseUrl}${salonData!.images!.isNotEmpty ? (salonData?.images?[0].image ?? '') : ''}',
                    placeholder: (context, url) => const Loading(),
                    errorWidget: errorBuilderForImage,
                    fit: BoxFit.cover),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 8.0,
                                sigmaY: 8.0,
                                tileMode: TileMode.mirror,
                              ),
                              child: Container(
                                width: double.infinity,
                                color: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      salonData?.salonName ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.bodyMedium!.copyWith(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      salonData?.salonAddress ?? '',
                                      style: context.bodyMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    RatingBar(
                                      initialRating:
                                          salonData?.rating?.toDouble() ?? 0,
                                      ignoreGestures: true,
                                      ratingWidget: RatingWidget(
                                        full: const Icon(
                                          Icons.star_rounded,
                                          color: ColorRes.sun,
                                        ),
                                        half: const Icon(
                                          Icons.star_rounded,
                                        ),
                                        empty: const Icon(
                                          Icons.star_rounded,
                                          color: ColorRes.darkGray,
                                        ),
                                      ),
                                      onRatingUpdate: (value) {},
                                      itemSize: 25,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopBarOfCatDetailWidget extends StatelessWidget {
  const TopBarOfCatDetailWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    home_data.Categories categories = Get.arguments;
    return BlocBuilder<SalonByCatBloc, SalonByCatState>(
      builder: (context, state) {
        SalonByCatBloc salonByCatBloc = context.read<SalonByCatBloc>();
        return SizedBox(
          child: Stack(
            children: [
              Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Container(height: 500, color: ColorRes.lavender)),
              SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: Get.height * 0.15,
                      child: CachedNetworkImage(
                          // height: double.infinity,
                          // width: double.infinity,
                          imageUrl: '${ConstRes.itemBaseUrl}${categories.icon}',
                          placeholder: (context, url) => const Loading(),
                          errorWidget: errorBuilderForImage,
                          fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      categories.title ?? '',
                      style: context.titleStyleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      margin: const EdgeInsets.only(
                        bottom: 10,
                        top: 20,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: context.colorScheme.outlineVariant
                              .withOpacity(.6),
                          prefixIcon: Icon(Icons.search,
                              color:
                                  context.colorScheme.primary.withOpacity(.8)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none),
                          hintText: AppLocalizations.of(context)!.search,
                          hintStyle: context.bodyMedium!,
                        ),
                        style: context.bodyMedium,
                        controller: salonByCatBloc.searchController,
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                bottom: false,
                child: CustomCircularInkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Icon(Icons.arrow_back_rounded,
                          size: 30, color: context.colorScheme.primary)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
