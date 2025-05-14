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
  final String? byteAddedOn;
  final String? byteUpdatedOn;
  final dynamic bunnyStreamVideoId;
  final String? bytePlusVideoId;
  final String? language;
  final String? orientation;
  final int? bunnyEncodingStatus;
  final dynamic deletedAt;
  final int? videoHeight;
  final int? videoWidth;
  final String? location;
  final int? isPrivate;
  final int? isHideComment;
  final String? description;
  final dynamic archivedAt;
  final User user;
  final Category? category;
  final List<dynamic>? resolutions;
  final bool? isLiked;
  final bool? isWished;
  final bool? isFollow;
  final String? metaDescription;
  final String? metaKeywords;
  final String? videoAspectRatio;

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
    required this.byteAddedOn,
    required this.byteUpdatedOn,
    required this.bunnyStreamVideoId,
    required this.bytePlusVideoId,
    required this.language,
    required this.orientation,
    required this.bunnyEncodingStatus,
    required this.deletedAt,
    required this.videoHeight,
    required this.videoWidth,
    required this.location,
    required this.isPrivate,
    required this.isHideComment,
    required this.description,
    required this.archivedAt,
    required this.user,
    required this.category,
    required this.resolutions,
    required this.isLiked,
    required this.isWished,
    required this.isFollow,
    required this.metaDescription,
    required this.metaKeywords,
    required this.videoAspectRatio,
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
      byteAddedOn: json['byte_added_on'],
      byteUpdatedOn: json['byte_updated_on'],
      bunnyStreamVideoId: json['bunny_stream_video_id'],
      bytePlusVideoId: json['byte_plus_video_id'],
      language: json['language'],
      orientation: json['orientation'],
      bunnyEncodingStatus: json['bunny_encoding_status'],
      deletedAt: json['deleted_at'],
      videoHeight: json['video_height'],
      videoWidth: json['video_width'],
      location: json['location'],
      isPrivate: json['is_private'],
      isHideComment: json['is_hide_comment'],
      description: json['description'],
      archivedAt: json['archived_at'],
      user: User.fromJson(json['user']),
      category: Category.fromJson(json['category']),
      isLiked: json['is_liked'],
      isWished: json['is_wished'],
      isFollow: json['is_follow'],
      metaDescription: json['meta_description'],
      metaKeywords: json['meta_keywords'],
      videoAspectRatio: json['video_aspect_ratio'],
      resolutions: json['resolutions'],
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
    data['byte_added_on'] = byteAddedOn;
    data['byte_updated_on'] = byteUpdatedOn;
    data['bunny_stream_video_id'] = bunnyStreamVideoId;
    data['byte_plus_video_id'] = bytePlusVideoId;
    data['language'] = language;
    data['orientation'] = orientation;
    data['bunny_encoding_status'] = bunnyEncodingStatus;
    data['deleted_at'] = deletedAt;
    data['video_height'] = videoHeight;
    data['video_width'] = videoWidth;
    data['location'] = location;
    data['is_private'] = isPrivate;
    data['is_hide_comment'] = isHideComment;
    data['description'] = description;
    data['archived_at'] = archivedAt;
    data['user'] = user.toJson();
    data['category'] = category?.toJson();
    data['is_liked'] = isLiked;
    data['is_wished'] = isWished;
    data['is_follow'] = isFollow;
    data['meta_description'] = metaDescription;
    data['meta_keywords'] = metaKeywords;
    data['video_aspect_ratio'] = videoAspectRatio;
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
