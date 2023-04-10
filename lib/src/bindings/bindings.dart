import 'package:get/get.dart';
import 'package:marketing/src/user/chat/controller/socket_service.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';
import 'package:marketing/src/user/controller/foreground_syncService.dart';
import 'package:marketing/src/user/controller/help_controller.dart';
import 'package:marketing/src/user/controller/home_controller.dart';
import 'package:marketing/src/user/controller/leave_controller.dart';
import 'package:marketing/src/user/controller/meetings_controller.dart';
import 'package:marketing/src/user/controller/my_meeting_controller.dart';
import 'package:marketing/src/user/controller/settings_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/controller/shop_create_controller.dart';
import 'package:marketing/src/user/controller/maps_controller.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/controller/shop_controller.dart';
import 'package:marketing/src/user/controller/teams_controller.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/controller/login_controller.dart';
import 'package:marketing/src/user/controller/odometer_controller.dart';
import 'package:marketing/src/user/controller/shop_details.dart';
import 'package:marketing/src/user/controller/shop_visit_controller.dart';
import 'package:marketing/src/user/controller/splash_controller.dart';
import 'package:marketing/src/user/controller/verification_controller.dart';
import 'package:marketing/src/user/screens/app_permission/controller/AppPermissionController.dart';
import 'package:marketing/src/user/screens/paints/controller/PaintsController.dart';
import 'package:marketing/src/user/screens/validation/controller/ValidationController.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageController());
    Get.put(ApiController());
    Get.put(CloudController());
    Get.put(SettingController());
  }
}

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MapsController());
    Get.put(ShopController());
    Get.put(VisitController());
    Get.put(ReminderController());
    Get.put(HomeController());
  }
}

class CreateShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopCreateController());
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}

class OdometerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(OdometerController());
  }
}

class ReminderBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ReminderController());
  }
}

class ShopCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopCreateController());
  }
}

class ShopDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopDetailsController());
  }
}

class ShopVisitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopVisitController());
  }
}

class VisitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(VisitController());
  }
}

class ShopReminderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ReminderController());
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

class VerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VerificationController());
  }
}

class DealerShipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DealerShipController());
  }
}

class MeetingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MeetingsController());
  }
}

class TeamsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(TeamsController());
  }
}

class LeaveBindigs extends Bindings {
  @override
  void dependencies() {
    Get.put(LeaveController());
  }
}

class MyMeetingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyMeetingController());
  }
}

class HelpCenterBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpScreenController());
  }
}

class SocketBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SocketService());
  }
}

class PaintBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaintsController());
  }
}

class ValidationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ValidationController());
  }
}

class AppPermissionBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppPermissionController());
  }
}

class ForegroundServiceBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForeGroundSyncService());
  }
}
