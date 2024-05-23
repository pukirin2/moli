import 'package:moli/bloc/fav/favourite_bloc.dart';
import 'package:moli/bloc/fav/favourite_event.dart';
import 'package:moli/bloc/fav/favourite_state.dart';
import 'package:moli/screens/fav/salon_screen.dart';
import 'package:moli/screens/fav/service_screen.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/asset_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavouriteScreen extends StatelessWidget {
  final Function()? onMenuClick;
  final PageController pageController = PageController(keepPage: true);

  FavouriteScreen({Key? key, this.onMenuClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouriteBloc(),
      child: Column(
        children: [
          Container(
            color: ColorRes.themeColor5,
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  BgRoundImageWidget(
                    image: AssetRes.icMenu,
                    imagePadding: 8,
                    onTap: onMenuClick,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocalizations.of(context)!.favourite,
                    style: kLightWhiteTextStyle.copyWith(
                      fontSize: 20,
                      color: ColorRes.themeColor,
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<FavouriteBloc, FavouriteState>(
                    builder: (context, state) {
                      int selectedIndex =
                          context.read<FavouriteBloc>().selectedIndex;
                      return Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          CustomCircularInkWell(
                            onTap: () {
                              context
                                  .read<FavouriteBloc>()
                                  .add(OnTabClickEvent(0));
                              pageController.jumpToPage(0);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedIndex == 0
                                    ? ColorRes.themeColor
                                    : ColorRes.smokeWhite1,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(100),
                                ),
                              ),
                              width: 90,
                              height: 40,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.service,
                                  style: kLightWhiteTextStyle.copyWith(
                                    color: selectedIndex == 0
                                        ? ColorRes.white
                                        : ColorRes.empress,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CustomCircularInkWell(
                            onTap: () {
                              context
                                  .read<FavouriteBloc>()
                                  .add(OnTabClickEvent(1));
                              pageController.jumpToPage(1);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedIndex == 1
                                    ? ColorRes.themeColor
                                    : ColorRes.smokeWhite1,
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(100),
                                ),
                              ),
                              width: 90,
                              height: 40,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.salon,
                                  style: kLightWhiteTextStyle.copyWith(
                                    color: selectedIndex == 1
                                        ? ColorRes.white
                                        : ColorRes.empress,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [
                ServiceScreen(),
                SalonScreen(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
