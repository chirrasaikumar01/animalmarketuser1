import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';

class TText extends StatefulWidget {
  final String keyName;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TText({super.key, required this.keyName, this.style, this.textAlign, this.maxLines, this.overflow});

  @override
  State<TText> createState() => _TTextState();
}

class _TTextState extends State<TText> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationsProvider>(builder: (context, state, child) {
      return Text(state.tr(widget.keyName), textAlign: widget.textAlign, maxLines: widget.maxLines, overflow: widget.overflow, style: widget.style);
    });
  }
}
class RTText extends StatefulWidget {
  final String keyName;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final List<TextSpan>? children;
  const RTText({super.key, required this.keyName, this.style, this.textAlign, this.maxLines, this.overflow, this.children});

  @override
  State<RTText> createState() => _RTTextState();
}

class _RTTextState extends State<RTText> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationsProvider>(builder: (context, state, child) {
      return RichText(
        textAlign: widget.textAlign??TextAlign.start,
        maxLines: widget.maxLines,
        overflow: widget.overflow??TextOverflow.ellipsis,
        text: TextSpan(
          text: state.tr(widget.keyName),
          style:widget.style,
            children:widget.children
        ),
      );
    });
  }
}
class RTTextSpan extends StatefulWidget {
  final List<RTSpanItem> items;
  final TextAlign textAlign;
  final int? maxChildren;
  final String keyName;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  const RTTextSpan({
    super.key,
    required this.items,
    this.textAlign = TextAlign.start,
    this.maxChildren, required this.keyName, this.style, this.maxLines, this.overflow,
  });

  @override
  State<RTTextSpan> createState() => _RTTextSpanState();
}

class _RTTextSpanState extends State<RTTextSpan> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TranslationsProvider>(context, listen: false);
    final spans = widget.items
        .map((item) => TextSpan(
      text: provider.tr(item.key),
      style: item.style,
    ))
        .toList();
    final limitedSpans =
    widget.maxChildren != null ? spans.take(widget.maxChildren!).toList() : spans;
    return RichText(
      textAlign: widget.textAlign,
      maxLines:widget.maxLines,
      overflow:widget.overflow??TextOverflow.ellipsis,
      text: TextSpan(
        text:  provider.tr(widget.keyName),
        style: widget.style,
        children: limitedSpans,
      ),
    );
  }
}

// Helper class to store each text span's translation key and style
class RTSpanItem {
  final String key;
  final TextStyle style;

  RTSpanItem({required this.key, required this.style});
}