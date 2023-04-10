import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/models/visit_model.dart';

class CreateReminderScreen extends StatelessWidget {
  const CreateReminderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VisitModel visitModel =
        ModalRoute.of(context)!.settings.arguments as VisitModel;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            var cureentFocus = FocusScope.of(context);
            if (!cureentFocus.hasPrimaryFocus) {
              cureentFocus.unfocus();
            }
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        titleSpacing: 2,
        title: Text(
          'Create Reminder',
          style: GoogleFonts.firaSans(
            color: Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      body: GetX<ReminderController>(
        builder: (reminder) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 160,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: reminder.remarkController,
                        enabled: !reminder.createReminderLoading.value,
                        expands: true,
                        maxLines: null,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Remark for this Reminder',
                          hintStyle: GoogleFonts.firaSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.blue.withOpacity(0.7),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: -10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppConfig.primaryColor7,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.factory,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          visitModel.type as String,
                          style: GoogleFonts.firaSans(
                            color: Colors.blue.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: -10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppConfig.primaryColor7,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.location_city_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        visitModel.type == "SHOP_VISIT"
                            ? visitModel.shop!.name as String
                            : visitModel.name as String,
                        style: GoogleFonts.firaSans(
                          color: Colors.blue.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: -10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppConfig.primaryColor7,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.timer,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: reminder.createReminderDate.value != 'N/A'
                            ? Text(
                                reminder.createReminderDate.value,
                                style: GoogleFonts.firaSans(
                                  color: Colors.blue.withOpacity(0.7),
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  reminder.getStartDate(context: context);
                                },
                                child: Text(
                                  'Tap Here to select reminder date',
                                  style: GoogleFonts.firaSans(
                                    color: Colors.blue.withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                      ),
                      reminder.createReminderDate.value != 'N/A'
                          ? reminder.createReminderLoading.isTrue
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    reminder.clearReminderCreateDate();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppConfig.primaryColor7,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                          : Container()
                    ],
                  ),
                ),
              ),
              reminder.createReminderLoading.isTrue
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 50),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            AppConfig.primaryColor7,
                          ),
                        ),
                        onPressed: () {
                          var cureentFocus = FocusScope.of(context);
                          if (!cureentFocus.hasPrimaryFocus) {
                            cureentFocus.unfocus();
                          }
                          reminder.createReminder(
                            context: context,
                            shop: visitModel.shop != null
                                ? visitModel.shop!.sId
                                : null,
                            visit: visitModel.sId as String,
                          );
                        },
                        child: Text(
                          "Create Reminder",
                          style: GoogleFonts.firaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
