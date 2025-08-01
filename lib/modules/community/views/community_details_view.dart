import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/helper/deep_link_service.dart';
import 'package:animal_market/helper/share_service.dart';
import 'package:animal_market/modules/community/models/blog_details_argument.dart';
import 'package:animal_market/modules/community/providers/community_provider.dart';
import 'package:animal_market/modules/community/widgets/reply_bottom_sheet.dart';
import 'package:animal_market/modules/community/widgets/show_more_text.dart';
import 'package:animal_market/modules/full_view_image/views/full_image_view.dart';
import 'package:animal_market/services/api_url.dart';

class CommunityDetailsView extends StatefulWidget {
  final BlogDetailsArgument argument;

  const CommunityDetailsView({super.key, required this.argument});

  @override
  State<CommunityDetailsView> createState() => _CommunityDetailsViewState();
}

class _CommunityDetailsViewState extends State<CommunityDetailsView> {
  late CommunityProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<CommunityProvider>();
      provider.blogpostDetail(context, widget.argument.id, true);
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading1 = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(title: "details",
                action:state.noData||state.isLoading1?SizedBox(): GestureDetector(
                  onTap: (){
                    final link = DeepLinkService().generateDeePLink(state.blogDetails!.catId.toString(), state.blogDetails!.id.toString(), "Blog");
                    final imageUrl = state.blogDetails?.image != null && state.blogDetails!.image!.isNotEmpty
                        ? state.blogDetails?.image
                        : "";

                    if (link.isNotEmpty) {
                      ShareService.shareProduct(
                        title: state.blogDetails?.description ?? "",
                        imageUrl:"${ApiUrl.imageUrl}${imageUrl??" "}",
                        link: link,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(4.dm),
                      border: Border.all(color: ColorConstant.borderCl),
                    ),
                    child: Image.asset(
                      ImageConstant.shareLineIc,
                      height: 22.h,
                      width: 22.w,
                      color: ColorConstant.appCl,
                    ),
                  ),
                ),
              ),
            ),
            body: Builder(builder: (context) {
              if (state.isLoading1) {
                return LoaderClass(
                  height: MediaQuery.of(context).size.height,
                );
              }
              if (state.noData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      ImageConstant.mailboxIc,
                      height: 111.h,
                      width: 111.w,
                    ),
                    SizedBox(height: 20.h),
                    TText(keyName:
                      "noDataFound",
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
                        "Blogs Details will appear here once you've received them. ",
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
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
                                    imageUrl: state.blogDetails?.userProfileImage ?? "",
                                    baseUrl: ApiUrl.imageUrl,
                                    height: 30.h,
                                    width: 30.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: 11.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TText(keyName:
                                      state.blogDetails?.userName ?? "",
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
                                            keyName:  state.blogDetails?.postedAgo ?? "",
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
                              Image.asset(
                                ImageConstant.moreOptionIc,
                                height: 22.h,
                                width: 8.w,
                              )
                            ],
                          ),
                          SizedBox(height: 19.h),
                          Padding(
                            padding: EdgeInsets.only(left: 50.w, right: 10.w),
                            child: ShowMoreText(
                              description: state.blogDetails?.description ?? "",
                              userName: '',
                              tagList: [],
                            ),
                          ),
                          state.blogDetails?.image != null && state.blogDetails?.image != ""
                              ? Padding(
                                  padding: EdgeInsets.only(left: 50.w, right: 10.w),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (state.blogDetails?.image != null && state.blogDetails?.image != "") {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => FullImageView(image: ApiUrl.imageUrl + state.blogDetails!.image!, isDownload: true)));
                                          } else {
                                            errorToast(context, "No image found");
                                          }
                                        },
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10.dm),
                                            child: CustomImage(
                                              placeholderAsset: ImageConstant.demoPostImg,
                                              errorAsset: ImageConstant.demoPostImg,
                                              radius: 10.dm,
                                              imageUrl: state.blogDetails?.image ?? "",
                                              baseUrl: ApiUrl.imageUrl,
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ImageConstant.commentIc,
                                color: ColorConstant.textDarkCl,
                                height: 18.h,
                                width: 18.w,
                              ),
                              SizedBox(width: 5.w),
                              TText(keyName:
                                "${state.blogDetails?.commentCount} Replies",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.textDarkCl,
                                  fontFamily: FontsStyle.medium,
                                  fontStyle: FontStyle.normal,
                                ),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              state.blogpostLike(context, state.blogDetails!.id.toString());
                            },
                            child: Icon(
                              state.blogDetails?.isLiked.toString() == "1" ? Icons.favorite : Icons.favorite_border,
                              size: 20.h,
                              color: state.blogDetails?.isLiked.toString() == "1" ? Colors.red : ColorConstant.textDarkCl,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: state.blogDetails?.commentsLists?.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var item = state.blogDetails?.commentsLists?[index];
                          return Container(
                            padding: EdgeInsets.all(13.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: ColorConstant.borderCl,
                                  width: 1.w,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 30.h,
                                      width: 30.w,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30.dm),
                                        child: CustomImage(
                                          placeholderAsset: ImageConstant.demoPostImg,
                                          errorAsset: ImageConstant.demoPostImg,
                                          radius: 30.dm,
                                          imageUrl: item?.profileImage ?? "",
                                          baseUrl: ApiUrl.imageUrl,
                                          height: 30.h,
                                          width: 30.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 11,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TText(keyName:
                                            item?.userName ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: ColorConstant.textLightCl,
                                              fontFamily: FontsStyle.medium,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          TText(keyName:
                                            item?.commentPostTime ?? "",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: ColorConstant.textLightCl,
                                              fontFamily: FontsStyle.regular,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        ReplyBottomSheet.show(context, () {
                                          state.addCommentReply(context, widget.argument.id, item!.id.toString());
                                        });
                                      },
                                      child: Image.asset(
                                        ImageConstant.sharePostIc,
                                        height: 20.h,
                                        width: 20.w,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Image.asset(
                                      ImageConstant.moreOptionIc,
                                      height: 22.h,
                                      width: 7.w,
                                    )
                                  ],
                                ),
                                SizedBox(height: 14.h),
                                TText(keyName:
                                  item?.comment ?? "",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.textLightCl,
                                    fontFamily: FontsStyle.medium,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                item!.commentReplies!.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 18.w),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.h),
                                            TText(keyName:
                                              "${item.commentReplies!.length} Replies",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w700,
                                                color: ColorConstant.textDarkCl,
                                                fontFamily: FontsStyle.medium,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            MediaQuery.removePadding(
                                              context: context,
                                              removeTop: true,
                                              child: ListView.builder(
                                                itemCount: item.commentReplies?.length,
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  var item1 = item.commentReplies?[index];
                                                  return Container(
                                                    padding: EdgeInsets.all(13.h),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color: ColorConstant.borderCl,
                                                          width: 1.w,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              height: 30.h,
                                                              width: 30.w,
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(30.dm),
                                                                child: CustomImage(
                                                                  placeholderAsset: ImageConstant.demoPostImg,
                                                                  errorAsset: ImageConstant.demoPostImg,
                                                                  radius: 30.dm,
                                                                  imageUrl: item1?.profileImage ?? "",
                                                                  baseUrl: ApiUrl.imageUrl,
                                                                  height: 30.h,
                                                                  width: 30.w,
                                                                  fit: BoxFit.fill,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 11,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  TText(keyName:
                                                                    item1?.userName ?? "",
                                                                    style: TextStyle(
                                                                      fontSize: 12.sp,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: ColorConstant.textLightCl,
                                                                      fontFamily: FontsStyle.medium,
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 6.h),
                                                                  TText(keyName:
                                                                    item1?.replyPostTime ?? "",
                                                                    style: TextStyle(
                                                                      fontSize: 10.sp,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: ColorConstant.textLightCl,
                                                                      fontFamily: FontsStyle.regular,
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 14.h),
                                                        TText(keyName:
                                                          item1?.comment ?? "",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: ColorConstant.textLightCl,
                                                            fontFamily: FontsStyle.medium,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 120.h),
                  ],
                ),
              );
            }),
            bottomSheet: state.isLoading1
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      border: Border(
                        top: BorderSide(
                          color: ColorConstant.gray1Cl,
                          width: 1.w,
                        ),
                      ),
                    ),
                    child: Wrap(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                borderCl: Colors.transparent,
                                hintText: "enterYourReplayHere",
                                controller: state.comment,
                                leading: Image.asset(
                                  ImageConstant.multimediaIc,
                                  height: 30.h,
                                  width: 30.w,
                                ),
                                leading1: GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    state.addComment(context, widget.argument.id);
                                  },
                                  child: Image.asset(
                                    ImageConstant.sharePostIc,
                                    height: 30.h,
                                    width: 30.w,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
