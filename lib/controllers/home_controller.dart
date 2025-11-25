import 'package:get/get.dart';

/// Controller for managing home screen state using GetX
///
/// Handles tab navigation and maintains the currently selected tab index
/// as a reactive observable value that automatically updates the UI
/// when changed.
class HomeController extends GetxController {
  /// Observable index of the currently selected tab
  ///
  /// Initialized to 0 (first tab). When this value changes,
  /// any widgets observing it will automatically rebuild.
  var currentIndex = 0.obs;

  /// Updates the current tab index
  ///
  /// Parameters:
  ///   [index] - The zero-based index of the tab to switch to
  ///
  /// This method updates the reactive [currentIndex] value,
  /// triggering UI updates in any observing widgets.
  void changeTab(int index) {
    currentIndex.value = index;
  }
}
