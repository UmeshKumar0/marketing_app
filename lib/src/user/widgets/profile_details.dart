import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/teams_model.dart';
import 'package:marketing/src/user/widgets/team_bottomsheet.dart';

class ProfileDetails extends StatelessWidget {
  ProfileDetails({
    super.key,
    required this.storage,
  });
  StorageController storage;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Obx(() {
          return SizedBox(
            // margin: const EdgeInsets.all(10),
            height: 50,
            child: Row(
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size.infinite,
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(width * 0.5, 50),
                    ),
                    overlayColor:
                        MaterialStateProperty.all(AppConfig.primaryColor7),
                    backgroundColor: MaterialStateProperty.all(
                      storage.isTeam.isFalse
                          ? AppConfig.primaryColor5
                          : Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 500),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(10),
                    ),
                  ),
                  onPressed: () {
                    storage.changeTeamvalue(value: false);
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: storage.isTeam.isFalse
                        ? Colors.white
                        : AppConfig.primaryColor7,
                  ),
                  label: Text(
                    'Personal Info',
                    style: GoogleFonts.firaSans(
                      color: storage.isTeam.isFalse
                          ? Colors.white
                          : Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size.infinite,
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(width * 0.5, 50),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      AppConfig.primaryColor5,
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      storage.isTeam.isTrue
                          ? AppConfig.primaryColor7
                          : Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 500),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(10),
                    ),
                  ),
                  onPressed: () {
                    storage.changeTeamvalue(value: true);
                  },
                  icon: Icon(
                    Icons.group_outlined,
                    color: storage.isTeam.isTrue
                        ? Colors.white
                        : AppConfig.primaryColor7,
                  ),
                  label: Text(
                    'My Teams',
                    style: GoogleFonts.firaSans(
                      color: storage.isTeam.isTrue
                          ? Colors.white
                          : Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
          );
        }),
        Expanded(
          child: Obx(
            () {
              return storage.isTeam.isFalse
                  ? Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: AppConfig.primaryColor7,
                          ),
                          title: Text(
                            'Phone',
                            style: GoogleFonts.firaSans(),
                          ),
                          subtitle: Text(
                            '+91 ${storage.userModel.value.user?.phone as String}',
                            style: GoogleFonts.firaSans(),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.mail,
                            color: AppConfig.primaryColor7,
                          ),
                          title: Text(
                            'Email',
                            style: GoogleFonts.firaSans(),
                          ),
                          subtitle: Text(
                            storage.userModel.value.user?.email as String,
                            style: GoogleFonts.firaSans(),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.cake,
                            color: AppConfig.primaryColor7,
                          ),
                          title: Text(
                            'DOB',
                            style: GoogleFonts.firaSans(),
                          ),
                          subtitle: Text(
                            '06-08-2001',
                            style: GoogleFonts.firaSans(),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.admin_panel_settings,
                            color: AppConfig.primaryColor7,
                          ),
                          title: Text(
                            'Role',
                            style: GoogleFonts.firaSans(),
                          ),
                          subtitle: Text(
                            storage.userModel.value.user?.role as String,
                            style: GoogleFonts.firaSans(),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.local_activity,
                            color: AppConfig.primaryColor7,
                          ),
                          title: Text(
                            'Status',
                            style: GoogleFonts.firaSans(),
                          ),
                          subtitle: Text(
                            storage.userModel.value.user?.active as bool == true
                                ? "Active"
                                : "Inactive",
                            style: GoogleFonts.firaSans(
                              color: storage.userModel.value.user?.active
                                          as bool ==
                                      true
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    )
                  : FutureBuilder(
                      future: Get.find<ApiController>().getTeams(
                        online: Get.find<CloudController>().alive.value,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<UserTeam> teams =
                              snapshot.data as List<UserTeam>;
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Card(
                                  elevation: 3,
                                  child: ListTile(
                                    onTap: () {
                                      Get.bottomSheet(
                                        TeamBottomSheet(
                                          team: teams[index],
                                        ),
                                        isDismissible: false,
                                      );
                                    },
                                    tileColor: Colors.white,
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: AppConfig.primaryColor7,
                                          width: 2,
                                        ),
                                      ),
                                      child: teams[index].profile == null
                                          ? const Icon(Icons.person)
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: Image.network(
                                                '${AppConfig.SERVER_IP}/${teams[index].profile!.thumbnailUrl}',
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(Icons.person),
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              ),
                                            ),
                                    ),
                                    title: Text(
                                      teams[index].name as String,
                                      style: GoogleFonts.firaSans(),
                                    ),
                                    subtitle: Text(
                                      teams[index].email as String,
                                      style: GoogleFonts.firaSans(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: teams.length,
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return const Center(
                            child: Text('No Team Found'),
                          );
                        }
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}
