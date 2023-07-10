import 'package:flutter/material.dart';

import '../model/add_employee.dart';
import '../utils/color.dart';
import '../widget/reusable_text.dart';

class ViewEmployee extends StatelessWidget {
  final List<AddEmployee> employee;

  const ViewEmployee({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const ReusableText(
            title: "Specialist",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GridView.builder(
            itemCount: employee.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10
            ),
            itemBuilder: (BuildContext context, int index) {
              final data = employee[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.lightGreyColor,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(data.image.toString()),
                              fit: BoxFit.cover),
                          color: AppColor.lightGreyColor,
                        ),
                      ),
                    ),
                    SizedBox(
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
            },
          ),
        ),
      ),
    );
  }
}
