import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/shop_create_controller.dart';
import 'package:marketing/src/user/widgets/customButton.dart';

class BrandProducts extends StatefulWidget {
  BrandProducts({
    super.key,
    required this.shopCreateController,
  });
  ShopCreateController shopCreateController;

  @override
  State<BrandProducts> createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  @override
  void initState() {
    super.initState();
    widget.shopCreateController.clearSelected();
    widget.shopCreateController.getProductsBrands(products: true);
    widget.shopCreateController.getProductsBrands(products: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Select Your Products',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppConfig.lightBG,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: widget.shopCreateController.productLoading
                                      .isTrue
                                  ? Text(
                                      'Loading...',
                                      style: GoogleFonts.firaSans(),
                                    )
                                  : widget.shopCreateController.selectedProducts
                                          .isEmpty
                                      ? Text(
                                          'Select Your Products',
                                          style: GoogleFonts.firaSans(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: const ScrollPhysics(
                                              parent: BouncingScrollPhysics()),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Chip(
                                                label: Text(
                                                  widget.shopCreateController
                                                      .selectedProducts[index],
                                                  style: GoogleFonts.firaSans(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.7),
                                                deleteIcon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                                onDeleted: () {
                                                  widget.shopCreateController
                                                      .removeProduct(
                                                    product: widget
                                                        .shopCreateController
                                                        .selectedProducts[index],
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          itemCount: widget.shopCreateController
                                              .selectedProducts.length,
                                        ),
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Obx(() {
                          return InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                Obx(() {
                                  return Container(
                                    height: 400,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Select Products',
                                                style: GoogleFonts.firaSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                icon: const Icon(Icons.clear),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Add New',
                                                              style: GoogleFonts
                                                                  .firaSans(),
                                                            ),
                                                            content:
                                                                TextFormField(
                                                              controller: widget
                                                                  .shopCreateController
                                                                  .newProductController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Product',
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: GoogleFonts
                                                                      .firaSans(),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  if (widget
                                                                      .shopCreateController
                                                                      .newProductController
                                                                      .text
                                                                      .isNotEmpty) {
                                                                    widget
                                                                        .shopCreateController
                                                                        .addProduct(
                                                                      product: widget
                                                                          .shopCreateController
                                                                          .newProductController
                                                                          .text,
                                                                    );
                                                                    Get.back();
                                                                  } else {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                      msg:
                                                                          'Please Enter Product Name',
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_SHORT,
                                                                      gravity:
                                                                          ToastGravity
                                                                              .BOTTOM,
                                                                      timeInSecForIosWeb:
                                                                          1,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          16.0,
                                                                    );
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Add',
                                                                  style: GoogleFonts
                                                                      .firaSans(),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.red
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Create Custom',
                                                        style: GoogleFonts
                                                            .firaSans(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: InkWell(
                                                    onTap: () {
                                                      widget
                                                          .shopCreateController
                                                          .getProductsBrands(
                                                        products: true,
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: AppConfig
                                                            .primaryColor7,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        widget
                                                                .shopCreateController
                                                                .productLoading
                                                                .isTrue
                                                            ? 'Loading...'
                                                            : 'Refresh',
                                                        style: GoogleFonts
                                                            .firaSans(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: widget.shopCreateController
                                                  .productLoading.isTrue
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  child:
                                                      const CircularProgressIndicator(),
                                                )
                                              : widget.shopCreateController
                                                      .products.isEmpty
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'No Products Found',
                                                        style: GoogleFonts
                                                            .firaSans(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      itemBuilder:
                                                          (context, index) {
                                                        return CheckboxListTile(
                                                          value: widget
                                                              .shopCreateController
                                                              .selectedProducts
                                                              .contains(widget
                                                                  .shopCreateController
                                                                  .products[index]),
                                                          onChanged: (value) {
                                                            if (value == true) {
                                                              widget
                                                                  .shopCreateController
                                                                  .addProduct(
                                                                product: widget
                                                                    .shopCreateController
                                                                    .products[index],
                                                              );
                                                            } else {
                                                              widget
                                                                  .shopCreateController
                                                                  .removeProduct(
                                                                product: widget
                                                                    .shopCreateController
                                                                    .products[index],
                                                              );
                                                            }
                                                          },
                                                          title: Text(
                                                            widget
                                                                .shopCreateController
                                                                .products[index],
                                                          ),
                                                        );
                                                      },
                                                      itemCount: widget
                                                          .shopCreateController
                                                          .products
                                                          .length,
                                                    ),
                                        ),
                                        const BrandsAndProductButton(),
                                      ],
                                    ),
                                  );
                                }),
                                isDismissible: false,
                              );
                            },
                            child: Container(
                              width: 55,
                              height: 55,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppConfig.primaryColor7,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: widget.shopCreateController.productLoading
                                      .isTrue
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

//
//
//
//
//
//

        const SizedBox(
          height: 20,
        ),
//
//
//
//
//
//
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Select Your Brands',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppConfig.lightBG,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: widget
                                      .shopCreateController.brandLoadin.isTrue
                                  ? Text(
                                      'Loading...',
                                      style: GoogleFonts.firaSans(),
                                    )
                                  : widget.shopCreateController.selectedBrands
                                          .isEmpty
                                      ? Text(
                                          'Select Your Brands',
                                          style: GoogleFonts.firaSans(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: const ScrollPhysics(
                                              parent: BouncingScrollPhysics()),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              child: Chip(
                                                label: Text(
                                                  widget.shopCreateController
                                                      .selectedBrands[index],
                                                  style: GoogleFonts.firaSans(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.7),
                                                deleteIcon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                                onDeleted: () {
                                                  widget.shopCreateController
                                                      .removeBrands(
                                                    brand: widget
                                                        .shopCreateController
                                                        .selectedBrands[index],
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          itemCount: widget.shopCreateController
                                              .selectedBrands.length,
                                        ),
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Obx(() {
                          return InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                Obx(() {
                                  return Container(
                                    height: 400,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Select Brands',
                                                style: GoogleFonts.firaSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                icon: const Icon(Icons.clear),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Add New',
                                                              style: GoogleFonts
                                                                  .firaSans(),
                                                            ),
                                                            content:
                                                                TextFormField(
                                                              controller: widget
                                                                  .shopCreateController
                                                                  .newBrandController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Brand',
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: GoogleFonts
                                                                      .firaSans(),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  if (widget
                                                                      .shopCreateController
                                                                      .newBrandController
                                                                      .text
                                                                      .isNotEmpty) {
                                                                    widget
                                                                        .shopCreateController
                                                                        .addBrands(
                                                                      brand: widget
                                                                          .shopCreateController
                                                                          .newBrandController
                                                                          .text,
                                                                    );
                                                                    Get.back();
                                                                  } else {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                      msg:
                                                                          'Please Enter Product Name',
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_SHORT,
                                                                      gravity:
                                                                          ToastGravity
                                                                              .BOTTOM,
                                                                      timeInSecForIosWeb:
                                                                          1,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          16.0,
                                                                    );
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Add',
                                                                  style: GoogleFonts
                                                                      .firaSans(),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.red
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Create Custom',
                                                        style: GoogleFonts
                                                            .firaSans(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: InkWell(
                                                    onTap: () {
                                                      widget
                                                          .shopCreateController
                                                          .getProductsBrands(
                                                        products: false,
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: AppConfig
                                                            .primaryColor7,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        widget
                                                                .shopCreateController
                                                                .brandLoadin
                                                                .isTrue
                                                            ? 'Loading...'
                                                            : 'Refresh',
                                                        style: GoogleFonts
                                                            .firaSans(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: widget.shopCreateController
                                                  .brandLoadin.isTrue
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  child:
                                                      const CircularProgressIndicator(),
                                                )
                                              : widget.shopCreateController
                                                      .brands.isEmpty
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'No Brands Found',
                                                        style: GoogleFonts
                                                            .firaSans(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      itemBuilder:
                                                          (context, index) {
                                                        return CheckboxListTile(
                                                          value: widget
                                                              .shopCreateController
                                                              .selectedBrands
                                                              .contains(widget
                                                                  .shopCreateController
                                                                  .brands[index]),
                                                          onChanged: (value) {
                                                            if (value == true) {
                                                              widget
                                                                  .shopCreateController
                                                                  .addBrands(
                                                                brand: widget
                                                                    .shopCreateController
                                                                    .brands[index],
                                                              );
                                                            } else {
                                                              widget
                                                                  .shopCreateController
                                                                  .removeBrands(
                                                                brand: widget
                                                                    .shopCreateController
                                                                    .brands[index],
                                                              );
                                                            }
                                                          },
                                                          title: Text(
                                                            widget
                                                                .shopCreateController
                                                                .brands[index],
                                                          ),
                                                        );
                                                      },
                                                      itemCount: widget
                                                          .shopCreateController
                                                          .brands
                                                          .length,
                                                    ),
                                        ),
                                        const BrandsAndProductButton(),
                                      ],
                                    ),
                                  );
                                }),
                                isDismissible: false,
                              );
                            },
                            child: Container(
                              width: 55,
                              height: 55,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppConfig.primaryColor7,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                                  widget.shopCreateController.brandLoadin.isTrue
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BrandsAndProductButton extends StatelessWidget {
  const BrandsAndProductButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("BACK"),
            ),
          ),
          Expanded(
            child: CustomButton(
              onTap: () {
                Get.back();
              },
              text: "SUBMIT",
              color: AppConfig.primaryColor7,
            ),
          )
        ],
      ),
    );
  }
}
