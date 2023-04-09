import 'package:get/get.dart';
import 'package:plusone_counter/controllers/home_controllers.dart';
import 'package:plusone_counter/services/hive_service/hive_service.dart';

initializeControllers() async {
  var hiveService =
      await Get.putAsync<HiveService>(() => HiveService.getInstance());

  Get.put(HomeController(hiveService));
}
