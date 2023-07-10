import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:washflash/screens/admin_screen/map_screen.dart';
import 'package:washflash/utils/color.dart';
import 'package:washflash/utils/flutter_toast.dart';

import '../../model/booking_model.dart';
import '../../widget/reusable_row.dart';
import '../../widget/reusable_text.dart';

class AdminPannel extends StatefulWidget {
  final String selectedService;
  const AdminPannel({Key? key, required this.selectedService}) : super(key: key);

  @override
  State<AdminPannel> createState() => _AdminPannelState();
}

class _AdminPannelState extends State<AdminPannel> {

  bool isVisible = false;

  List<BookingModel> allData = [];

  showOrders() {
    try {
      allData.clear();
      setState(() {});
      FirebaseFirestore.instance
          .collection("Booking")
          .snapshots()
          .listen((event) {
        allData.clear();
        setState(() {});
        for (int i = 0; i < event.docs.length; i++) {
          BookingModel dataModel = BookingModel.fromJson(event.docs[i].data());
          allData.add(dataModel);
        }
        setState(() {});
      });
      setState(() {});
    } catch (e) {
      Utils.errorToast("Some Error Occured");
    }
  }

  @override
  void initState() {
    showOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = allData.where((element){
      return element.serviceType!.contains(widget.selectedService);
    }).toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.blueColor,
          centerTitle: true,
          title: const ReusableText(
            title: "Admin Panel",
            size: 16,
            weight: FontWeight.w700,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ReusableText(
                  title: "Today Orders",
                  color: AppColor.textColor,
                  size: 18,
                  weight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                data.isEmpty ? const ReusableText(
                  title: "There is no order ",
                  color: AppColor.textColor,
                  size: 18,
                  weight: FontWeight.bold,
                ) : Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return MapScreen(
                                lat: data[index].lat!.toDouble(),
                                long: data[index].long!.toDouble(),
                                address: data[index].location!,
                              );
                            }),
                          );
                        },
                        child: Card(
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReusableRow(
                                  name: 'Name :',
                                  value: data[index].name.toString(),
                                ),
                                ReusableRow(
                                  name: 'Phone :',
                                  value: allData[index].phone.toString(),
                                ),
                                ReusableRow(
                                  name: 'Date :',
                                  value: data[index].dateShow.toString(),
                                ),
                                ReusableRow(
                                  name: 'Time :',
                                  value: data[index].time.toString(),
                                ),
                                isVisible ? const SizedBox() : Column(
                                  children: [

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                        onTap: (){
                                          setState(() {

                                            isVisible = true;
                                          });
                                        },
                                        child: const ReusableText(title: "Show more...",size: 16,weight: FontWeight.w700,color: AppColor.blackColor,)),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: isVisible,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      ReusableRow(
                                        name: 'Color :',
                                        value: data[index].color.toString(),
                                      ),
                                      ReusableRow(
                                        name: 'Long :',
                                        value: data[index].long.toString(),
                                      ),
                                      ReusableRow(
                                        name: 'lat :',
                                        value: data[index].lat.toString(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const ReusableText(
                                        title: "Services",
                                        size: 16,
                                        weight: FontWeight.bold,
                                        color: AppColor.blackColor,
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: data[index].services!.length,
                                        itemBuilder:
                                            (BuildContext context, int serviceIndex) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: ReusableText(
                                              title: data[index]
                                                  .services![serviceIndex]
                                                  .toString(),
                                              size: 16,
                                              weight: FontWeight.w700,color: AppColor.textColor,),
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                          onTap: (){
                                            setState(() {

                                              isVisible = false;
                                            });
                                          },
                                          child: const ReusableText(title: "less more ...",size: 16,weight: FontWeight.w700,color: AppColor.blackColor,)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
