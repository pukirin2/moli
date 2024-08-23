import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moli/bloc/fav/favourite_bloc.dart';
import 'package:moli/bloc/fav/favourite_event.dart';
import 'package:moli/bloc/fav/favourite_state.dart';
import 'package:moli/screens/fav/salon_screen.dart';
import 'package:moli/screens/fav/service_screen.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class FavouriteScreen extends StatelessWidget {
  final Function()? onMenuClick;
  final PageController pageController = PageController(keepPage: true);

  FavouriteScreen({super.key, this.onMenuClick});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouriteBloc(),
      child: Column(
        children: [
          Container(
            color: context.colorScheme.surface.withOpacity(0.1),
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
                    AppLocalizations.of(context)!.favourite,
                    style: context.bodyMedium!.copyWith(
                      fontSize: 20,
                      color: context.colorScheme.primary,
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
                                    ? context.colorScheme.primary
                                    : context.colorScheme.outlineVariant
                                        .withOpacity(.6),
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(100),
                                ),
                              ),
                              width: 90,
                              height: 40,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.service,
                                  style: context.bodyMedium!.copyWith(
                                    color: selectedIndex == 0
                                        ? context.colorScheme.onPrimary
                                        : context.colorScheme.outline,
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
                                    ? context.colorScheme.primary
                                    : context.colorScheme.outlineVariant
                                        .withOpacity(.6),
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(100),
                                ),
                              ),
                              width: 90,
                              height: 40,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.salon,
                                  style: context.bodyMedium!.copyWith(
                                    color: selectedIndex == 1
                                        ? context.colorScheme.onPrimary
                                        : context.colorScheme.outline,
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
