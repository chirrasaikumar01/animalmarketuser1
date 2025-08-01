import 'dart:io';

import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/custom_image.dart';
import 'package:animal_market/core/common_widgets/custom_input_fields.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/account/providers/account_provider.dart';
import 'package:animal_market/modules/community/models/blog_details_argument.dart';
import 'package:animal_market/modules/community/providers/community_provider.dart';
import 'package:animal_market/services/api_url.dart';

class CreatePostView extends StatefulWidget {
  final BlogDetailsArgument argument;

  const CreatePostView({super.key, required this.argument});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  late AccountProvider provider;
  late CommunityProvider provider1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<AccountProvider>();
      provider1 = context.read<CommunityProvider>();
      provider.getProfile(context);
      provider1.image = "";
      if (widget.argument.isEdit) {
        provider1.blogpostDetail(context, widget.argument.id, false);
      } else {
        provider1.postController.text = "";
        provider1.imageUrl = "";
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.isLoading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommunityProvider, AccountProvider>(builder: (context, state, state2, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 70.h),
            child: CommonAppBar(title: widget.argument.isEdit ? editPost : "createPost"),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 11.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                            imageUrl: state2.imageUrl,
                            baseUrl: ApiUrl.imageUrl,
                            height: 30.h,
                            width: 30.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(width: 11.w),
                      Expanded(
                        child: TText(keyName:
                          state2.name.text,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.textDarkCl,
                            fontFamily: FontsStyle.semiBold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: ColorConstant.borderCl,
                      borderRadius: BorderRadius.circular(10.dm),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TText(keyName:
                          "readCommunityGuidelinesBeforePosting",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.textDarkCl,
                            fontFamily: FontsStyle.medium,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        Image.asset(
                          ImageConstant.cancelRoundedIc,
                          height: 20.h,
                          width: 20.w,
                          color: ColorConstant.textDarkCl,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                    ),
                    child: Wrap(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                borderCl: ColorConstant.borderCl,
                                controller: state.postController,
                                hintText: "enterYourPostHere",
                                txKeyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                maxLength: 1200,
                                counterText: "1200",
                                maxCheck: 10,
                                onChanged: (value) {
                                  state.updateTText(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  state.image != ""
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.dm),
                          child: Image.file(
                            File(state.image),
                            fit: BoxFit.cover,
                          ),
                        )
                      : state.imageUrl != ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30.dm),
                              child: CustomImage(
                                placeholderAsset: ImageConstant.demoPostImg,
                                errorAsset: ImageConstant.demoPostImg,
                                radius: 30.dm,
                                imageUrl: state.imageUrl,
                                baseUrl: ApiUrl.imageUrl,
                                fit: BoxFit.fill,
                              ),
                            )
                          : SizedBox(),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        state.onUploadImage(context);
                      },
                      child: Image.asset(
                        ImageConstant.galleryIc,
                        height: 30.h,
                        width: 30.w,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        state.blogpostCreate(context, widget.argument.isEdit ? widget.argument.id : "");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.dm),
                          color: state.postController.text.isEmpty ? ColorConstant.grayCl : ColorConstant.darkAppCl,
                        ),
                        child: Row(
                          children: [
                            TText(keyName:
                              "post",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: state.postController.text.isEmpty ? ColorConstant.gray1Cl : ColorConstant.white,
                                fontFamily: FontsStyle.regular,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(width: 30.w),
                            Image.asset(
                              ImageConstant.sharePostIc,
                              height: 26.h,
                              width: 26.w,
                              color: state.postController.text.isEmpty ? ColorConstant.gray1Cl : ColorConstant.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
