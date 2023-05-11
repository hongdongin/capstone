import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/mode_config/mode_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/views/chat_test_screen.dart';
import 'package:tiktok_clone/features/inbox/views/activity_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  late final String chatRoomId;

  void _onDmPressed({required String chatRoomId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatTestScreen(
          chatRoomId: chatRoomId,
        ),
      ),
    );
  }

  void _onActivityTap() {
    context.pushNamed(ActivityScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            appBar: AppBar(
              elevation: 1,
              shadowColor: modeConfig.autoMode ? Colors.white : Colors.black,
              title: const Text('Inbox'),
              actions: [
                IconButton(
                  onPressed: () => _onDmPressed(chatRoomId: data.uid),
                  icon: const FaIcon(
                    FontAwesomeIcons.paperPlane,
                    size: Sizes.size20,
                  ),
                )
              ],
            ),
            body: ListView(
              children: [
                ListTile(
                  onTap: _onActivityTap,
                  title: const Text(
                    'Activity',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Sizes.size16,
                    ),
                  ),
                  trailing: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: Sizes.size14,
                    color: Colors.black,
                  ),
                ),
                Container(
                  height: Sizes.size1,
                  color: Colors.grey.shade200,
                ),
                ListTile(
                  leading: Container(
                    width: Sizes.size52,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.users,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: const Text(
                    'New followers',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Sizes.size16,
                    ),
                  ),
                  subtitle: const Text(
                    'Messages from followers will appear here.',
                    style: TextStyle(
                      fontSize: Sizes.size14,
                    ),
                  ),
                  trailing: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: Sizes.size14,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        );
  }
}
