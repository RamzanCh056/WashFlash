import 'package:flutter/material.dart';
import 'package:washflash/screens/admin_screen/admin_pannel.dart';
import 'package:washflash/utils/color.dart';
import 'package:washflash/widget/reusable_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../model/car_service.dart';
import 'add_employee.dart';


class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  final List<String> sliderImages = [
    "assets/images/im 1.jpg",
    "assets/images/im 2.jpg",
    "assets/images/im 3.jpg",
  ];

  final List<CarService> serviceName = [
    CarService(title: "Car", image: "assets/images/car.png"),
    CarService(title: "Cab", image: "assets/images/cab.png"),
    CarService(title: "Truck", image: "assets/images/truck.png"),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.blueColor,
          centerTitle: true,
          title: const ReusableText(
            title: "Category",
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              CarouselSlider(
                options: CarouselOptions(height: height * 0.25, autoPlay: true),
                items: sliderImages.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(i),
                            ),
                          ));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReusableText(
                      title: "Category",
                      size: 20,
                      weight: FontWeight.bold,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          serviceName.length,
                          (index) {
                            return Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return AdminPannel(
                                          selectedService: index == 0
                                              ? "Car"
                                              : index == 1
                                                  ? "Cab"
                                                  : "Truck");
                                    }),
                                  );
                                },
                                child: Card(
                                  color: AppColor.lightGreyColor,
                                  elevation: 6,
                                  margin: const EdgeInsets.all(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage(
                                              serviceName[index].image),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ReusableText(
                                          title: serviceName[index].title,
                                          size: 24,
                                          weight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                     InkWell(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                           return const AddEmployeeScreen();
                         }),);
                       },
                       child: const Card(
                        color: AppColor.lightGreyColor,
                        elevation: 6,
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.person,
                              size: 50,
                              color: AppColor.textColor,
                            ),
                            title: ReusableText(
                              title: "Add Employee",
                              size: 24,
                              weight: FontWeight.w500,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 30,
                            ),
                          ),
                        ),
                    ),
                     )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
