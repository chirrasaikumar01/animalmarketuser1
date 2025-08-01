import 'dart:convert';
import 'dart:io';

import 'package:animal_market/core/common_widgets/media_source_picker.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/image_picker_utils.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/community/models/blog_post_details_model.dart';
import 'package:animal_market/modules/community/models/blog_post_list_model.dart';
import 'package:animal_market/modules/community/models/reasons_list_model.dart';
import 'package:animal_market/services/api_service.dart';
import 'package:image_picker/image_picker.dart';

class CommunityProvider extends ChangeNotifier {
  String image = "";
  String imageUrl = "";
  TextEditingController postController = TextEditingController();
  TextEditingController comment = TextEditingController();
  TextEditingController reply = TextEditingController();
  bool isLoading = true;
  bool isLoading1 = true;
  bool isLoading2 = true;
  bool noData = false;
  var blogList = <BlogListModel>[];
  var myBlogList = <BlogListModel>[];
  var reasonList = <ReasonsListModel>[];
  BlogPostDetailsModel? blogDetails;
  var commentList = <BlogListModel>[];
  var categoryId = "";

  void updateTText(String text) {
    postController.text = text;
    notifyListeners();
  }

  String selectedReasonId = "";

  void selectReason(String id) {
    selectedReasonId = id;
    notifyListeners();
  }

  void onUploadImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstant.white,
      builder: (_) {
        return const MediaSourcePicker();
      },
    ).then(
      (value) async {
        if (value != null && value is ImageSource) {
          if (context.mounted) {
            File? pickedFile = await PickImageUtility.instance(
              applyEditor: false,
              context: context,
              toolbarBackgroundColor: ColorConstant.appCl,
            ).pickedFile(value);
            if (pickedFile != null) {
              image = pickedFile.path;
              notifyListeners();
            }
          }
        }
      },
    );
  }

  Future<void> blogpostListGet(BuildContext context, bool isLoad) async {
    try {
      isLoading = isLoad;
      var result = await ApiService.blogpostList(categoryId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        blogList = List<BlogListModel>.from(json['data'].map((i) => BlogListModel.fromJson(i))).toList(growable: true);
      } else {
        isLoading = false;
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> myBlogpostList(BuildContext context) async {
    try {
      isLoading2 = true;
      var result = await ApiService.myBlogpostList();
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading2 = false;
        myBlogList = List<BlogListModel>.from(json['data'].map((i) => BlogListModel.fromJson(i))).toList(growable: true);
      } else {
        isLoading2 = false;
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading2 = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> blogpostDetail(BuildContext context, String postId, bool isLoad) async {
    try {
      isLoading1 = isLoad;
      var result = await ApiService.blogpostDetail(postId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading1 = false;
        noData = false;
        blogDetails = BlogPostDetailsModel.fromJson(json["data"]);
        postController.text = blogDetails?.description ?? "";
        imageUrl = blogDetails?.image ?? "";
      } else {
        isLoading1 = false;
        noData = true;
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      noData = true;
      isLoading1 = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future blogpostCreate(BuildContext context, String postId) async {
    try {
      showProgress(context);
      final response = await ApiService.blogpostCreate(postController.text, image, postId, categoryId);
      if (context.mounted) {
        if (response["status"] == true) {
          closeProgress(context);
          blogpostListGet(context, false);
          myBlogpostList(context);
          notifyListeners();
          Navigator.pop(context);
          successToast(context, response["message"]);
        } else {
          closeProgress(context);
          errorToast(context, response["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
        Log.console(e.toString());
      }
    }
    notifyListeners();
  }

  Future<void> addComment(BuildContext context, String postId) async {
    try {
      showProgress(context);
      var result = await ApiService.addComment(postId, comment.text);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        comment.text = "";
        if (context.mounted) {
          closeProgress(context);
          blogpostDetail(context, postId, false);
          blogpostListGet(context, false);
          myBlogpostList(context);
          successToast(context, json["message"].toString());
        }
      } else {
        if (context.mounted) {
          closeProgress(context);
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> addCommentReply(BuildContext context, String postId, String commentId) async {
    try {
      showProgress(context);
      var result = await ApiService.addCommentReply(postId, reply.text, commentId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        reply.text = "";
        if (context.mounted) {
          closeProgress(context);
          Navigator.pop(context);
          blogpostDetail(context, postId, false);
          blogpostListGet(context, false);
          myBlogpostList(context);
          successToast(context, json["message"].toString());
        }
      } else {
        if (context.mounted) {
          closeProgress(context);
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> blogpostReport(BuildContext context, String postId) async {
    try {
      if (selectedReasonId == "") {
        errorToast(context, "Select reason");
        return;
      }
      showProgress(context);
      var result = await ApiService.blogpostReport(postId, selectedReasonId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
          Navigator.pop(context);
          blogpostDetail(context, postId, false);
          blogpostListGet(context, false);
          myBlogpostList(context);
          successToast(context, json["message"].toString());
        }
      } else {
        if (context.mounted) {
          closeProgress(context);
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> reasonsList(BuildContext context) async {
    try {
      isLoading = true;
      var result = await ApiService.reasonsList("post_report");
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        isLoading = false;
        reasonList = List<ReasonsListModel>.from(json['data'].map((i) => ReasonsListModel.fromJson(i))).toList(growable: true);
      } else {
        isLoading = false;
        if (context.mounted) {
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      isLoading = false;
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> blogpostDelete(BuildContext context, String postId) async {
    try {
      showProgress(context);
      var result = await ApiService.blogpostDelete(postId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
          myBlogpostList(context);
          blogpostListGet(context,false);
          Navigator.pop(context);
          successToast(context, json["message"].toString());
        }
      } else {
        if (context.mounted) {
          closeProgress(context);
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console(e.toString());
    }
    notifyListeners();
  }

  Future<void> blogpostLike(BuildContext context, String postId) async {
    try {
      showProgress(context);
      var result = await ApiService.blogpostLike(postId);
      var json = jsonDecode(result.body);
      if (json["status"] == true) {
        if (context.mounted) {
          closeProgress(context);
          blogpostListGet(context, false);
          blogpostDetail(context, postId, false);
          successToast(context, json["message"].toString());
        }
      } else {
        if (context.mounted) {
          closeProgress(context);
          errorToast(context, json["message"].toString());
        }
      }
    } catch (e) {
      if (context.mounted) {
        closeProgress(context);
      }
      Log.console(e.toString());
    }
    notifyListeners();
  }
}
