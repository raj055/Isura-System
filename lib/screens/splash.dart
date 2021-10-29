import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:isura_system/screens/auth/sign_in.dart';
import 'package:isura_system/services/auth.dart';
import 'package:isura_system/services/size_config.dart';
import 'package:isura_system/widget/theme.dart';

import 'dashboard.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedSplashScreen.withScreenFunction(
          splash: logo,
          screenFunction: () async {
            return Auth.userEmail() == null ? SignIn() : Dashboard();
          },
          splashTransition: SplashTransition.sizeTransition,
        ),
      ),
    );
  }
}
