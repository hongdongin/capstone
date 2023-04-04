import 'package:flutter/widgets.dart';

class ModeConfig extends ChangeNotifier {
  bool autoMode = false;
  String mode = 'light';

  void toggleAutoMute() {
    autoMode = !autoMode;

    if (!autoMode) {
      mode = 'dark';
    } else {
      mode = 'light';
    }
    notifyListeners();
  }
}

final modeConfig = ModeConfig();
