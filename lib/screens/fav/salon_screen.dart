import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/fav/favourite_bloc.dart';
import 'package:moli/bloc/fav/favourite_state.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/salon/salon_details_screen.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class SalonScreen extends StatelessWidget {
  const SalonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouriteBloc, FavouriteState>(
      builder: (context, state) {
        return state is FavouriteDataFound
            ? (state.favouriteData.data != null &&
                    state.favouriteData.data!.salons!.isNotEmpty
                ? ListView.builder(
                    itemCount: state.favouriteData.data?.salons?.length ?? 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    itemBuilder: (context, index) {
                      SalonData? salonData =
                          state.favouriteData.data?.salons?[index];
                      return ItemSalon(
                        salonData: salonData,
                      );
                    },
                  )
                : const DataNotFound())
            : const LoadingData(
                color: ColorRes.white,
              );
      },
    );
  }
}

class ItemSalon extends StatelessWidget {
  final SalonData? salonData;

  const ItemSalon({
    super.key,
    this.salonData,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCircularInkWell(
      onTap: () {
        Get.to(
          () => const SalonDetailsScreen(),
          arguments: salonData?.id?.toInt(),
        );
      },
      child: AspectRatio(
        aspectRatio: 1 / .45,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 1,
          surfaceTintColor: context.colorScheme.onSurface,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                          width: double.infinity,
                          height: double.infinity,
                          imageUrl:
                              '${ConstRes.itemBaseUrl}${salonData!.images!.isNotEmpty ? (salonData?.images?[0].image ?? '') : ''}',
                          placeholder: (context, url) => const Loading(),
                          errorWidget: errorBuilderForImage,
                          fit: BoxFit.cover)
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: context.colorScheme.surface,
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      right: 10,
                      left: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${salonData?.getCatInString()}',
                          style: context.bodyLarge!.copyWith(
                            color: context.colorScheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          salonData?.salonName ?? '',
                          style: context.bodyMedium!.copyWith(
                              color:
                                  context.bodyMedium!.color!.withOpacity(.5)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          salonData?.salonAddress ?? '',
                          style: context.bodyMedium!.copyWith(
                              color:
                                  context.bodyMedium!.color!.withOpacity(.5)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Visibility(
                                visible: true,
                                child: Card(
                                    color: context.colorScheme.primaryContainer
                                        .withOpacity(.6),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      child: Row(children: [
                                        Text(
                                            salonData?.rating
                                                    ?.toStringAsFixed(1) ??
                                                '',
                                            style: context.bodyMedium!.copyWith(
                                                color: ColorRes.pumpkin,
                                                fontSize: 14)),
                                        const SizedBox(width: 5),
                                        const Icon(Icons.star_rounded,
                                            color: ColorRes.pumpkin, size: 19)
                                      ]),
                                    ))),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${AppRes.calculateDistance(double.parse(salonData?.salonLat ?? '0'), double.parse(salonData?.salonLong ?? '0'))} km',
                              style: context.bodyMedium!.copyWith(
                                color: ColorRes.mortar,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
