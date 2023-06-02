import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/mode_config/mode_config.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';

import '../authentication/repos/authentication_repo.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          AnimatedBuilder(
            animation: modeConfig,
            builder: (context, child) => SwitchListTile.adaptive(
              value: modeConfig.autoMode,
              onChanged: (value) {
                modeConfig.toggleAutoMode();
              },
              title: const Text("시스템 모드 변경"),
              subtitle: const Text("화면을 반전 시킵니다."),
            ),
          ),
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).muted,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setMuted(value),
            title: const Text("동영상 소리 끄기"),
            subtitle: const Text("동영상 소리는 꺼진 것이 기본 상태입니다."),
          ),
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).autoplay,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setAutoplay(value),
            title: const Text("자동재생"),
            subtitle: const Text("동영상이 자동으로 실행됩니다."),
          ),
          SwitchListTile.adaptive(
            value: false,
            onChanged: (value) {},
            title: const Text("알림 설정"),
          ),
          CheckboxListTile(
            activeColor: Colors.black,
            value: false,
            onChanged: (value) {},
            title: const Text("마케팅 허용"),
          ),
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );
              if (kDebugMode) {
                print(date);
              }
              // ignore: use_build_context_synchronously
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (kDebugMode) {
                print(time);
              }
              // ignore: use_build_context_synchronously
              final booking = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                        appBarTheme: const AppBarTheme(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black)),
                    child: child!,
                  );
                },
              );
              if (kDebugMode) {
                print(booking);
              }
            },
            title: const Text("일정을 추가하세요."),
          ),
          ListTile(
            title: const Text("로그아웃"),
            textColor: Colors.red,
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: const Text("로그아웃 하시겠습니까?"),
                  actions: [
                    CupertinoActionSheetAction(
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("아니오."),
                    ),
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () => {
                        ref.read(authRepo).signOut(),
                        context.go("/"),
                      },
                      child: const Text("로그아웃."),
                    )
                  ],
                ),
              );
            },
          ),
          const AboutListTile(
            applicationVersion: "1.0",
            applicationLegalese: "캡스톤 발표.",
          ),
        ],
      ),
    );
  }
}
