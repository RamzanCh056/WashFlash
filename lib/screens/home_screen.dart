import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washflash/model/add_employee.dart';
import 'package:washflash/screens/view_employee.dart';
import 'package:washflash/utils/color.dart';
import 'package:washflash/utils/flutter_toast.dart';
import 'package:washflash/widget/reusable_text.dart';

import '../model/car_service.dart';
import 'booking_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<AddEmployee> employee = [];
  Position? currentPosition;

  Future _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      Utils.errorToast("to access the location you need to get permission");
    }
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  showEmployee() async {
    await _checkPermission();
    employee.clear();
    setState(() {});

    try {
      if (currentPosition != null) {
        FirebaseFirestore.instance
            .collection("addEmploye")
            .snapshots()
            .listen((event) async {
          employee.clear();
          setState(() {});

          for (int i = 0; i < event.docs.length; i++) {
            AddEmployee employeeData = AddEmployee.fromJson(event.docs[i].data());
            double distance = await Geolocator.distanceBetween(
              currentPosition!.latitude,
              currentPosition!.longitude,
              employeeData.latitude!,
              employeeData.longitude!,
            );

            print(distance.toString());
            if (distance <= 10000) {
              employee.add(employeeData);
            }
          }

          setState(() {});
        });
      }
    } catch (e) {
      Utils.errorToast("Some Error Occurred");
    }
  }


  Future handleLogout(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
      return const LoginScreen();
    }), (route) => false);
  }

  SharedPreferences? preferences;

  @override
  void initState() {
    showEmployee();
    SharedPreferences.getInstance().then((value) {
      preferences = value;
      setState(() {});
    });
    super.initState();
  }

  final List<CarService> serviceName = [
    CarService(title: "Car", image: "assets/images/car.png"),
    CarService(title: "Cab", image: "assets/images/cab.png"),
    CarService(title: "Truck", image: "assets/images/truck.png"),
  ];
  final List images = [
    "assets/images/1.jpeg",
    "assets/images/2.jpeg",
    "assets/images/3.jpeg",
    "assets/images/44.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              color: AppColor.blueColor,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ReusableText(
                        title: "Hi,",
                        size: 20,
                        weight: FontWeight.w700,
                        color: AppColor.whiteColor,
                      ),
                      InkWell(
                          onTap: () {
                            handleLogout(context);
                          },
                          child: const Icon(
                            Icons.logout_rounded,
                            color: AppColor.whiteColor,
                          ))
                    ],
                  ),
                  ReusableText(
                    title: preferences?.getString('username') ?? '',
                    size: 20,
                    weight: FontWeight.w700,
                    color: AppColor.whiteColor,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  const ReusableText(
                    title: "Welcome To",
                    size: 18,
                    weight: FontWeight.w500,
                    color: AppColor.whiteColor,
                  ),
                  SizedBox(
                    height: height * 0.001,
                  ),
                  const ReusableText(
                    title: "Wash Flash",
                    size: 25,
                    weight: FontWeight.bold,
                    color: AppColor.whiteColor,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ReusableText(
                    title: "Services",
                    size: 18,
                    weight: FontWeight.w700,
                    color: AppColor.textColor,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(serviceName.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return BookingScreen(
                                    index: index,
                                  );
                                }),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 110,
                                  width: 110,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.lightGreyColor,
                                  ),
                                  child: Image.asset(
                                    serviceName[index].image,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                ReusableText(
                                  title: serviceName[index].title,
                                  size: 18,
                                  weight: FontWeight.w700,
                                  color: AppColor.textColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ReusableText(
                        title: "Specialist",
                        size: 18,
                        weight: FontWeight.w700,
                        color: AppColor.textColor,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return ViewEmployee(employee: employee);
                            }),
                          );
                        },
                        child: const ReusableText(
                          title: "View All",
                          size: 18,
                          weight: FontWeight.w700,
                          color: AppColor.textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  employee.isEmpty
                      ? Center(
                          child: const Text("There is no employee Near you"))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(employee.length, (index) {
                              final data = employee[index];

                              return Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 110,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.blackColor),
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                data.image.toString()),
                                            fit: BoxFit.cover),
                                        color: AppColor.lightGreyColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ReusableText(
                                      title: data.name,
                                      size: 18,
                                      weight: FontWeight.w700,
                                      color: AppColor.textColor,
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    ReusableText(
                                      title: data.jobTitle,
                                      size: 16,
                                      weight: FontWeight.w400,
                                      color: AppColor.textColor,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const ReusableText(
                    title: "Flash Market Car",
                    size: 18,
                    weight: FontWeight.w700,
                    color: AppColor.textColor,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(images.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColor.blackColor),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: AssetImage(images[index]),
                                      fit: BoxFit.cover),
                                  color: AppColor.lightGreyColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
