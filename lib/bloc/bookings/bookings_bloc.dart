import 'package:moli/model/bookings/booking.dart';
import 'package:moli/model/slot/slot.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/payment/make_payment_screen.dart';
import 'package:moli/service/api_service.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  BookingsBloc() : super(BookingsInitial()) {
    on<FetchBookingsArgumentsEvent>((event, emit) async {
      Map<String, dynamic> map = Get.arguments;
      if (salonData == null) {
        salonData = map[ConstRes.salonData];
        services = map[ConstRes.services];
      }
      if (day != lastDay) {
        lastDay = day;
        selectedTime = null;
        emit(BookingsInitial());
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

      emit(BookingArgumentsFetchedState());
    });
    add(FetchBookingsArgumentsEvent());
  }

  SalonData? salonData;
  List<Services> services = [];
  List<SlotData> slots = [];
  DateTime? selectedDate = DateTime.now();
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

  void clickOnMakePayment() {
    if (selectedDate == null) {
      AppRes.showSnackBar(
          AppLocalizations.of(Get.context!)!.pleaseSelectDate, false);
      return;
    }

    if (selectedTime == null) {
      AppRes.showSnackBar(
          AppLocalizations.of(Get.context!)!.pleaseSelectTime, false);
      return;
    }
    Get.to(
      () => const MakePaymentScreen(),
      arguments: {
        ConstRes.salonData: salonData,
        ConstRes.services: services,
        ConstRes.date: selectedDate,
        ConstRes.time: selectedTime,
      },
    );
  }

  void removeService(int id) {
    if (services.length > 1) {
      for (Services? service in services) {
        if (service != null && service.id == id) {
          services.remove(service);
          break;
        }
      }
    }
    add(FetchBookingsArgumentsEvent());
  }

  int totalRates() {
    int totalPrice = 0;
    for (Services? service in services) {
      if (service != null) {
        totalPrice = totalPrice +
            ((service.price?.toInt() ?? 0) -
                AppRes.calculateDiscountByPercentage(
                        service.price?.toInt() ?? 0,
                        service.discount?.toInt() ?? 0)
                    .toInt());
      }
    }
    return totalPrice;
  }

  void onClickCalenderDay(DateTime day, BookingsBloc bookingsBloc) {
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
    bookingsBloc.add(FetchBookingsArgumentsEvent());
  }
}
