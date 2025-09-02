part of 'setting_bloc.dart';

class SettingsState extends Equatable {
  final bool isDarkMode;
  final bool useRealBluetooth;

  const SettingsState({
    this.isDarkMode = false,
    this.useRealBluetooth = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? useRealBluetooth,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      useRealBluetooth: useRealBluetooth ?? this.useRealBluetooth,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, useRealBluetooth];
}
