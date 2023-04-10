import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:path_provider/path_provider.dart';

class HelpScreenController extends GetxController {
  String ADD_IMAGE_WIDGET = 'ADD_IMAGE_WIDGET';
  RxList<String> images = <String>[].obs;
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final recordingPlayer = AssetsAudioPlayer();
  RxBool isRecording = false.obs;
  RxString dpath = ''.obs;
  RxString recordingPath = 'N/A'.obs;
  RxString timer = '00:10:37'.obs;
  RxString endTimer = '00:00:00'.obs;
  late StreamSubscription stream;
  RxBool playingMusic = false.obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late ApiController _apiController;

  RxBool creating = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print('Initiliazed Help Center controller ');
    _apiController = Get.find<ApiController>();
    recordingPath.value = "N/A";
    images.value = [];
    images.add(ADD_IMAGE_WIDGET);
    validatePathAndOpenRecorder();
  }

  @override
  void onClose() {
    print('Closing recorder');
    closeRecorder();
    descriptionController.dispose();
    titleController.dispose();
    super.onClose();
  }

  startRecording() async {
    stream = recorder.onProgress!.listen((event) {
      print('Recording ${event.duration}');
      timer.value = event.duration.toString();
    });
    recorder.setSubscriptionDuration(const Duration(milliseconds: 1000));
    print(dpath.value);
    await recorder.startRecorder(
      toFile: '${dpath.value}/recording',
      codec: Codec.defaultCodec,
    );

    isRecording.value = true;
  }

  stopRecording() async {
    await recorder.stopRecorder();
    stream.cancel();
    isRecording.value = !isRecording.value;
    print('Stopped recording');
    File f = File('${dpath.value}/recording');
    f.renameSync('${dpath.value}/recording.mp3');
    recordingPath.value = '${dpath.value}/recording.mp3';
  }

  validatePathAndOpenRecorder() async {
    Directory? directory = await getApplicationDocumentsDirectory();
    print(directory);
    String path = directory.path;
    dpath.value = path;
    await recorder.openRecorder();
  }

  removeEntity() async {
    if (recordingPath.value != 'N/A') {
      File f = File(recordingPath.value);
      f.deleteSync();
      recordingPath.value = 'N/A';
    }
  }

  closeRecorder() async {
    await recorder.closeRecorder();
  }

  playAudio() async {
    timer.value = '00:00:00';
    endTimer.value = '00:00:00';
    recordingPlayer.open(
      Audio.file(recordingPath.value),
      autoStart: true,
      showNotification: true,
      playInBackground: PlayInBackground.disabledRestoreOnForeground,
      notificationSettings: NotificationSettings(
        nextEnabled: false,
        prevEnabled: false,
        stopEnabled: true,
        seekBarEnabled: true,
        customStopAction: (player) {
          player.stop();
        },
        customPlayPauseAction: (player) {
          player.playOrPause();
        },
      ),
    );
    recordingPlayer.current.listen((event) {
      print('Playing ${event!.audio.duration}');
      endTimer.value = event.audio.duration.toString();
    });

    recordingPlayer.currentPosition.listen((event) {
      print('Playing ${event.inSeconds}');
      timer.value = event.toString();
    });
    recordingPlayer.isPlaying.listen((event) {
      playingMusic.value = event;
    });
  }

  stopAudio() {
    recordingPlayer.stop();
    playingMusic.value = false;
  }

  getImages() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (images != null) {
      String data = images.value.removeAt(images.length - 1);
      images.add(image!.path);
      images.add(data);
    }
  }

  submitForm() async {
    try {
      print(images.length);
      if (images.length <= 2) {
        Fluttertoast.showToast(msg: 'Please add atleast two image');
        return;
      }
      creating.value = true;
      await _apiController.postHelpRequest(
        images: images,
        recPath: recordingPath.value == "N/A" ? null : recordingPath.value,
        title: titleController.text,
        description: descriptionController.text,
      );
      images.value = [ADD_IMAGE_WIDGET];
      removeEntity();
      titleController.clear();
      descriptionController.clear();
      Fluttertoast.showToast(msg: 'Request submitted successfully');
      creating.value = false;
    } on HttpException catch (e) {
      showError(e.message);
      creating.value = false;
    } catch (e) {
      showError(e.toString());

      creating.value = false;
    }
  }

  showError(String message) {
    Get.snackbar('Error', message);
  }
}
