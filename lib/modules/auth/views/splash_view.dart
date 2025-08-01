

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/auth/providers/auth_provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.initApp(context: context);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstant.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Image.asset(
          ImageConstant.splashImg,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
