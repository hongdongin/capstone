import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/view_models/message_view_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';
import 'package:tiktok_clone/utils.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeUrl = "chatDetail";

  final String chatRoomId;
  final String yourUid;

  const ChatDetailScreen({
    Key? key,
    required this.chatRoomId,
    required this.yourUid,
  }) : super(key: key);

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  bool _isWriting = false;

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  void _onStopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _onSendPressed() {
    final text = _textEditingController.text;
    if (text == "") {
      return;
    }
    ref
        .read(messagesProvider(widget.chatRoomId).notifier)
        .sendMessage(text, widget.yourUid);
    _textEditingController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.read(messagesProvider(widget.chatRoomId)).isLoading;
    Future<Map<String, dynamic>?> userProfile =
        ref.read(userRepo).findProfile(widget.yourUid);

    final width = MediaQuery.of(context).size.width;
    final isDark = isDarkMode(context);

    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: FutureBuilder(
          future: userProfile,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: Sizes.size8,
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: Sizes.size24,
                      foregroundImage: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-76fcb.appspot.com/o/avatar%2F${widget.yourUid}?alt=media&"),
                      child: Text(
                        snapshot.data!['name'],
                      ),
                    ),
                    Positioned(
                      top: Sizes.size32,
                      left: Sizes.size32,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size2,
                          vertical: Sizes.size2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          color: isDark ? null : Colors.grey.shade50,
                        ),
                        child: const Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: Sizes.size14,
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  snapshot.data!['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text("Active now"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.flag,
                      size: Sizes.size20,
                    ),
                    Gaps.h32,
                    FaIcon(
                      FontAwesomeIcons.ellipsis,
                    )
                  ],
                ),
              );
            } else {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: Sizes.size8,
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: Sizes.size24,
                      foregroundImage: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-76fcb.appspot.com/o/avatar%2F${widget.yourUid}?alt=media&"),
                      child: const Text(
                        "??",
                      ),
                    ),
                    Positioned(
                      top: Sizes.size32,
                      left: Sizes.size32,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size2,
                          vertical: Sizes.size2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          color: isDark ? null : Colors.grey.shade50,
                        ),
                        child: const Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: Sizes.size14,
                        ),
                      ),
                    ),
                  ],
                ),
                title: const Text(
                  "??",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text("Active now"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.flag,
                      size: Sizes.size20,
                    ),
                    Gaps.h32,
                    FaIcon(
                      FontAwesomeIcons.ellipsis,
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
      body: GestureDetector(
        onTap: _onStopWriting,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.lg,
            ),
            child: Stack(
              children: [
                ref.watch(chatProvider(widget.chatRoomId)).when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stackTrace) => Center(
                        child: Text(error.toString()),
                      ),
                      data: (data) {
                        return ListView.separated(
                          // reverse: true,
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom +
                                Sizes.size96 +
                                Sizes.size10,
                            top: Sizes.size20,
                            left: Sizes.size14,
                            right: Sizes.size14,
                          ),
                          separatorBuilder: (context, index) => Gaps.v10,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final message = data[index];
                            final isMine =
                                message.userId == ref.watch(authRepo).user!.uid;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: isMine
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(Sizes.size14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft:
                                          const Radius.circular(Sizes.size20),
                                      topRight:
                                          const Radius.circular(Sizes.size20),
                                      bottomLeft: Radius.circular(
                                          isMine ? Sizes.size20 : Sizes.size5),
                                      bottomRight: Radius.circular(
                                          isMine ? Sizes.size5 : Sizes.size20),
                                    ),
                                    color: isMine
                                        ? Colors.blue
                                        : Theme.of(context).primaryColor,
                                  ),
                                  child: Text(
                                    message.text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: Sizes.size16,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                Positioned(
                  bottom: 0,
                  width: width < Breakpoints.lg ? width : Breakpoints.lg,
                  child: Container(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.size10,
                        horizontal: Sizes.size10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isWriting)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _textEditingController.text =
                                        "\u{2764}\u{2764}\u{2764}";
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.size32),
                                      color: isDark
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade200,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Sizes.size2),
                                    width: Sizes.size80,
                                    height: Sizes.size28,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text("\u{2764}"),
                                        Text("\u{2764}"),
                                        Text("\u{2764}"),
                                      ],
                                    ),
                                  ),
                                ),
                                Gaps.h7,
                                GestureDetector(
                                  onTap: () {
                                    _textEditingController.text =
                                        "\u{1F602}\u{1F602}\u{1F602}";
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.size28),
                                      color: isDark
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade200,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Sizes.size2),
                                    width: Sizes.size80,
                                    height: Sizes.size28,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text("\u{1F602}"),
                                        Text("\u{1F602}"),
                                        Text("\u{1F602}"),
                                      ],
                                    ),
                                  ),
                                ),
                                Gaps.h7,
                                GestureDetector(
                                  onTap: () {
                                    _textEditingController.text =
                                        "\u{1F44D}\u{1F44D}\u{1F44D}";
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.size28),
                                      color: isDark
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade200,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Sizes.size2),
                                    width: Sizes.size80,
                                    height: Sizes.size28,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text("\u{1F44D}"),
                                        Text("\u{1F44D}"),
                                        Text("\u{1F44D}"),
                                      ],
                                    ),
                                  ),
                                ),
                                Gaps.h7,
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(Sizes.size28),
                                    color: isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Sizes.size2),
                                  width: Sizes.size72 + Sizes.size36,
                                  height: Sizes.size28,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      FaIcon(
                                        FontAwesomeIcons.circlePlay,
                                        size: Sizes.size16,
                                      ),
                                      Gaps.h4,
                                      Text("Share post"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          Gaps.v10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  height: Sizes.size40,
                                  child: TextField(
                                    controller: _textEditingController,
                                    onTap: _onStartWriting,
                                    maxLines: 5,
                                    minLines: 1,
                                    textInputAction: TextInputAction.newline,
                                    cursorColor: Theme.of(context).primaryColor,
                                    decoration: InputDecoration(
                                      hintText: "Send a Message...",
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(Sizes.size20),
                                          topRight:
                                              Radius.circular(Sizes.size20),
                                          bottomLeft:
                                              Radius.circular(Sizes.size20),
                                          bottomRight: Radius.zero,
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: Sizes.size10,
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.faceLaugh,
                                          ),
                                          Gaps.h10,
                                          if (_isWriting)
                                            GestureDetector(
                                              onTap: _onStopWriting,
                                              child: FaIcon(
                                                FontAwesomeIcons.circleArrowUp,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: Sizes.size20,
                                              ),
                                            ),
                                          if (_isWriting) Gaps.h10,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Gaps.h8,
                              GestureDetector(
                                onTap: isLoading ? null : _onSendPressed,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade300,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: Sizes.size3,
                                    ),
                                    child: FaIcon(
                                      isLoading
                                          ? FontAwesomeIcons.hourglass
                                          : FontAwesomeIcons.solidPaperPlane,
                                      color: Colors.white,
                                      size: Sizes.size20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
