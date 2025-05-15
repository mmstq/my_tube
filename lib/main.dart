import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tube/core/util/injection_container.dart' as di;
import 'package:my_tube/presentation/bloc/reels_bloc.dart';
import 'package:my_tube/presentation/bloc/reels_home_bloc.dart';
import 'package:my_tube/presentation/pages/reels_homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Initialize dependency injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ReelsBloc>()),
        BlocProvider(create: (_) => di.sl<ReelsFeedBloc>()),
      ],
      child: MaterialApp(
        title: 'MyTube',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Colors.white),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const ReelsFeedPage(),
      ),
    );
  }
}
