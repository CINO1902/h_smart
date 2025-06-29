import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? textStyle;
  final TextStyle? seeMoreStyle;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 6,
    this.textStyle,
    this.seeMoreStyle,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  bool _showSeeMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow();
    });
  }

  void _checkTextOverflow() {
    final textSpan = TextSpan(text: widget.text);
    final tp = TextPainter(
      text: textSpan,
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 32);

    if (tp.didExceedMaxLines) {
      setState(() {
        _showSeeMore = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: widget.textStyle ??
                TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: theme.colorScheme.onSurface,
                ),
            maxLines: _expanded ? null : widget.maxLines,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (_showSeeMore && !_expanded)
            GestureDetector(
              onTap: () => setState(() => _expanded = true),
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  'See more',
                  style: widget.seeMoreStyle ??
                      TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
