import 'package:animal_market/common_model/dashboard_arguments.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/appointment/views/my_appointment_view.dart';
import 'package:animal_market/modules/buy/views/buy_view.dart';
import 'package:animal_market/modules/buy_crop/views/buy_crop_view.dart';
import 'package:animal_market/modules/buy_pet/views/buy_pet_view.dart';
import 'package:animal_market/modules/cattle_heath/views/cattle_heath_status_view.dart';
import 'package:animal_market/modules/community/models/my_post_argument.dart';
import 'package:animal_market/modules/community/views/community_view.dart';
import 'package:animal_market/modules/community/views/my_post_view.dart';
import 'package:animal_market/modules/doctor_list/view/doctor_list_view.dart';
import 'package:animal_market/modules/know_education/views/knowledge_fvrt_view.dart';
import 'package:animal_market/modules/know_education/views/knowledge_view.dart';
import 'package:animal_market/modules/sell/views/sell_view.dart';
import 'package:animal_market/modules/sell_crop/views/sell_crop_view.dart';
import 'package:animal_market/modules/sell_pet/views/pet_sell_view.dart';
import 'package:animal_market/routes/routes.dart';

class DashboardProvider extends ChangeNotifier {
  TabController? tabController;
  String categoryId = '';
  List<String> baseTitles = [
    "home",
    "buy",
    "sell",
    "community",
    "doctors",
  ];

  List<Widget> get baseWidgets => [
        BuyView(categoryId: categoryId),
        BuyView(categoryId: categoryId),
        SellView(categoryId: categoryId),
        CommunityView(categoryId: categoryId, isBottom: true),
        const DoctorListView(),
      ];

  List<Widget> get baseCropWidgets => [
        BuyCropView(categoryId: categoryId),
        BuyCropView(categoryId: categoryId),
        SellCropView(categoryId: categoryId),
        CommunityView(categoryId: categoryId, isBottom: true),
        const DoctorListView(),
      ];

  List<Widget> get basePetWidgets => [
        BuyPetView(categoryId: categoryId),
        BuyPetView(categoryId: categoryId),
        PetSellView(categoryId: categoryId),
        CommunityView(categoryId: categoryId, isBottom: true),
        const DoctorListView(),
      ];

  List<Widget> get baseCattleWidgets => [
        BuyView(categoryId: categoryId),
        BuyView(categoryId: categoryId),
        SellView(categoryId: categoryId),
        CommunityView(categoryId: categoryId, isBottom: true),
        const CattleHeathStatusView(),
      ];

  List<Widget> get communityWidgets => [
        CommunityView(categoryId: categoryId, isBottom: true),
        CommunityView(categoryId: categoryId, isBottom: true),
        MyPostView(
          myPostArgument: MyPostArgument(id: "", categoryId: categoryId, isBottom: true),
        ),
      ];

  List<Widget> get knowEducationWidgets => [
        KnowledgeView(categoryId: categoryId),
        KnowledgeView(categoryId: categoryId),
        KnowledgeFvrtView(categoryId: categoryId),
      ];

  List<Widget> get doctorWidgets => [
        const MyAppointmentView(),
        const MyAppointmentView(),
        CommunityView(categoryId: categoryId, isBottom: true),
        const DoctorListView(),
      ];
  int baseActiveBottomIndex = 1;

  void onChangeBaseBottomIndex(
    BuildContext context,
    int index,
    bool isCommunity,
    bool isFast,
    bool isDoctor,
    bool isCattle,
  ) {
    if (index == 0) {
      baseActiveBottomIndex = 1;
      if (!isFast) {
        Navigator.pushNamedAndRemoveUntil(context, Routes.category, (route) => false);
      } else {
        Navigator.pop(context);
      }
      notifyListeners();
    }
    if (index == 4 && !isCommunity && !isDoctor && !isCattle) {
      Navigator.pushNamed(context, Routes.doctorDashboard, arguments: DashboardArguments(isFast: false, categoryId: categoryId));
      baseActiveBottomIndex = 1;
      notifyListeners();
    } else {
      baseActiveBottomIndex = index;
      notifyListeners();
    }
  }
}
