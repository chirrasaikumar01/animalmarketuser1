import 'package:animal_market/core/export_file.dart';

class BenefitsOfSellingContainer extends StatefulWidget {
  const BenefitsOfSellingContainer({super.key});

  @override
  State<BenefitsOfSellingContainer> createState() => _BenefitsOfSellingContainerState();
}

class _BenefitsOfSellingContainerState extends State<BenefitsOfSellingContainer> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ColorConstant.darkAppCl,
        borderRadius: BorderRadius.circular(10.dm),
        border: Border.all(color: ColorConstant.borderCl),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEFFFE5),
            ColorConstant.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: ColorConstant.darkAppCl,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10.dm),
                bottomLeft: Radius.circular(10.dm),
              ),
              border: Border.all(
                color: ColorConstant.darkAppCl,
                width: 1.w,
              ),
            ),
            child: TText(keyName:
              "benefitsOfSellingInAnimalMarket",
              style: TextStyle(
                color: ColorConstant.buttonCl,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                fontFamily: FontsStyle.medium,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    ImageConstant.laptopIc,
                    height: 24.h,
                    width: 24.w,
                  ),
                  SizedBox(height: 16.h),
                  TText(keyName:
                   "noScams",
                    style: TextStyle(
                      color: ColorConstant.textDarkCl,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    ImageConstant.fundsIc,
                    height: 24.h,
                    width: 24.w,
                  ),
                  SizedBox(height: 16.h),
                  TText(keyName:
                   "profitH",
                    style: TextStyle(
                      color: ColorConstant.textDarkCl,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    ImageConstant.verifiedUserIc,
                    height: 24.h,
                    width: 24.w,
                  ),
                  SizedBox(height: 16.h),
                  TText(keyName:
                    "noFraud",
                    style: TextStyle(
                      color: ColorConstant.textDarkCl,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 13.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    ImageConstant.discountIc,
                    height: 24.h,
                    width: 24.w,
                  ),
                  SizedBox(height: 16.h),
                  TText(keyName:
                   "commission",
                    style: TextStyle(
                      color: ColorConstant.textDarkCl,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    ImageConstant.cancelIc,
                    height: 24.h,
                    width: 24.w,
                  ),
                  SizedBox(height: 16.h),
                  TText(keyName:
                    "noBrokerage",
                    style: TextStyle(
                      color: ColorConstant.textDarkCl,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    ImageConstant.sellBoardIc,
                    height: 24.h,
                    width: 24.w,
                  ),
                  SizedBox(height: 16.h),
                  TText(keyName:
                   "directSell",
                    style: TextStyle(
                      color: ColorConstant.textDarkCl,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      fontFamily: FontsStyle.medium,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 18.h),
        ],
      ),
    );
  }
}
