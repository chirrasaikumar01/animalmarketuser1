class BlogPostDetailsModel {
  int? id;
  String? description;
  String? image;
  dynamic isLiked;
  dynamic catId;
  int? commentCount;
  String? postTime;
  String? userName;
  String? userProfileImage;
  String? postedAgo;
  List<CommentsList>? commentsLists;

  BlogPostDetailsModel({
    this.id,
    this.description,
    this.image,
    this.commentCount,
    this.postTime,
    this.userName,
    this.userProfileImage,
    this.isLiked,
    this.catId,
    this.commentsLists,
    this.postedAgo,
  });

  factory BlogPostDetailsModel.fromJson(Map<String, dynamic> json) => BlogPostDetailsModel(
        id: json["id"],
        description: json["description"],
        image: json["image"] ?? "",
        commentCount: json["comment_count"],
        postTime: json["post_time"],
        userName: json["user_name"],
        isLiked: json["is_liked"],
        userProfileImage: json["user_profile_image"],
        postedAgo: json["posted_ago"],
        catId: json["cat_id"],
        commentsLists: json["comments_lists"] == null ? [] : List<CommentsList>.from(json["comments_lists"]!.map((x) => CommentsList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "image": image,
        "comment_count": commentCount,
        "post_time": postTime,
        "user_name": userName,
        "user_profile_image": userProfileImage,
        "is_liked": isLiked,
        "cat_id": catId,
        "posted_ago": postedAgo,
        "comments_lists": commentsLists == null ? [] : List<dynamic>.from(commentsLists!.map((x) => x.toJson())),
      };
}

class CommentsList {
  int? id;
  String? comment;
  String? userName;
  String? profileImage;
  int? repliesCount;
  String? commentPostTime;
  List<CommentReply>? commentReplies;

  CommentsList({
    this.id,
    this.comment,
    this.userName,
    this.profileImage,
    this.repliesCount,
    this.commentPostTime,
    this.commentReplies,
  });

  factory CommentsList.fromJson(Map<String, dynamic> json) => CommentsList(
        id: json["id"],
        comment: json["comment"],
        userName: json["user_name"],
        profileImage: json["profile_image"],
        repliesCount: json["replies_count"],
        commentPostTime: json["comment_post_time"],
        commentReplies: json["comment_replies"] == null ? [] : List<CommentReply>.from(json["comment_replies"]!.map((x) => CommentReply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "user_name": userName,
        "profile_image": profileImage,
        "replies_count": repliesCount,
        "comment_post_time": commentPostTime,
        "comment_replies": commentReplies == null ? [] : List<dynamic>.from(commentReplies!.map((x) => x.toJson())),
      };
}

class CommentReply {
  int? id;
  String? comment;
  String? userName;
  String? profileImage;
  String? replyPostTime;

  CommentReply({
    this.id,
    this.comment,
    this.userName,
    this.profileImage,
    this.replyPostTime,
  });

  factory CommentReply.fromJson(Map<String, dynamic> json) => CommentReply(
        id: json["id"],
        comment: json["comment"],
        userName: json["user_name"],
        profileImage: json["profile_image"],
        replyPostTime: json["reply_post_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "user_name": userName,
        "profile_image": profileImage,
        "reply_post_time": replyPostTime,
      };
}
