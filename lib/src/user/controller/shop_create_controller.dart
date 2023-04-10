// ignore_for_file: invalid_use_of_protected_member
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/maps_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/LatLon.dart';
import 'package:marketing/src/user/models/cp_shop.dart';
import 'package:marketing/src/user/models/location_model.dart';
import 'package:marketing/src/user/models/shopCreate.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:workmanager/workmanager.dart';

class ShopCreateController extends GetxController {
  late MapsController _mapsController;
  late CloudController _cloudController;
  late StorageController _storageController;

  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isCreated = false.obs;
  RxBool uploadingImage = false.obs;
  RxInt uploadingImgCount = 1.obs;
  RxBool preview = false.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController newProductController = TextEditingController();
  TextEditingController newBrandController = TextEditingController();
  TextEditingController cpController = TextEditingController();

  Rx<ShopCreate> shopCreateData = ShopCreate().obs;
  RxList imagePath = [].obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      nameController.text = 'Test Shop';
      ownerController.text = 'Test Owner';
      emailController.text = 'flutter@gmail.com';
      phoneController.text = '1234567890';
      addressController.text = 'Test Address';
      pinCodeController.text = '8001111';
      newProductController.text = 'Test Product';
      newBrandController.text = 'Test Brand';
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    ownerController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    pinCodeController.dispose();
    newProductController.dispose();
    newBrandController.dispose();
    cpController.dispose();
  }

  RxList brands = [].obs;
  RxList products = [].obs;
  RxList selectedBrands = [].obs;
  RxList selectedProducts = [].obs;
  RxBool brandLoadin = false.obs;
  RxBool productLoading = false.obs;
  RxBool brandError = false.obs;
  RxBool productError = false.obs;
  String brandErrorMessage = '';
  String productErrorMessage = '';

  final ImagePicker _imagePicker = ImagePicker();

  late Shops responseShop;
  Timer? _timer;
  RxBool cpLoading = false.obs;
  RxBool cpShopFound = false.obs;

  ShopCreateController() {
    _mapsController = Get.find<MapsController>();
    _storageController = Get.find<StorageController>();
    _cloudController = Get.find<CloudController>();
  }

  setShopCreate() async {
    shopCreateData.value = await getShopCreateData();
    preview.value = true;
  }

  Rx<CPShop> cpShop = CPShop().obs;

  fetchShopWithCpCode({required String cpCode}) async {
    try {
      cpLoading.value = true;
      cpShopFound.value = false;
      nameController.text = '';
      ownerController.text = '';
      phoneController.text = '';
      emailController.text = '';
      addressController.text = '';
      pinCodeController.text = '';
      CPShop cpShop =
          await _mapsController.apiController.getShopByCpCode(cpCode: cpCode);
      if (cpShop.cpCode != null) {
        nameController.text = cpShop.displayName.toString();
        ownerController.text = cpShop.ownerName.toString();
        phoneController.text = cpShop.businessContact.toString();
        emailController.text = cpShop.businessEmail.toString();
        addressController.text = cpShop.businessAddress.toString();
        pinCodeController.text = cpShop.businessPincode.toString();
        cpShopFound.value = true;
        this.cpShop.value = cpShop;
      } else {
        cpShopFound.value = false;
      }
      cpLoading.value = false;
    } on HttpException catch (e) {
      cpLoading.value = false;
      cpShopFound.value = false;
    } catch (e) {
      cpLoading.value = false;
      cpShopFound.value = false;
    }
  }

  debouncingFetcher({
    required String cpCode,
  }) async {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = Timer(const Duration(milliseconds: 200), () {
        fetchShopWithCpCode(cpCode: cpCode);
      });
    } else {
      _timer = Timer(const Duration(milliseconds: 200), () {
        fetchShopWithCpCode(cpCode: cpCode);
      });
    }
  }

  increasCurrentIndex() async {
    if (currentIndex.value == 0) {
      if (nameController.text.isEmpty || ownerController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter shop name',
        );
        return;
      } else {
        currentIndex.value = currentIndex.value + 1;
      }
    } else if (currentIndex.value == 1) {
      if (phoneController.text.isEmpty || phoneController.text.length != 10) {
        Get.snackbar(
          'Error',
          'Please enter valid email and phone number',
        );
        return;
      } else {
        currentIndex.value = currentIndex.value + 1;
      }
    } else if (currentIndex.value == 2) {
      if (selectedBrands.isEmpty || selectedProducts.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter address and pincode',
        );
        return;
      } else {
        currentIndex.value = currentIndex.value + 1;
      }
    } else if (currentIndex.value == 3) {
      if (addressController.text.isEmpty ||
          pinCodeController.text.isEmpty ||
          imagePath.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select atleast one brand and product',
        );
        return;
      } else {
        setShopCreate();
        currentIndex.value = currentIndex.value + 1;
      }
    } else if (currentIndex.value == 4) {
      await createShop();
      Fluttertoast.showToast(msg: "Shop Created");
      Get.back();
    }
  }

  decreaseCurrentIndex() {
    currentIndex.value = currentIndex.value - 1;
  }

  Future<ShopCreate> getShopCreateData() async {
    /* 

      This will resolve the mapAddress with the help of lat and lon
      and then will return the ShopCreate object with all the data
    
    */
    String? address = await _storageController.getAddress(
      latLong: LatLong(
          longitude: _mapsController.origin.value.longitude,
          latitude: _mapsController.origin.value.latitude),
    );
    return ShopCreate(
      name: nameController.text,
      shopAddress: addressController.text,
      shopBrand: selectedBrands.value.join(', '),
      shopEmail: emailController.text,
      shopOwner: ownerController.text,
      shopPhone: phoneController.text,
      shopPincode: pinCodeController.text,
      shopProducts: selectedProducts.value.join(', '),
      shopImg: imagePath.value,
      time: DateTime.now().millisecondsSinceEpoch.toString(),
      locationModel: LocationModel(
        latitude: _mapsController.origin.value.latitude.toString(),
        longitude: _mapsController.origin.value.longitude.toString(),
      ),
      mapAddress: address,
    );
  }

  Future createShop() async {
    try {
      /* 
        One Bug is there in this function
        uploadingImgCount is not working properly
      */

      uploadingImgCount.value = 1;
      ShopCreate shopCreate = await getShopCreateData();
      isLoading.value = true;

      /* 

        Creating a shop in local database

      */

      shopCreate =
          await _storageController.setShopCreateBox(shopCreate: shopCreate);
      Workmanager().registerOneOffTask(
        '1',
        'SYNC',
      );
      /* 
        After that we will check that if the user is online or not
        if the user is online then we will sync the data on the server 

          
          if (_cloudController.alive.isTrue) {
              Timer(const Duration(seconds: 3), () {
              _cloudController.apiController.syncShopCreate();
              });
            return;
          }

        This will call sync function which will sync every data on the server one by one if user is online
      
      */

      if (_cloudController.alive.isTrue) {
        return;
      }

      isCreated.value = true;
      isLoading.value = false;
      return;
    } on HttpException catch (e) {
      isLoading.value = false;
      Get.dialog(AlertDialog(
        title: const Text("Error"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(e.message),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("BACK"),
          ),
          TextButton(
            onPressed: () {
              createShop();
            },
            child: const Text("RETRY"),
          )
        ],
      ));
    } catch (e) {
      Get.dialog(AlertDialog(
        title: const Text("Error"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(e.toString()),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("BACK"),
          ),
          TextButton(
            onPressed: () {
              createShop();
            },
            child: const Text("RETRY"),
          )
        ],
      ));
      isLoading.value = false;
    }
  }

  pushImage({required String img}) async {
    List image = imagePath.value;
    image.add(img);
    imagePath.value = [];
    imagePath.value = image;
  }

  clearImg() {
    imagePath.value = [];
  }

  removeImage({required String path}) {
    List image = imagePath.value;
    image.remove(path);
    imagePath.value = [];
    imagePath.value = image;
  }

  Future getProductsBrands({required bool products}) async {
    try {
      if (products) {
        List p = await _storageController.getProducts();
        if (p.isEmpty && _cloudController.alive.isTrue) {
          productLoading.value = true;
          this.products.value = await _cloudController.apiController
              .getProductsAndBrand(product: products);
          productLoading.value = false;
        } else {
          this.products.value = p;
          if (_cloudController.alive.isTrue) {
            this.products.value = await _cloudController.apiController
                .getProductsAndBrand(product: products);
          } else {
            if (p.isEmpty) throw HttpException('Internet not available');
          }
        }
      } else {
        List b = await _storageController.getBrands();
        if (b.isEmpty && _cloudController.alive.isTrue) {
          brandLoadin.value = true;
          brands.value = await _cloudController.apiController
              .getProductsAndBrand(product: products);
          brandLoadin.value = false;
        } else {
          brands.value = b;
          if (_cloudController.alive.isTrue) {
            brands.value = await _cloudController.apiController
                .getProductsAndBrand(product: products);
          } else {
            if (b.isEmpty) throw HttpException('Internet not available');
          }
        }
      }
    } on HttpException catch (e) {
      if (products) {
        productErrorMessage = e.message;
        productLoading.value = false;
        productError.value = true;
      } else {
        brandErrorMessage = e.message;
        brandLoadin.value = false;
        brandError.value = true;
      }
    } catch (e) {
      if (products) {
        productErrorMessage = e.toString();
        productLoading.value = false;
        productError.value = true;
      } else {
        brandErrorMessage = e.toString();
        brandLoadin.value = false;
        brandError.value = true;
      }
    }
  }

  addProduct({required String product}) {
    if (!selectedProducts.value.contains(product)) {
      List products = selectedProducts.value;
      products.add(product);
      selectedProducts.value = [];
      selectedProducts.value = products;
    }
    newProductController.text = "";
    List p = products.value;
    if (!products.value.contains(product)) {
      p.add(product);
    }
    products.value = [];
    products.value = p;
  }

  removeProduct({required String product}) {
    List products = selectedProducts.value;
    products.remove(product);
    selectedProducts.value = [];
    selectedProducts.value = products;
    List p = this.products.value;
    this.products.value = [];
    this.products.value = p;
  }

  addBrands({required String brand}) {
    if (!selectedBrands.value.contains(brand)) {
      List b = selectedBrands.value;
      b.add(brand);
      selectedBrands.value = [];
      selectedBrands.value = b;
    }
    newBrandController.text = "";
    List p = brands.value;
    if (!brands.value.contains(brand)) {
      p.add(brand);
    }
    brands.value = [];
    brands.value = p;
  }

  removeBrands({required String brand}) {
    List brands = selectedBrands.value;
    brands.remove(brand);
    selectedBrands.value = [];
    selectedBrands.value = brands;
    List p = this.brands.value;
    this.brands.value = [];
    this.brands.value = p;
  }

  clearSelected() {
    selectedBrands.value = [];
    selectedProducts.value = [];
  }
}
