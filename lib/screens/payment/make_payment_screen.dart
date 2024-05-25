import 'package:moli/bloc/confirmbooking/confirm_booking_bloc.dart';
import 'package:moli/model/setting/setting.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/payment/coupon_bottom_sheet.dart';
import 'package:moli/screens/payment/recharge_wallet_sheet.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class MakePaymentScreen extends StatelessWidget {
  const MakePaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmBookingBloc(),
      child: Scaffold(
        body: BlocBuilder<ConfirmBookingBloc, ConfirmBookingState>(
          builder: (context, state) {
            var curentLocale = Localizations.localeOf(context).languageCode;
            ConfirmBookingBloc confirmBookingBloc =
                context.read<ConfirmBookingBloc>();
            return Column(
              children: [
                ToolBarWidget(
                  title: AppLocalizations.of(context)!.confirmBooking,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      color: ColorRes.themeColor10,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(
                      '${AppRes.currency}${confirmBookingBloc.salonUser?.data?.wallet?.toString() ?? ''}',
                      style: kSemiBoldThemeTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ColorRes.smokeWhite2,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.date,
                                      style: kLightWhiteTextStyle.copyWith(
                                        color: ColorRes.empress,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      AppRes.formatDate(
                                          confirmBookingBloc.selectedDate ??
                                              DateTime.now(),
                                          pattern: 'dd MMM yyyy',
                                          locale: curentLocale),
                                      style: kRegularThemeTextStyle.copyWith(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.time,
                                      style: kLightWhiteTextStyle.copyWith(
                                        color: ColorRes.empress,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      AppRes.convert24HoursInto12Hours(
                                          confirmBookingBloc.getTime(),
                                          locale: curentLocale),
                                      style: kRegularThemeTextStyle.copyWith(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.duration,
                                      style: kLightWhiteTextStyle.copyWith(
                                        color: ColorRes.empress,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      AppRes.convertTimeForService(
                                          context,
                                          confirmBookingBloc
                                              .getTotalMinOfServices()),
                                      style: kRegularThemeTextStyle.copyWith(
                                        fontSize: 15,
                                      ),
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
                              AppLocalizations.of(context)!.services,
                              style: kLightWhiteTextStyle.copyWith(
                                color: ColorRes.empress,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ListView.builder(
                            itemCount: confirmBookingBloc.services.length,
                            primary: false,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Services? service =
                                  confirmBookingBloc.services[index];
                              return Container(
                                color: ColorRes.smokeWhite,
                                margin: const EdgeInsets.only(bottom: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        service.title ?? ' ',
                                        style: kRegularTextStyle.copyWith(
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${AppRes.currency}${AppRes.formatCurrency((service.price?.toInt() ?? 0) - AppRes.calculateDiscountByPercentage(service.price?.toInt() ?? 0, service.discount?.toInt() ?? 0).toInt())}',
                                      style: kSemiBoldThemeTextStyle.copyWith(
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          Visibility(
                            visible: confirmBookingBloc.coupon != null,
                            child: Container(
                              color: ColorRes.smokeWhite,
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .couponDiscount,
                                        style: kRegularTextStyle.copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: ColorRes.smokeWhite1,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              (confirmBookingBloc
                                                          .coupon?.coupon ??
                                                      '')
                                                  .toUpperCase(),
                                              style:
                                                  kBoldThemeTextStyle.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            CustomCircularInkWell(
                                              onTap: () {
                                                confirmBookingBloc
                                                    .removeCoupon();
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: ColorRes.silver,
                                                  borderRadius:
                                                      BorderRadius.horizontal(
                                                    right: Radius.circular(5),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close_rounded,
                                                    size: 18,
                                                    color: ColorRes.mortar,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    '-\$${confirmBookingBloc.getDiscount()}',
                                    style: kSemiBoldThemeTextStyle.copyWith(
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: ColorRes.themeColor10,
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.subTotal,
                                  style: kRegularTextStyle.copyWith(
                                    fontSize: 17,
                                    color: ColorRes.themeColor,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${AppRes.currency}${AppRes.formatCurrency(confirmBookingBloc.getSubTotalAmount())}',
                                  style: kSemiBoldThemeTextStyle.copyWith(
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: confirmBookingBloc.coupon == null,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: CustomCircularInkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    CouponBottomSheet(
                                      onApplyCoupon:
                                          confirmBookingBloc.selectCoupon,
                                    ),
                                    isScrollControlled: true,
                                    ignoreSafeArea: false,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Image(
                                      image: AssetImage(AssetRes.icCoupon),
                                      height: 13,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.applyCoupon,
                                      style: kLightWhiteTextStyle.copyWith(
                                        color: ColorRes.themeColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: List<Widget>.generate(
                                confirmBookingBloc
                                        .setting?.data?.taxes?.length ??
                                    0, (index) {
                              Taxes? tax = confirmBookingBloc
                                  .setting?.data?.taxes?[index];
                              return Container(
                                color: ColorRes.smokeWhite,
                                margin: const EdgeInsets.only(bottom: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      tax?.taxTitle ?? '',
                                      style: kRegularTextStyle.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${AppRes.currency}${confirmBookingBloc.calculateTax(tax)}',
                                      style: kSemiBoldThemeTextStyle.copyWith(
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                          Container(
                            color: ColorRes.charcoal,
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(Get.context!)!
                                      .payableAmount,
                                  style: kRegularTextStyle.copyWith(
                                    fontSize: 16,
                                    color: ColorRes.white,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${AppRes.currency}${AppRes.formatCurrency(confirmBookingBloc.getTotalPayableAmount())}',
                                  style: kRegularThemeTextStyle.copyWith(
                                    fontSize: 18,
                                    color: ColorRes.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: TextButton(
                      style: kButtonThemeStyle,
                      onPressed: () {
                        if ((confirmBookingBloc.salonUser?.data?.wallet
                                    ?.toInt() ??
                                0) <
                            confirmBookingBloc.getTotalPayableAmount()) {
                          Get.bottomSheet(
                            const RechargeWalletSheet(),
                            isScrollControlled: true,
                            ignoreSafeArea: false,
                          ).then((value) {
                            confirmBookingBloc.add(FetchArgumentsEvent());
                          });
                        } else {
                          confirmBookingBloc.payNow();
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.payNow,
                        style: kRegularWhiteTextStyle,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
