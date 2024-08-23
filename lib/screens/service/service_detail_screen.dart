import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/service/service_details_bloc.dart';
import 'package:moli/model/service/services.dart';
import 'package:moli/model/service/services_details.dart';
import 'package:moli/model/user/salon_user.dart';
import 'package:moli/screens/booking/confirm_booking.dart';
import 'package:moli/screens/fav/salon_screen.dart';
import 'package:moli/screens/login/login_option_screen.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/service/api_service.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';
import 'package:share_plus/share_plus.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  ScrollController scrollController = ScrollController();
  bool toolbarIsExpand = true;
  bool lastToolbarIsExpand = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      toolbarIsExpand = !(scrollController.offset >=
          scrollController.position.maxScrollExtent - 120);
      if (lastToolbarIsExpand != toolbarIsExpand) {
        lastToolbarIsExpand = toolbarIsExpand;
        if (!lastToolbarIsExpand) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceDetailsBloc(),
      child: Scaffold(
        body: BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
          builder: (context, state) {
            ServiceDetails? serviceDetails =
                state is ServiceDetailsDataFoundState
                    ? state.serviceDetails
                    : null;
            ServiceDetailsBloc serviceDetailsBloc =
                context.read<ServiceDetailsBloc>();
            return NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  TopBarOfServiceDetails(
                    toolbarIsExpand: toolbarIsExpand,
                    serviceDetails: serviceDetails,
                    userData: serviceDetailsBloc.userData,
                  ),
                ];
              },
              physics: const NeverScrollableScrollPhysics(),
              body: state is ServiceDetailsDataFoundState
                  ? SafeArea(
                      top: false,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        margin: EdgeInsets.only(
                          top: toolbarIsExpand
                              ? 0
                              : MediaQuery.of(context).viewPadding.top +
                                  kToolbarHeight,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      serviceDetails?.data?.about ?? '',
                                      style: context.bodyMedium!.copyWith(
                                        color: context.colorScheme.outline,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.offeredBy,
                                      style: context.bodyMedium,
                                    ),
                                    ItemSalon(
                                      salonData: serviceDetails?.data?.salon,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 55,
                              width: double.infinity,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.red),
                                  shape: WidgetStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                  overlayColor: WidgetStateProperty.all(
                                      ColorRes.transparent),
                                ),
                                onPressed: () {
                                  if (ConstRes.userIdValue == -1) {
                                    Get.to(() => const LoginOptionScreen());
                                    return;
                                  }
                                  Get.to(() => const ConfirmBookingScreen(),
                                      arguments: {
                                        ConstRes.salonData:
                                            serviceDetails?.data?.salon,
                                        ConstRes.services:
                                            serviceDetailsBloc.selectedServices,
                                      });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.bookService,
                                  style: context.bodyMedium!.copyWith(
                                      color: ColorRes.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      color: ColorRes.smokeWhite1,
                    ),
            );
          },
        ),
      ),
    );
  }
}

class TopBarOfServiceDetails extends StatelessWidget {
  final ServiceDetails? serviceDetails;
  final bool toolbarIsExpand;
  final UserData? userData;

