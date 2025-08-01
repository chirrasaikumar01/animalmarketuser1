import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/dashboard/providers/dashboard_provider.dart';

class FABBottomAppBarItem {
  final String iconData;
  final String selectedIconData;
  final String text;
  final bool isCommunity;
  final bool isDoctor;
  final bool isFast;
  final bool isCattle;

  FABBottomAppBarItem({required this.iconData, required this.text, required this.selectedIconData, required this.isCommunity, required this.isFast, required this.isDoctor, required this.isCattle});
}

class FABBottomAppBar extends StatelessWidget {
  final List<FABBottomAppBarItem> items;
  final String? centerItemText;
  final double height;
  final double iconSize;
  final Color? backgroundColor;
  final Color? color;
  final Color? selectedColor;
  final NotchedShape? notchedShape;

  const FABBottomAppBar({
    super.key,
    required this.items,
    this.centerItemText,
    this.height = 42.0,
    this.iconSize = 20.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
  }) : assert(items.length == 5 || items.length == 3 || items.length == 4);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        List<Widget> tabItems = List.generate(items.length, (index) {
          return _buildTabItem(
            context: context,
            item: items[index],
            index: index,
            isActive: provider.baseActiveBottomIndex == index,
            isCommunity: items[index].isCommunity,
            isFast: items[index].isFast,
            isDoctor: items[index].isDoctor,
            isCattle: items[index].isCattle,
          );
        });

        return BottomAppBar(
          shape: notchedShape,
          surfaceTintColor: backgroundColor,
          color: Colors.white,
          shadowColor: Colors.black,
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tabItems,
          ),
        );
      },
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required FABBottomAppBarItem item,
    required int index,
    required bool isActive,
    required bool isCommunity,
    required bool isFast,
    required bool isDoctor,
    required bool isCattle,
  }) {
    final provider = Provider.of<DashboardProvider>(context, listen: false);

    Color? iconColor = isActive ? selectedColor : color;
    return Expanded(
      child: SizedBox(
        height: height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              provider.onChangeBaseBottomIndex(context, index, isCommunity, isFast, isDoctor, isCattle);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2.h),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: isActive ? selectedColor : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4.dm),
                        bottomRight: Radius.circular(4.dm),
                      )),
                ),
                const SizedBox(height: 8),
                Image.asset(
                  isActive ? item.selectedIconData : item.iconData,
                  height: iconSize,
                  width: iconSize,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 4),
                TText(keyName:
                  item.text,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 10,
                    fontFamily: FontsStyle.medium,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
