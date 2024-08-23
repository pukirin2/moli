import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/searchsalon/search_salon_bloc.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/screens/fav/salon_screen.dart';
import 'package:moli/screens/search/filter_bottom_sheet.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class SearchSalonScreen extends StatefulWidget {
  const SearchSalonScreen({super.key});

  @override
  State<SearchSalonScreen> createState() => _SearchSalonScreenState();
}

class _SearchSalonScreenState extends State<SearchSalonScreen> {
  bool searchIsEmpty = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchSalonBloc(),
      child: BlocBuilder<SearchSalonBloc, SearchSalonState>(
        builder: (context, state) {
          SearchSalonBloc searchSalonBloc = context.read<SearchSalonBloc>();
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
                                  catId: searchSalonBloc.catId ?? '',
                                ),
                                isScrollControlled: true,
                                ignoreSafeArea: false,
                              ).then((value) {
                                if (value != null && value is String) {
                                  searchSalonBloc.setCatId(value);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.filter_list_outlined,
                              size: 30,
                              color: context.colorScheme.primary,
                            ),
                          ),
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
                        focusNode: searchSalonBloc.focusNode,
                        controller: searchSalonBloc.searchController,
                        textCapitalization: TextCapitalization.sentences,
                        style: context.bodyMedium!
                            .copyWith(color: ColorRes.charcoal50),
                        onTapOutside: (event) {
                          searchSalonBloc.onTaOutsideOfTextField();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state is SearchSalonInitial
                    ? const LoadingData()
                    : SafeArea(
                        top: false,
                        child: searchSalonBloc.salons.isEmpty
                            ? const DataNotFound(color: ColorRes.white)
                            : SingleChildScrollView(
                                controller: searchSalonBloc.scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: searchSalonBloc
                                                .recentSearch.isNotEmpty &&
                                            searchSalonBloc
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
                                                    searchSalonBloc.clearAll();
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
                                              itemCount: searchSalonBloc
                                                          .recentSearch.length >
                                                      3
                                                  ? 3
                                                  : searchSalonBloc
                                                      .recentSearch.length,
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              itemBuilder: (context, index) {
                                                String data = searchSalonBloc
                                                    .recentSearch[index];
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(data,
                                                            style: context
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    color: ColorRes
                                                                        .empress,
                                                                    fontSize:
                                                                        17)),
                                                        const Spacer(),
                                                        CustomCircularInkWell(
                                                          onTap: () {
                                                            searchSalonBloc
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
                                        visible: searchSalonBloc
                                            .searchController.text.isEmpty,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .suggestions,
                                          style: context.bodyMedium!.copyWith(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ListView.builder(
                                        itemCount:
                                            searchSalonBloc.salons.length,
                                        primary: false,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(0),
                                        itemBuilder: (context, index) {
                                          SalonData salonData =
                                              searchSalonBloc.salons[index];
                                          return ItemSalon(
                                            salonData: salonData,
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

  @override
  void dispose() {
    super.dispose();
  }
}
