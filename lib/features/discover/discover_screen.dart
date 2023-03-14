import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

final tabs = ["Top", "Users", "Videos", "Sounds", "LIVE", "Shopping", "Brands"];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _textEditingController = TextEditingController(
    text: "initial text",
  );

  bool _isWriting = false;

  void _onSearchChanged(String value) {
    print("searching for $value");
  }

  void _onSubmitted(String value) {
    print("submitted $value");
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _stopSearch() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _indexChanged(int n) {
    if (tabs[n].isNotEmpty) {
      setState(() {
        FocusScope.of(context).unfocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: GestureDetector(
        onTap: _stopSearch,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 1,
            title: CupertinoSearchTextField(
              controller: _textEditingController,
              onChanged: _onSearchChanged,
              onSubmitted: _onSubmitted,
            ),
            bottom: TabBar(
              onTap: _indexChanged,
              splashFactory: NoSplash.splashFactory,
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
              isScrollable: true,
              indicatorColor: Colors.black,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.size16,
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade500,
              tabs: [
                for (var tab in tabs)
                  Tab(
                    text: tab,
                  ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  Sizes.size6,
                ),
                child: GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: 20,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Sizes.size10,
                    mainAxisSpacing: Sizes.size10,
                    childAspectRatio: 9 / 20,
                  ),
                  itemBuilder: (context, index) => Column(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Sizes.size4,
                          ),
                        ),
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/placeholder.jpg",
                            fit: BoxFit.cover,
                            image:
                                "https://images.unsplash.com/photo-1554486840-db3a33d9318e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80",
                          ),
                        ),
                      ),
                      Gaps.v10,
                      const Text(
                        "this is a very long caption for my tiktok that im upload just now currently.",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: Sizes.size18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.v8,
                      DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Expanded(
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                  "https://p.kakaocdn.net/th/talkp/wl4bsCBor2/896IHydowqOQbAUgmxFOX0/josobb_110x110_c.jpg",
                                ),
                              ),
                              Gaps.h4,
                              const Expanded(
                                child: Text(
                                  "this is a very long caption for my tiktok that im upload just now currently.",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Gaps.h4,
                              FaIcon(
                                FontAwesomeIcons.heart,
                                size: Sizes.size16,
                                color: Colors.grey.shade600,
                              ),
                              Gaps.h2,
                              const Text(
                                "2.5M",
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              for (var tab in tabs.skip(1))
                Center(
                  child: Text(
                    tab,
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
