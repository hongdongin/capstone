import 'package:flutter/widgets.dart';

class ModeConfig extends ChangeNotifier {
  bool autoMode = false;

  void toggleAutoMode() {
    autoMode = !autoMode;
    notifyListeners();
  }
}

final modeConfig = ModeConfig();
