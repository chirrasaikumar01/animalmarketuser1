import 'package:animal_market/core/export_file.dart';

class ShowMoreText extends StatefulWidget {
  final String description;
  final String userName;
  final Color? color;
  final List<String> tagList;

  const ShowMoreText({super.key, required this.description, required this.userName, required this.tagList, this.color});

  @override
  State<ShowMoreText> createState() => _ShowMoreTextState();
}

class _ShowMoreTextState extends State<ShowMoreText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> tagTextSpans = widget.tagList
        .map(
          (tag) => TextSpan(
            text: " $tag ",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              fontFamily: FontsStyle.medium,
              color: widget.color ?? ColorConstant.appCl,
            ),
          ),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: _isExpanded
              ? RichText(
                  text: TextSpan(
                    text: "${widget.userName} ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontsStyle.medium,
                      color: widget.color ?? Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: widget.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontFamily: FontsStyle.medium,
                          color: widget.color ?? Colors.grey,
                        ),
                      ),
                      if (widget.tagList.isNotEmpty) ...tagTextSpans,
                    ],
                  ),
                )
              : RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: "${widget.userName} ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontsStyle.medium,
                      color: widget.color ?? Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: widget.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontFamily: FontsStyle.medium,
                          color: widget.color ?? Colors.grey,
                        ),
                      ),
                      if (widget.tagList.isNotEmpty) ...tagTextSpans,
                    ],
                  ),
                ),
        ),
        if (widget.description.length > 50)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: TText(keyName:
              _isExpanded ? 'Show less' : 'Show more',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                fontFamily: FontsStyle.semiBold,
                color: ColorConstant.darkAppCl,
              ),
            ),
          ),
      ],
    );
  }
}
