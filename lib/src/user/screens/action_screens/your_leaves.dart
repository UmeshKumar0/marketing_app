import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/leave_controller.dart';
import 'package:marketing/src/user/widgets/error_widget.dart';

class YourLeaves extends StatefulWidget {
  YourLeaves({
    super.key,
    required this.leaveController,
  });
  LeaveController leaveController;

  @override
  State<YourLeaves> createState() => _YourLeavesState();
}

class _YourLeavesState extends State<YourLeaves> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLeaves();
  }

  loadLeaves() async {
    await widget.leaveController.loadLeaves();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        loadLeaves();
        return Future.value();
      },
      child: Obx(
        () {
          return widget.leaveController.isLoading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : widget.leaveController.isError.isTrue
                  ? CustomErrorWidget(
                      errorMessage: widget.leaveController.errorMessage,
                      buttonText: "Retry",
                      loggedOut:
                          widget.leaveController.errorMessage == 'TOKEN_EXPIRE'
                              ? true
                              : false,
                      cb: loadLeaves,
                    )
                  : ListView.builder(
                      itemCount: widget.leaveController.leaves.length,
                      itemBuilder: (context, index) {
                        String status =
                            widget.leaveController.leaves[index].status;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Leave Details',
                                      style: GoogleFonts.firaSans(),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'From: ${DateTime.fromMillisecondsSinceEpoch((widget.leaveController.leaves[index].startDate)).toString().split(' ').first}',
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'To: ${DateTime.fromMillisecondsSinceEpoch((widget.leaveController.leaves[index].endDate)).toString().split(' ').first}',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'Leave Type: ${widget.leaveController.leaves[index].leaveType}',
                                            style: GoogleFonts.firaSans(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'Status: ${widget.leaveController.leaves[index].status}',
                                            style: GoogleFonts.firaSans(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'Reason: ${widget.leaveController.leaves[index].reason}',
                                            style: GoogleFonts.firaSans(),
                                          ),
                                        ),
                                        if (widget.leaveController.leaves[index]
                                                .rejectionReason !=
                                            null)
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              'Rejection Reason: ${widget.leaveController.leaves[index].rejectionReason}',
                                              style: GoogleFonts.firaSans(
                                                color: AppConfig.primaryColor7,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        if (widget.leaveController.leaves[index]
                                                .status ==
                                            'APPROVED')
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Your leave is approved',
                                              style: GoogleFonts.firaSans(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            tileColor: Colors.white,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget
                                    .leaveController.leaves[index].leaveType),
                                Text(
                                  status,
                                  style: GoogleFonts.firaSans(
                                    color: status == 'APPROVED'
                                        ? Colors.green
                                        : status == 'REJECTED'
                                            ? Colors.red
                                            : Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'From: ${DateTime.fromMillisecondsSinceEpoch((widget.leaveController.leaves[index].startDate)).toString().split(' ').first}',
                                ),
                                Text(
                                  'To: ${DateTime.fromMillisecondsSinceEpoch((widget.leaveController.leaves[index].endDate)).toString().split(' ').first}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
    );
  }
}
