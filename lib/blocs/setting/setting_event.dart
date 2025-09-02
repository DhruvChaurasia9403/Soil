part of 'setting_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class ToggleTheme extends SettingsEvent {
  final bool isDarkMode;
  const ToggleTheme(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}

class ToggleDataSource extends SettingsEvent {
  final bool useRealBluetooth;
  const ToggleDataSource(this.useRealBluetooth);

  @override
  List<Object?> get props => [useRealBluetooth];
}
