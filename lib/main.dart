import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/router.dart';

import 'common/mode_config/mode_config.dart';
import 'features/videos/repos/video_playback_config_repo.dart';
import 'features/videos/view_models/playback_config_vm.dart';
import 'firebase_options.dart';

void main() async {
  //WidgetFlutterBinding는 Flutter Engine과의 상호작용을 위해 사용된다.
  //ensureInitialized()를 호출하여 플랫폼 채널의 위젯 바인딩을 보장해야한다.
  WidgetsFlutterBinding.ensureInitialized();
  //파이어베이스 초기화를 위해 사용한다.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //플러터에서 화면을 고정하기 위해 사용한다.
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  final preferences = await SharedPreferences.getInstance();
  final repository = PlaybackConfigRepository(preferences);

  runApp(
    ProviderScope(
      overrides: [
        playbackConfigProvider
            .overrideWith(() => PlaybackConfigViewModel(repository))
      ],
      child: const TikTokApp(),
    ),
  );
}

class TikTokApp extends ConsumerWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //위젯이 많은 복잡한 화면에서 세세한 에니메이션을 구현할 수 있어 사용함.
    return AnimatedBuilder(
      animation: modeConfig,
      //gorouter를 이용하여 페이지 이동을 구현.
      builder: (context, child) => MaterialApp.router(
        //riverpod을 이용한 위젯을 구성하는 편리한 번들.
        routerConfig: ref.watch(routerProvider),
        debugShowCheckedModeBanner: false,
        title: '작은 일상',
        themeMode: modeConfig.autoMode ? ThemeMode.dark : ThemeMode.system,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: Typography.blackMountainView,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xFFE9435A),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
          ),
          splashColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: Colors.black,
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.black,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          tabBarTheme: TabBarTheme(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade700,
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
          ),
          textTheme: Typography.whiteMountainView,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.grey.shade900,
            backgroundColor: Colors.grey.shade900,
            foregroundColor: Colors.white,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
            iconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade900,
          ),
          primaryColor: const Color(0xFFE9435A),
        ),
      ),
    );
  }
}
