import 'package:animal_market/core/common_widgets/custom_buttons.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/doctor_list/models/doctor_argument.dart';
import 'package:animal_market/modules/doctor_list/providers/doctor_list_provider.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorListView extends StatefulWidget {
  const DoctorListView({super.key});

  @override
  State<DoctorListView> createState() => _DoctorListViewState();
}

class _DoctorListViewState extends State<DoctorListView> {
  late DoctorListProvider doctorProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      doctorProvider = context.read<DoctorListProvider>();
      doctorProvider.doctorListGet(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    doctorProvider.isLoading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorListProvider>(
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: ColorConstant.white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              children: [
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "searchForDoctors",
                        borderCl: ColorConstant.borderCl,
                        fillColor: ColorConstant.white,
                        onChanged: (value) {
                          state.filterSearchResults(value);
                        },
                        leading1: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              ImageConstant.searchIc,
                              height: 22.h,
                              width: 22.w,
                            ),
                            SizedBox(width: 6.w),
                            SizedBox(
                              height: 22.h,
                              child: VerticalDivider(
                                color: ColorConstant.borderCl,
                                width: 1.w,
                              ),
                            ),
                            SizedBox(width: 6.w),
                           /* Image.asset(
                              ImageConstant.micIc,
                              height: 22.h,
                              width: 22.w,
                            ),*/
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 9.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: ColorConstant.appCl,
                        borderRadius: BorderRadius.circular(10.dm),
                      ),
                      child: Image.asset(
                        ImageConstant.filterIc,
                        height: 36.h,
                        width: 36.w,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 14.h),
                Expanded(
                  child: Builder(builder: (context) {
                    if (state.isLoading) {
                      return LoaderClass(height: double.infinity);
                    }
                    if (state.filteredList.isEmpty) {
                      return NoDataClass(
                        height: double.infinity,
                        text: noDataFound,
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.filteredList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var item = state.filteredList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.doctorDetails,
                                arguments: DoctorArgument(id: item.id.toString(), isUser: false, clinicName: item.clinicName ?? "", name: item.name ?? "", fees: item.fees ?? ""));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 14.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.dm),
                              border: Border.all(color: ColorConstant.borderCl),
                            ),
                            padding: EdgeInsets.all(10.h),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 60.h,
                                      width: 60.w,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5.dm),
                                        child: CustomImage(
                                          placeholderAsset: ImageConstant.demoUserImg,
                                          errorAsset: ImageConstant.demoUserImg,
                                          radius: 5.dm,
                                          imageUrl: item.profile,
                                          baseUrl: ApiUrl.imageUrl,
                                          height: 60.h,
                                          width: 60.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              TText(keyName:
                                                item.clinicName ?? "",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorConstant.textDarkCl,
                                                  fontFamily: FontsStyle.medium,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Image.asset(
                                                ImageConstant.verifyIc,
                                                height: 14.h,
                                                width: 14.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          TText(keyName:
                                            "Dr. ${item.name ?? ""}",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: ColorConstant.textLightCl,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          TText(keyName:
                                            "Exp. ${item.experience ?? ""} Year",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: ColorConstant.textLightCl,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: ColorConstant.darkAppCl,
                                        borderRadius: BorderRadius.circular(4.dm),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageConstant.startIc,
                                            height: 12.h,
                                            width: 12.w,
                                          ),
                                          TText(keyName:
                                            "4.5",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: ColorConstant.white,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          await launchUrl(
                                            Uri.parse("https://wa.me/+91${item.whatsappNo ?? ""}/?text=Hii..."),
                                            mode: LaunchMode.externalApplication,
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 8.h),
                                          decoration: BoxDecoration(
                                            color: ColorConstant.white,
                                            borderRadius: BorderRadius.circular(10.dm),
                                            border: Border.all(color: ColorConstant.darkAppCl, width: 1.w),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                ImageConstant.whatsappIc,
                                                width: 16.w,
                                                height: 16.h,
                                              ),
                                              SizedBox(width: 10.w),
                                              TText(keyName:
                                                "chat",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorConstant.darkAppCl,
                                                  fontFamily: FontsStyle.medium,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: CustomButtonWidget(
                                        style: CustomButtonStyle.style2,
                                        padding: EdgeInsets.symmetric(vertical: 8.h),
                                        onPressed: () {
                                          Navigator.pushNamed(context, Routes.appointmentBooking,
                                              arguments: DoctorArgument(id: item.id.toString(), isUser: false, clinicName: item.clinicName ?? "", name: item.name ?? "", fees: item.fees??""));
                                        },
                                        text: "",
                                        iconWidget: TText(keyName:
                                          "bookAppointment",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorConstant.darkAppCl,
                                            fontFamily: FontsStyle.medium,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
