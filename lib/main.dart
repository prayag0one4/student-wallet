import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/di/injection_container.dart';
import 'app/providers/theme_provider.dart';
import 'app/router/app_router.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const StudentWalletApp());
}

class StudentWalletApp extends StatelessWidget {
  const StudentWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = GetIt.instance<ThemeProvider>();

    return ProviderScope(
      child: ListenableBuilder(
        listenable: themeProvider,
        builder: (context, _) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
