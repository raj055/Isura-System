import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:isura_system/services/auth.dart';
import 'package:isura_system/services/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Auth.initialize();
  await FlutterDownloader.initialize();

  await Firebase.initializeApp();

  runApp(
    GetMaterialApp(
      defaultTransition: Transition.fade,
      initialRoute: '/',
      title: 'Insura System',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      debugShowCheckedModeBanner: false,
      getPages: CustomRouter.pages,
    ),
  );
}
