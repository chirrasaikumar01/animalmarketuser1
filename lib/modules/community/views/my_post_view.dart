import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/helper/deep_link_service.dart';
import 'package:animal_market/helper/share_service.dart';
import 'package:animal_market/modules/community/models/blog_details_argument.dart';
import 'package:animal_market/modules/community/models/my_post_argument.dart';
import 'package:animal_market/modules/community/providers/community_provider.dart';
import 'package:animal_market/modules/community/widgets/show_more_text.dart';
import 'package:animal_market/modules/sell_pet/widgets/delete_product_bottom_sheet.dart';
import 'package:animal_market/routes/routes.dart';
import 'package:animal_market/services/api_url.dart';

class MyPostView extends StatefulWidget {
  final MyPostArgument myPostArgument;

  const MyPostView({super.key, required this.myPostArgument});

  @override
  State<MyPostView> createState() => _MyPostViewState();
}

class _MyPostViewState extends State<MyPostView> {
  late CommunityProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<CommunityProvider>();
      provider.myBlogpostList(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading2 = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: !widget.myPostArgument.isBottom
                ? PreferredSize(
                    preferredSize: Size(double.infinity, 60.h),
                    child: CommonAppBar(title: "myPost"),
                  )
                : null,
            body: Column(
              children: [
                Builder(builder: (context) {
                  if (state.isLoading2) {
                    return Expanded(
                      child: LoaderClass(
                        height: MediaQuery.of(context).size.height - 100,
                      ),
                    );
                  }
                  if (state.myBlogList.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 150.h, width: MediaQuery.of(context).size.width),
                        Image.asset(
                          ImageConstant.mailboxIc,
                          height: 111.h,
                          width: 111.w,
                        ),
                        SizedBox(height: 20.h),
                        TText(keyName:
                          "No Blog Create",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.textDarkCl,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60.w),
                          child: TText(keyName:
                            "Blogs  will appear here once you've received them. ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.textLightCl,
                              fontFamily: FontsStyle.medium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: 50.h),
                      ],
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.myBlogList.length,
                      itemBuilder: (_, index) {
                        var item = state.myBlogList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.communityDetails, arguments: BlogDetailsArgument(id: item.id.toString(), isEdit: false, categoryId: ''));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: ColorConstant.borderCl,
                                  width: 1.w,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 30.h,
                                      width: 30.w,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30.dm),
                                        child: CustomImage(
                                          placeholderAsset: ImageConstant.demoUserImg,
                                          errorAsset: ImageConstant.demoUserImg,
                                          radius: 30.dm,
                                          imageUrl: item.userProfileImage ?? "",
                                          baseUrl: ApiUrl.imageUrl,
                                          height: 30.h,
                                          width: 30.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 11.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TText(keyName:
                                            item.userName ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: ColorConstant.textDarkCl,
                                              fontFamily: FontsStyle.semiBold,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.appCl,
                                              borderRadius: BorderRadius.circular(6.r),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 14.sp,
                                                  color: ColorConstant.white,
                                                ),
                                                SizedBox(width: 3.w),
                                                TText(
                                                  keyName: item.postedAgo ?? "",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorConstant.white,
                                                    fontFamily: FontsStyle.semiBold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    GestureDetector(
                                      onTap: () {
                                        final link = DeepLinkService().generateDeePLink("0", item.id.toString(), "Blog");
                                        final imageUrl = item.image != null && item.image!.isNotEmpty
                                            ? item.image
                                            : "";

                                        if (link.isNotEmpty) {
                                          ShareService.shareProduct(
                                            title: item.description ?? "",
                                            imageUrl:"${ApiUrl.imageUrl}${imageUrl??" "}",
                                            link: link,
                                          );
                                        }
                                      },
                                      child: Image.asset(
                                        ImageConstant.sharePostIc,
                                        height: 20.h,
                                        width: 20.w,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 19.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 50.w, right: 10.w),
                                  child: ShowMoreText(
                                    description: item.description ?? "",
                                    userName: '',
                                    tagList: [],
                                  ),
                                ),
                                item.image != null && item.image!.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 50.w, right: 10.w),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.dm),
                                                child: CustomImage(
                                                  placeholderAsset: ImageConstant.demoPostImg,
                                                  errorAsset: ImageConstant.demoPostImg,
                                                  radius: 10.dm,
                                                  imageUrl: item.image ?? "",
                                                  baseUrl: ApiUrl.imageUrl,
                                                  width: double.infinity,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                SizedBox(height: 34.h),
                                Row(
                                  children: [
                                    item.latestCommentsProfile != null
                                        ? SizedBox(
                                            width: 22 + (3 - 1) * 15,
                                            height: 22,
                                            child: Stack(
                                              children: List.generate(
                                                item.latestCommentsProfile!.length,
                                                (index) {
                                                  return Positioned(
                                                    left: index * 15,
                                                    child: CircleAvatar(
                                                      backgroundColor: ColorConstant.white,
                                                      radius: 11,
                                                      child: Container(
                                                        decoration: BoxDecoration(border: Border.all(color: ColorConstant.white, width: 1.w), shape: BoxShape.circle),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10.dm),
                                                          child: CustomImage(
                                                            placeholderAsset: ImageConstant.demoPostImg,
                                                            errorAsset: ImageConstant.demoPostImg,
                                                            radius: 100.dm,
                                                            imageUrl: item.latestCommentsProfile![index].profileImage ?? "",
                                                            baseUrl: ApiUrl.imageUrl,
                                                            width: double.infinity,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(width: 13.w),
                                    Image.asset(
                                      ImageConstant.commentIc,
                                      height: 18.h,
                                      width: 18.w,
                                    ),
                                    SizedBox(width: 5.w),
                                    Expanded(
                                      child: TText(keyName:
                                        '${item.commentCount ?? ""} Comments',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color(0XFF74AC42),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, Routes.createPost, arguments: BlogDetailsArgument(id: item.id.toString(), isEdit: true, categoryId: item.catId.toString()));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.dm),
                                            border: Border.all(color: ColorConstant.appCl, width: 1.w),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                ImageConstant.editIc,
                                                height: 20.h,
                                                width: 20.w,
                                              ),
                                              SizedBox(width: 10.w),
                                              TText(keyName:
                                                "editInfo",
                                                style: TextStyle(
                                                  color: ColorConstant.appCl,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.sp,
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
                                      child: GestureDetector(
                                        onTap: () {
                                          DeleteProductBottomSheet.show(context, () {
                                            state.blogpostDelete(context, item.id.toString());
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.dm),
                                            border: Border.all(color: ColorConstant.redCl, width: 1.w),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                ImageConstant.deleteOutlineIc,
                                                height: 20.h,
                                                width: 20.w,
                                                color: ColorConstant.redCl,
                                              ),
                                              SizedBox(width: 10.w),
                                              TText(keyName:
                                               "delete",
                                                style: TextStyle(
                                                  color: ColorConstant.redCl,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.sp,
                                                  fontFamily: FontsStyle.medium,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
            floatingActionButton: InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.createPost, arguments: BlogDetailsArgument(id: "", isEdit: false, categoryId: widget.myPostArgument.categoryId));
              },
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: ColorConstant.borderCl,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstant.black.withValues(alpha: 0.25),
                      spreadRadius: 0,
                      blurRadius: 7,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    ImageConstant.editIc,
                    height: 22.h,
                    width: 22.w,
                    color: ColorConstant.textDarkCl,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
