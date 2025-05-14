import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_tube/core/util/cache_util.dart';
import 'package:my_tube/data/repositories/video_repository_impl.dart';
import 'package:my_tube/data/sources/video_remote_data_source.dart';
import 'package:my_tube/domain/repositories/video_repository.dart';
import 'package:my_tube/domain/usecases/get_videos.dart';
import 'package:my_tube/presentation/bloc/video_bloc.dart';
import 'package:my_tube/presentation/bloc/reels_home_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory<VideoBloc>(() => VideoBloc(getVideos: sl<GetVideos>()));
  sl.registerFactory<ReelsHomeBloc>(
    () => ReelsHomeBloc(getVideos: sl<GetVideos>()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetVideos(sl<VideoRepository>()));

  // Repository
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(
      remoteDataSource: sl<VideoRemoteDataSource>(),
      cacheUtil: sl<CacheUtil>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<VideoRemoteDataSource>(
    () => VideoRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());

  // Utils
  sl.registerLazySingleton(
    () => CacheUtil(sharedPreferences: sl<SharedPreferences>()),
  );
}
