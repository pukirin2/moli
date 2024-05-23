import 'package:moli/bloc/bookinghistory/booking_history_bloc.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'history_widget.dart';

class ProfileBookingScreen extends StatelessWidget {
  const ProfileBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingHistoryBloc(),
      child: Scaffold(
        body: Column(
          children: [
            ToolBarWidget(
              title: AppLocalizations.of(context)!.bookings,
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
                                  ),
                                ],
                              ),
                            );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
