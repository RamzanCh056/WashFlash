import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washflash/screens/home_screen.dart';

import 'admin_screen/category_screen.dart';
import 'register_screen.dart';
import '../utils/color.dart';
import '../widget/reusable_button.dart';
import '../widget/reusable_text.dart';
import '../widget/reusable_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  userLogin() async {
    isLoading = true;
    setState(() {});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool userNameExists;
    bool passwordExists;
    bool adminExist;
    bool adminPasswordExist;
    try {
      var authResult = await FirebaseFirestore.instance
          .collection("Register")
          .where('email', isEqualTo: _emailController.text)
          .get();

      var adminResult = await FirebaseFirestore.instance
          .collection("Admin")
          .where('email', isEqualTo: _emailController.text.toLowerCase(),)
          .get();
      userNameExists = authResult.docs.isNotEmpty;
      adminExist = adminResult.docs.isNotEmpty;
      if (userNameExists) {
        var authResult = await FirebaseFirestore.instance
            .collection("Register")
            .where('password',
                isEqualTo: _passwordController.text.toLowerCase())
            .get();
        passwordExists = authResult.docs.isNotEmpty;
        if (passwordExists) {
          await preferences.setBool('isLoggedIn', true);
          String userName = authResult.docs[0]["name"];

          await preferences.setString('username', userName);
          // await preferences.setString('email', _emailController.text.trim());
          // await preferences.setString('password', _passwordController.text.trim());
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: 'Successfully logged in');
          //NavigateToHome
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: 'Incorrect username or password');
        }
      }
      else if (adminExist) {
        var adminResult = await FirebaseFirestore.instance
            .collection("Admin")
            .where('password', isEqualTo: _passwordController.text)
            .get();
        adminPasswordExist = adminResult.docs.isNotEmpty;
        if (adminPasswordExist) {
          // await preferences.setString('email', _emailController.text.trim());
          // await preferences.setString('password', _passwordController.text.trim());
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: 'Successfully logged in');
          //NavigateToHome
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminCategoryScreen()),
          );
        } else {
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: 'Incorrect username or password');
        }
      }
      else {
        isLoading = false;
        setState(() {});
        Fluttertoast.showToast(msg: 'Incorrect username or password');
      }





    } catch (e) {
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Some error occurred');
    }


  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPass = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  AppColor.blackColor.withOpacity(0.3), BlendMode.darken),
              fit: BoxFit.cover,
              image: const AssetImage("assets/images/car wash.jpg"),
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColor.whiteColor,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                              height: 150,
                              width: 150,
                              child: Image.asset("assets/images/logo.png",fit: BoxFit.cover,),),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          const ReusableText(
                            title: "Login With Your Account",
                            size: 24,
                            weight: FontWeight.w700,
                            color: AppColor.textColor,
                          ),
                          SizedBox(
                            height: height * 0.04,
                          ),
                          ReusableTextForm(
                            controller: _emailController,
                            hintText: "Email",
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_rounded),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "this field is required";
                              } else if (!v.contains("@")) {
                                return "email badly formatted";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          ReusableTextForm(
                            controller: _passwordController,
                            hintText: "Password",
                            obscureText: isPass,
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isPass = !isPass;
                                  });
                                },
                                child: Icon(isPass
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Password should not be null";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.04,
                          ),
                          ReusableButton(
                            title: "Login",
                            isLoading: isLoading,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                userLogin();
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const ReusableText(
                                  title: "Don't have an account ? "),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return const RegisterScreen();
                                    }),
                                  );
                                },
                                child: const ReusableText(title: "Sign up"),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
