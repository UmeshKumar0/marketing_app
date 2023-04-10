import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      elevation: 10,
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: GetX<StorageController>(builder: (storage) {
          return Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppConfig.PROFILE);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            border: Border.all(
                              color: AppConfig.primaryColor7,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              '${AppConfig.SERVER_IP}/${storage.userModel.value.user!.images!.thumbnailUrl}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: AppConfig.primaryColor7,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          if (storage.odoMeter.value == AppConfig.PRESENT) {
                            Get.toNamed(AppConfig.CREATE_ODOMETER_SCREEN);
                          } else {
                            Get.toNamed(AppConfig.PROFILE);
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${storage.userModel.value.user!.name}',
                                      style: GoogleFonts.poppins(
                                        color: AppConfig.primaryColor7,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    storage.odoMeter.value == AppConfig.PRESENT
                                        ? Colors.green
                                        : storage.odoMeter.value ==
                                                AppConfig.COMPLETE
                                            ? AppConfig.primaryColor7
                                            : Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text: storage.odoMeter.value ==
                                          AppConfig.PRESENT
                                      ? ""
                                      : "",
                                  style: GoogleFonts.firaSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: storage.odoMeter.value ==
                                              AppConfig.COMPLETE
                                          ? 'ODOMETER DONE'
                                          : storage.odoMeter.value ==
                                                  AppConfig.PRESENT
                                              ? "ODOMETER OUT"
                                              : storage.odoMeter.value ==
                                                      AppConfig.ABSENT
                                                  ? "ABSENT"
                                                  : storage.odoMeter.value ==
                                                          AppConfig.HALFDAY
                                                      ? "HALF DAY"
                                                      : "ODOMETER IN",
                                      style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: Hive.box('odometer').listenable(),
                  builder: (context, value, child) {
                    DateTime date = DateTime.now();
                    String today = "${date.year}-${date.month}-${date.day}";
                    Box box = Hive.box('odometer');
                    String status = box.get(today);
                    return status == AppConfig.PRESENT
                        ? Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(
                                  AppConfig.ACTIONS_SCREEN,
                                  arguments: null,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.indigo.shade400,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : status == AppConfig.COMPLETE
                            ? Container()
                            : status == AppConfig.ABSENT
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          AppConfig.CREATE_ODOMETER_SCREEN,
                                        );
                                        // Get.toNamed(AppConfig.DEALERSHIP_FORM);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppConfig.primaryColor7,
                                        ),
                                        child: const Icon(
                                          Icons.fingerprint,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                  },
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
