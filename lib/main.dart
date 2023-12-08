import 'package:flutter/material.dart';

import 'package:push_notification/config/router/app_router.dart';
import 'package:push_notification/config/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
