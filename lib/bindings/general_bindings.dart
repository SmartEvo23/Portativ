import 'package:get/get.dart';
import '../features/personalization/controllers/address_controller.dart';
import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.put(NetworkManager());

    /// -- Other
    Get.put(AddressController());
  }
}
