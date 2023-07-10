import 'package:flutter/material.dart';
import 'package:washflash/widget/reusable_text.dart';

import '../utils/color.dart';
class ReusableRow extends StatelessWidget {
  final String name;
  final String value;

  const ReusableRow({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ReusableText(
              title: name,
              size: 16,
              weight: FontWeight.w700,
              color: AppColor.textColor,
            ),
          ),
          Expanded(
            flex: 2,
            child: ReusableText(
              title: value,
              size: 16,
              weight: FontWeight.w700,
              color: AppColor.textColor,
            ),
          ),
        ],
      ),
    );
  }
}