import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/controllers/auth_controller.dart';
import 'package:qrcode/app/modules/loading/loading_screen.dart';
import 'package:qrcode/firebase_options.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthController(), permanent: true);
  runApp(
    myApp(),
  );
}

class myApp extends StatelessWidget {
  myApp({
    super.key,
  });
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapAuth) {
          if (snapAuth.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          return GetMaterialApp(
            title: "QR Code",
            initialRoute: snapAuth.hasData ? Routes.HOME : Routes.LOGIN,
            getPages: AppPages.routes,
          );
        });
  }
}
