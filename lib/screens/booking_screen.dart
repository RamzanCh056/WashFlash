import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:multiselect/multiselect.dart';
import 'package:washflash/utils/flutter_toast.dart';
import '../model/booking_model.dart';
import '../model/service_selection.dart';
import '../utils/color.dart';
import '../widget/reusable_button.dart';
import '../widget/reusable_text.dart';
import '../widget/reusable_textformfield.dart';
import 'location_pick.dart';
import 'package:http/http.dart' as http;

class BookingScreen extends StatefulWidget {
  final int index;

  // final List<ServiceSelection> serciceType;
  const BookingScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<String> servicetype = [];
  List<String> car = [
    "Full Wash \$450",
    "Foreign Service \$250",
    "Inside Service \$250",
    "Upholstery Cleaning \$400",
    "Other Services ",
  ];
  List<String> cab = [
    "Full Wash \450",
    "Foreign Service \$250",
    "Inside Service \$250",
    "Upholstery Cleaning \$400",
    "Other Services ",
  ];
  List<String> truck = [
    "Full Wash \525",
    "Foreign Service \300",
    "Inside Service \300",
    "Upholstery Cleaning \800",
    "Other Services ",
  ];

  double lat = 0;
  double long = 0;

  AddSupplier() async {
    isLoading = true;
    setState(() {});
    int id = DateTime.now().millisecondsSinceEpoch;
    BookingModel dataModel = BookingModel(
      serviceType: widget.index == 0
          ? "Car"
          : widget.index == 1
              ? "Cab"
              : "Truck",
      services: servicetype,
      color: _colorController.text,
      location: _locationController.text,
      lat: lat,
      long: long,
      modelNumber: _modelController.text,
      name: _nameController.text,
      phone: _phoneController.text,
      doc: id.toString(),
      time: _timeController.text,
      dateShow: _dateController.text,
    );
    try {
      await FirebaseFirestore.instance
          .collection("Booking")
          .doc('$id')
          .set(dataModel.toJson());
      isLoading = false;
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Request book successfully"),
      ));
    } catch (e) {
      isLoading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: AppColor.redColor,
        content: Text("Some error occurred"),
      ));
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPass = true;

  String? selectedService;
  bool visible = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  Map<String, dynamic>? paymentIntent;

  Future<void> openPaymentSheetWidget() async {
    try {
      paymentIntent = await makingPaymentDataIntentApi('200', 'INR');
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          appearance: PaymentSheetAppearance(
            primaryButton: const PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Colors.blue,
                ),
              ),
            ),
            colors: PaymentSheetAppearanceColors(background: AppColor.blueColor),
          ),
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.system,
          merchantDisplayName: 'Merchant Display Name',
        ),
      )
          .then((value) {
        showPaymentSheetWidget();
      });
    } catch (exe, s) {
      debugPrint('Exception:$exe$s');
    }
  }

  makingPaymentDataIntentApi(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      debugPrint("Body : $body");
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Add_Your_Authorization_Token_Here',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('callPaymentIntentApi Exception: ${err.toString()}');
    }
  }

  calculateAmount(amount){
    final price = int.parse(amount) * 100;
    return price.toString();
  }
  showPaymentSheetWidget() async {
    try {
      await Stripe.instance.presentPaymentSheet(
        );
      setState(() {
        paymentIntent = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            "Payment Successfully Completed ",
            style: TextStyle(color: Colors.white),
          )));
    } on StripeException catch (e) {
      debugPrint('StripeException:  $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Get Stripe Exception"),
          ));
    } catch (e) {
      debugPrint('$e');
    }
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
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
        appBar: AppBar(
          backgroundColor: AppColor.blueColor,
          centerTitle: true,
          title: const ReusableText(title: "Book Slot"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.cover,
                    ),
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

                  Container(
                    width: width,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.lightGreyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropDownMultiSelect(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      )),
                      options: widget.index == 0
                          ? car
                          : widget.index == 1
                              ? cab
                              : truck,
                      selectedValues: servicetype,
                      onChanged: (value) {
                        setState(() {
                          servicetype = value;
                        });
                      },
                      whenEmpty: 'Select the service type',
                    ),
                  ),
                  // Container(
                  //   width: width,
                  //   constraints: BoxConstraints(minHeight: 50),
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: AppColor.lightGreyColor,
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       InkWell(
                  //         onTap: () {
                  //           setState(() {
                  //             visible = !visible;
                  //           });
                  //         },
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(selectedService ?? "Select Service"),
                  //             Icon(visible
                  //                 ? Icons.keyboard_arrow_up_rounded
                  //                 : Icons.keyboard_arrow_down_sharp)
                  //           ],
                  //         ),
                  //       ),
                  //       Visibility(
                  //         visible: visible,
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: widget.serciceType.map((e) {
                  //             return CheckboxListTile(value: e.checkValue,
                  //               title: Text(
                  //                 e.title.toString(),
                  //               ),
                  //               subtitle: Text(
                  //                 e.subTitle.toString(),
                  //               ),
                  //               controlAffinity: ListTileControlAffinity.leading,
                  //               secondary: Text(
                  //                 e.price.toString(),
                  //               ),
                  //               onChanged: (v) {
                  //                 setState(() {
                  //                   e.checkValue = v;
                  //
                  //
                  //                 });
                  //               },
                  //             );
                  //
                  //           }).toList(),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  InkWell(
                    onTap: () async {
                      var result = await Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return LocationPicker();
                      }));

                      if (result != null) {
                        setState(() {
                          _locationController.text = result.address;
                          lat = result.latLong.latitude;
                          long = result.latLong.longitude;
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
                  InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        setState(() {
                          _dateController.text =
                              "${value!.year}-${value!.month}-${value!.day}";
                        });
                      });
                    },
                    child: ReusableTextForm(
                      controller: _dateController,
                      hintText: "Date",
                      enabled: false,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.date_range),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        setState(() {
                          _timeController.text = "${value!.format(context)}";
                        });
                      });
                    },
                    child: ReusableTextForm(
                      controller: _timeController,
                      hintText: "Time",
                      enabled: false,
                      prefixIcon: const Icon(Icons.alarm),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  ReusableTextForm(
                    controller: _modelController,
                    hintText: "Model Number",
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
                      title: "Book Now",
                      isLoading: isLoading,
                      onTap: () async {

                        if (_formKey.currentState!.validate()) {
                          await openPaymentSheetWidget().then((value) => AddSupplier());

                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
