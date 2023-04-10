import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/models/visit_model.dart';
import 'package:marketing/src/user/widgets/error_widget.dart';
import 'package:marketing/src/user/widgets/visitItem.dart';
import 'package:marketing/src/user/widgets/visitPost.dart';

class TodayVisits extends StatefulWidget {
  const TodayVisits({super.key});

  @override
  State<TodayVisits> createState() => _TodayVisitsState();
}

class _TodayVisitsState extends State<TodayVisits> {
  List<VisitModel> visits = [];
  bool isLoading = false;
  final VisitController _visitController = Get.find<VisitController>();
  bool isError = false;
  String errorMessage = '';
  bool postView = false;

  @override
  void initState() {
    super.initState();
    getVisits();
  }

  setPostView() {
    setState(() {
      postView = !postView;
    });
  }

  getVisits() async {
    try {
      setState(() {
        isLoading = true;
      });
      DateTime now = DateTime.now();
      String today =
          DateTime(now.year, now.month, now.day).toString().split(' ')[0];
      String tomorrow =
          DateTime(now.year, now.month, now.day + 1).toString().split(' ')[0];
      List<VisitModel> visit = await _visitController.api.getVisits(
        online: Get.find<CloudController>().alive.value,
        startDate: today,
        endDate: tomorrow,
      );
      setState(() {
        visits = visit;
        isError = false;
        isLoading = false;
      });
    } on HttpException catch (e) {
      setState(() {
        isError = true;
        errorMessage = e.message;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
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
          'Today Visits',
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setPostView();
            },
            icon: Icon(
              postView ? Icons.post_add_outlined : Icons.list_alt_outlined,
              color: AppConfig.primaryColor7,
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : isError
              ? CustomErrorWidget(
                  errorMessage: errorMessage,
                  buttonText: "Retry",
                  loggedOut: errorMessage == 'TOKEN_EXPIRE' ? true : false,
                  cb: getVisits,
                )
              : visits.isEmpty
                  ? CustomErrorWidget(
                      errorMessage: errorMessage,
                      buttonText: "Retry",
                      loggedOut: false,
                      cb: getVisits,
                    )
                  : RefreshIndicator(
                      onRefresh: () {
                        return getVisits();
                      },
                      child: ListView.builder(
                        physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: visits.length,
                        itemBuilder: (context, index) {
                          return postView
                              ? VisitPostWidget(
                                  visitController: _visitController,
                                  visit: visits[index],
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 2,
                                  ),
                                  child: VisitItem(
                                    visitController: _visitController,
                                    visit: visits[index],
                                  ),
                                );
                        },
                      ),
                    ),
    );
  }
}
