import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/auth/providers/auth_provider.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

class SearchLocationView extends StatefulWidget {
  const SearchLocationView({super.key});

  @override
  State<SearchLocationView> createState() => _SearchLocationViewState();
}

class _SearchLocationViewState extends State<SearchLocationView> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 70.h),
          child: CommonAppBar(
            title: searchLocation,
            function: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 18.h),
            Consumer<AuthProvider>(builder: (context, provider, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 0),
                child: GooglePlaceAutoCompleteTextField(
                  focusNode: focusNode,
                  textEditingController: search,
                  googleAPIKey: "AIzaSyDqa48JWUaqiPJfGPVAjjFR0Zmd74U3y1E",
                  inputDecoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ColorConstant.borderCl),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ColorConstant.borderCl),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ColorConstant.borderCl),
                    ),
                    hintText: searchLocation,
                    hintStyle: TextStyle(
                      fontFamily: FontsStyle.regular,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Image.asset(
                        ImageConstant.searchIc,
                        height: 18.h,
                        width: 18.w,
                        color: ColorConstant.gray1Cl,
                      ),
                    ),
                  ),
                  debounceTime: 600,
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) {},
                  itemClick: (Prediction prediction) {
                    focusNode.unfocus();
                    search.text = prediction.description!;
                    search.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description!.length));
                    provider.fetchPlaceDetails(prediction.placeId!).then((v) {
                      LocationModel locationModel = LocationModel(
                        stateName: provider.stateName,
                        cityName: provider.cityName,
                        pinCode: provider.pinCode,
                        lat: provider.late.toString(),
                        long: provider.long.toString(),
                        addressLocation: '',
                      );
                      Log.console("Popping with location model: $locationModel");
                      if (context.mounted) {
                        Navigator.pop(context, locationModel);
                      }
                    });
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    String fullAddress = prediction.description ?? "";
                    String placeName = fullAddress.split(",").first;
                    return InkWell(
                      onTap: () async {
                        focusNode.unfocus();
                        provider.fetchPlaceDetails(prediction.placeId!).then((v) {
                          LocationModel locationModel = LocationModel(
                            stateName: provider.stateName,
                            cityName: provider.cityName,
                            pinCode: provider.pinCode,
                            lat: provider.late.toString(),
                            long: provider.long.toString(),
                            addressLocation: '',
                          );
                          Log.console("Popping with location model: $locationModel");
                          if (context.mounted) { Navigator.pop(context, locationModel);}
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 13.w,vertical: 2),
                        margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              ImageConstant.locationIc,
                              height: 24.h,
                              width: 24.w,
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TText(keyName:
                                    placeName,
                                    style: TextStyle(
                                      color: ColorConstant.textDarkCl,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      fontFamily: FontsStyle.regular,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  TText(keyName:
                                    fullAddress,
                                    style: TextStyle(
                                      color: ColorConstant.hintTextCl,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      fontFamily: FontsStyle.regular,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Divider(height: 1.h, color: ColorConstant.borderCl),
                                  SizedBox(height: 15.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  seperatedBuilder: Divider(
                    color: ColorConstant.borderCl,
                    height: 1.h,
                  ),
                  isCrossBtnShown: true,
                  placeType: PlaceType.establishment,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
