import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/screens/odometer/controller/admin_odometer.controller.dart';

class OdometerHeader extends StatelessWidget {
  OdometerHeader({
    super.key,
    required this.controller,
  });
  AOdometerController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: controller.cupertinoDate,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            controller.createdAt.value,
                            style: GoogleFonts.firaSans(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Checkbox(
                        activeColor: Colors.white,
                        fillColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        checkColor: AppConfig.primaryColor5,
                        value: controller.showPending.value,
                        onChanged: (value) {
                          controller.changePending();
                        },
                      ),
                      IconButton(
                        onPressed: controller.changeLocation,
                        icon: controller.locationNotFound.isTrue
                            ? const Icon(
                                Icons.location_off,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                      )
                    ],
                  );
                }),
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
                    style: GoogleFonts.firaSans(color: AppConfig.primaryColor5),
                  ),
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(5),
                  dropdownColor: Colors.white,
                  underline: Container(),
                  value: controller.selectedGroupVlaue.value,
                  items: controller.dropDownItems
                      .map(
                        (element) => DropdownMenuItem(
                          value: element.value,
                          child: Text(element.text),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedGroupVlaue.value = value.toString();
                    controller.pagingController.refresh();
                  },
                ),
              );
            }),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) {
                controller.changeName(value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Seach Odometer....',
                prefixIcon: Icon(
                  Icons.search,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
