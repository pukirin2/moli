import 'package:moli/model/chat/chat.dart';
import 'package:moli/model/user/salon.dart';
import 'package:moli/model/user/salon_user.dart';
import 'package:moli/screens/chat/chat_screen.dart';
import 'package:moli/service/api_service.dart';
import 'package:moli/utils/firebase_res.dart';
import 'package:moli/utils/shared_pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../utils/app_res.dart';

part 'salon_details_event.dart';

part 'salon_details_state.dart';

class SalonDetailsBloc extends Bloc<SalonDetailsEvent, SalonDetailsState> {
  SalonDetailsBloc() : super(SalonDetailsInitial()) {
    on<FetchSalonDataEvent>((event, emit) async {
      SharePref sharePref = await SharePref().init();
      Salon salon = await ApiService().fetchSalonDetails(Get.arguments);
      salonData = salon.data;
      categories = salonData?.categories
              ?.where((element) => element.services!.isNotEmpty)
              .toList() ??
          [];
      userData = sharePref.getSalonUser()?.data;
      emit(SalonDataFetched(salon));
    });
    add(FetchSalonDataEvent());
  }

  SalonData? salonData;
  UserData? userData;
  List<Categories> categories = [];
  List<Services> selectedServices = [];

  void onChatBtnTap() {
    ChatUser chatUser = ChatUser(
        image: salonData?.images?[0].image ?? '',
        msgCount: 0,
        userid: salonData?.id?.toInt() ?? -1,
        userIdentity: '${FirebaseRes.sl}${salonData?.email}',
        username: salonData?.salonName);
    Conversation conversation = Conversation(
        time: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId:
            '${FirebaseRes.ct}${userData?.identity}${FirebaseRes.sl}${salonData?.email}',
        deletedId: '',
        isDeleted: false,
        lastMsg: '',
        newMsg: '',
        user: chatUser);
    Get.to(() => const ChatScreen(), arguments: [conversation, userData]);
  }

  bool isSelected(int id) {
    for (Services? services in selectedServices) {
      if (services?.id == id) {
        return true;
      }
    }
    return false;
  }

  int totalRates() {
    int totalPrice = 0;
    for (Services? services in selectedServices) {
      if (services != null) {
        totalPrice = totalPrice +
            (services.price?.toInt() ?? 0) -
            AppRes.calculateDiscountByPercentage(services.price?.toInt() ?? 0,
                    services.discount?.toInt() ?? 0)
                .toInt();
      }
    }
    return totalPrice;
  }
}
