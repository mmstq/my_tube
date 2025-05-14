// ignore_for_file: unnecessary_null_comparison

class VideoModel {
  final int? id;
  final String? title;
  final String? url;
  final String? cdnUrl;
  final String? thumbCdnUrl;
  final int? userId;
  final String? status;
  final String? slug;
  final String? encodeStatus;
  final int? priority;
  final int? categoryId;
  final int? totalViews;
  final int? totalLikes;
  final int? totalComments;
  final int? totalShare;
  final int? totalWishlist;
  final int? duration;
  final String? language;
  final String? orientation;
  final int? videoHeight;
  final int? videoWidth;
  final int? isPrivate;
  final int? isHideComment;
  final String? description;
  final User user;
  final Category? category;
  final bool? isLiked;
  final bool? isWished;
  final bool? isFollow;

  VideoModel({
    required this.id,
    required this.title,
    required this.url,
    required this.cdnUrl,
    required this.thumbCdnUrl,
    required this.userId,
    required this.status,
    required this.slug,
    required this.encodeStatus,
    required this.priority,
    required this.categoryId,
    required this.totalViews,
    required this.totalLikes,
    required this.totalComments,
    required this.totalShare,
    required this.totalWishlist,
    required this.duration,
    required this.language,
    required this.orientation,
    required this.videoHeight,
    required this.videoWidth,
    required this.isPrivate,
    required this.isHideComment,
    required this.description,
    required this.user,
    required this.category,
    required this.isLiked,
    required this.isWished,
    required this.isFollow,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      cdnUrl: json['cdn_url'],
      thumbCdnUrl: json['thumb_cdn_url'],
      userId: json['user_id'],
      status: json['status'],
      slug: json['slug'],
      encodeStatus: json['encode_status'],
      priority: json['priority'],
      categoryId: json['category_id'],
      totalViews: json['total_views'],
      totalLikes: json['total_likes'],
      totalComments: json['total_comments'],
      totalShare: json['total_share'],
      totalWishlist: json['total_wishlist'],
      duration: json['duration'],
      language: json['language'],
      orientation: json['orientation'],
      videoHeight: json['video_height'],
      videoWidth: json['video_width'],
      isPrivate: json['is_private'],
      isHideComment: json['is_hide_comment'],
      description: json['description'],
      user: User.fromJson(json['user']),
      category: Category.fromJson(json['category']),
      isLiked: json['is_liked'],
      isWished: json['is_wished'],
      isFollow: json['is_follow'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['url'] = url;
    data['cdn_url'] = cdnUrl;
    data['thumb_cdn_url'] = thumbCdnUrl;
    data['user_id'] = userId;
    data['status'] = status;
    data['slug'] = slug;
    data['encode_status'] = encodeStatus;
    data['priority'] = priority;
    data['category_id'] = categoryId;
    data['total_views'] = totalViews;
    data['total_likes'] = totalLikes;
    data['total_comments'] = totalComments;
    data['total_share'] = totalShare;
    data['total_wishlist'] = totalWishlist;
    data['duration'] = duration;
    data['language'] = language;
    data['orientation'] = orientation;
    data['video_height'] = videoHeight;
    data['video_width'] = videoWidth;
    data['is_private'] = isPrivate;
    data['is_hide_comment'] = isHideComment;
    data['description'] = description;
    data['user'] = user.toJson();
    data['category'] = category?.toJson();
    data['is_liked'] = isLiked;
    data['is_wished'] = isWished;
    data['is_follow'] = isFollow;
    return data;
  }
}

class User {
  int? userId;
  String? fullName;
  String? username;
  String? profilePicture;
  String? profilePictureCdn;
  String? designation;
  bool? isSubscriptionActive;
  bool? isFollow;

  User({
    required this.userId,
    required this.fullName,
    required this.username,
    required this.profilePicture,
    required this.profilePictureCdn,
    required this.designation,
    required this.isSubscriptionActive,
    required this.isFollow,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      fullName: json['fullname'],
      username: json['username'],
      profilePicture: json['profile_picture'],
      profilePictureCdn: json['profile_picture_cdn'],
      designation: json['designation'],
      isSubscriptionActive: json['is_subscription_active'],
      isFollow: json['is_follow'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['fullname'] = fullName;
    data['username'] = username;
    data['profile_picture'] = profilePicture;
    data['profile_picture_cdn'] = profilePictureCdn;
    data['designation'] = designation;
    data['is_subscription_active'] = isSubscriptionActive;
    data['is_follow'] = isFollow;
    return data;
  }
}

class Category {
  String? title;

  Category({required this.title});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(title: json['title']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    return data;
  }
}
