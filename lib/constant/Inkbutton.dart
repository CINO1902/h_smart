import 'package:flutter/material.dart';

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
              ? Theme.of(context).primaryColor.withOpacity(.5)
              : Theme.of(context).primaryColor),
      child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          )),
    );
  }
}
