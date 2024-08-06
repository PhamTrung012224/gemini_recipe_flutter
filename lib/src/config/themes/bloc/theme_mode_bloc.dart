import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/themes/bloc/theme_mode_event.dart';
import 'package:gemini_cookbook/src/config/themes/bloc/theme_mode_state.dart';

class ThemeModeBloc extends Bloc<ThemeModeEvent, ThemeModeState> {
  ThemeModeBloc() : super(const ThemeModeState()) {
    on<SwitchModeEvent>((event, emit) {
      emit(state.copyWith(
          isOnSwitch: (state.isOnSwitch == false) ? true : false));
    });
  }
}
