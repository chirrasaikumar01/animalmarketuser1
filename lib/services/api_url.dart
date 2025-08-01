class ApiUrl {
  ///base api
  ///static const String baseUrl = "https://aegistax.co.in/animal_market/api/";
  static const String severUrl = "https://animalmarket.in";
  static const String baseUrl = "$severUrl/api/";
  static const String imageUrl = "$severUrl/public/";

  ///auth api
  static const String register = "${baseUrl}register-login";
  static const String verifyOtp = "${baseUrl}verify-otp";

  ///language api
  static const String languageList = "${baseUrl}language-list";
  static const String changeLanguage = "${baseUrl}change-language";

  ///category api
  static const String category = "${baseUrl}category";
  static const String subCategory = "${baseUrl}sub-category";

  ///blog api
  static const String myBlogpostList = "${baseUrl}my-blogpost-list";
  static const String blogpostList = "${baseUrl}blogpost-list";
  static const String blogpostDetail = "${baseUrl}blogpost-detail";
  static const String blogpostCreate = "${baseUrl}blogpost-create";
  static const String addComment = "${baseUrl}add-comment";
  static const String addCommentReply = "${baseUrl}add-comment-reply";
  static const String reasonsList = "${baseUrl}reasons-list";
  static const String blogpostReport = "${baseUrl}blogpost-report";
  static const String blogpostDelete = "${baseUrl}blogpost-delete";
  static const String blogpostLike = "${baseUrl}blogpost-like";

  ///event
  static const String eventList = "${baseUrl}event-list";
  static const String addEvent = "${baseUrl}add-event";
  static const String deleteEvent = "${baseUrl}delete-event";

  ///profile api
  static const String getProfile = "${baseUrl}get-profile";
  static const String updateProfile = "${baseUrl}update-profile";

  ///doctor api
  static const String doctorHome = "${baseUrl}doctor-home";
  static const String createDoctor = "${baseUrl}create-doctor";
  static const String subscriptionPlanList = "${baseUrl}subscription-plan-list";
  static const String buySubscription = "${baseUrl}buy-subscription";

  static const String cancelAppointment = "${baseUrl}cancel-appointment";
  static const String timeSlotsList = "${baseUrl}time-slots-list";
  static const String addDoctorTimeSlots = "${baseUrl}add-doctor-time-slots";
  static const String doctorList = "${baseUrl}doctor-list";
  static const String doctorDetail = "${baseUrl}doctor-detail";

  ///appointment api
  static const String bookAppointment = "${baseUrl}book-appointment";
  static const String myAppointment = "${baseUrl}my-appointment";

  ///common  api
  static const String cmsPages = "${baseUrl}cms-pages";
  static const String state = "${baseUrl}states";
  static const String city = "${baseUrl}cities";
  static const String appDownload = "${baseUrl}app-download";
  static const String deactivateAccount = "${baseUrl}deactivate-account";
  static const String notificationList = "${baseUrl}notification-list";

  ///cattle crop home api
  static const String buyCropCattleHome = "${baseUrl}buy-crop-cattle-home";
  static const String featuresList = "${baseUrl}features-list";

  ///cattle api
  static const String cattleList = "${baseUrl}cattle-list";
  static const String cattleDetail = "${baseUrl}cattle-detail";
  static const String breed = "${baseUrl}breed";
  static const String heathStatusList = "${baseUrl}health-status";
  static const String createEditCattle = "${baseUrl}create-edit-cattle";
  static const String pregnancyHistory = "${baseUrl}pregnancy-history";
  static const String deleteCattle = "${baseUrl}delete-cattle";
  static const String cattleMarkToSold = "${baseUrl}cattle-mark-to-sold";

  ///crop api
  static const String cropList = "${baseUrl}crop-list";
  static const String cropDetail = "${baseUrl}crop-detail";
  static const String cropName = "${baseUrl}crop-type";
  static const String cropVariety = "${baseUrl}crop-variety";
  static const String cropQualities = "${baseUrl}crop-quanities";
  static const String createEditCrop = "${baseUrl}create-edit-crop";
  static const String deleteCrop = "${baseUrl}delete-crop";
  static const String cropMarkToSold = "${baseUrl}crop-mark-to-sold";

  ///pet api
  static const String petList = "${baseUrl}pet-list";
  static const String petDetail = "${baseUrl}pet-detail";
  static const String deletePet = "${baseUrl}delete-pet";
  static const String petMarkToSold = "${baseUrl}pet-mark-to-sold";
  static const String createEditPet = "${baseUrl}create-edit-pet";

  ///seller api
  static const String sellerHome = "${baseUrl}seller-home";
  static const String sellerDashboard = "${baseUrl}seller-dashboard";

  ///update fcm
  static const String updateFcm = "${baseUrl}fcm-update";

  /// knowledge List
  static const String knowledgeList = "${baseUrl}knowledge-list";
  static const String knowledgeDetails = "${baseUrl}knowledge-detail";

  ///health report
  static const String healthReportHome = "${baseUrl}health-home";
  static const String reportPlanList = "${baseUrl}report-plan-list";
  static const String healthReportAdd = "${baseUrl}health-report-add";
  static const String payForHealthReport = "${baseUrl}payfor-health-report";
  static const String myHealthReport = "${baseUrl}my-health-report";

  ///add remove favourite
  static const String addRemoveFavourite = "${baseUrl}add-remove-favourite";
  static const String myFavouriteList = "${baseUrl}my-favourite-list";

  ///faq
  static const String faqList = "${baseUrl}faq";

  /// translations
  static const String translations = "${baseUrl}translate-json";
  /// other seller profile
  static const String getOtherSellerDetail = "${baseUrl}get-other-seller-detail";
  static const String increaseCallCount = "${baseUrl}increase-call-count";
}
