import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/leave_controller.dart';
import 'package:marketing/src/user/widgets/customButton.dart';

class LeaveApplyWidget extends StatefulWidget {
  LeaveApplyWidget({
    super.key,
    required this.leaveController,
  });
  LeaveController leaveController;

  @override
  State<LeaveApplyWidget> createState() => _LeaveApplyWidgetState();
}

class _LeaveApplyWidgetState extends State<LeaveApplyWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLeaveTypes();
  }

  loadLeaveTypes() async {
    await widget.leaveController.getLeaveTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(() {
            return InkWell(
              onTap: () {
                if (widget.leaveController.createingLeave.isTrue) {
                  Fluttertoast.showToast(
                      msg: 'Please wait while we are creating leave');
                } else {
                  widget.leaveController.pickDate(
                    isFrom: true,
                  );
                }
              },
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.leaveController.from.value != "N/A"
                      ? widget.leaveController.from.value
                      : 'SELECT START DATE',
                  style: GoogleFonts.firaSans(color: AppConfig.primaryColor7),
                ),
              ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            return InkWell(
              onTap: () {
                if (widget.leaveController.createingLeave.isTrue) {
                  Fluttertoast.showToast(
                      msg: 'Please wait while we are creating leave');
                } else {
                  widget.leaveController.pickDate(isFrom: false);
                }
              },
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.leaveController.to.value != "N/A"
                      ? widget.leaveController.to.value
                      : 'SELECT END DATE',
                  style: GoogleFonts.firaSans(color: AppConfig.primaryColor7),
                ),
              ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonFormField(
                onTap: () {
                  if (widget.leaveController.createingLeave.isTrue) {
                    Fluttertoast.showToast(
                        msg: 'Please wait while we are creating leave');
                  }
                },
                elevation: 2,
                value: 'SELECT LEAVE TYPE',
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'SELECT LEAVE TYPE',
                ),
                items: [
                  DropdownMenuItem(
                    value: 'SELECT LEAVE TYPE',
                    child: widget.leaveController.isLoadingLeaveTypes.isTrue
                        ? const Text('LOADING....')
                        : widget.leaveController.leaveTypes.isEmpty
                            ? const Text('LEAVE TYPE NOT FOUND')
                            : const Text('SELECT LEAVE TYPE'),
                  ),
                  ...widget.leaveController.leaveTypes.value
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString().toUpperCase()),
                        ),
                      )
                      .toList(),
                ],
                onChanged: (value) {
                  widget.leaveController.setLeaveValue(value: value.toString());
                },
              ),
            );
          }),
          if (widget.leaveController.isErrorLoadingLeaveTypes.isTrue)
            Container(),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: TextField(
              enabled: !widget.leaveController.createingLeave.value,
              controller: widget.leaveController.reasonController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Reason of Leave',
              ),
            ),
          ),
          Obx(() {
            return widget.leaveController.createingLeave.isTrue
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : CustomButton(
                    onTap: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      widget.leaveController.createLeave();
                    },
                    text: "Apply Leave",
                    color: AppConfig.primaryColor7,
                  );
          })
        ],
      ),
    );
  }
}
