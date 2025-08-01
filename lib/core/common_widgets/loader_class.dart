

import 'package:animal_market/core/export_file.dart';

class LoaderClass extends StatefulWidget {
  final double height;
  final Color? color;

  const LoaderClass({super.key, required this.height, this.color});

  @override
  State<LoaderClass> createState() => _LoaderClassState();
}

class _LoaderClassState extends State<LoaderClass> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.height,
      color: widget.color ?? ColorConstant.appCl.withValues(alpha: 0.05),
      child: const Center(
        child: CircularProgressIndicator(
          color: ColorConstant.appCl,
        ),
      ),
    );
  }
}
