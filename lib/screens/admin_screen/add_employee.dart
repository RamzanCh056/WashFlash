import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:washflash/model/add_employee.dart';
import 'package:washflash/utils/flutter_toast.dart';
import 'package:washflash/widget/reusable_button.dart';

import '../../utils/color.dart';
import '../../widget/reusable_textformfield.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  File? selectedImage;
  String? imageUrl;

  Future uploadImage() async {
    try {
      Reference storage = FirebaseStorage.instance
          .ref()
          .child("images/${DateTime.now().microsecondsSinceEpoch}");
      final uploadTask = storage.putFile(selectedImage!);
      final snapshot = await uploadTask!.whenComplete(() => null);
      final url = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      Utils.errorToast("Image not upload");
    }
  }

  Future pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future uploadData() async {
    setState(() {
      isLoading = true;
    });
    await uploadImage();
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    AddEmployee addEmployee = AddEmployee(
        image: imageUrl,
        id: id,
        name: nameC.text,
        about: aboutC.text,
        jobTitle: jobC.text,
      latitude: double.parse(latitudeC.text),
      longitude: double.parse(longitudeC.text),

    );

    try {
      await FirebaseFirestore.instance
          .collection("addEmploye")
          .add(addEmployee.toJson());
      isLoading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Employee Added successfully"),
      ));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Utils.errorToast("Some Error occured");
    }
  }

  final TextEditingController nameC = TextEditingController();
  final TextEditingController aboutC = TextEditingController();
  final TextEditingController jobC = TextEditingController();
  final TextEditingController latitudeC = TextEditingController();
  final TextEditingController longitudeC = TextEditingController();

  @override
  void dispose() {
    nameC.dispose();
    aboutC.dispose();
    jobC.dispose();
    latitudeC.dispose();
    longitudeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Add Employee",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: Stack(
                        children: [
                          selectedImage != null
                              ? Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColor.lightBlueColor,
                                        width: 2),
                                    shape: BoxShape.circle,
                                    color: AppColor.lightGreyColor,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        File(selectedImage!.path),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColor.lightBlueColor,
                                        width: 2),
                                    shape: BoxShape.circle,
                                    color: AppColor.lightGreyColor,
                                  ),
                                ),
                          const Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                                color: AppColor.lightBlueColor,
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Personal Information",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableTextForm(
                    controller: nameC,
                    hintText: "Name",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "This field is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ReusableTextForm(
                    controller: aboutC,
                    hintText: "About",
                    maxLines: 5,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "This field is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ReusableTextForm(
                    controller: jobC,
                    hintText: "Job Title",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "This field is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10
                  ),
                  ReusableTextForm(
                    controller: latitudeC,
                    keyboardType: TextInputType.number,
                    hintText: "Latitude",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "This field is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10
                  ),
                  ReusableTextForm(
                    controller: longitudeC,
                    keyboardType: TextInputType.number,
                    hintText: "Longitude",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "This field is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableButton(
                      title: "Add Employee",
                      isLoading: isLoading,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          uploadData();
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
