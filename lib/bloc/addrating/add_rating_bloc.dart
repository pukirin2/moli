import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/service/api_service.dart';
import 'package:moli/utils/app_res.dart';

part 'add_rating_event.dart';
part 'add_rating_state.dart';

class AddRatingBloc extends Bloc<AddRatingEvent, AddRatingState> {
  AddRatingBloc() : super(AddRatingInitial()) {
    on<ChangeReviewEvent>((event, emit) {
      emit(ChangeReviewState());
    });
    reviewController.addListener(() {
      add(ChangeReviewEvent());
    });
  }

  TextEditingController reviewController = TextEditingController();
  double rating = 0;
  String? bookingId;

  void onValueChange(double rating) {
    this.rating = rating;
  }

  void tapOnContinue() {
    if (rating == 0) {
      AppRes.showSnackBar(Get.context!,
          AppLocalizations.of(Get.context!)!.pleaseSelectAtLeast1Star, false);
      return;
    }
    if (reviewController.text.isEmpty) {
      AppRes.showSnackBar(Get.context!,
          AppLocalizations.of(Get.context!)!.pleaseEnterReview, false);
      return;
    }
    AppRes.showCustomLoader();
    ApiService()
        .addRating(bookingId ?? '', rating.round(), reviewController.text)
        .then((value) {
      AppRes.hideCustomLoaderWithBack();
      AppRes.showSnackBar(
          Get.context!, value.message ?? '', value.status ?? false);
    });
  }
}
