import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/searchservice/search_service_bloc.dart';
import 'package:moli/model/service/services.dart';
import 'package:moli/model/user/salon.dart' as salon;
import 'package:moli/screens/fav/service_screen.dart';
import 'package:moli/screens/search/filter_bottom_sheet.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class SearchServiceScreen extends StatefulWidget {
  const SearchServiceScreen({super.key});

  @override
  State<SearchServiceScreen> createState() => _SearchServiceScreenState();
}

class _SearchServiceScreenState extends State<SearchServiceScreen> {
  bool searchIsEmpty = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchServiceBloc(),
      child: BlocBuilder<SearchServiceBloc, SearchServiceState>(
        builder: (context, state) {
          SearchServiceBloc searchServiceBloc =
              context.read<SearchServiceBloc>();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                Get.bottomSheet(
                                  FilterBottomSheet(
                                      catId: searchServiceBloc.catId ?? ''),
                                  isScrollControlled: true,
                                  ignoreSafeArea: false,
                                ).then((value) {
                                  if (value != null && value is String) {
                                    searchServiceBloc.setCatId(value);
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.filter_list_outlined,
                                size: 30,
                                color: context.colorScheme.primary,
                              )),
                          fillColor: context.colorScheme.outlineVariant
                              .withOpacity(.5),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none),
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.search,
                          hintStyle: context.bodyMedium!
                              .copyWith(color: context.colorScheme.outline),
                        ),
                        focusNode: searchServiceBloc.focusNode,
                        controller: searchServiceBloc.searchController,
                        textCapitalization: TextCapitalization.sentences,
                        style: context.bodyMedium!,
                        onTapOutside: (event) {
                          searchServiceBloc.onTaOutsideOfTextField();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              state is SearchServiceInitial
                  ? const Expanded(
                      child: LoadingData(
                        color: ColorRes.white,
                      ),
                    )
                  : Expanded(
                      child: searchServiceBloc.services.isEmpty
                          ? const DataNotFound()
                          : SafeArea(
                              top: false,
                              child: SingleChildScrollView(
                                controller: searchServiceBloc.scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: searchServiceBloc
                                                .recentSearch.isNotEmpty &&
                                            searchServiceBloc
                                                .searchController.text.isEmpty,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .recent,
                                                  style: context.bodyMedium!
                                                      .copyWith(),
                                                ),
                                                const Spacer(),
                                                CustomCircularInkWell(
                                                  onTap: () {
                                                    searchServiceBloc
                                                        .clearAll();
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .clearAll,
                                                    style: context.bodyMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              primary: false,
                                              itemCount: searchServiceBloc
                                                          .recentSearch.length >
                                                      3
                                                  ? 3
                                                  : searchServiceBloc
                                                      .recentSearch.length,
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              itemBuilder: (context, index) {
                                                String data = searchServiceBloc
                                                    .recentSearch[index];
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          data,
                                                          style: context
                                                              .bodyMedium!
                                                              .copyWith(
                                                            color: ColorRes
                                                                .empress,
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        CustomCircularInkWell(
                                                          onTap: () {
                                                            searchServiceBloc
                                                                .deleteRecentSearch(
                                                                    data);
                                                          },
                                                          child: const Icon(
                                                            Icons.close_rounded,
                                                            size: 24,
                                                            color: ColorRes
                                                                .empress,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      color: ColorRes.darkGray,
                                                      height: 0.2,
                                                      width: double.infinity,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Visibility(
                                        visible: searchServiceBloc
                                            .searchController.text.isEmpty,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .suggestions,
                                          style: context.titleStyleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      ListView.builder(
                                        itemCount:
                                            searchServiceBloc.services.length,
                                        primary: false,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(0),
                                        itemBuilder: (context, index) {
                                          ServiceData serviceData =
                                              searchServiceBloc.services[index];
                                          return ItemService(
                                            services: salon.Services.fromJson(
                                              serviceData.toJson(),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
            ],
          );
        },
      ),
    );
  }
}

class ItemPopularSearch extends StatelessWidget {
  final String title;

  const ItemPopularSearch({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorRes.lavender,
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      child: Text(
        title,
        style:
            context.bodyMedium!.copyWith(fontWeight: FontWeight.w300).copyWith(
                  fontSize: 16,
                ),
      ),
    );
  }
}
