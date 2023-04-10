import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/admin/screens/activities/views/ActivitiesView.dart';
import 'package:marketing/src/admin/screens/add_user/views/AddUserView.dart';
import 'package:marketing/src/admin/screens/constants/view/constants_view.dart';
import 'package:marketing/src/admin/screens/ddoc/views/DdocView.dart';
import 'package:marketing/src/admin/screens/dealer/views/DealerView.dart';
import 'package:marketing/src/admin/screens/deleted_users/views/deleted_userd_view.dart';
import 'package:marketing/src/admin/screens/groups/views/group_views.dart';
import 'package:marketing/src/admin/screens/leaves/views/LeavesView.dart';
import 'package:marketing/src/admin/screens/meetings/views/adminMeeting_views.dart';
import 'package:marketing/src/admin/screens/permissions/views/permission_views.dart';
import 'package:marketing/src/admin/screens/reports/views/ReportsView.dart';
import 'package:marketing/src/admin/screens/teams/views/TeamsView.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/widgets/cool_button.dart';

class QuickAction extends GetView<StorageController> {
  const QuickAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: Colors.indigo.shade400,
                      iconColor: Colors.white,
                      textColor: Colors.black,
                      onTap: () {
                        Get.toNamed(ActivitiesViews.routeName);
                      },
                      icon: Icons.history,
                      text: "Activities",
                      isAdmin: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: controller.isViewConstants
                          ? Colors.indigo.shade400
                          : Colors.grey.shade500,
                      iconColor: Colors.white,
                      textColor: controller.isViewConstants
                          ? Colors.black
                          : Colors.white,
                      onTap: () {
                        if (controller.isViewConstants) {
                          Get.toNamed(ConstantsViews.routeName);
                        } else {
                          Get.snackbar("Error",
                              "Permision not found for this action ask to admin");
                        }
                      },
                      icon: Icons.lightbulb_sharp,
                      text: "Constants",
                      isAdmin: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: controller.isShowMistriMeetings
                          ? Colors.indigo.shade400
                          : Colors.grey.shade500,
                      iconColor: Colors.white,
                      textColor: controller.isShowMistriMeetings
                          ? Colors.black
                          : Colors.white,
                      onTap: () {
                        if (controller.isShowMistriMeetings) {
                          Get.toNamed(AdminMeetingViews.routeName);
                        } else {
                          Get.snackbar("Error",
                              "Permision not found for this action ask to admin");
                        }
                      },
                      icon: Icons.groups_outlined,
                      text: "Meetings",
                      isAdmin: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: Colors.indigo.shade400,
                      iconColor: Colors.white,
                      textColor: Colors.black,
                      onTap: () {
                        Get.toNamed(GroupViews.routeName);
                      },
                      icon: Icons.group,
                      text: "Groups",
                      isAdmin: true,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: Colors.indigo.shade400,
                      iconColor: Colors.white,
                      textColor: Colors.black,
                      onTap: () {
                        Get.toNamed(ReportsViews.routeName);
                      },
                      icon: Icons.book,
                      text: "Reports",
                      isAdmin: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: Colors.indigo.shade400,
                      iconColor: Colors.white,
                      textColor: Colors.black,
                      onTap: () {
                        Get.toNamed(LeavesViews.routeName);
                      },
                      icon: Icons.remove_done,
                      text: "Leaves",
                      isAdmin: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: controller.isDdocUser
                          ? Colors.indigo.shade400
                          : Colors.grey.shade500,
                      iconColor: Colors.white,
                      textColor:
                          controller.isDdocUser ? Colors.black : Colors.white,
                      onTap: () {
                        if (controller.isDdocUser) {
                          Get.toNamed(DdocViews.routeName);
                        } else {
                          Get.snackbar("Error",
                              "Permision not found for this action ask to admin");
                        }
                      },
                      icon: Icons.data_object,
                      text: "Ddoc",
                      isAdmin: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: controller.isDeletedUsers
                          ? Colors.indigo.shade400
                          : Colors.grey.shade500,
                      iconColor: Colors.white,
                      textColor: controller.isDeletedUsers
                          ? Colors.black
                          : Colors.white,
                      onTap: () {
                        if (controller.isDeletedUsers) {
                          Get.toNamed(DeletedUser.routeName);
                        } else {
                          Get.snackbar("Error",
                              "Permision not found for this action ask to admin");
                        }
                      },
                      icon: Icons.delete,
                      text: "Del User",
                      isAdmin: true,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: controller.isViewPermissions
                          ? Colors.indigo.shade400
                          : Colors.grey.shade500,
                      iconColor: Colors.white,
                      textColor: controller.isViewPermissions
                          ? Colors.black
                          : Colors.white,
                      onTap: () {
                        if (controller.isCreateUser) {
                          Get.toNamed(PermissionViews.routeName);
                        } else {
                          Get.snackbar("Error",
                              "Permision not found for this action ask to admin");
                        }
                      },
                      icon: Icons.security,
                      text: "Permission",
                      isAdmin: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: Colors.indigo.shade400,
                      iconColor: Colors.white,
                      textColor: Colors.black,
                      onTap: () {
                        Get.toNamed(DealerViews.routeName);
                      },
                      icon: Icons.shop,
                      text: "Dealer",
                      isAdmin: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: Colors.indigo.shade400,
                      iconColor: Colors.white,
                      textColor: Colors.black,
                      onTap: () {
                        Get.toNamed(TeamsViews.routeName);
                      },
                      icon: Icons.flag,
                      text: "Team",
                      isAdmin: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CoolButton(
                      backgroundColor: controller.isCreateUser
                          ? Colors.indigo.shade400
                          : Colors.grey.shade500,
                      iconColor: Colors.white,
                      textColor:
                          controller.isCreateUser ? Colors.black : Colors.white,
                      icon: Icons.person_add,
                      onTap: () {
                        if (controller.isCreateUser) {
                          Get.toNamed(AddUserViews.routeName);
                        } else {
                          Get.snackbar("Error",
                              "Permision not found for this action ask to admin");
                        }
                      },
                      text: "Add User",
                      isAdmin: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
