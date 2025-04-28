import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AutoScrollText extends StatelessWidget {
  final String text;
  final double height;
  final double maxWidth;
  final TextStyle? style;
  final TextAlign? align;

  const AutoScrollText(
      {Key? key,
      required this.text,
      required this.maxWidth,
      this.height = 20,
      this.style,
      this.align = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // measure the text
    final textStyle = style ?? DefaultTextStyle.of(context).style;
    final tp = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    if (tp.width <= maxWidth) {
      // fits: just render normally
      return SizedBox(
        height: height,
        width: maxWidth,
        child: Text(
          text,
          style: textStyle,
          maxLines: 1,
          overflow: TextOverflow.clip,
          textAlign: align,
        ),
      );
    } else {
      // too long: use marquee
      return SizedBox(
        height: height,
        width: maxWidth,
        child: Marquee(
          text: text,
          blankSpace: 20.0,
          style: textStyle,
          velocity: 30.0,
          pauseAfterRound: Duration(seconds: 2),
        ),
      );
    }
  }
}
