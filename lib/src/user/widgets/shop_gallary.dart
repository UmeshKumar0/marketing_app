// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/shop_details.dart';
import 'package:marketing/src/user/models/shop_image.dart';
import 'package:marketing/src/user/screens/fullscreen_image.dart';

class ShopGallary extends StatefulWidget {
  ShopGallary({
    Key? key,
    required this.id,
  }) : super(key: key);
  String id;
  @override
  State<ShopGallary> createState() => _ShopGallaryState();
}

class _ShopGallaryState extends State<ShopGallary> {
  final int _pageSize = 15;
  final PagingController<int, ShopImage> _pagingController =
      PagingController(firstPageKey: 0);
  late ShopDetailsController _shopDetailsController;

  @override
  void initState() {
    super.initState();
    _shopDetailsController = Get.find<ShopDetailsController>();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchImage(pageKey: pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  _fetchImage({
    required int pageKey,
  }) async {
    try {
      List images = await _shopDetailsController.getImages(
        id: widget.id,
        ekip: (pageKey / _pageSize).toString(),
        limit: _pageSize.toString(),
      );

      if (images.length < _pageSize) {
        _pagingController.appendLastPage(images as List<ShopImage>);
      } else {
        _pagingController.appendPage(
          images as List<ShopImage>,
          pageKey + images.length,
        );
      }
    } on HttpException catch (e) {
      _pagingController.error = e.message;
    } catch (e) {
      _pagingController.error = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: RefreshIndicator(
            child: PagedGridView(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<ShopImage>(
                itemBuilder: (context, item, index) {
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: InkWell(
                        child: Image.network(
                          '${AppConfig.SERVER_IP}/${item.thumbnailUrl}',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return InkWell(
                              onTap: () {
                                Fluttertoast.showToast(
                                    msg:
                                        'This image is corrupted or not exist on server');
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '404',
                                  style: GoogleFonts.firaSans(
                                      color: Colors.red.withOpacity(0.7),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24),
                                ),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          Get.to(
                            FullScreenImage(
                              url: '${AppConfig.SERVER_IP}/${item.url}',
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
            onRefresh: () => Future.sync(() => _pagingController.refresh())));
  }
}