  const TopBarOfServiceDetails({
    super.key,
    required this.toolbarIsExpand,
    this.serviceDetails,
    this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      collapsedHeight: 60,
      expandedHeight: MediaQuery.of(context).size.width + 40,
      pinned: true,
      floating: true,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BgRoundIconWidget(
          icon: Icons.arrow_back_ios_new_outlined,
          imagePadding: 6,
          iconColor: !toolbarIsExpand ? ColorRes.mortar : ColorRes.white,
          bgColor: !toolbarIsExpand
              ? ColorRes.smokeWhite1
              : ColorRes.lavender.withOpacity(0.5),
          onTap: () => Get.back(),
        ),
      ),
      elevation: 0,
      title: Text(
        !toolbarIsExpand ? (serviceDetails?.data?.title ?? '') : '',
        style: context.bodyMedium!.copyWith(
            fontWeight: FontWeight.w300,
            color: context.colorScheme.outline,
            fontSize: 18),
      ),
      titleTextStyle: context.bodyMedium!.copyWith(
          fontWeight: FontWeight.w300, color: context.colorScheme.outline),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ToggleImageWidget(
            toolbarIsExpand: toolbarIsExpand,
            isFav: userData
                ?.isFavouriteService(serviceDetails?.data?.id?.toInt() ?? 0),
            serviceData: serviceDetails?.data,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: BgRoundImageWidget(
            onTap: () async {
              BranchUniversalObject buo = BranchUniversalObject(
                canonicalIdentifier: 'flutter/branch',
                title: serviceDetails?.data?.title ?? '',
                imageUrl:
                    '${ConstRes.itemBaseUrl}${serviceDetails?.data?.images?[0].image}',
                contentDescription: serviceDetails?.data?.about ?? '',
                publiclyIndex: true,
                locallyIndex: true,
                contentMetadata: BranchContentMetaData()
                  ..addCustomMetadata(ConstRes.serviceId,
                      serviceDetails?.data?.id?.toInt() ?? -1),
              );
              BranchLinkProperties lp = BranchLinkProperties(
                  channel: 'facebook',
                  feature: 'sharing',
                  stage: 'new share',
                  tags: ['one', 'two', 'three']);
              BranchResponse response = await FlutterBranchSdk.getShortUrl(
                  buo: buo, linkProperties: lp);
              if (response.success) {
                Share.share(
                  'Check out this Profile ${response.result}',
                  subject: 'Look ${serviceDetails?.data?.title}',
                );
              } else {}
            },
            image: AssetRes.icShare,
            imagePadding: 8,
            imageColor: !toolbarIsExpand ? ColorRes.mortar : ColorRes.white,
            bgColor: !toolbarIsExpand
                ? ColorRes.smokeWhite1
                : ColorRes.lavender.withOpacity(0.5),
          ),
        ),
      ],
      flexibleSpace: serviceDetails == null
          ? const LoadingData(
              color: ColorRes.smokeWhite1,
            )
          : FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: SizedBox(
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: PageView(
                        children: List<Widget>.generate(
                            serviceDetails?.data?.images?.length ?? 0, (index) {
                          return CachedNetworkImage(
                              imageUrl:
                                  '${ConstRes.itemBaseUrl}${serviceDetails?.data?.images?[index].image}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Loading(),
                              errorWidget: errorBuilderForImage);

                          // FadeInImage.assetNetwork(
                          //   placeholder: '1',
                          //   width: double.infinity,
                          //   image:

                          //   imageErrorBuilder: errorBuilderForImage,
                          //   placeholderErrorBuilder: loadingImage,
                          // );
                        }),
                      ),
                    ),
                    Column(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            color: context.colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 30, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    serviceDetails?.data?.title ?? '',
                                    style: context.titleStyleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${AppLocalizations.of(context)!.by} ${serviceDetails?.data?.salon?.salonName ?? ''}',
                                    style: context.bodyMedium!.copyWith(
                                        fontSize: 16,
                                        color: context.bodyMedium!.color!
                                            .withOpacity(.5)),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        ' ${AppRes.formatCurrency((serviceDetails?.data?.price ?? 0) - AppRes.calculateDiscountByPercentage(serviceDetails?.data?.price?.toInt() ?? 0, serviceDetails?.data?.discount?.toInt() ?? 0).toInt())} ${AppRes.currency}',
                                        style: context.bodyMedium!.copyWith(
                                            color: context.colorScheme.tertiary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24),
                                      ),
                                      const SizedBox(width: 10),
                                      Visibility(
                                        visible: serviceDetails
                                                    ?.data?.discount !=
                                                null &&
                                            serviceDetails?.data?.discount != 0,
                                        child: Text(
                                          '${AppRes.formatCurrency(serviceDetails?.data?.price ?? 0)} ${AppRes.currency}',
                                          style: context.bodyMedium!.copyWith(
                                            color: context.colorScheme.tertiary
                                                .withOpacity(.5),
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Visibility(
                                        visible: serviceDetails
                                                    ?.data?.discount !=
                                                null &&
                                            serviceDetails?.data?.discount != 0,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: ColorRes.pumpkin15,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              const Image(
                                                image:
                                                    AssetImage(AssetRes.icTag),
                                                color: ColorRes.pumpkin,
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '-${serviceDetails?.data?.discount}%',
                                                style: context.bodyMedium!
                                                    .copyWith(
                                                  color: ColorRes.pumpkin,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 118,
                      left: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              AppRes.getGenderTypeInStringFromNumber(
                                  context, serviceDetails?.data?.gender ?? 0),
                              style: context.bodyMedium!.copyWith(
                                color: ColorRes.white,
                                letterSpacing: 2,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            child: Text(
                              AppRes.convertTimeForService(context,
                                  serviceDetails?.data?.serviceTime ?? 0),
                              style: context.bodyMedium!.copyWith(
                                color: ColorRes.white,
                                letterSpacing: 1,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ToggleImageWidget extends StatefulWidget {
  const ToggleImageWidget({
    super.key,
    required this.toolbarIsExpand,
    this.isFav,
    this.serviceData,
    this.userData,
  });

  final ServiceData? serviceData;
  final UserData? userData;
  final bool toolbarIsExpand;
  final bool? isFav;

  @override
  State<ToggleImageWidget> createState() => _ToggleImageWidgetState();
}

class _ToggleImageWidgetState extends State<ToggleImageWidget> {
  bool? isFav;

  @override
  Widget build(BuildContext context) {
    if (widget.isFav != null && isFav == null) {
      isFav ??= widget.isFav ?? false;
    }
    return BgRoundImageWidget(
      onTap: () {
        if (ConstRes.userIdValue == -1) {
          Get.to(() => const LoginOptionScreen());
          return;
        }
        ApiService()
            .editUserDetails(
                favouriteServices: widget.serviceData?.id?.toString())
            .then((value) {});
        isFav = !isFav!;
        setState(() {});
      },
      image:
          (isFav != null && isFav!) ? AssetRes.icFav : AssetRes.icUnFavourite,
      imagePadding: (isFav != null && isFav!) ? 9 : 10,
      imageColor: (isFav != null && isFav!)
          ? context.colorScheme.primary
          : ColorRes.mortar1,
      bgColor: !widget.toolbarIsExpand
          ? ColorRes.smokeWhite1
          : ColorRes.lavender.withOpacity(0.5),
    );
  }
}
