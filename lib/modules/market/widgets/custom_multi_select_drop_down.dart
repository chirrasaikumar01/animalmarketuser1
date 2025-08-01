import 'package:animal_market/core/export_file.dart';

class CustomMultiSelectDropdown<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final ValueChanged<List<T>> onChanged;
  final String Function(T) itemLabelBuilder;
  final String Function(T) itemValueBuilder;
  final TextStyle? selectedTextStyle;
  final TextStyle? placeholderTextStyle;
  final BoxDecoration? containerDecoration;
  final BoxDecoration? dropdownDecoration;
  final String placeholderText;
  final bool closeAfterSelection;

  const CustomMultiSelectDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.itemLabelBuilder,
    required this.itemValueBuilder,
    this.selectedTextStyle,
    this.placeholderTextStyle,
    this.containerDecoration,
    this.dropdownDecoration,
    this.placeholderText = "Select Items",
    this.closeAfterSelection = false,
  });

  @override
  State<CustomMultiSelectDropdown<T>> createState() => _CustomMultiSelectDropdownState<T>();
}

class _CustomMultiSelectDropdownState<T> extends State<CustomMultiSelectDropdown<T>> {
  bool isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isDropdownOpen) {
          setState(() {
            isDropdownOpen = false;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isDropdownOpen = !isDropdownOpen;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: widget.containerDecoration ??
                  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TText(keyName: _buildSelectedItemsTText(),
                      style: widget.selectedItems.isEmpty
                          ? (widget.placeholderTextStyle ??
                              TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ))
                          : (widget.selectedTextStyle ??
                              TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontsStyle.regular,
                                color: ColorConstant.appCl,
                              )),
                    ),
                  ),
                  Image.asset(
                    ImageConstant.arrowDropDownIc,
                    height: 24.h,
                    width: 24.w,
                  )
                ],
              ),
            ),
          ),
          if (isDropdownOpen)
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 180,
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                width: double.maxFinite,
                decoration: widget.dropdownDecoration ??
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                child: ListView(
                  shrinkWrap: true,
                  children: widget.items.map((item) {
                    bool isSelected = widget.selectedItems.any((selectedItem) => widget.itemValueBuilder(selectedItem) == widget.itemValueBuilder(item));
                    return ListTile(
                      title: TText(keyName:
                        widget.itemLabelBuilder(item),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: ColorConstant.black,
                          fontFamily: FontsStyle.regular,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      leading: Icon(
                        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isSelected ? ColorConstant.appCl : Colors.black,
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            widget.selectedItems.removeWhere((selectedItem) => widget.itemValueBuilder(selectedItem) == widget.itemValueBuilder(item));
                          } else {
                            widget.selectedItems.add(item);
                          }
                        });
                        widget.onChanged(List.from(widget.selectedItems));
                        if (widget.closeAfterSelection) {
                          setState(() {
                            isDropdownOpen = false;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _buildSelectedItemsTText() {
    if (widget.selectedItems.isEmpty) {
      return widget.placeholderText;
    } else {
      return widget.selectedItems.map(widget.itemLabelBuilder).join(", ");
    }
  }
}
