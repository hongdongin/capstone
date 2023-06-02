import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class PostVideoButton extends StatelessWidget {
  const PostVideoButton({
    super.key,
    required this.inverted,
  });

  final bool inverted;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size12,
          ),
          decoration: BoxDecoration(
            color: !inverted ? Colors.white : Colors.green.shade500,
            borderRadius: BorderRadius.circular(
              Sizes.size6,
            ),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.mugSaucer,
              color: !inverted ? Colors.green.shade500 : Colors.white,
              size: 18,
            ),
          ),
        )
      ],
    );
  }
}
