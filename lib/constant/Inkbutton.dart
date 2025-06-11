import 'package:flutter/material.dart';
import 'package:h_smart/core/utils/appColor.dart';

class InkButton extends StatelessWidget {
  InkButton({
    super.key,
    required this.title,
    this.active,
  });
  String title;
  bool? active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 350,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: active != null
              ? AppColors.kprimaryColor500.withOpacity(.5)
              : AppColors.kprimaryColor500),
      child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          )),
    );
  }
}
