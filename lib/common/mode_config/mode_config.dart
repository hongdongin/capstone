import 'package:flutter/widgets.dart';

class ModeConfig extends ChangeNotifier {
  bool autoMode = false;

  void toggleAutoMute() {
    autoMode = !autoMode;
    notifyListeners();
  }
}

final modeConfig = ModeConfig();
