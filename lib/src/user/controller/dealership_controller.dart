import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/models/LatLon.dart';
import 'package:marketing/src/user/models/dealership_form/dealership_from.dart';
import 'package:marketing/src/user/models/dealership_status.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/widgets/cool_button.dart';

class Docs {
  String key;
  String? url;
  String reason;
  bool reason_status;
  bool uploaded;
  Docs({
    required this.key,
    required this.url,
    this.reason = "N/A",
    required this.uploaded,
    required this.reason_status,
  });
}

class IronDealer {
  String name;
  String total_sales;
  bool uploaded;
  IronDealer({
    required this.name,
    required this.total_sales,
    this.uploaded = false,
  });
}

class DealerShipController extends GetxController {
  RxInt stepperIndex = 0.obs;
  TextEditingController gstinController = TextEditingController(text: "");
  RxString image = "N/A".obs;
  RxString signature = "N/A".obs;
  RxBool verifingGst = false.obs;
  Rx<DealershipForm> dealerShipFrom = DealershipForm().obs;
  Rx<DealerShip> dealerShip = DealerShip().obs;
  late CloudController cloudController;
  late ApiController apiController;
  RxBool editable = false.obs;
  RxList keys = [].obs;
  RxMap<String, Docs> docs = {
    "N/A": Docs(key: "N/A", url: "N/A", uploaded: true, reason_status: false),
  }.obs;
  RxList ironDealers = [].obs;
  RxList magadhDealers = [].obs;
  RxMap<String, Shops> selectedMagadhDealers = {"N/A": Shops()}.obs;

  RxBool magadhDealersLoading = false.obs;
  DealerShipStatus dealerShipStatus = DealerShipStatus(
    reason: 'N/A',
    staus: 'PENDING',
  );

  pushMagadhDealer({required Shops shops}) async {
    selectedMagadhDealers[shops.sId.toString()] = shops;
    List s = magadhDealers.value;
    magadhDealers.value = [];
    magadhDealers.value = s;
  }

  popMagadhDealer({
    required String sid,
  }) async {
    selectedMagadhDealers.remove(sid);
    List s = magadhDealers.value;
    magadhDealers.value = [];
    magadhDealers.value = s;
  }

  pushDocs({required Docs docs}) {
    this.docs[docs.key] = docs;
  }

  popDocs({required Docs docs}) {
    this.docs.remove(docs.key);
  }

  pushDealer({required IronDealer ironDealer, required Function cb}) {
    if (ironDealer.name.isEmpty || ironDealer.total_sales.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all the fields");
      return;
    } else {
      List dealer = ironDealers.value;
      dealer.add(ironDealer);
      ironDealers.value = [];
      ironDealers.value = dealer;
      ironDealerName.text = "";
      ironDealerTotalSales.text = "";
      cb();
    }
  }

  popDealer({
    required IronDealer ironDealer,
  }) {
    List dealer = ironDealers.value;
    dealer.remove(ironDealer);
    ironDealers.value = [];
    ironDealers.value = dealer;
  }

  TextEditingController counterController = TextEditingController();
  TextEditingController firmController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController talukaController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController proprietorController = TextEditingController();
  TextEditingController gstController = TextEditingController();

  //Cheque Details
  TextEditingController chequeno = TextEditingController();
  TextEditingController chequeDate =
      TextEditingController(text: DateTime.now().toString());
  TextEditingController chequeAmount = TextEditingController();

  //Bank Details
  TextEditingController bankName = TextEditingController();
  TextEditingController bankBranch = TextEditingController();
  TextEditingController bankAccount = TextEditingController();
  TextEditingController bankIfsc = TextEditingController();
  TextEditingController bankMicr = TextEditingController();
  TextEditingController ccLimits = TextEditingController();

  //Contact details
  TextEditingController dealerPhone = TextEditingController();
  TextEditingController dealerEmail = TextEditingController();
  TextEditingController dealerLandline = TextEditingController();

  //Basic Details
  TextEditingController counterPotential = TextEditingController();
  TextEditingController tagetQuantity = TextEditingController();
  TextEditingController spaceAvailable = TextEditingController();
  TextEditingController partnerDetails = TextEditingController(text: "N/A");

