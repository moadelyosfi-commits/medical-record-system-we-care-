import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_app/router/app_router.dart';
import 'package:wecare_models/wecare_models.dart';

final appSettingsStreamProvider = StreamProvider<AppSettings>((ref) {
  final repository = ref.watch(appSettingsRepositoryProvider);
  return repository.watchSettings();
});

final appRouterProvider = Provider<GoRouter>((ref) {
  return createRouter();
});

class WeCareApp extends ConsumerWidget {
  const WeCareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsStreamProvider);
    final settings = settingsAsync.value ?? const AppSettings();
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'WeCare',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: Locale(settings.languageCode),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: switch (settings.themeMode) {
        ThemePreference.light => ThemeMode.light,
        ThemePreference.dark => ThemeMode.dark,
        ThemePreference.system => ThemeMode.system,
      },
    );
  }
}
