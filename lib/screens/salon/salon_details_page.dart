import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moli/bloc/salon/salon_details_bloc.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class SalonDetailsPage extends StatelessWidget {
  const SalonDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SalonDetailsBloc salonDetailsBloc = context.read<SalonDetailsBloc>();
    var curentLocale = Localizations.localeOf(context).languageCode;
    return SingleChildScrollView(
      primary: true,
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(salonDetailsBloc.salonData?.salonAbout ?? '',
                  style: context.bodyMedium!.copyWith(
                      color: context.bodyMedium!.color!.withOpacity(0.5)))),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.contactUs,
                              style: context.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w300)),
                          const SizedBox(height: 2),
                          Text(
                              AppLocalizations.of(context)!
                                  .forQuestionsAndQueries,
                              style: context.bodyMedium!
                                  .copyWith(color: context.colorScheme.outline))
                        ]),
                    const Spacer(),
                    RoundCornerWithImageWidget(
                      image: AssetRes.icCall,
                      imageColor: context.colorScheme.tertiary,
                      onTap: () {
                        launchUrl(Uri.parse(
                            'tel:${salonDetailsBloc.salonData?.salonPhone}'));
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    RoundCornerWithImageWidget(
                      image: AssetRes.icMessage,
                      imageColor: context.colorScheme.tertiary,
                      onTap: () {
                        salonDetailsBloc.onChatBtnTap();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.availability,
                        style: context.bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.mondayFriday,
                              style: context.bodyMedium!.copyWith(
                                color:
                                    context.bodyMedium!.color!.withOpacity(.8),
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${AppRes.convert24HoursInto12Hours(salonDetailsBloc.salonData?.monFriFrom, locale: curentLocale)}'
                              ' - '
                              '${AppRes.convert24HoursInto12Hours(salonDetailsBloc.salonData?.monFriTo, locale: curentLocale)}',
                              style: context.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w300)
                                  .copyWith(
                                    fontSize: 16,
                                    color: context.bodyMedium!.color!
                                        .withOpacity(.5),
                                  ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          margin: const EdgeInsets.only(top: 15, bottom: 15),
                          color: context.colorScheme.onSurface.withOpacity(.8),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.saturdaySunday,
                          style: context.bodyMedium!.copyWith(
                            color: context.bodyMedium!.color!.withOpacity(.8),
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${AppRes.convert24HoursInto12Hours(salonDetailsBloc.salonData?.satSunFrom, locale: curentLocale)}'
                          ' - '
                          '${AppRes.convert24HoursInto12Hours(salonDetailsBloc.salonData?.satSunTo, locale: curentLocale)}',
                          style: context.bodyMedium!
                              .copyWith(fontWeight: FontWeight.w300)
                              .copyWith(
                                fontSize: 16,
                                color:
                                    context.bodyMedium!.color!.withOpacity(.5),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          AspectRatio(
            aspectRatio: 1 / .6,
            child: Stack(
              children: [
                GMapDetails(salon: salonDetailsBloc.salonData),
                Align(
                  alignment: Alignment.bottomRight,
                  child: CustomCircularInkWell(
                    onTap: () async {
                      String iosUrl =
                          'https://maps.apple.com/?q=${salonDetailsBloc.salonData?.salonLat},${salonDetailsBloc.salonData?.salonLong}';
                      if (Platform.isAndroid) {
                        String googleUrl =
                            'https://www.google.com/maps/search/?api=1&query=${salonDetailsBloc.salonData?.salonLat},${salonDetailsBloc.salonData?.salonLong}';
                        if (await canLaunchUrl(Uri.parse(googleUrl))) {
                          await launchUrl(Uri.parse(googleUrl));
                        } else {
                          throw 'Could not launch $googleUrl';
                        }
                      } else {
                        if (await canLaunchUrl(Uri.parse(iosUrl))) {
                          await launchUrl(Uri.parse(iosUrl));
                        } else {
                          throw 'Could not open the map.';
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: Container(
                          color: context.colorScheme.primary,
                          width: 130,
                          height: 45,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Image(
                                  image: AssetImage(AssetRes.icNavigator),
                                  height: 24,
                                  width: 24,
                                  color: ColorRes.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.navigate,
                                  style: context.bodyMedium!.copyWith(
                                    color: ColorRes.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundCornerWithImageWidget extends StatelessWidget {
  final String image;
  final Color? bgColor;
  final Color? imageColor;
  final double? imagePadding;
  final double? cornerRadius;
  final Function()? onTap;

  const RoundCornerWithImageWidget({
    super.key,
    required this.image,
    this.imagePadding,
    this.cornerRadius,
    this.bgColor,
    this.imageColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCircularInkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? context.colorScheme.tertiary.withOpacity(.5),
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius ?? 10)),
        ),
        height: 45,
        width: 45,
        padding: EdgeInsets.all(imagePadding ?? 10),
        child: Image(
          image: AssetImage(
            image,
          ),
          color: imageColor,
        ),
      ),
    );
  }
}

class GMapDetails extends StatefulWidget {
  const GMapDetails({
    super.key,
    required this.salon,
  });

  final SalonData? salon;

  @override
  State<GMapDetails> createState() => _GMapDetailsState();
}

class _GMapDetailsState extends State<GMapDetails> {
  BitmapDescriptor? bitmapDescriptor;
  Set<Marker> markers = {};
  late String mapStyle;
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return widget.salon != null
        ? GoogleMap(
            initialCameraPosition: CameraPosition(
              // target: LatLng(
              //   double.parse(widget.salon?.data?.salonLat ?? '0'),
              //   double.parse(widget.salon?.data?.salonLong ?? '0'),
              // ),
              target: LatLng(
                double.parse(widget.salon?.salonLat ?? '0'),
                double.parse(widget.salon?.salonLong ?? '0'),
              ),
              zoom: 12,
            ),
            onTap: null,
            onMapCreated: (controller) {
              if (bitmapDescriptor == null) {
                initBitmap(controller);
              }
            },
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            buildingsEnabled: true,
            markers: markers,
            scrollGesturesEnabled: false,
          )
        : const SizedBox();
  }

  void initBitmap(GoogleMapController controller) async {
    mapStyle = await rootBundle.loadString('images/map_style.json');
    bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            size: Platform.isAndroid ? const Size(24, 24) : const Size(15, 15)),
        Platform.isAndroid ? AssetRes.icPinAnd : AssetRes.icPin);
    markers = Set.of(List.generate(1, (index) {
      return Marker(
        markerId: const MarkerId('q'),
        position: LatLng(
          double.parse(widget.salon?.salonLat ?? '0'),
          double.parse(widget.salon?.salonLong ?? '0'),
        ),
        icon: bitmapDescriptor!,
      );
    }));
    controller.setMapStyle(mapStyle);
    setState(() {});
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
