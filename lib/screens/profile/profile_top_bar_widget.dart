import 'package:cached_network_image/cached_network_image.dart';
import 'package:moli/bloc/profile/profile_bloc.dart';
import 'package:moli/model/user/salon_user.dart';
import 'package:moli/screens/edit_profile_screen.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class ProfileTopBarWidget extends StatelessWidget {
  const ProfileTopBarWidget({
    Key? key,
    required this.onMenuClick,
    this.salonUser,
  }) : super(key: key);
  final SalonUser? salonUser;
  final Function()? onMenuClick;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ColorRes.themeColor5,
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
        child: SafeArea(
            bottom: false,
            child: Column(children: [
              Row(children: [
                BgRoundIconWidget(
                    icon: Icons.menu_open_sharp, onTap: onMenuClick),
                const SizedBox(width: 15),
                Text(AppLocalizations.of(context)!.profile,
                    style: kLightWhiteTextStyle.copyWith(
                        fontSize: 20, color: ColorRes.themeColor))
              ]),
              const SizedBox(height: 15),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(children: [
                    Container(
                        decoration: BoxDecoration(
                            color: ColorRes.themeColor,
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(1),
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: SizedBox(
                                width: 110,
                                height: 110,
                                child: salonUser?.data?.profileImage != null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            '${ConstRes.itemBaseUrl}${salonUser?.data?.profileImage ?? ''}',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Loading(),
                                        errorWidget: errorBuilderForImage)
                                    : const ImageNotFound()))),
                    const SizedBox(width: 15),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(salonUser?.data?.fullname?.capitalize ?? '',
                              style: kBoldThemeTextStyle.copyWith(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Row(children: [
                            Text(AppLocalizations.of(context)!.totalBookings,
                                style: kThinWhiteTextStyle.copyWith(
                                    color: ColorRes.black, fontSize: 14)),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(':',
                                    style: kThinWhiteTextStyle.copyWith(
                                        color: ColorRes.black, fontSize: 14))),
                            Text('${salonUser?.data?.bookingsCount ?? 0}',
                                style: kThinWhiteTextStyle.copyWith(
                                    color: ColorRes.black, fontSize: 14))
                          ]),
                          CustomCircularInkWell(
                              onTap: () {
                                Get.to(() => const EditProfileScreen())
                                    ?.then((value) {
                                  context
                                      .read<ProfileBloc>()
                                      .add(FetchUserDataEvent());
                                });
                              },
                              child: Container(
                                  decoration: const BoxDecoration(
                                    color: ColorRes.themeColor5,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                  ),
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Center(
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .editDetails,
                                          style: kRegularThemeTextStyle
                                              .copyWith(fontSize: 14)))))
                        ])
                  ]))
            ])));
  }
}
