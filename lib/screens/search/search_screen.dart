import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/route_manager.dart';
import 'package:moli/bloc/search/search_bloc.dart';
import 'package:moli/bloc/search/search_event.dart';
import 'package:moli/bloc/search/search_state.dart';
import 'package:moli/screens/search/search_salon_screen.dart';
import 'package:moli/screens/search/search_service_screen.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class SearchScreen extends StatelessWidget {
  final PageController pageController = PageController();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SearchBloc(),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    CustomCircularInkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Icon(Icons.arrow_back_ios_new_outlined,
                              size: 30, color: context.colorScheme.primary)),
                    ),
                    Text(
                      AppLocalizations.of(context)!.search,
                      style: context.titleStyleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        int selectedIndex = 0;
                        if (state is SearchChangeTabState) {
                          selectedIndex = state.selectedIndex;
                        }
                        return Row(
                          children: [
                            InkWell(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(100),
                                  bottomLeft: Radius.circular(100)),
                              onTap: () {
                                context
                                    .read<SearchBloc>()
                                    .add(SearchOnTabClickEvent(0));
                                pageController.jumpToPage(0);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedIndex == 0
                                      ? context.colorScheme.primary
                                      : context.colorScheme.surface,
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
                                          ? Colors.white
                                          : context.colorScheme.outline,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(100),
                                  bottomRight: Radius.circular(100)),
                              onTap: () {
                                context
                                    .read<SearchBloc>()
                                    .add(SearchOnTabClickEvent(1));
                                pageController.jumpToPage(1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedIndex == 1
                                      ? context.colorScheme.primary
                                      : context.colorScheme.surface,
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
                                          ? Colors.white
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
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  SearchServiceScreen(),
                  SearchSalonScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
