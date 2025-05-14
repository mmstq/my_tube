import 'package:equatable/equatable.dart';
import 'package:my_tube/data/models/video_model.dart';

class Video extends Equatable {
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
  final Category category;
  final bool? isLiked;
  final bool? isWished;
  final bool? isFollow;

  const Video({
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

  @override
  List<dynamic> get props => [
    id,
    title,
    description,
    url,
    cdnUrl,
    thumbCdnUrl,
    userId,
    status,
    slug,
    encodeStatus,
    priority,
    totalViews,
    totalLikes,
    totalComments,
    totalShare,
    totalWishlist,
    duration,
    language,
    orientation,
    videoHeight,
    videoWidth,
    isPrivate,
    isHideComment,
    isLiked,
    isWished,
    isFollow,
    user,
    category,
  ];
}
