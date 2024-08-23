import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/salon/salon_details_bloc.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/model/user/salon_user.dart';
import 'package:moli/screens/login/login_option_screen.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/screens/salon/salon_awards_page.dart';
import 'package:moli/screens/salon/salon_details_page.dart';
import 'package:moli/screens/salon/salon_gallery_page.dart';
import 'package:moli/screens/salon/salon_reviews_page.dart';
import 'package:moli/screens/salon/salon_services_page.dart';
import 'package:moli/service/api_service.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/app_res.dart';

class SalonDetailsScreen extends StatefulWidget {
  const SalonDetailsScreen({super.key});

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen> {
  ScrollController scrollController = ScrollController();
  bool toolbarIsExpand = true;
  bool lastToolbarIsExpand = true;
  PageController pageController = PageController();

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
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SalonDetailsBloc(),
        child: Scaffold(body: BlocBuilder<SalonDetailsBloc, SalonDetailsState>(
            builder: (context, state) {
          SalonDetailsBloc salonDetailsBloc = context.read<SalonDetailsBloc>();
          return state is SalonDataFetched
              ? NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      TopBarOfSalonDetails(
                          toolbarIsExpand: toolbarIsExpand,
                          salonData: state.salon.data,
                          userData: salonDetailsBloc.userData)
                    ];
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  body: SafeArea(
                      top: false,
                      child: Column(children: [
                        Container(
                            height: toolbarIsExpand
                                ? 0
                                : MediaQuery.of(context).viewPadding.top +
                                    kToolbarHeight),
                        TabBarOfSalonDetailWidget(onTabChange: (selectedIndex) {
                          pageController.jumpToPage(selectedIndex);
                        }),
                        Expanded(
                            child: PageView(
                                controller: pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                              const SalonDetailsPage(),
                              const SalonServicesPage(),
                              const SalonGalleryPage(),
                              SalonReviewsPage(
                                  salonData: salonDetailsBloc.salonData),
                              const SalonAwardsPage(),
                            ]))
                      ])))
              // : const LoadingImage();
              : const LoadingData();
        })));
  }
}

class TabBarOfSalonDetailWidget extends StatefulWidget {
  final Function(int)? onTabChange;

  const TabBarOfSalonDetailWidget({
    super.key,
    this.onTabChange,
  });

  @override
  State<TabBarOfSalonDetailWidget> createState() =>
      _TabBarOfSalonDetailWidgetState();
}

