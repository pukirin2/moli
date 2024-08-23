import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/bookingdetail/booking_detail_bloc.dart';
import 'package:moli/model/bookings/booking.dart';
import 'package:moli/model/setting/setting.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/bookingdetail/add_rating_bottom_sheet.dart';
import 'package:moli/screens/bookingdetail/my_qr_bottom_sheet.dart';
import 'package:moli/screens/bookingdetail/reschedule_bottom_sheet.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool orderIsStart = Random().nextBool();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingDetailBloc(),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 15),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCircularInkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Icon(Icons.arrow_back_rounded,
                              color: context.colorScheme.primary, size: 30)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.bookingDetails,
                                style: context.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                Get.arguments ?? '',
                                style: context.bodySmall!.copyWith(
                                  fontSize: 14,
                                  color: context.colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          BgRoundImageWidget(
                            image: AssetRes.icQrCode,
                            imagePadding: 10,
                            bgColor: ColorRes.smokeWhite1,
                            imageColor: ColorRes.black,
                            onTap: () {
                              Get.bottomSheet(
                                MyQrCodeBottomSheet(
                                  bookingId: Get.arguments ?? '',
                                ),
                                ignoreSafeArea: false,
                                isScrollControlled: true,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<BookingDetailBloc, BookingDetailState>(
              builder: (context, state) {
                var curentLocale = Localizations.localeOf(context).languageCode;
                BookingDetailBloc bookingDetailsBloc =
                    context.read<BookingDetailBloc>();
                BookingData? bookingData =
                    bookingDetailsBloc.bookingDetails?.data;
                return bookingData == null
                    ? const Expanded(
                        child: LoadingData(),
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              color: AppRes.getColorByStatus(
                                  context, bookingData.status?.toInt() ?? 0),
                              child: Text(
                                AppRes.getTextByStatus(
                                    bookingData.status?.toInt() ?? 0),
                                style: context.bodyMedium!.copyWith(
                                  color: AppRes.getTextColorByStatus(
                                      bookingData.status?.toInt() ?? 0),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: bookingData.status == 2 &&
                                          bookingData.isRated != 1,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: ColorRes.pumpkin15,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 18),
                                        margin: const EdgeInsets.only(
                                            left: 15, right: 15, top: 10),
                                        child: Row(
                                          children: [
                                            FittedBox(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .rateThisSaloon,
                                                    style: context.bodyMedium!
                                                        .copyWith(
                                                      color: ColorRes.pumpkin,
                                                    ),
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .shareYourExperienceWithUs,
                                                    style: context.bodySmall!
                                                        .copyWith(
                                                      color: ColorRes.pumpkin,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            FittedBox(
                                              child: CustomCircularInkWell(
                                                onTap: () {
                                                  Get.bottomSheet(
                                                    AddRatingBottomSheet(
                                                        bookingId: bookingData
                                                                .bookingId ??
                                                            ''),
                                                    isScrollControlled: true,
                                                    ignoreSafeArea: false,
                                                  ).then((value) {
                                                    context
                                                        .read<
                                                            BookingDetailBloc>()
                                                        .add(
                                                            FetchBookingDetailEvent());
                                                    setState(() {});
                                                  });
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: ColorRes.pumpkin15,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .rateNow,
                                                    style: context.bodyMedium!
                                                        .copyWith(
                                                      color: ColorRes.pumpkin,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    AspectRatio(
                                      aspectRatio: 1 / .35,
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 15,
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.horizontal(
                                                left: Radius.circular(10),
                                              ),
                                              child: AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          '${ConstRes.itemBaseUrl}${bookingData.salonData?.images != null && bookingData.salonData!.images!.isNotEmpty ? bookingData.salonData?.images![0].image : ''}',
                                                      placeholder:
                                                          (context, url) =>
                                                              const Loading(),
                                                      errorWidget:
                                                          errorBuilderForImage,
                                                      fit: BoxFit.cover)),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                  right: 15,
                                                  left: 15,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        bookingData.salonData
                                                                ?.salonName ??
                                                            '',
                                                        style: context
                                                            .titleStyleLarge!),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        bookingData.salonData
                                                                ?.salonAddress ??
                                                            '',
                                                        style: context
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color: context
                                                                    .colorScheme
                                                                    .outline)),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            ColorRes.pumpkin15,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                      ),
                                                      width: 60,
                                                      height: 26,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            bookingData
                                                                    .salonData
                                                                    ?.rating
                                                                    ?.toStringAsFixed(
                                                                        1) ??
                                                                '',
                                                            style: context
                                                                .bodyMedium!
                                                                .copyWith(
                                                              color: ColorRes
                                                                  .pumpkin,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Icon(
                                                            Icons.star_rounded,
                                                            color: ColorRes
                                                                .pumpkin,
                                                            size: 20,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .date,
                                                          style: context
                                                              .bodyLarge!
                                                              .copyWith(
                                                            color: context
                                                                .colorScheme
                                                                .outline,
                                                          ),
                                                        ),
                                                        Text(
                                                            AppRes.formatDate(
                                                                AppRes.parseDate(
                                                                    bookingData
                                                                            .date ??
                                                                        '',
                                                                    pattern:
                                                                        'yyyy-MM-dd',
                                                                    isUtc:
                                                                        false,
                                                                    locale:
                                                                        curentLocale),
                                                                pattern:
                                                                    'dd MMM, yyyy',
                                                                isUtc: false,
                                                                locale:
                                                                    curentLocale),
                                                            style: context
                                                                .bodyMedium!)
                                                      ]),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .time,
                                                        style: context
                                                            .bodyLarge!
                                                            .copyWith(
                                                          color: context
                                                              .colorScheme
                                                              .outline,
                                                        ),
                                                      ),
                                                      Text(
                                                        AppRes.convert24HoursInto12Hours(
                                                            bookingData.time,
                                                            locale:
                                                                curentLocale),
                                                        style: context
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .duration,
                                                        style: context
                                                            .bodyLarge!
                                                            .copyWith(
                                                                color: context
                                                                    .colorScheme
                                                                    .outline),
                                                      ),
                                                      Text(
                                                        AppRes
                                                            .convertTimeForService(
                                                          context,
                                                          int.parse(bookingData
                                                                  .duration ??
                                                              '0'),
                                                        ),
                                                        style:
                                                            context.bodyMedium!,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 20,
                                                bottom: 10,
                                              ),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .services,
                                                style:
                                                    context.bodyLarge!.copyWith(
                                                  color: context
                                                      .colorScheme.outline,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: List.generate(
                                                  bookingData
                                                          .services?.length ??
                                                      0, (index) {
                                                Services? serviceData =
                                                    bookingData
                                                        .services?[index];
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 5),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          serviceData?.title ??
                                                              '',
                                                          style: context
                                                              .bodyMedium!
                                                              .copyWith(
                                                            fontSize: 16,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${AppRes.formatCurrency((serviceData?.price?.toInt() ?? 0) - AppRes.calculateDiscountByPercentage(serviceData?.price?.toInt() ?? 0, serviceData?.discount?.toInt() ?? 0).toInt())} ${AppRes.currency}',
                                                        style: context
                                                            .bodyMedium!
                                                            .copyWith(
                                                          color: context
                                                              .colorScheme
                                                              .tertiary,
                                                          fontSize: 18,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ),
                                            Visibility(
                                              visible:
                                                  bookingData.isCouponApplied ==
                                                      1,
                                              child: Container(
                                                color: ColorRes.smokeWhite,
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 15),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .couponDiscount,
                                                          style: context
                                                              .bodyMedium!
                                                              .copyWith(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: ColorRes
                                                                .smokeWhite1,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 8,
                                                            vertical: 3,
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 5,
                                                          ),
                                                          child: Text(
                                                            bookingData
                                                                    .getOrderSummary()
                                                                    .coupon
                                                                    ?.coupon
                                                                    ?.toUpperCase() ??
                                                                '',
                                                            style: context
                                                                .bodyMedium!
                                                                .copyWith(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      '-\$${bookingData.getOrderSummary().discountAmount}',
                                                      style: context.bodyMedium!
                                                          .copyWith(
                                                        fontSize: 18,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Divider(
                                                color: context
                                                    .colorScheme.outlineVariant,
                                                height: 1,
                                                thickness: 1,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              padding: const EdgeInsets.only(
                                                  right: 15, left: 15, top: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .subTotal,
                                                    style: context.bodyMedium!
                                                        .copyWith(),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    '${AppRes.formatCurrency(bookingData.getOrderSummary().subtotal ?? 0)} ${AppRes.currency}',
                                                    style: context.bodyMedium!
                                                        .copyWith(
                                                            color: context
                                                                .colorScheme
                                                                .tertiary),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: List.generate(
                                                  bookingData
                                                          .getOrderSummary()
                                                          .taxes
                                                          ?.length ??
                                                      0, (index) {
                                                Taxes tax = bookingData
                                                    .getOrderSummary()
                                                    .taxes![index];
                                                return Container(
                                                  color: ColorRes.smokeWhite,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 5),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        tax.taxTitle ?? '',
                                                        style: context
                                                            .bodyMedium!
                                                            .copyWith(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        '${tax.taxAmount} ${AppRes.currency}',
                                                        style: context
                                                            .bodyMedium!
                                                            .copyWith(
                                                          color: context
                                                              .colorScheme
                                                              .tertiary,
                                                          fontSize: 18,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 15,
                                                  left: 15,
                                                  top: 5,
                                                  bottom: 15),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .payableAmount,
                                                    style: context.bodyMedium!
                                                        .copyWith(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    '${AppRes.formatCurrency(bookingData.getOrderSummary().payableAmount ?? 0)} ${AppRes.currency}',
                                                    style: context.bodyMedium!
                                                        .copyWith(
                                                            fontSize: 18,
                                                            color: context
                                                                .colorScheme
                                                                .tertiary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: bookingData.status == 0 ||
                                          bookingData.status == 1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: CustomCircularInkWell(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    builder: (context) {
                                                      return ReScheduleBottomSheet(
                                                        bookingDetailBloc:
                                                            bookingDetailsBloc,
                                                      );
                                                    },
                                                    context: context,
                                                  ).then((value) {
                                                    context
                                                        .read<
                                                            BookingDetailBloc>()
                                                        .add(
                                                            FetchBookingDetailEvent());
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: ColorRes.smokeWhite2,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .reschedule,
                                                      style: context.bodyMedium!
                                                          .copyWith(
                                                              color: context
                                                                  .colorScheme
                                                                  .outline,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: CustomCircularInkWell(
                                                onTap: () {
                                                  context
                                                      .read<BookingDetailBloc>()
                                                      .cancelBooking();
                                                },
                                                child: Container(
                                                  height: 50,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color:
                                                        ColorRes.bitterSweet10,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .cancel,
                                                      style: context.bodyMedium!
                                                          .copyWith(
                                                        color: ColorRes
                                                            .bitterSweet,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: bookingData.isRated == 1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Card(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .yourReview,
                                                    style: context.bodyMedium),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                RatingBar(
                                                  initialRating: bookingData
                                                          .review?.rating
                                                          ?.toDouble() ??
                                                      0,
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
                                                  itemSize: 30,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  bookingData.review?.comment ??
                                                      '',
                                                  style: context.bodyMedium!
                                                      .copyWith(
                                                    color: context
                                                        .colorScheme.outline,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      );
              },
            ),
            BlocBuilder<BookingDetailBloc, BookingDetailState>(
              builder: (context, state) {
                BookingData? bookingData =
                    context.read<BookingDetailBloc>().bookingDetails?.data;
                return SafeArea(
                  top: false,
                  child: Visibility(
                    visible: bookingData?.status == 1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                    AppLocalizations.of(context)!.completionOtp,
                                    style: context.bodyLarge),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    bookingData?.completionOtp?.toString() ??
                                        '',
                                    style: context.bodyMedium),
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .pleaseProvideThisOtpAtSalonWhenAskedOnlyAfter,
                              style: context.bodyMedium!.copyWith(
                                color: context.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
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
