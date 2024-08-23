import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moli/model/bookings/booking.dart';
import 'package:moli/screens/bookingdetail/booking_detail_screen.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class BookingHistoryWidget extends StatelessWidget {
  const BookingHistoryWidget({
    super.key,
    required this.bookings,
    this.onUpdate,
  });
  final List<BookingData> bookings;
  final Function()? onUpdate;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        BookingData bookingData = bookings[index];
        return ItemHistoryBooking(
          bookingData: bookingData,
          onUpdate: onUpdate,
        );
      },
    );
  }
}

class ItemHistoryBooking extends StatelessWidget {
  const ItemHistoryBooking({
    super.key,
    required this.bookingData,
    this.onUpdate,
  });
  final BookingData bookingData;
  final Function()? onUpdate;

  @override
  Widget build(BuildContext context) {
    var curentLoca = Localizations.localeOf(context).languageCode;
    return CustomCircularInkWell(
      onTap: () {
        Get.to(
          () => const BookingDetailsScreen(),
          arguments: bookingData.bookingId,
        )?.then((value) {
          onUpdate?.call();
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, right: 20, left: 20),
        child: Card(
          elevation: 1,
          surfaceTintColor: context.colorScheme.onSurface,
          child: Row(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  clipBehavior: Clip.antiAlias,
                  height: 110,
                  width: 110,
                  child: CachedNetworkImage(
                      imageUrl:
                          '${ConstRes.itemBaseUrl}${bookingData.salonData!.images != null && bookingData.salonData!.images!.isNotEmpty ? bookingData.salonData!.images![0].image : ''}',
                      placeholder: (context, url) => const Loading(),
                      errorWidget: errorBuilderForImage,
                      fit: BoxFit.cover)),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 10,
                    right: 15,
                    left: 15,
                  ),
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bookingData.salonData?.salonName ?? '',
                        style: context.titleStyleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        bookingData.salonData?.salonAddress ?? '',
                        style: context.bodyMedium!.copyWith(
                          color: context.bodyMedium!.color!.withOpacity(.4),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${AppRes.formatDate(AppRes.parseDate(bookingData.date ?? '', pattern: 'yyyy-MM-dd', isUtc: false, locale: curentLoca), pattern: 'dd MMM, yyyy - EE', isUtc: false, locale: curentLoca)} - ${AppRes.convert24HoursInto12Hours(bookingData.time, locale: curentLoca)}',
                        style: context.bodyMedium!.copyWith(
                          color: context.colorScheme.outline,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: double.infinity,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppRes.getTextColorByStatus(
                              bookingData.status?.toInt() ?? 0)
                          .withOpacity(.2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      AppRes.getTextByStatus(bookingData.status?.toInt() ?? 0),
                      style: context.bodyMedium!.copyWith(
                        color: AppRes.getTextColorByStatus(
                            bookingData.status?.toInt() ?? 0),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
