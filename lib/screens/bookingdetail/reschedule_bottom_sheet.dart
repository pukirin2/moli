import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:moli/bloc/bookingdetail/booking_detail_bloc.dart';
import 'package:moli/bloc/confirmbooking/confirm_booking_bloc.dart';
import 'package:moli/bloc/reschedule/re_schedule_bloc.dart';
import 'package:moli/model/slot/slot.dart';
import 'package:moli/screens/search/filter_bottom_sheet.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class ReScheduleBottomSheet extends StatelessWidget {
  final BookingDetailBloc bookingDetailBloc;

  const ReScheduleBottomSheet({
    super.key,
    required this.bookingDetailBloc,
  });

  @override
  Widget build(BuildContext context) {
    var curentLocale = Localizations.localeOf(context).languageCode;
    return BlocProvider(
      create: (context) => ReScheduleBloc(),
      child: BlocBuilder<ReScheduleBloc, ReScheduleState>(
        builder: (context, state) {
          ReScheduleBloc reScheduleBloc = context.read<ReScheduleBloc>();
          if (reScheduleBloc.bookingDetails == null) {
            reScheduleBloc.bookingDetails = bookingDetailBloc.bookingDetails;
            reScheduleBloc.add(UpdateDataEvent());
          }
          return Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            )),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.reschedule,
                      style: context.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const CloseButtonWidget(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
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
                      '${AppRes.convertMonthNumberToName(context, reScheduleBloc.month)} ${reScheduleBloc.year}',
                      style: context.bodyMedium!.copyWith(
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
                    itemCount: reScheduleBloc.days.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      DateTime day = reScheduleBloc.days[index];
                      bool isSelected = day.day == reScheduleBloc.day &&
                          day.month == reScheduleBloc.month;
                      return CustomCircularInkWell(
                        onTap: () {
                          reScheduleBloc.onClickCalenderDay(
                              context, day, reScheduleBloc);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.colorScheme.primary
                                : ColorRes.smokeWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          child: AspectRatio(
                            aspectRatio: 1 / 1.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('EE').format(day).toUpperCase(),
                                  style: context.bodyMedium!.copyWith(
                                    color: isSelected
                                        ? ColorRes.white
                                        : ColorRes.charcoal,
                                    fontSize: 12,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  day.day.toString(),
                                  style: context.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
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
                  style: context.bodyMedium!.copyWith(
                    fontSize: 16,
                    color: context.colorScheme.outline,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 80,
                  child: state is ReScheduleInitial
                      ? const LoadingData()
                      : reScheduleBloc.slots.isEmpty
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
                                  style: context.bodyMedium!.copyWith(
                                    color: ColorRes.darkGray,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: reScheduleBloc.slots.length,
                              padding: const EdgeInsets.all(0),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                SlotData? slotData =
                                    reScheduleBloc.slots[index];
                                int hour =
                                    reScheduleBloc.selectedTime?.hour ?? 0;
                                int min =
                                    reScheduleBloc.selectedTime?.minute ?? 0;
                                String selectedTime =
                                    '${hour < 10 ? '0$hour' : '$hour'}${min < 10 ? '0$min' : '$min'}';
                                var dataTime = slotData.time;
                                var currentTimeData =
                                    '${0.convert2Digits(TimeOfDay.now().hour)}${0.convert2Digits(TimeOfDay.now().minute)}';
                                var compareDate =
                                    dataTime!.compareTo(currentTimeData);
                                var isShowDisable = slotData.remainSlot == 0 ||
                                    (reScheduleBloc.selectedDate?.day ==
                                            DateTime.now().day &&
                                        compareDate < 1);

                                return CustomCircularInkWell(
                                  onTap: () {
                                    if (isShowDisable) {
                                      return;
                                    }
                                    if (slotData.remainSlot == 0) {
                                      return;
                                    }
                                    reScheduleBloc.selectedTime = TimeOfDay(
                                      hour: AppRes.getHourFromTime(
                                          AppRes.convert24HoursInto12Hours(
                                              slotData.time)),
                                      minute: int.parse(
                                        AppRes.getMinFromTime(
                                            AppRes.convert24HoursInto12Hours(
                                                slotData.time)),
                                      ),
                                    );
                                    reScheduleBloc.add(UpdateDataEvent());
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 95,
                                        decoration: BoxDecoration(
                                          color: slotData.time == selectedTime
                                              ? context.colorScheme.primary
                                              : ColorRes.smokeWhite,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        margin: const EdgeInsets.only(right: 8),
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppRes.convert24HoursInto12Hours(
                                              slotData.time,
                                              locale: curentLocale),
                                          style: context.bodyMedium!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: slotData.time == selectedTime
                                                ? ColorRes.white
                                                : isShowDisable
                                                    ? ColorRes.darkGray
                                                    : ColorRes.charcoal,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        isShowDisable
                                            ? AppLocalizations.of(context)!
                                                .notAvailable
                                            : '${slotData.remainSlot} ${AppLocalizations.of(context)!.slotsAvailable}',
                                        style: context.bodyMedium!.copyWith(
                                          color: isShowDisable
                                              ? ColorRes.darkGray
                                              : ColorRes.islamicGreen,
                                          fontSize: 13,
                                          letterSpacing: .4,
                                        ),
                                      )

                                      // Container(
                                      //   height: 40,
                                      //   width: 95,
                                      //   decoration: BoxDecoration(
                                      //     color: slotData.time == selectedTime
                                      //         ? context.colorScheme.primary
                                      //         : ColorRes.smokeWhite,
                                      //     borderRadius: const BorderRadius.all(
                                      //       Radius.circular(5),
                                      //     ),
                                      //   ),
                                      //   margin: const EdgeInsets.only(
                                      //       right: 8, bottom: 3),
                                      //   alignment: Alignment.center,
                                      //   child: Text(
                                      //     AppRes.convert24HoursInto12Hours(
                                      //         slotData.time,
                                      //         locale: curentLocale),
                                      //     style: kBoldWhiteTextStyle.copyWith(
                                      //       color: slotData.time == selectedTime
                                      //           ? ColorRes.white
                                      //           : slotData.remainSlot == 0
                                      //               ? ColorRes.darkGray
                                      //               : ColorRes.charcoal,
                                      //       fontSize: 16,
                                      //     ),
                                      //   ),
                                      // ),
                                      // Text(
                                      //   slotData.remainSlot == 0
                                      //       ? AppLocalizations.of(context)!
                                      //           .notAvailable
                                      //       : '${slotData.remainSlot} ${AppLocalizations.of(context)!.slotsAvailable}',
                                      //   style: context.bodyMedium.copyWith(
                                      //     color: slotData.remainSlot == 0
                                      //         ? ColorRes.darkGray
                                      //         : ColorRes.islamicGreen,
                                      //     fontSize: 13,
                                      //     letterSpacing: .4,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                      shape: WidgetStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      reScheduleBloc.onSubmitClick();
                    },
                    child: Text(AppLocalizations.of(context)!.submit,
                        style:
                            context.bodyMedium!.copyWith(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onSubmitClick() async {
    // AppRes.showCustomLoader();
    // RestResponse response = await ApiService().rescheduleBooking(
    //   bookingDetailBloc.bookingId ?? '',
    //   AppRes.formatDate(selectedDate ?? DateTime.now(), pattern: 'yyyy-MM-dd'),
    //   '${0.convert2Digits(selectedTime?.hour)}${0.convert2Digits(selectedTime?.minute)}',
    // );
    // AppRes.hideCustomLoaderWithBack();
    // AppRes.showSnackBar(response.message ?? '', response.status ?? false);
  }
}
