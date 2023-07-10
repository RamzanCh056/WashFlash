import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washflash/screens/home_screen.dart';
import 'package:washflash/screens/select_site_screen.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late SharedPreferences preferences;
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) async {
      preferences = value;
      if (preferences.getBool('isLoggedIn') ?? false) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false);
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false);
        });
      }
    }).catchError((e) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
      });
    });
    // Timer(const Duration(seconds: 3), (){
    //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    //     return const LandingPage();
    //   }));
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/washflash.jpeg"),
            ],
          ),
        ),
      ),
    );
  }
}
