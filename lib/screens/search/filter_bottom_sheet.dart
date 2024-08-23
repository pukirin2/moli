import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/bloc/filter/filter_bloc.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({
    super.key,
    required this.catId,
  });
  final String catId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterBloc(),
      child: SafeArea(
        bottom: false,
        child: Container(
          decoration: const BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.filters,
                        style: context.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .applyFiltersAccordingToYourNeed,
                        style: context.bodyMedium!.copyWith(
                          color: ColorRes.subTitleText,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  BlocBuilder<FilterBloc, FilterState>(
                    builder: (context, state) {
                      FilterBloc filterBloc = context.read<FilterBloc>();
                      if (filterBloc.categories.isEmpty) {
                        filterBloc.add(FetchCategoriesDataEvent(catId));
                      }
                      return CustomCircularInkWell(
                        onTap: () {
                          Get.back(
                              result: context.read<FilterBloc>().selectedIndex);
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: const BoxDecoration(
                            color: ColorRes.lavender,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.close_rounded,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.categories,
                style:
                    context.bodyMedium!.copyWith(fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 10,
              ),
              const CategoriesWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({
    super.key,
  });

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        FilterBloc filterBloc = context.read<FilterBloc>();
        return Wrap(
          children: List<Widget>.generate(
            filterBloc.categories.length,
            (index) => ItemFilterWidget(
              title: filterBloc.categories[index].title ?? '',
              filterIsSelected: filterBloc.selectedIndex ==
                  filterBloc.categories[index].id.toString(),
              onTap: () {
                filterBloc.selectedIndex = filterBloc.selectedIndex ==
                        filterBloc.categories[index].id.toString()
                    ? '-1'
                    : filterBloc.categories[index].id.toString();
                Get.back(result: context.read<FilterBloc>().selectedIndex);
              },
            ),
          ),
        );
      },
    );
  }
}

class ItemFilterWidget extends StatelessWidget {
  final String title;
  final bool filterIsSelected;
  final Function()? onTap;

  const ItemFilterWidget({
    super.key,
    required this.title,
    required this.filterIsSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCircularInkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: filterIsSelected ? ColorRes.lavender : ColorRes.smokeWhite,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(
            color: filterIsSelected
                ? context.colorScheme.primary
                : ColorRes.transparent,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        child: Text(
          title,
          style: context.bodyMedium!
              .copyWith(fontWeight: FontWeight.w300)
              .copyWith(
                fontSize: 16,
                color: filterIsSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.outline,
              ),
        ),
      ),
    );
  }
}

class CloseButtonWidget extends StatelessWidget {
  final Function()? onTap;

  const CloseButtonWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCircularInkWell(
      onTap: () {
        Get.back();
        onTap?.call();
      },
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: context.colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        padding: const EdgeInsets.all(5),
        child: Icon(
          Icons.close_rounded,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
