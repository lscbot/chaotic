part of widgets;

class CustomText extends StatelessWidget {
  final String? tag, text;
  final TextStyle? style;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final int maxLines;
  final TextAlign align;

  const CustomText({
    this.tag,
    this.text,
    this.style,
    this.fontSize = 10,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.maxLines = 1,
    this.align = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final deliStyle = style ??
        TextStyle(
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          color: color,
        );
    return Text(
      text ?? tr(tag ?? 'text and tag = null'),
      style: deliStyle,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      locale: context.locale,
      maxLines: maxLines,
    );
  }
}
