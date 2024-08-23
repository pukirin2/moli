import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moli/bloc/addrating/add_rating_bloc.dart';
import 'package:moli/screens/search/filter_bottom_sheet.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/extensions.dart';

class AddRatingBottomSheet extends StatelessWidget {
  final String bookingId;

  const AddRatingBottomSheet({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocProvider(
        create: (context) => AddRatingBloc(),
        child: Container(
          height: context.sizeDevice.height * 0.5,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: BlocBuilder<AddRatingBloc, AddRatingState>(
            builder: (context, state) {
              AddRatingBloc addRatingBloc = context.read<AddRatingBloc>();
              addRatingBloc.bookingId = bookingId;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.addRatings,
                            style: context.titleStyleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .shareYourExperienceInFewWords,
                            style: context.bodySmall!.copyWith(
                              color: context.colorScheme.outline,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const CloseButtonWidget(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RatingBar(
                    initialRating: 0,
                    ratingWidget: RatingWidget(
                      full: const Icon(
                        Icons.star_rounded,
                        color: ColorRes.koroMiko,
                      ),
                      half: const Icon(
                        Icons.star_rounded,
                      ),
                      empty: const Icon(
                        Icons.star_rounded,
                        color: ColorRes.darkGray,
                      ),
                    ),
                    onRatingUpdate: addRatingBloc.onValueChange,
                    itemSize: 40,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                    controller: addRatingBloc.reviewController,
                    style: context.bodyMedium,
                    maxLines: 6,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${addRatingBloc.reviewController.text.length}/200',
                      style: context.bodySmall!.copyWith(
                        color: ColorRes.darkGray,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
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
                        addRatingBloc.tapOnContinue();
                      },
                      child: Text(AppLocalizations.of(context)!.continue_,
                          style: context.bodyMedium!
                              .copyWith(color: ColorRes.white)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