class _TabBarOfSalonDetailWidgetState extends State<TabBarOfSalonDetailWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      AppLocalizations.of(context)!.details,
      AppLocalizations.of(context)!.services,
      AppLocalizations.of(context)!.gallery,
      AppLocalizations.of(context)!.reviews,
      AppLocalizations.of(context)!.awards
    ];
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(
          categories.length,
          (index) => CustomCircularInkWell(
            onTap: () {
              selectedIndex = index;
              widget.onTabChange?.call(selectedIndex);
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                color: index == selectedIndex
                    ? context.colorScheme.primaryContainer.withOpacity(.8)
                    : ColorRes.smokeWhite,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              margin: EdgeInsets.only(
                right: index == (categories.length - 1) ? 15 : 10,
                left: index == 0 ? 15 : 0,
                bottom: 10,
                top: 10,
              ),
              child: Text(
                categories[index],
                style: context.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w300)
                    .copyWith(
                      fontSize: 15,
                      color: index == selectedIndex
                          ? context.colorScheme.primary
                          : context.colorScheme.outline,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopBarOfSalonDetails extends StatelessWidget {
  TopBarOfSalonDetails({
    super.key,
    required this.toolbarIsExpand,
    this.salonData,
    this.userData,
  });

  final bool toolbarIsExpand;
  final SalonData? salonData;
  final UserData? userData;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      collapsedHeight: 60,
      expandedHeight: 350,
      pinned: true,
      floating: true,
      backgroundColor: ColorRes.transparent,
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
        !toolbarIsExpand ? salonData?.salonName ?? '' : '',
        style: context.titleStyleLarge!.copyWith(fontWeight: FontWeight.w300),
      ),
      titleTextStyle: context.titleStyleLarge!
          .copyWith(fontWeight: FontWeight.w300)
          .copyWith(
            color: ColorRes.mortar,
          ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ToggleImageWidget(
            toolbarIsExpand: toolbarIsExpand,
            isFav: userData?.isFavouriteSalon(salonData?.id?.toInt() ?? 0),
            salonData: salonData,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: BgRoundIconWidget(
            onTap: () async {
              BranchUniversalObject buo = BranchUniversalObject(
                canonicalIdentifier: 'flutter/branch',
                title: salonData?.salonName ?? '',
                imageUrl:
                    '${ConstRes.itemBaseUrl}${salonData?.images?[0].image}',
                contentDescription: salonData?.salonAbout ?? '',
                publiclyIndex: true,
                locallyIndex: true,
                contentMetadata: BranchContentMetaData()
                  ..addCustomMetadata(
                      ConstRes.salonId_, salonData?.id?.toInt() ?? -1),
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
                  subject: 'Look ${salonData?.salonName}',
                );
              } else {}
            },
            icon: Icons.share_sharp,
            imagePadding: 8,
            iconColor: !toolbarIsExpand ? ColorRes.mortar : ColorRes.white,
            bgColor: !toolbarIsExpand
                ? ColorRes.smokeWhite1
                : ColorRes.lavender.withOpacity(0.5),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: SizedBox(
          height: 350,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: PageView(
                      physics: const BouncingScrollPhysics(),
                      controller: pageController,
                      children: List<Widget>.generate(
                          salonData?.images?.length ?? 0, (index) {
                        return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                '${ConstRes.itemBaseUrl}${salonData?.images?[index].image}',
                            placeholder: (context, url) => const Loading(),
                            errorWidget: errorBuilderForImage);

                        // FadeInImage.assetNetwork(
                        //   placeholder: 'asset/loading.gif',
                        //   width: double.infinity,
                        //   image:
                        //       '${ConstRes.itemBaseUrl}${salonData?.images?[index].image}',
                        //   imageErrorBuilder: errorBuilderForImage,
                        //   placeholderErrorBuilder: loadingImage,
                        //   fit: BoxFit.cover,
                        // );
                      }),
                    ),
                  ),
                  Container(
                    height: 100,
                  ),
                ],
              ),
              Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 15, top: 20, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              '${salonData?.salonName}',
                              style: context.titleStyleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${salonData?.salonAddress}',
                                  style: context.bodyMedium!.copyWith(
                                      color: context.bodyMedium!.color!
                                          .withOpacity(0.5)),
                                ),
                                const SizedBox(height: 5),
                                Visibility(
                                  visible: true,
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: ColorRes.pumpkin15,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${salonData?.rating?.toStringAsFixed(1)}',
                                              style:
                                                  context.bodyMedium!.copyWith(
                                                color: ColorRes.pumpkin,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(
                                              Icons.star_rounded,
                                              color: ColorRes.pumpkin,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '(${salonData?.reviewsCount ?? 0} ${AppLocalizations.of(context)!.ratings})',
                                        style: context.bodyMedium!.copyWith(
                                          color: context.bodyMedium!.color!
                                              .withOpacity(.5),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: PageIndicator(
                                salon: salonData,
                                pageController: pageController,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 110,
                left: 20,
                child: SizedBox(
                  width: context.sizeDevice.width - 40,
                  height: 35,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      OpenClosedStatusWidget(
                        bgDisable: ColorRes.smokeWhite1,
                        salonData: salonData,
                      ),
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
                        child: Text(
                          AppRes.getGenderTypeInStringFromNumber(
                              context, salonData?.genderServed?.toInt() ?? 0),
                          style: context.bodyMedium!.copyWith(
                            color: ColorRes.white,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: salonData?.topRated == 1,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [ColorRes.pancho, ColorRes.fallow],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!
                                .topRated
                                .toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.bodyMedium!.copyWith(
                              color: ColorRes.white,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isSalonIsOpen(SalonData? salon) {
    int currentDay = DateTime.now().weekday;
    int todayTime = int.parse(
        '${DateTime.now().hour}${DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : DateTime.now().minute}');
    if (salon?.satSunFrom == null ||
        salon?.satSunTo == null ||
        salon?.monFriFrom == null ||
        salon?.monFriTo == null) {
      return false;
    }
    if (currentDay > 5) {
      return int.parse('${salon?.satSunFrom}') < todayTime &&
          int.parse('${salon?.satSunTo}') > todayTime;
    } else {
      return int.parse('${salon?.monFriFrom}') < todayTime &&
          int.parse('${salon?.monFriTo}') > todayTime;
    }
  }
}

class ToggleImageWidget extends StatefulWidget {
  const ToggleImageWidget({
    super.key,
    required this.toolbarIsExpand,
    this.isFav,
    this.salonData,
    this.userData,
  });

  final SalonData? salonData;
  final UserData? userData;
  final bool toolbarIsExpand;
  final bool? isFav;

  @override
  State<ToggleImageWidget> createState() => _ToggleImageWidgetState();
}

class _ToggleImageWidgetState extends State<ToggleImageWidget> {
  bool isFav = false;

  @override
  void initState() {
    isFav = widget.isFav ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgRoundImageWidget(
      onTap: () {
        if (ConstRes.userIdValue == -1) {
          Get.to(() => const LoginOptionScreen());
          return;
        }
        ApiService()
            .editUserDetails(favouriteSalons: widget.salonData?.id?.toString())
            .then((value) {
          isFav = !isFav;
          setState(() {});
        });
      },
      image: isFav ? AssetRes.icFav : AssetRes.icUnFavourite,
      imagePadding: isFav ? 9 : 10,
      imageColor: isFav ? context.colorScheme.primary : ColorRes.mortar,
      bgColor: !widget.toolbarIsExpand
          ? ColorRes.smokeWhite1
          : ColorRes.lavender.withOpacity(0.5),
    );
  }
}

class PageIndicator extends StatefulWidget {
  const PageIndicator({
    super.key,
    required this.salon,
    this.pageController,
  });

  final SalonData? salon;
  final PageController? pageController;

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.pageController?.addListener(() {
      // if (selectedIndex != (widget.pageController?.page?.round() ?? 0)) {
      setState(() {});
      // }
      selectedIndex = widget.pageController?.page?.round() ?? 0;
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: List.generate(widget.salon?.images?.length ?? 0, (index) {
            return Container(
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? ColorRes.smokeWhite
                    : ColorRes.smokeWhite.withOpacity(.3),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              height: 2.5,
              width: 20,
            );
          }),
        ),
      ),
    );
  }
}
