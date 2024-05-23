import 'package:moli/bloc/main/main_screen_event.dart';
import 'package:moli/bloc/main/main_screen_state.dart';
import 'package:moli/screens/login/login_option_screen.dart';
import 'package:moli/utils/const_res.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(InitialMainScreenState()) {
    on<MenuClickEvent>(
      (event, emit) {
        emit(MenuChangeMainScreenState(event.selectedIndex));
      },
    );
  }

  void onMenuClickEvent(int selectedIndex) {
    if (selectedIndex >= 1 && ConstRes.userIdValue == -1) {
      Get.to(() => const LoginOptionScreen());
      return;
    }
    add(MenuClickEvent(selectedIndex));
  }
}
