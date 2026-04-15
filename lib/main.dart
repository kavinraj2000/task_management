import 'package:flutter/material.dart';
import 'package:task_management/app/app.dart';
import 'package:task_management/src/core/services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await serviceLocator();
  runApp(const App());
}
