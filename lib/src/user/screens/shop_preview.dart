import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/widgets/shop_gallary.dart';
import 'package:marketing/src/user/widgets/shop_info.dart';

class ShopPreview extends StatefulWidget {
  const ShopPreview({Key? key}) : super(key: key);

  @override
  State<ShopPreview> createState() => _ShopPreviewState();
}

class _ShopPreviewState extends State<ShopPreview>
    with TickerProviderStateMixin {
  bool _infoActive = true;
  bool _toolbarActive = false;
  late Animation<Offset> _position;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _position = Tween<Offset>(
            begin: const Offset(0.0, 2.0), end: const Offset(0.0, 0.0))
        .animate(_controller);
  }

  changeValue() {
    setState(() {
      if (_toolbarActive) {
        _controller.reverse();
        _toolbarActive = false;
      } else {
        _controller.forward();
        _toolbarActive = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Shops shops = ModalRoute.of(context)!.settings.arguments as Shops;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        titleSpacing: 2,
        title: Text(
          shops.name as String,
          style: GoogleFonts.firaSans(
            color: Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          spreadRadius: -7,
                          blurRadius: 8,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        child: shops.profile!.thumbnail == 'N/A'
                            ? Image.asset("assets/createShop.png")
                            : Image.network(
                                '${AppConfig.SERVER_IP}/${shops.profile!.thumbnail}',
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset("assets/createShop.png");
                                },
                              ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 20),
                  child: Text(
                    shops.name!.length > 20
                        ? "${shops.name!.substring(0, 20)}..."
                        : shops.name as String,
                    style: GoogleFonts.firaSans(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    spreadRadius: -7,
                    blurRadius: 8,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    // margin: const EdgeInsets.all(10),
                    height: 50,
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              Size.infinite,
                            ),
                            minimumSize: MaterialStateProperty.all(
                              Size(width * 0.5, 50),
                            ),
                            overlayColor: MaterialStateProperty.all(
                              Colors.red.withOpacity(0.7),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              _infoActive == true
                                  ? Colors.red.withOpacity(0.7)
                                  : Colors.white,
                            ),
                            animationDuration:
                                const Duration(milliseconds: 500),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.all(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _infoActive = true;
                            });
                          },
                          icon: Icon(
                            Icons.info_outline,
                            color: _infoActive == true
                                ? Colors.white
                                : Colors.red.withOpacity(0.7),
                          ),
                          label: Text(
                            'Shop Info',
                            style: GoogleFonts.firaSans(
                              color: _infoActive == true
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              Size.infinite,
                            ),
                            minimumSize: MaterialStateProperty.all(
                              Size(width * 0.5, 50),
                            ),
                            overlayColor: MaterialStateProperty.all(
                              Colors.red.withOpacity(0.7),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              _infoActive == false
                                  ? Colors.red.withOpacity(0.7)
                                  : Colors.white,
                            ),
                            animationDuration:
                                const Duration(milliseconds: 500),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.all(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _infoActive = false;
                            });
                          },
                          icon: Icon(
                            Icons.photo_library_outlined,
                            color: _infoActive == false
                                ? Colors.white
                                : Colors.red.withOpacity(0.7),
                          ),
                          label: Text(
                            'Shop Gallery',
                            style: GoogleFonts.firaSans(
                              color: _infoActive == false
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: _infoActive == true
                        ? ShopInfo(
                            shops: shops,
                          )
                        : ShopGallary(
                            id: shops.sId.toString(),
                          ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _toolbarActive == false
          ? FloatingActionButton(
              onPressed: () {
                changeValue();
              },
              child: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            )
          : SlideTransition(
              position: _position,
              child: Wrap(
                // alignment: WrapAlignment.end,
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.end,

                children: [
                  GetX<StorageController>(builder: (storage) {
                    return storage.odoMeter.value == AppConfig.PRESENT
                        ? ElevatedButton.icon(
                            onPressed: () {
                              Get.toNamed(
                                AppConfig.CREATE_VISIT,
                                arguments: shops,
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Create Visit',
                              style: GoogleFonts.firaSans(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(
                            height: 10,
                            width: 10,
                            color: Colors.transparent,
                          );
                  }),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(
                        AppConfig.SHOP_VISIT,
                        arguments: shops,
                      );
                    },
                    icon: const Icon(
                      Icons.paste_sharp,
                      color: Colors.white,
                    ),
                    label: Text(
                      'View Visits',
                      style: GoogleFonts.firaSans(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(AppConfig.SHOP_REMINDER, arguments: shops);
                    },
                    icon: const Icon(
                      Icons.timer,
                      color: Colors.white,
                    ),
                    label: Text(
                      'View Reminders',
                      style: GoogleFonts.firaSans(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      changeValue();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Close',
                      style: GoogleFonts.firaSans(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
