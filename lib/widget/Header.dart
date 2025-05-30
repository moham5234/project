import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildHeader() {
  return Container(
    height: 120.h,
    decoration: BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(100.r),
        bottomLeft: Radius.circular(100.r),
      ),
    ),
    child: Center(
      child: Image.asset(
        "Assets/log2.png",
        width: 130.w,
      ),
    ),
  );
}
