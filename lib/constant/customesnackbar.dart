import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class CustomeSnackbar extends StatelessWidget {
  CustomeSnackbar({
    Key? key,
    required this.topic,
    required this.msg,
    required this.color1,
    required this.color2,
  }) : super(key: key);

  final String topic;
  String msg;
  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.140,
          decoration: BoxDecoration(
            color: color1,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.05,
                      child: FittedBox(
                        child: Text(
                          topic,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        msg,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
            child: SvgPicture.asset(
              'images/bubbles.svg',
              height: 48,
              width: 40,
              color: color2,
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'images/fail.svg',
                height: 40,
              ),
              Positioned(
                top: 10,
                child: SvgPicture.asset(
                  'images/close.svg',
                  height: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
