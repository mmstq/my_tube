import 'package:equatable/equatable.dart';
import 'package:my_tube/domain/entities/video.dart';
import 'package:my_tube/domain/repositories/video_repository.dart';

class GetVideos {
  final VideoRepository repository;

  GetVideos(this.repository);

  Future<List<Video>> call(Params params) async {
    return await repository.getVideos(params.page, params.limit);
  }
}

class Params extends Equatable {
  final int page;
  final int limit;

  const Params({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}
