import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/screens/validation/views/ValidationView.dart';
import 'package:marketing/src/user/widgets/profile_details.dart';
import 'package:marketing/src/user/widgets/update_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<StorageController>(builder: (storage) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 3,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Profile',
            style: GoogleFonts.firaSans(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
          ),
          actions: [
            storage.isLoggingOut.isTrue
                ? const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: CircularProgressIndicator(),
                  )
                : IconButton(
                    onPressed: () async {
                      await Get.find<ApiController>().logout();
                      Get.offAllNamed(
                        ValidationViews.routeName,
                      );
                    },
                    icon: Icon(
                      Icons.logout,
                      color: AppConfig.primaryColor7,
                    ),
                  )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          color: Colors.white,
                        ),
                        height: 200,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Options',
                                    style: GoogleFonts.firaSans(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(Icons.clear),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Profile Picture',
                                                style: GoogleFonts.firaSans(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            content: SizedBox(
                                              height: 200,
                                              width: 200,
                                              child: Image.network(
                                                '${AppConfig.SERVER_IP}/${storage.userModel.value.user!.images!.url}',
                                                // fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Center(
                                                    child: Text('No Image'),
                                                  );
                                                },
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            actions: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    AppConfig.primaryColor7,
                                                  ),
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          3),
                                                ),
                                                child: Text(
                                                  "Close",
                                                  style: GoogleFonts.firaSans(
                                                    fontSize: 17,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    leading: Icon(
                                      Icons.image,
                                      color: AppConfig.primaryColor7,
                                    ),
                                    title: Text(
                                      'View Profile Picture',
                                      style: GoogleFonts.firaSans(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const UpdateProfile();
                                        },
                                        barrierDismissible: false,
                                      );
                                    },
                                    leading: Icon(
                                      Icons.camera_alt,
                                      color: AppConfig.primaryColor7,
                                    ),
                                    title: Text(
                                      'Update Profile Picture',
                                      style: GoogleFonts.firaSans(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      exitBottomSheetDuration:
                          const Duration(milliseconds: 400),
                      enterBottomSheetDuration:
                          const Duration(milliseconds: 400),
                      isDismissible: false,
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppConfig.primaryColor7,
                        width: 2,
                      ),
                    ),
                    child: storage.userModel.value.user!.images!.thumbnailUrl !=
                            "N/A"
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              '${AppConfig.SERVER_IP}/${storage.userModel.value.user!.images!.thumbnailUrl}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person);
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 60,
                            color: AppConfig.primaryColor7,
                          ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  storage.userModel.value.user?.name!.toUpperCase() as String,
                  style: GoogleFonts.firaSans(
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ProfileDetails(storage: storage),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