  // Commercial Details
  TextEditingController tradeLicenseDetails = TextEditingController();
  TextEditingController dateofissue =
      TextEditingController(text: DateTime.now().toString());
  TextEditingController validUpTo =
      TextEditingController(text: DateTime.now().toString());

  //Iron Dealer Controlller
  TextEditingController ironDealerName = TextEditingController();
  TextEditingController ironDealerTotalSales = TextEditingController();

  RxBool checkStatus = false.obs;
  RxString statusMessage = 'N/A'.obs;

  @override
  void onInit() {
    super.onInit();
    cloudController = Get.find<CloudController>();
    apiController = Get.find<ApiController>();
    statusMessage.value = 'N/A';
  }

  @override
  void onReady() {
    super.onReady();
    fetchKeys();
  }

  @override
  void onClose() {
    super.onClose();
    counterController.dispose();
    firmController.dispose();
    addressController.dispose();
    talukaController.dispose();
    panController.dispose();
    proprietorController.dispose();
    gstController.dispose();
    chequeno.dispose();
    chequeDate.dispose();
    chequeAmount.dispose();
    bankName.dispose();
    bankBranch.dispose();
    bankAccount.dispose();
    bankIfsc.dispose();
    bankMicr.dispose();
    ccLimits.dispose();
    dealerPhone.dispose();
    dealerEmail.dispose();
    dealerLandline.dispose();
    counterPotential.dispose();
    tagetQuantity.dispose();
    spaceAvailable.dispose();
    partnerDetails.dispose();
    tradeLicenseDetails.dispose();
    dateofissue.dispose();
    validUpTo.dispose();
    ironDealerName.dispose();
    ironDealerTotalSales.dispose();
    cloudController.dispose();
    apiController.dispose();
  }

  bool updated = false;

