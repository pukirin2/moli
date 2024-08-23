import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moli/bloc/bookinghistory/booking_history_bloc.dart';
import 'package:moli/screens/booking/history_widget.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class MyBookingScreen extends StatelessWidget {
  final Function()? onMenuClick;

  const MyBookingScreen({super.key, this.onMenuClick});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingHistoryBloc(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  BgRoundIconWidget(
                    icon: Icons.menu_open_sharp,
                    onTap: onMenuClick,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocalizations.of(context)!.myBookings,
                    style: context.bodyMedium!.copyWith(
                      fontSize: 20,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
              builder: (context, state) {
                BookingHistoryBloc bookingHistoryBloc =
                    context.read<BookingHistoryBloc>();
                return state is BookingHistoryInitial
                    ? const LoadingData()
                    : bookingHistoryBloc.bookings.isEmpty
                        ? const Center(child: DataNotFound())
                        : SingleChildScrollView(
                            controller: bookingHistoryBloc.scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BookingHistoryWidget(
                                  bookings: bookingHistoryBloc.bookings,
                                  onUpdate: bookingHistoryBloc.updateData,
                                ),
                              ],
                            ),
                          );
              },
            ),
          ),
        ],
      ),
    );
  }
}
