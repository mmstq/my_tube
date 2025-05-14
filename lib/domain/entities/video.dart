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
  final Category category;
  final List<dynamic>? resolutions;
  final bool? isLiked;
  final bool? isWished;
  final bool? isFollow;
  final String? metaDescription;
  final String? metaKeywords;
  final String? videoAspectRatio;

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
    categoryId,
    totalViews,
    totalLikes,
    totalComments,
    totalShare,
    totalWishlist,
    duration,
    byteAddedOn,
    byteUpdatedOn,
    bunnyStreamVideoId,
    bytePlusVideoId,
    language,
    orientation,
    bunnyEncodingStatus,
    deletedAt,
    videoHeight,
    videoWidth,
    location,
    isPrivate,
    isHideComment,
    isLiked,
    isWished,
    isFollow,
    metaDescription,
    metaKeywords,
    videoAspectRatio,
    user,
    category,
    resolutions,
  ];
}
