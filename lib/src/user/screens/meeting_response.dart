import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/my_meeting_controller.dart';
import 'package:marketing/src/user/models/meetings/meeting_response.dart';
import 'package:marketing/src/user/models/mymeeting_model.dart';

class MeetingResponse extends StatefulWidget {
  const MeetingResponse({super.key});

  @override
  State<MeetingResponse> createState() => _MeetingResponseState();
}

class _MeetingResponseState extends State<MeetingResponse> {
  List<MeetingResponseModel> data = [];
  late MyMeetingController _meetingController;
  bool create = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  addUser() {
    setState(() {
      data.add(MeetingResponseModel(
        name: nameController.text,
        number: numberController.text,
        from: addressController.text,
      ));
      nameController.clear();
      numberController.clear();
      addressController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _meetingController = Get.find<MyMeetingController>();
  }

  updateMeeting({
    required MyMeetingModel meeting,
  }) async {
    try {
      await _meetingController.completeMeeting(
          meeting: meeting, meetingResponse: data);
      await _meetingController.fetchMeetings();
      Fluttertoast.showToast(msg: 'Meeting Updated');
      Get.back();
    } on HttpException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    MyMeetingModel meetingModel = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          'Meeting Response Form',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                create = true;
                setState(() {});
              },
              icon: Icon(
                Icons.add,
                color: AppConfig.primaryColor5,
              ))
        ],
      ),
      body: meetingModel == null
          ? Container(
              alignment: Alignment.center,
              child: Text(
                'Select a meeting to view response',
                style: GoogleFonts.firaSans(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                !create
                    ? Container()
                    : Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Enter User Details',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      create = false;
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: AppConfig.primaryColor5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextFormField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Name',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: AppConfig.primaryColor5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextFormField(
                                    controller: numberController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Number',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: AppConfig.primaryColor5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextFormField(
                                    controller: addressController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Address',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: addUser,
                                  icon: const Icon(Icons.check),
                                  label: const Text("Add User"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset("assets/createShop.png"),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                meetingModel.shop!.name.toString(),
                                style: GoogleFonts.poppins(
                                  color: AppConfig.primaryColor5,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  meetingModel.shop!.phone.toString(),
                                  style: GoogleFonts.poppins(
                                    color: AppConfig.primaryColor5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.group,
                                  color: Colors.grey.shade600,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '(${meetingModel.strength})',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.image,
                                  color: Colors.grey.shade600,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '(${meetingModel.gallery!.length})',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.person_add,
                                  color: Colors.grey.shade600,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '(${data.length})',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: data.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              'No Users Added Yet',
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 20),
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: AppConfig.primaryColor5,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              data[index].name,
                                              style: GoogleFonts.poppins(
                                                color: AppConfig.primaryColor5,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                data[index].number,
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      AppConfig.primaryColor5,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.location_city,
                                                color: Colors.grey.shade600,
                                                size: 15,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                data[index].from.length > 20
                                                    ? '${data[index].from.substring(0, 20)}...'
                                                    : data[index].from,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: data.length,
                          ),
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_meetingController.updatingMeeting.isFalse) {
            updateMeeting(meeting: meetingModel);
          } else {
            Get.snackbar('Please Wait', 'Updating Meeting');
          }
        },
        child: Obx(
          () {
            return _meetingController.updatingMeeting.isTrue
                ? const CircularProgressIndicator()
                : const Icon(
                    Icons.check,
                  );
          },
        ),
      ),
    );
  }
}
