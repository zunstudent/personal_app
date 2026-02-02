import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/auth_binding.dart';
import 'pages/login_page.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Personal App',
      debugShowCheckedModeBanner: false,

      initialBinding: AuthBinding(),
      initialRoute: AppRoutes.login,

      getPages: AppRoutes.pages,
    );
  }
}
