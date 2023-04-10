// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/widgets/connection_status.dart';
import 'package:marketing/src/user/widgets/error_widget.dart';
import 'package:marketing/src/user/widgets/sync_status.dart';
import 'package:marketing/src/user/widgets/visitItem.dart';
import 'package:marketing/src/user/widgets/visitPost.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({
    Key? key,
    required this.visitController,
  }) : super(key: key);
  VisitController visitController;
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    _fetchVisit();
  }

  _fetchVisit() async {
    await widget.visitController.getVisits();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const ConnectionStatus(),
        Container(
          height: 35,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.date_range,
                  size: 20,
                  color: AppConfig.primaryColor7,
                ),
                onPressed: () {},
              ),
              Text(
                'From',
                style: GoogleFonts.firaSans(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Obx(() {
                return Text(
                  widget.visitController.from.value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }),
              const SizedBox(
                width: 10,
              ),
              Text(
                'To',
                style: GoogleFonts.firaSans(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Obx(() {
                return Text(
                  widget.visitController.to.value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }),
              Expanded(child: Container()),
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: SyncStatus(),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            return RefreshIndicator(
              child: widget.visitController.isLoading.isTrue
                  ? Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  : widget.visitController.isLoggedOut.isTrue
                      ? CustomErrorWidget(
                          errorMessage:
                              'You are logged out or your session has expired please login again',
                          buttonText: 'Login',
                          loggedOut: true,
                          cb: () {},
                        )
                      : widget.visitController.isError.isTrue
                          ? CustomErrorWidget(
                              errorMessage: widget.visitController.errorMessage,
                              buttonText: 'Retry',
                              cb: () {
                                _fetchVisit();
                              },
                              loggedOut: false,
                            )
                          : widget.visitController.visits.isEmpty
                              ? CustomErrorWidget(
                                  errorMessage:
                                      'No visits found on date ${widget.visitController.from.value}',
                                  buttonText: 'Retry',
                                  loggedOut: false,
                                  cb: () {
                                    _fetchVisit();
                                  },
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(
                                    parent: BouncingScrollPhysics(),
                                  ),
                                  itemCount:
                                      widget.visitController.visits.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: widget.visitController
                                                  .isPostView.isTrue
                                              ? 0
                                              : 5,
                                          vertical: widget.visitController
                                                  .isPostView.isTrue
                                              ? 0
                                              : 2),
                                      child: widget
                                              .visitController.isPostView.isTrue
                                          ? VisitPostWidget(
                                              visit: widget.visitController
                                                  .visits[index],
                                              visitController:
                                                  widget.visitController,
                                            )
                                          : VisitItem(
                                              visitController:
                                                  widget.visitController,
                                              visit: widget.visitController
                                                  .visits[index],
                                            ),
                                    );
                                  },
                                ),
              onRefresh: () => Future.sync(
                () => _fetchVisit(),
              ),
            );
          }),
        ),
        Container(
          height: 70,
        )
      ],
    );
  }
}
