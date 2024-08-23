import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/fav/favourite_bloc.dart';
import 'package:moli/bloc/fav/favourite_state.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/service/service_detail_screen.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouriteBloc, FavouriteState>(
      builder: (context, state) {
        return state is FavouriteDataFound
            ? (state.favouriteData.data != null &&
                    state.favouriteData.data!.services!.isNotEmpty
                ? ListView.builder(
                    itemCount: state.favouriteData.data?.services?.length ?? 0,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    itemBuilder: (context, index) {
                      Services? services =
                          state.favouriteData.data?.services?[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ItemService(
                          services: services,
                        ),
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

class ItemService extends StatelessWidget {
  final Services? services;

  const ItemService({
    super.key,
    this.services,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCircularInkWell(
        onTap: () {
          Get.to(() => const ServiceDetailScreen(),
              arguments: services?.id?.toInt() ?? -1);
        },
        child: AspectRatio(
            aspectRatio: 1 / .35,
            child: Card(
                elevation: 1,
                surfaceTintColor: context.colorScheme.onSurface,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Row(children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                                width: double.infinity,
                                height: double.infinity,
                                imageUrl:
                                    '${ConstRes.itemBaseUrl}${services!.images!.isNotEmpty ? services?.images?.first.image : ''}',
                                placeholder: (context, url) => const Loading(),
                                errorWidget: errorBuilderForImage,
                                fit: BoxFit.cover),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                              color: context.colorScheme.surface,
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 10, right: 10, left: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(services?.title ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w300)
                                            .copyWith(fontSize: 16)),
                                    const SizedBox(height: 5),
                                    Text(
                                        "${AppLocalizations.of(context)!.by} ${services?.salonData?.salonName ?? ''}",
                                        style: context.bodyMedium!.copyWith(
                                            color: context.colorScheme.onSurface
                                                .withOpacity(.6),
                                            fontSize: 14)),
                                    const SizedBox(height: 5),
                                    Row(children: [
                                      Text(
                                          '${AppRes.formatCurrency((services?.price ?? 0) - AppRes.calculateDiscountByPercentage(services?.price?.toInt() ?? 0, services?.discount?.toInt() ?? 0).toInt())} ${AppRes.currency}',
                                          style: context.bodyMedium!.copyWith(
                                              color:
                                                  context.colorScheme.tertiary,
                                              fontWeight: FontWeight.bold)),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text('-',
                                              style: context.bodyMedium!
                                                  .copyWith(
                                                      color: ColorRes.mortar))),
                                      Text(
                                          AppRes.convertTimeForService(
                                              context,
                                              services?.serviceTime?.toInt() ??
                                                  0),
                                          style: context.bodyMedium!
                                              .copyWith(color: ColorRes.mortar))
                                    ])
                                  ])))
                    ])))));
  }
}