  fetchKeys() async {
    try {
      keys.value = await apiController.getDocumentKeys();
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
        ),
      );
    }
  }

  getDealershipStatus() async {
    checkStatus.value = true;
    statusMessage.value = await apiController.getGstStatus(
      gstin: gstinController.text,
    );
    checkStatus.value = false;
  }

  getMagadhShops() async {
    try {
      magadhDealersLoading.value = true;
      List<Shops> magadhDealers =
          await apiController.getShopsByKm(distance: 2000, online: true);
      this.magadhDealers.value = [];
      this.magadhDealers.value = magadhDealers;
      magadhDealersLoading.value = false;
    } on HttpException catch (e) {
      magadhDealersLoading.value = false;
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
        ),
      );
    } catch (e) {
      magadhDealersLoading.value = false;
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
        ),
      );
    }
  }

  increaseStepperIndex() async {
    if (stepperIndex.value == 6) {
      // Call APi to save data
    }
    if (stepperIndex.value == 7) {
      verifingGst.value = true;
      for (var element in docs.values) {
        if (element.uploaded == false && dealerShip.value.sId != null) {
          updated = true;
          dealerShipFrom.value = await apiController.uploadDocuments(
            docs: {element.key: element},
            userId: dealerShip.value.sId.toString(),
          );
        }
      }
      if (updated) dealerShip.value = dealerShipFrom.value.dealer!;
      if (updated) {
        docs.clear();
        for (var element in dealerShip.value.documents!) {
          docs[element.title.toString()] = Docs(
            key: element.title.toString(),
            url: element.attachment.toString(),
            reason: element.reason.toString(),
            uploaded: true,
            reason_status: element.reason == null ? true : false,
          );
        }
      }
      verifingGst.value = false;
      stepperIndex.value = stepperIndex.value + 1;
    } else if (stepperIndex.value == 8) {
      verifingGst.value = true;
      bool status = await updateIronDealers(
        ironDealers: ironDealers.value,
      );

      verifingGst.value = false;
      if (status) {
        Fluttertoast.showToast(msg: "Iron Dealers Updated");
        stepperIndex.value = stepperIndex.value + 1;
      }
    } else if (stepperIndex.value == 9) {
      verifingGst.value = true;
      bool status = await updateMagadhDealers();
      verifingGst.value = false;
      if (status) {
        Fluttertoast.showToast(msg: "Magadh Dealers Updated");
        stepperIndex.value = stepperIndex.value + 1;
      }
    } else if (stepperIndex.value == 10) {
      if (image.value != "N/A" && signature.value != "N/A") {
        if (image.value.contains('http') && signature.value.contains('http')) {
          stepperIndex.value = stepperIndex.value + 1;
        } else {
          bool value = await uploadImage();
          if (value) {
            Fluttertoast.showToast(msg: "Image Uploaded");
            stepperIndex.value = stepperIndex.value + 1;
          } else {
            Fluttertoast.showToast(msg: "Image Not Uploaded");
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Please Upload Image and Signature");
      }
    } else {
      stepperIndex.value = stepperIndex.value + 1;
    }
  }

  Future<bool> uploadImage() async {
    try {
      if (image.value != "N/A") {
        DealerShip d = await apiController.uploadSignAndImage(
          sign: signature.value,
          image: image.value,
          id: dealerShip.value.sId.toString(),
        );

        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> updateMagadhDealers() async {
    try {
      List<Map> magadhDealers = [];
      String location = apiController.storageController.latLong;

      for (var element in selectedMagadhDealers.values) {
        magadhDealers.add({
          "name": element.name,
          "location": element.mapAddress,
          "distance": location != "N/A"
              ? element.location == null
                  ? 0
                  : element.location!.coordinates == null
                      ? 0
                      : apiController.storageController
                          .getDistance(
                            endPoint: LatLong(
                              longitude:
                                  element.location?.coordinates![0] as double,
                              latitude:
                                  element.location?.coordinates![1] as double,
                            ),
                            startPoint: LatLong(
                              longitude: double.parse(location.split(",")[1]),
                              latitude: double.parse(location.split(",")[0]),
                            ),
                          )
                          .toInt()
              : 0,
          "remark": "N/A",
        });
      }

      await apiController.updateDealer(id: dealerShip.value.sId!, body: {
        "magadh_dealers": magadhDealers,
      });

      return true;
    } on HttpException catch (e) {
      Fluttertoast.showToast(msg: e.message);
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  Future<bool> updateIronDealers({
    required List ironDealers,
  }) async {
    List<Map> dealers = [];
    for (var element in ironDealers) {
      dealers.add({
        "name": element.name,
        "total_sale": element.total_sales,
      });
    }

    try {
      if (dealers.isNotEmpty) {
        DealerShip dealershipForm = await apiController
            .updateDealer(id: dealerShip.value.sId.toString(), body: {
          "iron_dealers": dealers,
        });
        dealerShip.value = dealershipForm;

        dealerShipFrom.value.dealer = dealershipForm;
        ironDealers.clear();
        for (IronDealers element in dealerShip.value.ironDealers!) {
          ironDealers.add(
            IronDealer(
              name: element.name.toString(),
              total_sales: element.totalSale.toString(),
              uploaded: true,
            ),
          );
        }
      }
      return true;
    } on HttpException catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text(e.message),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Ok"),
            ),
            ElevatedButton(
              onPressed: () {
                updateIronDealers(ironDealers: ironDealers);
              },
              child: const Text("Retry"),
            )
          ],
        ),
      );
      return false;
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Ok"),
            ),
            ElevatedButton(
              onPressed: () {
                updateIronDealers(ironDealers: ironDealers);
              },
              child: const Text("Retry"),
            )
          ],
        ),
      );
      return false;
    }
  }

  decreaseStepprtIndex() {
    stepperIndex.value = stepperIndex.value - 1;
  }

  fetchDetailsByGSTNumber() async {
    if (gstinController.text.length != 15) {
      Get.snackbar(
        "Error",
        "Please enter valid GST Number",
        snackStyle: SnackStyle.GROUNDED,
        backgroundColor: AppConfig.primaryColor7,
        colorText: Colors.white,
      );
    } else {
      if (cloudController.alive.isTrue) {
        try {
          selectedMagadhDealers.clear();
          verifingGst.value = true;
          DealershipForm gsTdetails =
              await apiController.verifyandgetgstdetails(
            gstin: gstinController.text,
          );
          counterController.text = gsTdetails.dealer?.counterName ?? "";
          dealerShip.value.counterName = gsTdetails.dealer?.counterName ?? "";
          firmController.text = gsTdetails.dealer?.firmName ?? "";
          dealerShip.value.firmName = gsTdetails.dealer?.firmName ?? "";
          addressController.text = gsTdetails.dealer?.address ?? "";
          dealerShip.value.address = gsTdetails.dealer?.address ?? "";
          talukaController.text = gsTdetails.dealer?.taluka ?? "";
          dealerShip.value.taluka = gsTdetails.dealer?.taluka ?? "";
          panController.text = gsTdetails.dealer?.panNumber ?? "";
          dealerShip.value.panNumber = gsTdetails.dealer?.panNumber ?? "";
          proprietorController.text = gsTdetails.dealer?.firmName ?? "";
          gstController.text = gsTdetails.dealer?.gstNumber ?? "";
          dealerShip.value.gstNumber = gsTdetails.dealer?.gstNumber ?? "";
          dealerShipFrom.value.status = gsTdetails.status;
          dealerShip.value.pincode = gsTdetails.dealer?.pincode ?? "";
          tradeLicenseDetails.text = gsTdetails.dealer?.gstNumber ?? "";
          dateofissue.text = DateTime.fromMillisecondsSinceEpoch(
                  gsTdetails.dealer?.dateOfTradeLicense ??
                      DateTime.now().millisecondsSinceEpoch)
              .toString();

          if (gsTdetails.status == true) {
            partnerDetails.text = gsTdetails.dealer?.partnerName ?? "";
            proprietorController.text = gsTdetails.dealer?.firmName ?? "";
            dealerShip.value.sId = gsTdetails.dealer?.sId ?? "";
            counterPotential.text =
                gsTdetails.dealer?.counterPotential.toString() ?? "";
            dealerShip.value.counterPotential =
                gsTdetails.dealer?.counterPotential;
            tagetQuantity.text =
                gsTdetails.dealer?.targetQuantity.toString() ?? "";
            dealerShip.value.targetQuantity = gsTdetails.dealer?.targetQuantity;
            spaceAvailable.text =
                gsTdetails.dealer?.spaceAvailable.toString() ?? "";
            dealerShip.value.spaceAvailable = gsTdetails.dealer?.spaceAvailable;
            dealerPhone.text = gsTdetails.dealer?.phone ?? "";
            dealerEmail.text = gsTdetails.dealer?.email ?? "";
            dealerLandline.text = gsTdetails.dealer?.landline ?? "";
            dealerShip.value.tradeLicense = gsTdetails.dealer?.gstNumber ?? "";
            chequeno.text = gsTdetails.dealer?.chequeNumber ?? "";
            dealerShip.value.chequeNumber =
                gsTdetails.dealer?.chequeNumber ?? "";
            chequeDate.text = DateTime.fromMillisecondsSinceEpoch(int.parse(
                    gsTdetails.dealer?.chequeDate.toString() ??
                        DateTime.now().millisecondsSinceEpoch.toString()))
                .toString();
            dealerShip.value.chequeDate = gsTdetails.dealer?.chequeDate ??
                DateTime.now().millisecondsSinceEpoch;
            chequeAmount.text = gsTdetails.dealer?.sdAmount.toString() ?? "";
            dealerShip.value.sdAmount = gsTdetails.dealer?.sdAmount ?? 0;
            bankName.text = gsTdetails.dealer?.bankName ?? "";
            dealerShip.value.bankName = gsTdetails.dealer?.bankName ?? "";
            bankBranch.text = gsTdetails.dealer?.branchName ?? "";
            dealerShip.value.branchName = gsTdetails.dealer?.branchName ?? "";
            bankAccount.text = gsTdetails.dealer?.accountNumber ?? "";
            dealerShip.value.accountNumber =
                gsTdetails.dealer?.accountNumber ?? "";
            bankIfsc.text = gsTdetails.dealer?.ifscCode ?? "";
            dealerShip.value.ifscCode = gsTdetails.dealer?.ifscCode ?? "";
            bankMicr.text = gsTdetails.dealer?.micrCode ?? "";
            dealerShip.value.micrCode = gsTdetails.dealer?.micrCode ?? "";
            ccLimits.text = gsTdetails.dealer?.ccLimits.toString() ?? "";
            dealerShip.value.ccLimits = gsTdetails.dealer?.ccLimits ?? 0;
            tradeLicenseDetails.text = gsTdetails.dealer?.tradeLicense ?? "";

            dateofissue.text = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(gsTdetails.dealer!.dateOfTradeLicense.toString()))
                .toString();
            validUpTo.text = DateTime.fromMillisecondsSinceEpoch(int.parse(
                    gsTdetails.dealer?.validityOfTradeLicense.toString() ??
                        DateTime.now().millisecondsSinceEpoch.toString()))
                .toString();
            if (gsTdetails.dealer!.image != null) {
              dealerShip.value.image = gsTdetails.dealer!.image;
              image.value = gsTdetails.dealer!.image as String;
              if (gsTdetails.dealer!.sign != null) {
                dealerShip.value.sign = gsTdetails.dealer!.sign;
                signature.value = gsTdetails.dealer!.sign as String;
              }
            }
            if (gsTdetails.dealer!.documents != null &&
                gsTdetails.dealer!.documents!.isNotEmpty) {
              docs.clear();
              for (var element in gsTdetails.dealer!.documents!) {
                docs[element.title.toString()] = Docs(
                  key: element.title.toString(),
                  url: element.attachment.toString(),
                  reason: element.reason.toString(),
                  uploaded: true,
                  reason_status: element.reason == null ? true : false,
                );
              }

              dealerShip.value.documents = gsTdetails.dealer!.documents;
              stepperIndex.value = 7;
            } else {
              stepperIndex.value = 6;
            }

            if (gsTdetails.dealer!.ironDealers != null &&
                gsTdetails.dealer!.ironDealers!.isNotEmpty) {
              List dealer = gsTdetails.dealer!.ironDealers!;
              ironDealers.clear();

              for (IronDealers element in dealer) {
                ironDealers.add(
                  IronDealer(
                    name: element.name.toString(),
                    total_sales: element.totalSale.toString(),
                    uploaded: true,
                  ),
                );
              }
            }

            if (gsTdetails.dealer!.magadhDealers != null &&
                gsTdetails.dealer!.magadhDealers!.isNotEmpty) {
              List dealer = gsTdetails.dealer!.magadhDealers!;
              selectedMagadhDealers.clear();

              for (MagadhDealers element in dealer) {
                selectedMagadhDealers[element.sId.toString()] = Shops(
                  sId: element.sId.toString(),
                  name: element.name.toString(),
                  uploaded: true,
                  mapAddress: element.location.toString(),
                );
              }
            }

            verifingGst.value = false;
            editable.value = false;
          } else {
            Fluttertoast.showToast(
              msg:
                  'This gst no is not registered with us please verify and perform registration',
            );
            verifingGst.value = false;
            editable.value = true;
            increaseStepperIndex();
          }
        } catch (e) {
          verifingGst.value = false;
          Get.snackbar(
            "Error",
            e.toString(),
            snackStyle: SnackStyle.GROUNDED,
            backgroundColor: AppConfig.primaryColor7,
            colorText: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(msg: 'Please check your internet connection');
      }
    }
  }

  setBasicDetailsInGST() {
    if (counterPotential.text.isEmpty ||
        tagetQuantity.text.isEmpty ||
        spaceAvailable.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all the fields');
    } else {
      if (partnerDetails.text.isEmpty) {
        dealerShip.value.partnerName = "N/A";
      } else {
        dealerShip.value.partnerName = partnerDetails.text;
      }
      dealerShip.value.counterPotential = int.parse(counterPotential.text);
      dealerShip.value.targetQuantity = int.parse(tagetQuantity.text);
      dealerShip.value.spaceAvailable = int.parse(spaceAvailable.text);
      increaseStepperIndex();
    }
  }

  setChequeDetailsInGST() {
    if (chequeno.text.isEmpty ||
        chequeDate.text.isEmpty ||
        chequeAmount.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all the fields');
    } else {
      dealerShip.value.chequeNumber = chequeno.text;
      dealerShip.value.chequeDate =
          DateTime.parse(chequeDate.text).millisecondsSinceEpoch;
      dealerShip.value.sdAmount = int.parse(chequeAmount.text);
      increaseStepperIndex();
    }
  }

  Future<int> pickADate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context as BuildContext,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      return picked.millisecondsSinceEpoch;
    } else {
      return 0;
    }
  }

  setBankDetailsInGST() {
    if (bankName.text.isEmpty ||
        bankBranch.text.isEmpty ||
        bankAccount.text.isEmpty ||
        bankIfsc.text.isEmpty ||
        bankMicr.text.isEmpty ||
        ccLimits.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all the fields');
    } else {
      dealerShip.value.bankName = bankName.text;
      dealerShip.value.branchName = bankBranch.text;
      dealerShip.value.accountNumber = bankAccount.text;
      dealerShip.value.ifscCode = bankIfsc.text;
      dealerShip.value.micrCode = bankMicr.text;
      dealerShip.value.ccLimits = int.parse(ccLimits.text);
      increaseStepperIndex();
    }
  }

  setContactDetailsInGST() async {
    if (dealerPhone.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all the fields');
    } else {
      dealerShip.value.phone = dealerPhone.text;
      dealerShip.value.email = dealerEmail.text;
      dealerShip.value.landline = dealerLandline.text;
      increaseStepperIndex();
    }
  }

  Future<bool> createDealerShip() async {
    try {
      if (cloudController.alive.isFalse) {
        Fluttertoast.showToast(msg: "Please connect to internet");
        return false;
      } else {
        verifingGst.value = true;
        DealerShip dealerShip = await apiController.createDealerShipForm(
          dealerShipForm: this.dealerShip.value,
        );
        this.dealerShip.value = dealerShip;
        dealerShipFrom.value.dealer = dealerShip;
        dealerShipFrom.value.status = true;
        verifingGst.value = false;
        return true;
      }
    } on HttpException catch (e) {
      verifingGst.value = false;
      Get.dialog(
        AlertDialog(
          title: Text(
            'Error',
            style: GoogleFonts.firaSans(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text(e.message)],
          ),
        ),
      );
      return false;
    } catch (e) {
      verifingGst.value = false;
      Get.dialog(
        AlertDialog(
          title: Text(
            'Error',
            style: GoogleFonts.firaSans(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text(e.toString())],
          ),
        ),
      );
      return false;
    }
  }

  setCommercialDetails() async {
    if (tradeLicenseDetails.text.isEmpty ||
        validUpTo.text.isEmpty ||
        dateofissue.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all the fields');
    } else {
      dealerShip.value.tradeLicense = tradeLicenseDetails.text;
      dealerShip.value.validityOfTradeLicense =
          DateTime.parse(validUpTo.text).millisecondsSinceEpoch;
      dealerShip.value.dateOfTradeLicense =
          DateTime.parse(dateofissue.text).millisecondsSinceEpoch;
      if (dealerShipFrom.value.status == true) {
        increaseStepperIndex();
      } else {
        bool value = await createDealerShip();
        if (value) {
          increaseStepperIndex();
        } else {
          Fluttertoast.showToast(msg: 'Something went wrong');
        }
      }
    }
  }

  resetImage({
    required bool isImage,
  }) {
    if (isImage) {
      image.value = "N/A";
    } else {
      signature.value = "N/A";
    }
  }

  getImages({required bool image}) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Select Source',
                  style: GoogleFonts.firaSans(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 20),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CoolButton(
                    backgroundColor: Colors.indigo.shade400,
                    iconColor: Colors.white,
                    textColor: Colors.black,
                    icon: Icons.camera,
                    onTap: () {
                      pickImage(
                        imageSource: ImageSource.camera,
                        isImage: image,
                      );
                      Get.back();
                    },
                    text: "Camera",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CoolButton(
                    backgroundColor: Colors.indigo.shade400,
                    iconColor: Colors.white,
                    textColor: Colors.black,
                    icon: Icons.photo_album,
                    onTap: () {
                      pickImage(
                        imageSource: ImageSource.gallery,
                        isImage: image,
                      );
                      Get.back();
                    },
                    text: "Gallery",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  pickImage({
    required ImageSource imageSource,
    required bool isImage,
  }) {
    ImagePicker()
        .pickImage(
      source: imageSource,
    )
        .then((value) {
      if (value != null) {
        if (isImage) {
          image.value = value.path;
        } else {
          signature.value = value.path;
        }
      }
    });
  }

  pickImageFile({
    required ImageSource imageSource,
  }) async {
    ImagePicker? image = ImagePicker();
    XFile? file = await image.pickImage(
      source: imageSource,
      maxWidth: 1080,
    );

    if (file != null) {
      return file.path;
    } else {
      return null;
    }
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      return file.path;
    } else {
      return null;
    }
  }
}
