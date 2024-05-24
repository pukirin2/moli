import 'package:cached_network_image/cached_network_image.dart';
import 'package:moli/bloc/bookings/bookings_bloc.dart';
import 'package:moli/bloc/confirmbooking/confirm_booking_bloc.dart';
import 'package:moli/model/slot/slot.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ConfirmBookingScreen extends StatelessWidget {
  const ConfirmBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var curentLocale = Localizations.localeOf(context).languageCode;
    return BlocProvider(
      create: (context) => BookingsBloc(),
      child: Scaffold(
        body: Column(
          children: [
            ToolBarWidget(
              title: AppLocalizations.of(context)!.confirmBooking,
            ),
            Expanded(
              child: BlocBuilder<BookingsBloc, BookingsState>(
                builder: (context, state) {
                  BookingsBloc bookingsBloc = context.read<BookingsBloc>();

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.salon,
                                  style: kLightWhiteTextStyle.copyWith(
                                    fontSize: 16,
                                    color: ColorRes.empress,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  bookingsBloc.salonData?.salonName ?? '',
                                  style: kBoldThemeTextStyle,
                                ),
                                Text(
                                  bookingsBloc.salonData?.salonAddress ?? '',
                                  style: kThinWhiteTextStyle.copyWith(
                                    color: ColorRes.titleText,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.selectDate,
                                      style: kLightWhiteTextStyle.copyWith(
                                        fontSize: 16,
                                        color: ColorRes.empress,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${AppRes.convertMonthNumberToName(context, bookingsBloc.month)} ${bookingsBloc.year}',
                                      style: kMediumTextStyle.copyWith(
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    itemCount: bookingsBloc.days.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      DateTime day = bookingsBloc.days[index];
                                      bool isSelected =
                                          day.day == bookingsBloc.day &&
                                              day.month == bookingsBloc.month;

                                      return CustomCircularInkWell(
                                        onTap: () {
                                          bookingsBloc.onClickCalenderDay(
                                              day, bookingsBloc);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? ColorRes.themeColor
                                                : ColorRes.smokeWhite,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1.1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  DateFormat('EE', curentLocale)
                                                      .format(day)
                                                      .toUpperCase(),
                                                  style: kRegularThemeTextStyle
                                                      .copyWith(
                                                    color: isSelected
                                                        ? ColorRes.white
                                                        : ColorRes.charcoal,
                                                    fontSize: 12,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                                Text(
                                                  day.day.toString(),
                                                  style: kBoldThemeTextStyle
                                                      .copyWith(
                                                    fontSize: 20,
                                                    color: isSelected
                                                        ? ColorRes.white
                                                        : ColorRes.charcoal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.selectTime,
                                  style: kLightWhiteTextStyle.copyWith(
                                    fontSize: 16,
                                    color: ColorRes.empress,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 60,
                                  child: state is BookingsInitial
                                      ? const Center(
                                          child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: LoadingData(),
                                          ),
                                        )
                                      : bookingsBloc.slots.isEmpty
                                          ? Container(
                                              decoration: const BoxDecoration(
                                                color: ColorRes.smokeWhite,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .noSlotsAvailable,
                                                  style:
                                                      kRegularEmpressTextStyle
                                                          .copyWith(
                                                    color: ColorRes.darkGray,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount:
                                                  bookingsBloc.slots.length,
                                              padding: const EdgeInsets.all(0),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                SlotData? slotData =
                                                    bookingsBloc.slots[index];
                                                int hour = bookingsBloc
                                                        .selectedTime?.hour ??
                                                    0;
                                                int min = bookingsBloc
                                                        .selectedTime?.minute ??
                                                    0;
                                                String selectedTime =
                                                    '${hour < 10 ? '0$hour' : '$hour'}${min < 10 ? '0$min' : '$min'}';

                                                var dataTime = slotData.time;
                                                var currentTimeData =
                                                    '${0.convert2Digits(TimeOfDay.now().hour)}${0.convert2Digits(TimeOfDay.now().minute)}';

                                                bool isShowDisable = slotData
                                                            .remainSlot ==
                                                        0 ||
                                                    (bookingsBloc.selectedDate
                                                                ?.day ==
                                                            DateTime.now()
                                                                .day &&
                                                        dataTime!.compareTo(
                                                                currentTimeData) <
                                                            1);

                                                return CustomCircularInkWell(
                                                  onTap: () {
                                                    if (isShowDisable) {
                                                      return;
                                                    }
                                                    bookingsBloc.selectedTime =
                                                        TimeOfDay(
                                                      hour: AppRes
                                                          .getHourFromTime(AppRes
                                                              .convert24HoursInto12Hours(
                                                                  slotData.time,
                                                                  curentLocale)),
                                                      minute: int.parse(
                                                        AppRes.getMinFromTime(AppRes
                                                            .convert24HoursInto12Hours(
                                                                slotData.time,
                                                                curentLocale)),
                                                      ),
                                                    );
                                                    bookingsBloc.add(
                                                        FetchBookingsArgumentsEvent());
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 95,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: slotData
                                                                      .time ==
                                                                  selectedTime
                                                              ? ColorRes
                                                                  .themeColor
                                                              : ColorRes
                                                                  .smokeWhite,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(5),
                                                          ),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .only(right: 8),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          AppRes
                                                              .convert24HoursInto12Hours(
                                                                  slotData.time,
                                                                  curentLocale),
                                                          style:
                                                              kBoldWhiteTextStyle
                                                                  .copyWith(
                                                            color: slotData
                                                                        .time ==
                                                                    selectedTime
                                                                ? ColorRes.white
                                                                : isShowDisable
                                                                    ? ColorRes
                                                                        .darkGray
                                                                    : ColorRes
                                                                        .charcoal,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        isShowDisable
                                                            ? AppLocalizations
                                                                    .of(context)!
                                                                .notAvailable
                                                            : '${slotData.remainSlot} ${AppLocalizations.of(context)!.slotsAvailable}',
                                                        style: kRegularTextStyle
                                                            .copyWith(
                                                          color: isShowDisable
                                                              ? ColorRes
                                                                  .darkGray
                                                              : ColorRes
                                                                  .islamicGreen,
                                                          fontSize: 13,
                                                          letterSpacing: .4,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.services,
                                  style: kLightWhiteTextStyle.copyWith(
                                    fontSize: 16,
                                    color: ColorRes.empress,
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: bookingsBloc.services.length,
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    Services? service =
                                        bookingsBloc.services[index];
                                    return ItemConfirmService(
                                      service: service,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppRes.currency}${bookingsBloc.totalRates()}',
                                      style: kBoldThemeTextStyle,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.subTotal,
                                      style: kLightWhiteTextStyle.copyWith(
                                        color: ColorRes.empress,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 55,
                                  child: TextButton(
                                    style: kButtonThemeStyle,
                                    onPressed: () {
                                      bookingsBloc.clickOnMakePayment();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.makePayment,
                                      style: kRegularWhiteTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemConfirmService extends StatelessWidget {
  final Services? service;

  const ItemConfirmService({
    Key? key,
    this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: ColorRes.smokeWhite2,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Row(
          children: [
            SizedBox(
                width: 130,
                height: 110,
                child: CachedNetworkImage(
                    imageUrl:
                        '${ConstRes.itemBaseUrl}${service != null && service?.images != null && service!.images!.isNotEmpty ? service!.images![0].image : ''}',
                    placeholder: (context, url) => const Loading(),
                    errorWidget: errorBuilderForImage,
                    fit: BoxFit.cover)),
            Expanded(
              child: Container(
                color: ColorRes.smokeWhite2,
                padding: const EdgeInsets.only(
                  bottom: 5,
                  right: 10,
                  left: 10,
                ),
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service?.title ?? '',
                      style: kSemiBoldTextStyle.copyWith(
                        color: ColorRes.nero,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${AppRes.currency}${(service?.price?.toInt() ?? 0) - AppRes.calculateDiscountByPercentage(service?.price?.toInt() ?? 0, service?.discount?.toInt() ?? 0).toInt()}',
                                  style: kBoldThemeTextStyle.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    '-',
                                    style: kThinWhiteTextStyle.copyWith(
                                      color: ColorRes.mortar,
                                    ),
                                  ),
                                ),
                                Text(
                                  AppRes.convertTimeForService(context,
                                      service?.serviceTime?.toInt() ?? 0),
                                  style: kThinWhiteTextStyle.copyWith(
                                    color: ColorRes.mortar,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              AppRes.getGenderTypeInStringFromNumber(
                                  context, service?.gender?.toInt() ?? 0),
                              style: kLightWhiteTextStyle.copyWith(
                                color: ColorRes.empress,
                                fontSize: 12,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        BgRoundImageWidget(
                          onTap: () {
                            BookingsBloc bookingBloc =
                                context.read<BookingsBloc>();
                            bookingBloc
                                .removeService(service?.id?.toInt() ?? -1);
                          },
                          image: AssetRes.icMinus,
                          imagePadding: 11,
                          bgColor: ColorRes.monaLisa,
                          height: 35,
                          width: 35,
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
    );
  }
}
