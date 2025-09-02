import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<ToggleTheme>((event, emit) {
      emit(state.copyWith(isDarkMode: event.isDarkMode));
    });

    on<ToggleDataSource>((event, emit) {
      emit(state.copyWith(useRealBluetooth: event.useRealBluetooth));
    });
  }
}
