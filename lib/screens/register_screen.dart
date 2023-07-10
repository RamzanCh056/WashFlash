import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'
;
import 'package:geolocator/geolocator.dart';import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:washflash/screens/login_screen.dart';

import '../model/add_user.dart';
import '../utils/color.dart';
import '../utils/flutter_toast.dart';
import '../widget/reusable_button.dart';
import '../widget/reusable_text.dart';
import '../widget/reusable_textformfield.dart';
import 'location_pick.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  RegisterUser() async {
    isLoading = true;
    setState(() {});
    int id = DateTime.now().millisecondsSinceEpoch;
    AddUserModel dataModel = AddUserModel(
      name: _nameController.text,
      email: _emailController.text,
      password:_passwordController.text,
      location: _locationController.text,
      phoneNumber: _phoneController.text,
      color: _colorController.text,
      vehicle: _vehicleController.text,
      doc: id.toString(),
    );
    try {
      await FirebaseFirestore.instance
          .collection("Register")
          .doc('$id')
          .set(dataModel.toJson());
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'account created successfully');

    } catch (e) {
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Some error occurred');
    }
  }
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPass = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _colorController.dispose();
    _vehicleController.dispose();
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
          child: Column(
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    color: AppColor.whiteColor,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset("assets/images/logo.png",fit: BoxFit.cover,),),
                          const ReusableText(
                            title: "Register Your Account",
                            size: 24,
                            weight: FontWeight.w700,
                            color: AppColor.textColor,
                          ),
                          SizedBox(
                            height: height * 0.04,
                          ),
                          ReusableTextForm(
                            controller: _nameController,
                            hintText: "Name",
                            prefixIcon: const Icon(Icons.person),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "this field is required";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.02,
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
                            controller: _phoneController,
                            hintText: "Phone Number",
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Phone number should not be null";
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
                                onTap: (){
                                  setState(() {
                                    isPass = !isPass;
                                  });
                                },
                                child:  Icon(isPass ? Icons.visibility : Icons.visibility_off)),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Password should not be null";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          InkWell(
                            onTap: () async{
                            var result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                               return LocationPicker();
                             }));

                            if (result != null) {
                              setState(() {
                                _locationController.text = result.address;
                              });
                            }
                            },
                            child: ReusableTextForm(
                              controller: _locationController,
                              hintText: "Location",
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "this field is required";
                                } else {
                                  return null;
                                }
                              },
                              enabled: false,
                              prefixIcon: const Icon(Icons.location_on),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          ReusableTextForm(
                            controller: _vehicleController,
                            hintText: "Vehicle",
                            prefixIcon: const Icon(Icons.bus_alert_rounded),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "this field is required";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          ReusableTextForm(
                            controller: _colorController,
                            hintText: "Color",
                            prefixIcon: const Icon(Icons.color_lens),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Color is required";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.04,
                          ),

                          ReusableButton(
                            title: "Register",
                            isLoading: isLoading,
                            onTap: () async {

                              if (_formKey.currentState!.validate()) {
                                RegisterUser();

                                // await AuthServices.createAccount(
                                //         _emailController.text,
                                //         _passwordController.text)
                                //     .then((value) {
                                //   if (value != null) {
                                //     setState(() {
                                //       isLoading = true;
                                //     });
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (ctx) => const HomeScreen()),
                                //     );
                                //     Utils.successToast(
                                //         "Account Successfully created");
                                //   }
                                //   else {
                                //     setState(() {
                                //       isLoading = false;
                                //     });
                                //   }
                                // });
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const ReusableText(
                                  title: "Already have an account ? "),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return const LoginScreen();
                                    }),
                                  );
                                },
                                child: const ReusableText(title: "Login"),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
