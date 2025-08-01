import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/auth/models/location_argument.dart';
import 'package:animal_market/modules/auth/models/location_model.dart';
import 'package:animal_market/modules/auth/providers/auth_provider.dart';
import 'package:animal_market/modules/sell/providers/sell_products_provider.dart';
import 'package:animal_market/modules/transleter/transleter_app_lang.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class LocationView extends StatefulWidget {
  final LocationArgument argument;

  const LocationView({super.key, required this.argument});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  TextEditingController search = TextEditingController();
  FocusNode focusNode = FocusNode();
  late AccountProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<AccountProvider>();
      provider.getProfile(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SellProductsProvider, TranslationsProvider>(
      builder: (context, state, state2, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(title: state2.tr("yourLocation")),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () {
                      if (widget.argument.isEdit) {
                        Navigator.pop(context, "200");
                      } else {
                        final sellProvider = Provider.of<SellProductsProvider>(context, listen: false);
                        sellProvider.getLocationStatus();
                        final fullAddress = sellProvider.addressLocation;
                        final accountProvider = Provider.of<AccountProvider>(context, listen: false);
                        accountProvider.address.text = fullAddress;
                        accountProvider.state.text = sellProvider.stateName;
                        accountProvider.city.text = sellProvider.cityName;
                        accountProvider.pinCode.text = sellProvider.pinCode.text;
                        accountProvider.latitude.text = sellProvider.lat.toString();
                        accountProvider.longitude.text = sellProvider.long.toString();
                        accountProvider.updateProfile(context, false, true, false);
                      }
                    },
                    child: Row(
                      children: [
                        Image.asset(ImageConstant.gpsIc, height: 16.h, width: 16.w),
                        SizedBox(width: 15.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TText(
                              keyName: state2.tr("currentLocation"),
                              style: TextStyle(
                                color: ColorConstant.redCl,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                fontFamily: FontsStyle.regular,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            TText(
                              keyName: state2.tr("usingGPS"),
                              style: TextStyle(
                                color: ColorConstant.hintTextCl,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                fontFamily: FontsStyle.regular,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Consumer<AuthProvider>(
                    builder: (context, state, child) {
                      return GooglePlaceAutoCompleteTextField(
                        focusNode: focusNode,
                        textEditingController: search,
                        googleAPIKey: "AIzaSyDqa48JWUaqiPJfGPVAjjFR0Zmd74U3y1E",
                        debounceTime: 600,
                        isLatLngRequired: true,
                        getPlaceDetailWithLatLng: (Prediction prediction) {},
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
                          hintText: "Search Address / Pincode",
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
                        itemClick: (Prediction prediction) {
                          focusNode.unfocus();
                          search.text = prediction.description!;
                          search.selection = TextSelection.fromPosition(
                            TextPosition(offset: prediction.description!.length),
                          );
                          state.fetchPlaceDetails(prediction.placeId!);
                        },
                        itemBuilder: (context, index, Prediction prediction) {
                          String fullAddress = prediction.description ?? "";
                          String placeName = fullAddress.split(",").first;
                          return InkWell(
                            onTap: () async {
                              focusNode.unfocus();
                              await state.fetchPlaceDetails(prediction.placeId!).then((v) {
                                if (!mounted) return;
                                if (widget.argument.isEdit) {
                                  Navigator.pop(
                                    context,
                                    LocationModel(
                                      stateName: state.stateName,
                                      cityName: state.cityName,
                                      pinCode: state.pinCode,
                                      addressLocation: fullAddress,
                                      lat: state.late.toString(),
                                      long: state.long.toString(),
                                    ),
                                  );
                                } else {
                                  final accountProvider = Provider.of<AccountProvider>(context, listen: false);
                                  accountProvider.state.text = state.stateName;
                                  accountProvider.city.text = state.cityName;
                                  accountProvider.pinCode.text = state.pinCode;
                                  accountProvider.latitude.text = state.late.toString();
                                  accountProvider.longitude.text = state.long.toString();
                                  accountProvider.address.text = fullAddress;
                                  accountProvider.updateProfile(context, false, true, false);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                            TText(
                                              keyName: placeName,
                                              style: TextStyle(
                                                color: ColorConstant.textDarkCl,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                                fontFamily: FontsStyle.regular,
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            TText(
                                              keyName: fullAddress,
                                              style: TextStyle(
                                                color: ColorConstant.hintTextCl,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.sp,
                                                fontFamily: FontsStyle.regular,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.h),
                                  Divider(height: 1.h, color: ColorConstant.borderCl),
                                ],
                              ),
                            ),
                          );
                        },
                        seperatedBuilder: Divider(color: ColorConstant.borderCl, height: 1.h),
                        isCrossBtnShown: true,

                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
