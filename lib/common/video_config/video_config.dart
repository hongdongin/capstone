import 'package:flutter/widgets.dart';

class VideoConfig extends ChangeNotifier {
  bool isAutoMuted = false;
  bool isAutoPlay = false;
  void toggleAutoMute() {
    isAutoMuted = !isAutoMuted;
    notifyListeners();
  }
}

final videoConfig = VideoConfig();
