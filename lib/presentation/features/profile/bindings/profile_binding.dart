import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

/// Profile binding for dependency injection
/// This ensures all dependencies are available when the profile view is initialized
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy put profile controller - will be created when first accessed
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );

    // Services are already initialized in main.dart as permanent
    // They can be accessed via Get.find() in the controller
  }
}
