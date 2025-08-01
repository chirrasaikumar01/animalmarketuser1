import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/category/providers/category_provider.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerWidget extends StatefulWidget {
  final CategoryProvider state;

  const BannerWidget({super.key, required this.state});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ColorConstant.white, border: Border.all(color: ColorConstant.appCl, width: 1.w), borderRadius: BorderRadius.circular(13.dm)),
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.center,
              child: CarouselSlider(
                carouselController: widget.state.carouselSliderController,
                options: CarouselOptions(
                  aspectRatio: 16 / 6.9,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  padEnds: false,
                  pauseAutoPlayOnTouch: true,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    widget.state.updateIndexBanner(index);
                  },
                ),
                items: List.generate(
                  widget.state.bannerList.length,
                  (ind) => Container(
                    height: 140.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.dm), border: Border.all(color: ColorConstant.textDarkCl)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.dm),
                      child: CustomImage(
                        placeholderAsset: ImageConstant.bannerImg,
                        errorAsset: ImageConstant.bannerImg,
                        radius: 10.dm,
                        imageUrl: widget.state.bannerList[ind].image,
                        baseUrl: ApiUrl.imageUrl,
                        height: 140.h,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 4.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.dm),
                    color: ColorConstant.darkAppCl.withValues(alpha: 0.30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.state.bannerList.length,
                      (ind) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        height: 6.h,
                        width: 6.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.dm),
                          color: ind == widget.state.selectedIndex ? ColorConstant.textDarkCl : Colors.transparent,
                          border: Border.all(
                            color: ind == widget.state.selectedIndex ? ColorConstant.textDarkCl : ColorConstant.white,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
