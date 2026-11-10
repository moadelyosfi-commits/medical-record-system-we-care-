import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wecare_models/src/entities/enums.dart';

@immutable
final class AppSettings extends Equatable {
  const AppSettings({
    this.languageCode = 'ar',
    this.themeMode = ThemePreference.system,
    this.autoLockMinutes = 5,
    this.secureScreensEnabled = true,
  }) : assert(languageCode == 'ar' || languageCode == 'en');

  final String languageCode;
  final ThemePreference themeMode;
  final int autoLockMinutes;
  final bool secureScreensEnabled;

  AppSettings copyWith({
    String? languageCode,
    ThemePreference? themeMode,
    int? autoLockMinutes,
    bool? secureScreensEnabled,
  }) => AppSettings(
    languageCode: languageCode ?? this.languageCode,
    themeMode: themeMode ?? this.themeMode,
    autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
    secureScreensEnabled: secureScreensEnabled ?? this.secureScreensEnabled,
  );

  @override
  List<Object?> get props => [
    languageCode,
    themeMode,
    autoLockMinutes,
    secureScreensEnabled,
  ];

  @override
  String toString() => 'AppSettings()';
}
