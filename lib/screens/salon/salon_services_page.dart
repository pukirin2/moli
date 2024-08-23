import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/route_manager.dart';
import 'package:moli/bloc/salon/salon_details_bloc.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/booking/confirm_booking.dart';
import 'package:moli/screens/login/login_option_screen.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class SalonServicesPage extends StatefulWidget {
  const SalonServicesPage({super.key});

  @override
  State<SalonServicesPage> createState() => _SalonServicesPageState();
}

class _SalonServicesPageState extends State<SalonServicesPage> {
  @override
  Widget build(BuildContext context) {
    SalonDetailsBloc salonDetailsBloc = context.read<SalonDetailsBloc>();
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemCount: salonDetailsBloc.categories.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  Categories category = salonDetailsBloc.categories[index];
                  return ItemSalonDetailsService(
                      categories: category,
                      onUpdate: () {
                        setState(() {});
                      });
                })),
        Visibility(
          visible: salonDetailsBloc.totalRates() != 0,
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
                        '${salonDetailsBloc.totalRates()} ${AppRes.currency}',
                        style: context.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.tertiary),
                      ),
                      Text(
                        AppLocalizations.of(context)!.subTotal,
                        style: context.bodyMedium!.copyWith(
                          color: context.colorScheme.outline,
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
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        if (ConstRes.userIdValue == -1) {
                          Get.to(() => const LoginOptionScreen());
                          return;
                        }
                        Get.to(
                          () => const ConfirmBookingScreen(),
                          arguments: {
                            ConstRes.salonData: salonDetailsBloc.salonData,
                            ConstRes.services:
                                salonDetailsBloc.selectedServices,
                          },
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.placeBooking,
                        style:
                            context.bodyMedium!.copyWith(color: Colors.white),
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
  }
}

class ItemSalonDetailsService extends StatelessWidget {
  final Categories categories;
  final Function()? onUpdate;

  const ItemSalonDetailsService({
    super.key,
    required this.categories,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            categories.title?.toUpperCase() ?? '',
            style: context.bodyMedium!.copyWith(
              color: context.colorScheme.primary,
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: categories.services?.length ?? 0,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              Services? service = categories.services?[index];
              return ItemServiceTYpeWidget(
                service: service,
                onUpdate: onUpdate,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ItemServiceTYpeWidget extends StatefulWidget {
  const ItemServiceTYpeWidget({
    super.key,
    this.service,
    this.onUpdate,
  });
  final Services? service;
  final Function()? onUpdate;

  @override
  State<ItemServiceTYpeWidget> createState() => _ItemServiceTYpeWidgetState();
}

class _ItemServiceTYpeWidgetState extends State<ItemServiceTYpeWidget> {
  bool isAdded = false;

  @override
  void initState() {
    SalonDetailsBloc salonDetailsBloc = context.read<SalonDetailsBloc>();
    isAdded = salonDetailsBloc.isSelected(widget.service?.id?.toInt() ?? -1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var price =
        '${AppRes.formatCurrency((widget.service?.price ?? 0) - AppRes.calculateDiscountByPercentage(widget.service?.price?.toInt() ?? 0, widget.service?.discount?.toInt() ?? 0).toInt())} ${AppRes.currency}';
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: ColorRes.smokeWhite2,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Row(children: [
              SizedBox(
                  width: 130,
                  height: 110,
                  child: CachedNetworkImage(
                    imageUrl:
                        '${ConstRes.itemBaseUrl}${widget.service!.images!.isNotEmpty ? widget.service?.images?.first.image : ''}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Loading(),
                    errorWidget: errorBuilderForImage,
                  )),
              Expanded(
                  child: Container(
                      color: isAdded ? ColorRes.lavender : ColorRes.smokeWhite2,
                      padding:
                          const EdgeInsets.only(bottom: 5, right: 10, left: 10),
                      height: 110,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.service?.title ?? '',
                                style: context.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w300)
                                    .copyWith(
                                        color: ColorRes.nero, fontSize: 16)),
                            const SizedBox(height: 5),
                            Row(children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      // AppRes.formatCurrency(widget.service?.price ?? 0)

                                      // Text(
                                      //     '${AppRes.currency}${(widget.service?.price?.toInt() ?? 0) - AppRes.calculateDiscountByPercentage(widget.service?.price?.toInt() ?? 0, widget.service?.discount?.toInt() ?? 0).toInt()}',
                                      //     style: context.bodyMedium!.copyWith(                                              fontWeight: FontWeight.bold).copyWith(
                                      //         fontSize: 18)),
                                      Text(price,
                                          style: context.bodyMedium!.copyWith(
                                              color:
                                                  context.colorScheme.tertiary,
                                              fontWeight: FontWeight.bold)),

                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text('-',
                                              style: context.bodyMedium!
                                                  .copyWith(
                                                      color: ColorRes.mortar))),
                                      Text(
                                          AppRes.convertTimeForService(
                                              context,
                                              widget.service?.serviceTime
                                                      ?.toInt() ??
                                                  0),
                                          style: context.bodyMedium!
                                              .copyWith(color: ColorRes.mortar))
                                    ]),
                                    const SizedBox(height: 5),
                                    Text(
                                        AppRes.getGenderTypeInStringFromNumber(
                                            context,
                                            widget.service?.gender?.toInt() ??
                                                0),
                                        style: context.bodyMedium!.copyWith(
                                            color: context.colorScheme.outline,
                                            fontSize: 12,
                                            letterSpacing: 2))
                                  ]),
                              const Spacer(),
                              PlusMinusImageWidget(
                                  onTapChange: (isAdded) {
                                    this.isAdded = isAdded;
                                    setState(() {});
                                    widget.onUpdate?.call();
                                  },
                                  services: widget.service)
                            ])
                          ])))
            ])));
  }
}

class PlusMinusImageWidget extends StatefulWidget {
  final Function(bool isAdded)? onTapChange;
  final Services? services;

  const PlusMinusImageWidget({
    super.key,
    this.onTapChange,
    this.services,
  });

  @override
  State<PlusMinusImageWidget> createState() => _PlusMinusImageWidgetState();
}

class _PlusMinusImageWidgetState extends State<PlusMinusImageWidget> {
  bool serviceIsAdded = false;
  late SalonDetailsBloc salonDetailsBloc;

  @override
  void initState() {
    salonDetailsBloc = context.read<SalonDetailsBloc>();
    serviceIsAdded =
        salonDetailsBloc.isSelected(widget.services?.id?.toInt() ?? -1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCircularInkWell(
      onTap: () {
        if (serviceIsAdded) {
          salonDetailsBloc.selectedServices.remove(widget.services);
        } else {
          if (widget.services != null) {
            salonDetailsBloc.selectedServices.add(widget.services!);
          }
        }
        serviceIsAdded = !serviceIsAdded;
        widget.onTapChange?.call(serviceIsAdded);
        setState(() {});
      },
      child: BgRoundImageWidget(
        image: serviceIsAdded ? AssetRes.icMinus : AssetRes.icPlus,
        imagePadding: serviceIsAdded ? 11 : 7,
        bgColor:
            serviceIsAdded ? ColorRes.monaLisa : context.colorScheme.primary,
        height: 35,
        width: 35,
      ),
    );
  }
}
