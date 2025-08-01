class BlogListModel {
  int? id;
  String? description;
  String? image;
  int? commentCount;
  String? postTime;
  dynamic isLiked;
  dynamic catId;
  String? userName;
  String? userProfileImage;
  String? postedAgo;
  List<LatestCommentsProfile>? latestCommentsProfile;

  BlogListModel({
    this.id,
    this.description,
    this.image,
    this.commentCount,
    this.postTime,
    this.userName,
    this.userProfileImage,
    this.latestCommentsProfile,
    this.isLiked,
    this.catId,
    this.postedAgo,
  });

  factory BlogListModel.fromJson(Map<String, dynamic> json) => BlogListModel(
        id: json["id"],
        description: json["description"],
        image: json["image"],
        commentCount: json["comment_count"],
        postTime: json["post_time"],
        userName: json["user_name"],
        userProfileImage: json["user_profile_image"],
        isLiked: json["is_liked"],
        catId: json["cat_id"],
        postedAgo: json["posted_ago"],
        latestCommentsProfile: json["latest_comments_profile"] == null ? [] : List<LatestCommentsProfile>.from(json["latest_comments_profile"]!.map((x) => LatestCommentsProfile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "image": image,
        "comment_count": commentCount,
        "post_time": postTime,
        "user_name": userName,
        "is_liked": isLiked,
        "cat_id": catId,
        "user_profile_image": userProfileImage,
         "posted_ago":postedAgo,
        "latest_comments_profile": latestCommentsProfile == null ? [] : List<dynamic>.from(latestCommentsProfile!.map((x) => x.toJson())),
      };
}

class LatestCommentsProfile {
  int? id;
  String? comment;
  String? profileImage;
  String? commentPostTime;

  LatestCommentsProfile({
    this.id,
    this.comment,
    this.profileImage,
    this.commentPostTime,
  });

  factory LatestCommentsProfile.fromJson(Map<String, dynamic> json) => LatestCommentsProfile(
        id: json["id"],
        comment: json["comment"],
        profileImage: json["profile_image"],
        commentPostTime: json["comment_post_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "profile_image": profileImage,
        "comment_post_time": commentPostTime,
      };
}
