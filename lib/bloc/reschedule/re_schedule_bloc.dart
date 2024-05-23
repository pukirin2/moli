import 'package:moli/bloc/confirmbooking/confirm_booking_bloc.dart';
import 'package:moli/model/bookings/booking.dart';
import 'package:moli/model/bookings/booking_details.dart';
import 'package:moli/model/slot/slot.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/service/api_service.dart';
import 'package:moli/utils/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

part 're_schedule_event.dart';

part 're_schedule_state.dart';

class ReScheduleBloc extends Bloc<ReScheduleEvent, ReScheduleState> {
  ReScheduleBloc() : super(ReScheduleInitial()) {
    on<UpdateDataEvent>((event, emit) async {
      // selectedTime = TimeOfDay(
      //     hour: int.parse(bookingDetails?.data?.time?.substring(0, 2) ?? '0'),
      //     minute:
      //         int.parse(bookingDetails?.data?.time?.substring(2, 4) ?? '0'));
      // selectedDate = AppRes.parseDate(
      //   bookingDetails?.data?.date ?? '',
      //   pattern: 'yyyy-MM-dd',
      //   isUtc: false,
      // );
      salonData ??= bookingDetails?.data?.salonData;
      // year = selectedDate?.year ?? DateTime.now().year;
      // month = selectedDate?.month ?? DateTime.now().month;
      // day = selectedDate?.day ?? DateTime.now().day;
      // weekDay = selectedDate?.weekday ?? DateTime.now().weekday;

      if (day != lastDay) {
        lastDay = day;
        selectedTime = null;
        emit(ReScheduleInitial());
        Booking booking =
            await ApiService().fetchAcceptedPendingBookingsOfSalonByDate(
          salonData?.id?.toInt() ?? -1,
          '$year-$month-$day',
        );
        slots = salonData?.slots?.where((element) {
              return element.weekday == weekDay;
            }).toList() ??
            [];
        for (SlotData slotData in slots) {
          int slotBooked = 0;
          for (BookingData bookingData in booking.data ?? []) {
            if (bookingData.time == slotData.time) {
              slotBooked++;
            }
          }
          slotData.calculateBookingLimit(slotBooked);
        }
      }
      emit(UpdateReScheduleDataState());
    });
  }

  BookingDetails? bookingDetails;
  SalonData? salonData;
  List<Services> services = [];
  List<SlotData> slots = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;
  int lastDay = -1;
  int weekDay = DateTime.now().weekday;
  List<DateTime> days = List<DateTime>.generate(
      AppRes.totalDays,
      (i) => DateTime.utc(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ).add(Duration(hours: 24 * i)));

  void onSubmitClick() async {
    AppRes.showCustomLoader();
    await ApiService().rescheduleBooking(
      bookingDetails?.data?.bookingId ?? '',
      AppRes.formatDate(selectedDate ?? DateTime.now(), pattern: 'yyyy-MM-dd'),
      '${0.convert2Digits(selectedTime?.hour)}${0.convert2Digits(selectedTime?.minute)}',
    );
    AppRes.hideCustomLoaderWithBack();
  }

  void onClickCalenderDay(DateTime day, ReScheduleBloc bookingsBloc) {
    int differenceDay = day.difference(DateTime.now()).inDays;

    if (differenceDay < 0 || differenceDay > 90) {
      AppRes.showSnackBar(
          AppLocalizations.of(Get.context!)!
              .youCanMakeBookingsOnlyForTodayOrForThe,
          false);
      return;
    }
    month = day.month;
    this.day = day.day;
    weekDay = day.weekday;
    year = day.year;
    selectedDate = day;
    bookingsBloc.add(UpdateDataEvent());
  }
}
