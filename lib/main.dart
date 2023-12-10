import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:push_notification/config/router/app_router.dart';
import 'package:push_notification/config/theme/app_theme.dart';
import 'package:push_notification/presentation/blocs/blocs.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsBloc.initializeFirebaseCM();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationsBloc(),
        )
      ],
      child: const MyApp(),
    )
  );
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
