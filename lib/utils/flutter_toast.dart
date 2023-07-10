
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'color.dart';



class Utils {
  static errorToast (String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.redColor,
        textColor: AppColor.whiteColor,
        fontSize: 16.0
    );
  }
  static successToast (String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.blackColor,
        textColor: AppColor.whiteColor,
        fontSize: 16.0
    );
  }
}