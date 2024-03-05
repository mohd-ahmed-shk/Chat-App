import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? width;
  final String title;
  const AppButton({super.key, required this.onPressed, required this.title, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,height: 45.h,
      child: ElevatedButton(onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD5715B)
          ),
          child: Text(title,style: TextStyle(color: Colors.white,fontSize: 18.sp),)),
    );
  }
}
