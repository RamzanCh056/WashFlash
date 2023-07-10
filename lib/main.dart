import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:washflash/screens/splash_screen.dart';
import 'package:washflash/utils/color.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51NNfoyG1pyX05sYY8fKp5EmJN8bWdM2jGRNcEYiuNqn3BGXs7IFYJ7HPtCviNjLhGNKzZ311A9TPE9jg8jFPed2U00QzAp2MUe';

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.whiteColor,
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

