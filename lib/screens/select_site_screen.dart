import 'package:flutter/material.dart';
import 'package:washflash/utils/color.dart';
import 'package:washflash/widget/reusable_text.dart';

import 'admin_screen/category_screen.dart';
import 'login_screen.dart';

class SelectSite extends StatelessWidget {
  const SelectSite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return const AdminCategoryScreen();
                }),);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.admin_panel_settings,size: 100,color: AppColor.textColor,),
                ReusableText(title: "Admin",size: 30,)
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return const LoginScreen();
                }),);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.person,size: 100,color: AppColor.textColor,),
                ReusableText(title: "User",size: 30,)
                ],
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}
