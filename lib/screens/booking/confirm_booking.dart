import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:moli/bloc/bookings/bookings_bloc.dart';
import 'package:moli/bloc/confirmbooking/confirm_booking_bloc.dart';
import 'package:moli/model/slot/slot.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class ConfirmBookingScreen extends StatelessWidget {
  const ConfirmBookingScreen({super.key});

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
                                  style: context.bodyMedium!.copyWith(
                                    fontSize: 16,
                                    color: context.colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  bookingsBloc.salonData?.salonName ?? '',
                                  style: context.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  bookingsBloc.salonData?.salonAddress ?? '',
                                  style: context.bodyMedium!.copyWith(
                                      color: context.colorScheme.outline),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.selectDate,
                                      style: context.bodyMedium!.copyWith(
                                        fontSize: 16,
                                        color: context.colorScheme.outline,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${AppRes.convertMonthNumberToName(context, bookingsBloc.month)} ${bookingsBloc.year}',
                                      style: context.bodyMedium!.copyWith(
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
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
                                                ? context.colorScheme.primary
                                                : context.colorScheme.surface,
                                            border: Border.all(
                                                color: isSelected
                                                    ? context.colorScheme
                                                        .primaryContainer
                                                    : context
                                                        .colorScheme.outline
                                                        .withOpacity(.3)),
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
                                                  style: context.bodyMedium!
                                                      .copyWith(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : context.colorScheme
                                                            .outline,
                                                    fontSize: 12,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                                Text(
                                                  day.day.toString(),
                                                  style: context.bodyMedium!
                                                      .copyWith(
                                                    fontSize: 20,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : context.colorScheme
                                                            .outline,
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
                                  style: context.bodyMedium!.copyWith(
                                    fontSize: 16,
                                    color: context.colorScheme.outline,
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
                                          ? Card(
                                              elevation: 1,
                                              surfaceTintColor:
                                                  context.colorScheme.onSurface,
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .noSlotsAvailable,
                                                  style: context.bodyMedium!
                                                      .copyWith(
                                                    color: context
                                                        .bodyMedium!.color!
                                                        .withOpacity(0.8),
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
                                                                  slotData.time
                                                                  // curentLocale
                                                                  )),
                                                      minute: int.parse(
                                                        AppRes.getMinFromTime(AppRes
                                                            .convert24HoursInto12Hours(
                                                                slotData.time
                                                                // curentLocale
                                                                )),
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
                                                          border: Border.all(
                                                              color: slotData
                                                                          .time ==
                                                                      selectedTime
                                                                  ? context
                                                                      .colorScheme
                                                                      .primaryContainer
                                                                  : context
                                                                      .colorScheme
                                                                      .outline
                                                                      .withOpacity(
                                                                          .3)),
                                                          color: slotData
                                                                      .time ==
                                                                  selectedTime
                                                              ? context
                                                                  .colorScheme
                                                                  .primary
                                                              : context
                                                                  .colorScheme
                                                                  .surface,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .only(right: 8),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          AppRes.convert24HoursInto12Hours(
                                                              slotData.time,
                                                              locale:
                                                                  curentLocale),
                                                          style: context
                                                              .bodyMedium!
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: slotData
                                                                        .time ==
                                                                    selectedTime
                                                                ? Colors.white
                                                                : isShowDisable
                                                                    ? context
                                                                        .colorScheme
                                                                        .outline
                                                                    : context
                                                                        .colorScheme
                                                                        .outline,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        isShowDisable
                                                            ? AppLocalizations
                                                                    .of(context)!
                                                                .notAvailable
                                                            : '${slotData.remainSlot} ${AppLocalizations.of(context)!.slotsAvailable}',
                                                        style: context
                                                            .bodyMedium!
                                                            .copyWith(
                                                          color: isShowDisable
                                                              ? Colors.red
                                                              : Colors.green,
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
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!.services,
                                  style: context.bodyMedium!.copyWith(
                                    fontSize: 16,
                                    color: context.colorScheme.outline,
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
                                      ' ${AppRes.formatCurrency(bookingsBloc.totalRates())} ${AppRes.currency}',
                                      style: context.bodyLarge!.copyWith(
                                          color: context.colorScheme.tertiary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.subTotal,
                                      style: context.bodyMedium!.copyWith(
                                        color: context.colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 55,
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
                                          Colors.transparent),
                                    ),
                                    onPressed: () {
                                      bookingsBloc.clickOnMakePayment();
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .makePayment,
                                        style: context.bodyMedium!.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
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
    super.key,
    this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      surfaceTintColor: context.colorScheme.onSurface,
      margin: const EdgeInsets.symmetric(vertical: 8),
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
                      style: context.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${(AppRes.formatCurrency((service?.price ?? 0) - AppRes.calculateDiscountByPercentage(service?.price?.toInt() ?? 0, service?.discount?.toInt() ?? 0).toInt()))} ${AppRes.currency}',
                                  style: context.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: context.colorScheme.tertiary,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    '-',
                                    style: context.bodyMedium!.copyWith(
                                        color: context.colorScheme.outline),
                                  ),
                                ),
                                Text(
                                  AppRes.convertTimeForService(context,
                                      service?.serviceTime?.toInt() ?? 0),
                                  style: context.bodyMedium!.copyWith(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              AppRes.getGenderTypeInStringFromNumber(
                                  context, service?.gender?.toInt() ?? 0),
                              style: context.bodyMedium!.copyWith(
                                color: context.colorScheme.outline,
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
                          bgColor: context.colorScheme.primary,
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
