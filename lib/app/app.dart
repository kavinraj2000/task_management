import 'package:flutter/material.dart';
import 'package:task_management/app/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp.router(
      debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        routerConfig: Routes().router,
    builder: (context, child) {

      return child!;
    },
   );
  }
}