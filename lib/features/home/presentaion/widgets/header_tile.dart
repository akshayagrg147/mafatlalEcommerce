import 'package:flutter/material.dart';

class HoverUnderlineText extends StatefulWidget {
  // Text displayed
  final String text;

  // Initial and hover colors for the text
  final Color initialColor;
  final Color hoverColor;

  // Font size of the text
  final double fontSize;

  // Optional callback function for click events
  final VoidCallback? onTap;

  const HoverUnderlineText({
    required this.text,
    this.initialColor = Colors.blue,
    this.hoverColor = Colors.red,
    this.fontSize = 16.0,
    this.onTap,
  });

  @override
  State<HoverUnderlineText> createState() => _HoverUnderlineTextState();
}

class _HoverUnderlineTextState extends State<HoverUnderlineText> {
  bool isHovered = false;
  late TextStyle style;
  double textWidth = 0.0;

  @override
  void initState() {
    style = TextStyle(
      color: isHovered ? widget.hoverColor : widget.initialColor,
      height: 2,
      fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
      fontSize: widget.fontSize,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    textWidth = textPainter.size.width;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => _onHoverChanged(
        true,
      ),
      onExit: (event) => _onHoverChanged(
        false,
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: isHovered ? widget.hoverColor : widget.initialColor,
            height: 2,
            fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
            fontSize: widget.fontSize,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.text),
              if (isHovered)
                SizedBox(
                  width: textWidth,
                  child: Divider(
                    color: widget.hoverColor,
                    thickness: 3,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void _onHoverChanged(
    bool isHovered,
  ) {
    this.isHovered = isHovered;
    setState(() {});
  }
}
