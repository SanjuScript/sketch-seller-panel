import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class HapticHandler {
  HapticHandler._();
  static final HapticHandler instance = HapticHandler._();

  void lightImpact() async {
    await Haptics.vibrate(HapticsType.light);
  }

  void errorImpact() async {
    await Haptics.vibrate(HapticsType.error);
  }

  void succesImpact() async {
    await Haptics.vibrate(HapticsType.success);
  }

  void warningImpact() async {
    await Haptics.vibrate(HapticsType.warning);
  }

  void mediumImpact() async {
    await Haptics.vibrate(HapticsType.medium);
  }

  void heavyImpact() async {
    await Haptics.vibrate(HapticsType.heavy);
  }

  void selectionClick() async {
    await Haptics.vibrate(HapticsType.selection);
  }

  void vibrate() {
    HapticFeedback.vibrate();
  }
}
