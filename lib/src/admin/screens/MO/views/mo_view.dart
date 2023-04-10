import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/models/moProfile.dart';
import 'package:marketing/src/admin/screens/MO/controller/mo_controller.dart';
import 'package:marketing/src/admin/screens/add_user/views/AddUserView.dart';
import 'package:marketing/src/admin/screens/officers_profile/views/officers_profile_view.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';

class MoViews extends GetView<MoController> {
  const MoViews({super.key});
  static String route = '/admin/officers';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Marketing Officers',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppConfig.primaryColor7,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: controller.decrease,
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                          Obx(() {
                            return Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                controller.pageSize.value.toString(),
                                style: GoogleFonts.firaSans(
                                  color: AppConfig.primaryColor5,
                                ),
                              ),
                            );
                          }),
                          IconButton(
                            onPressed: controller.increase,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            return Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: DropdownButton(
                                value: controller.status.value,
                                underline: Container(),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'all',
                                    child: Text('All'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'true',
                                    child: Text('Active'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'false',
                                    child: Text('Inactive'),
                                  ),
                                ],
                                onChanged: (value) {
                                  controller.setStatus(value.toString());
                                },
                              ),
                            );
                          }),
                          const SizedBox(
                            width: 10,
                          ),
                          Obx(() {
                            return Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: DropdownButton(
                                value: controller.role.value,
                                underline: Container(),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'all',
                                    child: Text('All'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'USER',
                                    child: Text('USER'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'ADMIN',
                                    child: Text('ADMIN'),
                                  ),
                                ],
                                onChanged: (value) {
                                  controller.setRole(value.toString());
                                },
                              ),
                            );
                          })
                        ],
                      )
                    ],
                  ),
                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton(
                        hint: Text(
                          'Select team member',
                          style: GoogleFonts.firaSans(
                              color: AppConfig.primaryColor5),
                        ),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: Colors.white,
                        underline: Container(),
                        value: controller.selectedGroup.value,
                        items: controller.items
                            .map(
                              (element) => DropdownMenuItem(
                                value: element.value,
                                child: Text(
                                  element.text,
                                  style: GoogleFonts.firaSans(
                                      color: AppConfig.primaryColor5),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          controller.changeSelectedGroup(value.toString());
                        },
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (value) {
                      controller.changename(value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Seach User....',
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                () => controller.pagingController.refresh(),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: PagedListView(
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<MOProfile>(
                    itemBuilder: (context, item, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    OfficersProfileView.route,
                                    arguments: item,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: item.profile != null
                                          ? item.profile!.thumbnailUrl !=
                                                      null &&
                                                  item.profile!.thumbnailUrl!
                                                      .isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Image.network(
                                                    '${AppConfig.SERVER_IP}/${item.profile!.thumbnailUrl!}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                    item.name
                                                        .toString()
                                                        .substring(0, 1)
                                                        .toUpperCase(),
                                                    style: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                )
                                          : Center(
                                              child: Text(
                                                item.name
                                                    .toString()
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: GoogleFonts.firaSans(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name == null
                                              ? ''
                                              : item.name.toString().length > 15
                                                  ? '${item.name.toString().substring(0, 15)}...'
                                                  : item.name.toString(),
                                          style: GoogleFonts.firaSans(
                                            color: AppConfig.primaryColor5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          item.email != null
                                              ? item.email.toString().length >
                                                      18
                                                  ? '${item.email.toString().substring(0, 18)}...'
                                                  : item.email.toString()
                                              : '',
                                          style: GoogleFonts.firaSans(
                                            color: AppConfig.primaryColor5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  GetX<StorageController>(
                                    builder: (storage) {
                                      return storage.isEditUser == true
                                          ? IconButton(
                                              onPressed: () {
                                                Get.toNamed(
                                                  AddUserViews.routeName,
                                                  arguments: {
                                                    'title': 'Edit User',
                                                    'user': item,
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: AppConfig.primaryColor5,
                                              ),
                                            )
                                          : Container();
                                    },
                                  ),
                                  GetX<StorageController>(
                                    builder: (storage) {
                                      return storage.isDeleteUser == true
                                          ? controller.deleting.isTrue
                                              ? Container(
                                                  height: 30,
                                                  width: 30,
                                                  alignment: Alignment.center,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color:
                                                        AppConfig.primaryColor5,
                                                    strokeWidth: 1,
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    Get.dialog(
                                                      AlertDialog(
                                                        title: Text(
                                                          'Warning! ',
                                                          style: GoogleFonts
                                                              .firaCode(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                'Are you sure want to perform this action ?',
                                                                style: GoogleFonts
                                                                    .firaSans(
                                                                  color: Colors
                                                                      .indigo
                                                                      .shade400,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                'After this action this user will be deleted permanently',
                                                                style: GoogleFonts
                                                                    .firaSans(
                                                                  color: Colors
                                                                      .indigo
                                                                      .shade400,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              'No',
                                                              style: GoogleFonts
                                                                  .firaSans(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                              controller
                                                                  .deleteUser(
                                                                userId: item.sId
                                                                    .toString(),
                                                              );
                                                            },
                                                            child: Text(
                                                              'Yes',
                                                              style: GoogleFonts
                                                                  .firaSans(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color:
                                                        AppConfig.primaryColor5,
                                                  ),
                                                )
                                          : Container();
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
