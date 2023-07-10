import 'package:flutter/material.dart';
import 'package:washflash/widget/reusable_text.dart';

import '../utils/color.dart';
class ReusableButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  const ReusableButton({
    super.key, required this.title, required this.onTap,  this.isLoading = false,
  });


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height * 0.09,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.blueColor),
        child: isLoading ? const CircularProgressIndicator(color: AppColor.whiteColor,) : ReusableText(
          title: title,
          size: 20,
          weight: FontWeight.w700,
          color: AppColor.whiteColor,
        ),
      ),
    );
  }
}