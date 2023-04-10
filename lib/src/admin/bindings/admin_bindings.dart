import 'package:get/get.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/controller/admin_controller.dart';
import 'package:marketing/src/admin/controller/ashop_controller.dart';
import 'package:marketing/src/admin/controller/spreview_controller.dart';
import 'package:marketing/src/admin/maps/controller/maps_controller.dart';
import 'package:marketing/src/admin/screens/MO/controller/mo_controller.dart';
import 'package:marketing/src/admin/screens/activities/controller/ActivitiesController.dart';
import 'package:marketing/src/admin/screens/add_user/controller/AddUserController.dart';
import 'package:marketing/src/admin/screens/all_visits/controller/all_visits_controller.dart';
import 'package:marketing/src/admin/screens/chat_module/controller/ChatModuleController.dart';
import 'package:marketing/src/admin/screens/chat_module/controller/chat_preview_controller.dart';
import 'package:marketing/src/admin/screens/constants/controller/constants_controller.dart';
import 'package:marketing/src/admin/screens/dealer/controller/DealerController.dart';
import 'package:marketing/src/admin/screens/deleted_users/controller/deleted_user_controller.dart';
import 'package:marketing/src/admin/screens/groups/controller/group_controller.dart';
import 'package:marketing/src/admin/screens/headers_profilelist/controller/headers_profile_controller.dart';
import 'package:marketing/src/admin/screens/leaves/controller/LeavesController.dart';
import 'package:marketing/src/admin/screens/meetings/controller/admin_meetingcontroller.dart';
import 'package:marketing/src/admin/screens/odometer/controller/admin_odometer.controller.dart';
import 'package:marketing/src/admin/screens/officers_profile/controller/officer_profile_controller.dart';
import 'package:marketing/src/admin/screens/permissions/controller/permission_controller.dart';
import 'package:marketing/src/admin/screens/reports/controller/ReportsController.dart';
import 'package:marketing/src/admin/screens/sponsor/controller/SponsorController.dart';
import 'package:marketing/src/admin/screens/teams/controller/TeamsController.dart';

class AdminHomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AdminApi(),
    );
    Get.lazyPut(
      () => AdminController(),
    );
  }
}

class AdminShopBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AShopController());
  }
}

class SPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpreviewController());
  }
}

class AOdometersBinding extends Bindings {
  @override
  dependencies() {
    Get.lazyPut(() => AOdometerController());
  }
}

class MapsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AMapsController());
  }
}

class OfficersProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OfficersProfileController());
  }
}

class MoBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MoController());
  }
}

class AllVisitsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllVisitController());
  }
}

class HeadersProfileListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HeadersProfileController());
  }
}

class ConstantsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConstantsController());
  }
}

class PermissionmBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PermisionController());
  }
}

class GroupBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupController());
  }
}

class AdminMeetingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminMeetingController());
  }
}

class DeletedUserBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeletedUserController());
  }
}

class DdocBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DdocBindings());
  }
}

class LeavesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeavesController());
  }
}

class ActivitiesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivitiesController());
  }
}

class ReportsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportsController());
  }
}

class DealerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DealerController());
  }
}

class AdminTeamsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeamsController());
  }
}

class AddUserBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddUserController());
  }
}

class SponsorBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SponsorController());
  }
}

class ChatModuleBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatModuleController());
  }
}

class AdminChatPreviewBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminChatPreviewController());
  }
}
