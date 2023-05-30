import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/image/views/image_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chat_page.dart';
import 'package:tiktok_clone/features/notifications/notifications_provider.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

import 'common/main_navigation/widgets/main_navigation/main_navigation_screen.dart';
import 'features/authentication/repos/authentication_repo.dart';
import 'features/videos/views/video_recording_screen.dart';

final routerProvider = Provider((ref) {
  // ref.watch(authState);
  return GoRouter(
    initialLocation: "/discover",
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.subloc != SignUpScreen.routeUrl &&
            state.subloc != LoginScreen.routeUrl) {
          return SignUpScreen.routeUrl;
        }
      }
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          ref.read(notificationsProvider(context));
          return child;
        },
        routes: [
          GoRoute(
            name: SignUpScreen.routeName,
            path: SignUpScreen.routeUrl,
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            name: LoginScreen.routeName,
            path: LoginScreen.routeUrl,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            name: InterestsScreen.routeName,
            path: InterestsScreen.routeUrl,
            builder: (context, state) => const InterestsScreen(),
          ),
          GoRoute(
            path: "/:tab(home|discover|inbox|profile)",
            name: MainNavigationScreen.routeName,
            builder: (context, state) {
              final tab = state.params["tab"]!;
              return MainNavigationScreen(tab: tab);
            },
          ),
          GoRoute(
            name: ChatPage.routeName,
            path: ChatPage.routeUrl,
            builder: (context, state) => const ChatPage(
              meetingId: 'user',
            ),
            routes: const [],
          ),
          GoRoute(
            name: ImageScreen.routeName,
            path: ImageScreen.routeUrl,
            builder: (context, state) => const ImageScreen(),
          ),
          GoRoute(
            path: VideoRecordingScreen.routeUrl,
            name: VideoRecordingScreen.routeName,
            pageBuilder: (context, state) => CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 200),
              child: const VideoRecordingScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final position = Tween(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation);
                return SlideTransition(
                  position: position,
                  child: child,
                );
              },
            ),
          )
        ],
      ),
    ],
  );
});
