import 'package:animal_market/common_model/dashboard_arguments.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/account/views/account_view.dart';
import 'package:animal_market/modules/account/views/edit_profile_view.dart';
import 'package:animal_market/modules/appointment/views/appointment_booking_view.dart';
import 'package:animal_market/modules/auth/models/language_argument.dart';
import 'package:animal_market/modules/auth/models/location_argument.dart';
import 'package:animal_market/modules/auth/views/location_view.dart';
import 'package:animal_market/modules/auth/views/login_view.dart';
import 'package:animal_market/modules/auth/views/otp_view.dart';
import 'package:animal_market/modules/auth/views/select_language_view.dart';
import 'package:animal_market/modules/auth/views/splash_view.dart';
import 'package:animal_market/modules/auth/views/user_name_view.dart';
import 'package:animal_market/modules/buy/models/cattle_argument.dart';
import 'package:animal_market/modules/buy/views/cattle_sub_category_view.dart';
import 'package:animal_market/modules/buy/views/market_details_view.dart';
import 'package:animal_market/modules/buy/views/market_view.dart';
import 'package:animal_market/modules/buy_crop/models/crop_argument.dart';
import 'package:animal_market/modules/buy_crop/views/crop_sub_category_view.dart';
import 'package:animal_market/modules/buy_pet/models/pet_argument.dart';
import 'package:animal_market/modules/buy_pet/views/pet_sub_category_view.dart';
import 'package:animal_market/modules/category/views/category_view.dart';
import 'package:animal_market/modules/cattle_heath/views/my_health_report_view.dart';
import 'package:animal_market/modules/cattle_heath/views/scan_now_view.dart';
import 'package:animal_market/modules/cms/models/cms_arguments.dart';
import 'package:animal_market/modules/cms/views/cms_view.dart';
import 'package:animal_market/modules/cms/views/help_and_support_view.dart';
import 'package:animal_market/modules/community/models/blog_details_argument.dart';
import 'package:animal_market/modules/community/models/my_post_argument.dart';
import 'package:animal_market/modules/community/views/community_dashboard_view.dart';
import 'package:animal_market/modules/community/views/community_details_view.dart';
import 'package:animal_market/modules/community/views/community_home_view.dart';
import 'package:animal_market/modules/community/views/create_post_view.dart';
import 'package:animal_market/modules/community/views/my_post_view.dart';
import 'package:animal_market/modules/dashboard/views/dashboard_view.dart';
import 'package:animal_market/modules/doctor/models/edit_doctor_argument.dart';
import 'package:animal_market/modules/doctor/views/create_account_doctor_view.dart';
import 'package:animal_market/modules/doctor/views/doctor_account_view.dart';
import 'package:animal_market/modules/doctor/views/doctor_appointment_list_view.dart';
import 'package:animal_market/modules/doctor/views/doctor_plan_view.dart';
import 'package:animal_market/modules/doctor/views/doctor_profile_dashboard_view.dart';
import 'package:animal_market/modules/doctor/views/doctor_view.dart';
import 'package:animal_market/modules/doctor_list/models/doctor_argument.dart';
import 'package:animal_market/modules/doctor_list/view/doctor_dashboard_view.dart';
import 'package:animal_market/modules/doctor_list/view/doctor_details_view.dart';
import 'package:animal_market/modules/event/views/event_view.dart';
import 'package:animal_market/modules/faq/views/faqs_view.dart';
import 'package:animal_market/modules/know_education/model/know_argument.dart';
import 'package:animal_market/modules/know_education/views/know_education_dashboard_view.dart';
import 'package:animal_market/modules/know_education/views/knowledge_details_view.dart';
import 'package:animal_market/modules/market/views/crop_market_details_view.dart';
import 'package:animal_market/modules/market/views/crop_market_view.dart';
import 'package:animal_market/modules/market_pet/views/pet_market_details_view.dart';
import 'package:animal_market/modules/market_pet/views/pet_market_view.dart';
import 'package:animal_market/modules/my_favorite/views/my_favorite_view.dart';
import 'package:animal_market/modules/notifications/views/notification_view.dart';
import 'package:animal_market/modules/other_seller_profile/models/other_seller_arguments.dart';
import 'package:animal_market/modules/other_seller_profile/views/other_seller_view.dart';
import 'package:animal_market/modules/sell/models/add_sell_products_arguments.dart';
import 'package:animal_market/modules/sell/models/success_argument.dart';
import 'package:animal_market/modules/sell/views/add_sell_products_view.dart';
import 'package:animal_market/modules/sell/views/products_dashboard_view.dart';
import 'package:animal_market/modules/sell/views/successfully_created_view.dart';
import 'package:animal_market/modules/sell_crop/models/add_sell_crop_products_arguments.dart';
import 'package:animal_market/modules/sell_crop/views/add_sell_crop_products_view.dart';
import 'package:animal_market/modules/sell_crop/views/crop_products_dashboard_view.dart';
import 'package:animal_market/modules/sell_crop/views/successfully_created_crop_view.dart';
import 'package:animal_market/modules/sell_pet/models/add_pet_sell_products_arguments.dart';
import 'package:animal_market/modules/sell_pet/models/pet_success_argument.dart';
import 'package:animal_market/modules/sell_pet/views/add_pet_sell_products_view.dart';
import 'package:animal_market/modules/sell_pet/views/pet_products_dashboard_view.dart';
import 'package:animal_market/modules/sell_pet/views/pet_successfully_created_view.dart';
import 'package:animal_market/routes/routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashView(),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginView(),
        );
      case Routes.otp:
        return MaterialPageRoute(
          builder: (_) => const OtpView(),
        );
      case Routes.location:
        return MaterialPageRoute(
          builder: (_) =>  LocationView(
            argument: args as LocationArgument,
          ),
        );
      case Routes.userName:
        return MaterialPageRoute(
          builder: (_) => const UserNameView(),
        );
      case Routes.category:
        return MaterialPageRoute(
          builder: (_) => const CategoryView(),
        );
      case Routes.dashboard:
        return MaterialPageRoute(
          builder: (_) => DashboardView(
            arguments: args as DashboardArguments,
          ),
        );
      case Routes.doctorDetails:
        return MaterialPageRoute(
          builder: (_) => DoctorDetailsView(
            argument: args as DoctorArgument,
          ),
        );
      case Routes.appointmentBooking:
        return MaterialPageRoute(
          builder: (_) => AppointmentBookingView(
            arguments: args as DoctorArgument,
          ),
        );
      case Routes.account:
        return MaterialPageRoute(
          builder: (_) => const AccountView(),
        );
      case Routes.cms:
        return MaterialPageRoute(
          builder: (_) => CmsView(
            cmsArguments: args as CmsArguments,
          ),
        );
      case Routes.helpAndSupport:
        return MaterialPageRoute(
          builder: (_) => HelpAndSupportView(
            arguments: args as CmsArguments,
          ),
        );
      case Routes.myFavourite:
        return MaterialPageRoute(
          builder: (_) => const MyFavoriteView(),
        );
      case Routes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationView(),
        );
      case Routes.communityDashboard:
        return MaterialPageRoute(
          builder: (_) => CommunityDashboardView(
            arguments: args as DashboardArguments,
          ),
        );
      case Routes.communityDetails:
        return MaterialPageRoute(
          builder: (_) => CommunityDetailsView(
            argument: args as BlogDetailsArgument,
          ),
        );
      case Routes.createPost:
        return MaterialPageRoute(
          builder: (_) => CreatePostView(
            argument: args as BlogDetailsArgument,
          ),
        );
      case Routes.doctorDashboard:
        return MaterialPageRoute(
          builder: (_) => DoctorDashboardView(
            arguments: args as DashboardArguments,
          ),
        );
      case Routes.market:
        return MaterialPageRoute(
          builder: (_) => MarketView(
            argument: args as CattleArgument,
          ),
        );
      case Routes.marketDetails:
        return MaterialPageRoute(
          builder: (_) => MarketDetailsView(
            argument: args as CattleArgument,
          ),
        );
      case Routes.marketCrop:
        return MaterialPageRoute(
          builder: (_) => CropMarketView(
            argument: args as CropArgument,
          ),
        );
      case Routes.marketCropDetails:
        return MaterialPageRoute(
          builder: (_) => CropMarketDetailsView(
            argument: args as CropArgument,
          ),
        );
      case Routes.addSellProducts:
        return MaterialPageRoute(
          builder: (_) => AddSellProductsView(
            arguments: args as AddSellProductsArguments,
          ),
        );
      case Routes.successfullyCreated:
        return MaterialPageRoute(
          builder: (_) => SuccessfullyCreatedView(
            argument: args as SuccessArgument,
          ),
        );
      case Routes.productsDashboard:
        return MaterialPageRoute(
          builder: (_) => ProductsDashboardView(),
        );
      case Routes.doctor:
        return MaterialPageRoute(
          builder: (_) => DoctorView(),
        );
      case Routes.doctorAccount:
        return MaterialPageRoute(
          builder: (_) => DoctorAccountView(),
        );
      case Routes.createAccountDoctor:
        return MaterialPageRoute(
          builder: (_) => CreateAccountDoctorView(
            argument: args as EditDoctorArgument,
          ),
        );
      case Routes.doctorPlan:
        return MaterialPageRoute(
          builder: (_) => DoctorPlanView(),
        );
      case Routes.doctorAppointmentList:
        return MaterialPageRoute(
          builder: (_) => DoctorAppointmentListView(
            isBottom: false,
          ),
        );
      case Routes.event:
        return MaterialPageRoute(
          builder: (_) => EventView(),
        );
      case Routes.scanNow:
        return MaterialPageRoute(
          builder: (_) => ScanNowView(),
        );
      case Routes.editProfile:
        return MaterialPageRoute(
          builder: (_) => EditProfileView(),
        );
      case Routes.selectLanguage:
        return MaterialPageRoute(
          builder: (_) => SelectLanguageView(
            argument: args as LanguageArgument,
          ),
        );
      case Routes.cattleSubCategory:
        return MaterialPageRoute(
          builder: (_) => CattleSubCategoryView(
            argument: args as CattleArgument,
          ),
        );
      case Routes.cropSubCategory:
        return MaterialPageRoute(
          builder: (_) => CropSubCategoryView(
            argument: args as CropArgument,
          ),
        );
      case Routes.addCropSellProducts:
        return MaterialPageRoute(
          builder: (_) => AddSellCropProductsView(
            arguments: args as AddSellCropProductsArguments,
          ),
        );
      case Routes.productsCropDashboard:
        return MaterialPageRoute(
          builder: (_) => CropProductsDashboardView(),
        );
      case Routes.successfullyCreatedCrop:
        return MaterialPageRoute(
          builder: (_) => SuccessfullyCreatedCropView(
            argument: args as SuccessArgument,
          ),
        );
      case Routes.doctorProfileDashboard:
        return MaterialPageRoute(
          builder: (_) => DoctorProfileDashboardView(),
        );
      case Routes.knowEducationDashboard:
        return MaterialPageRoute(
          builder: (_) => KnowEducationDashboardView(
            arguments: args as DashboardArguments,
          ),
        );
      case Routes.petSubCategory:
        return MaterialPageRoute(
          builder: (_) => PetSubCategoryView(
            argument: args as PetArgument,
          ),
        );
      case Routes.petMarket:
        return MaterialPageRoute(
          builder: (_) => PetMarketView(
            argument: args as PetArgument,
          ),
        );
      case Routes.petMarketDetails:
        return MaterialPageRoute(
          builder: (_) => PetMarketDetailsView(
            argument: args as PetArgument,
          ),
        );
      case Routes.addPetSellProducts:
        return MaterialPageRoute(
          builder: (_) => AddPetSellProductsView(
            arguments: args as AddPetSellProductsArguments,
          ),
        );
      case Routes.productsPetDashboard:
        return MaterialPageRoute(
          builder: (_) => PetProductsDashboardView(),
        );
      case Routes.successfullyCreatedPet:
        return MaterialPageRoute(
          builder: (_) => PetSuccessfullyCreatedView(
            argument: args as PetSuccessArgument,
          ),
        );
      case Routes.myReport:
        return MaterialPageRoute(
          builder: (_) => MyHealthReportView(),
        );
      case Routes.knowEducationDetails:
        return MaterialPageRoute(
          builder: (_) => KnowledgeDetailsView(
            argument: args as KnowArgument,
          ),
        );
      case Routes.faq:
        return MaterialPageRoute(
          builder: (_) => FaqsView(),
        );
      case Routes.myPost:
        return MaterialPageRoute(
          builder: (_) => MyPostView(
            myPostArgument: args as MyPostArgument,
          ),
        );
      case Routes.otherSellerProfile:
        return MaterialPageRoute(
          builder: (_) => OtherSellerView(
            arguments: args as OtherSellerArguments,
          ),
        );
      case Routes.communityHome:
        return MaterialPageRoute(
          builder: (_) => CommunityHomeView(
            arguments: args as DashboardArguments,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashView(),
        );
    }
  }
}
