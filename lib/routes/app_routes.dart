import 'package:get/get_navigation/src/routes/get_route.dart';

/// Navigația din Portativ folosește aproape peste tot [Get.to]/[Get.offAll]
/// cu widget-uri directe, nu rute cu nume - lista de mai jos e goală
/// intenționat (rutele de mai jos erau legate de magazinul de test, șters).
/// GetMaterialApp cere totuși o listă (poate fi goală) pentru `getPages`.
class AppRoutes {
  static final pages = <GetPage>[];
}
