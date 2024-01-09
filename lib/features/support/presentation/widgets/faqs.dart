import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class facdoc extends StatefulWidget {
  facdoc({super.key, required this.title, required this.decr});
  String title;
  String decr;
  @override
  State<facdoc> createState() => _facdocState();
}

class _facdocState extends State<facdoc> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.blue.withOpacity(.7)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                show = !show;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 13, color: Color.fromARGB(255, 93, 93, 93)),
                ),
                show
                    ? SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset('images/chevron-down.png'))
                    : SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset('images/iconright.png'))
              ],
            ),
          ),
          Gap(10),
          show
              ? Text(
                  widget.decr,
                  style: TextStyle(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 93, 93, 93)),
                )
              : SizedBox(),
          Gap(10),
        ],
      ),
    );
  }
}
