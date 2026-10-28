import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/notification_service.dart';
import 'core/router.dart';
import 'core/theme/app_theme.dart';
import 'features/state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const ProviderScope(child: PosturePulseApp()));
}

class PosturePulseApp extends ConsumerWidget {
  const PosturePulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool darkMode = ref.watch(
      settingsProvider.select((Settings settings) => settings.darkMode),
    );

    return MaterialApp.router(
      title: 'PosturePulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}

