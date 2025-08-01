import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/auth/providers/auth_provider.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

class SearchLocationBottomSheet {
  final FocusNode focusNode = FocusNode();

  Future<LocationModel?> show(BuildContext context, TextEditingController search) async {
    return await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return DraggableScrollableSheet(
                initialChildSize: 0.6,
                // Default height (60% of screen)
                minChildSize: 0.4,
                // Minimum height (40% of screen)
                maxChildSize: 0.9,
                // Maximum height (90% of screen)
                expand: false,
                builder: (context, scrollController) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      bottom: 30.h + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.dm),
                        topLeft: Radius.circular(16.dm),
                      ),
                    ),
                    child: Wrap(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                                decoration: BoxDecoration(
                                  color: ColorConstant.borderCl,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16.dm),
                                    topLeft: Radius.circular(16.dm),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageConstant.arrowLeftIc,
                                            height: 16.h,
                                            width: 12.w,
                                          ),
                                          SizedBox(width: 14.w),
                                          TText(keyName:
                                            searchLocation,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: ColorConstant.textDarkCl,
                                              fontFamily: FontsStyle.regular,
                                              fontSize: 14.sp,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Image.asset(
                                        ImageConstant.closeIc,
                                        height: 22.h,
                                        width: 22.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Consumer<AuthProvider>(builder: (context, provider, child) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  child: GooglePlaceAutoCompleteTextField(
                                    focusNode: focusNode,
                                    textEditingController: search,
                                    googleAPIKey: "AIzaSyDqa48JWUaqiPJfGPVAjjFR0Zmd74U3y1E",
                                    inputDecoration: InputDecoration(
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
                                      hintText: "Search Address",
                                      hintStyle: TextStyle(
                                        fontFamily: FontsStyle.regular,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: Image.asset(
                                          ImageConstant.searchIc,
                                          height: 20.h,
                                          width: 20.w,
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
                                            if (context.mounted) {
                                              Navigator.pop(context, locationModel);
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 13.w),
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
                              SizedBox(height: 120.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        });
  }
}
