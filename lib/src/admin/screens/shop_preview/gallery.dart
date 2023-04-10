import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/controller/spreview_controller.dart';
import 'package:marketing/src/admin/models/AShopImage.dart';

class SGallery extends StatelessWidget {
  SGallery({super.key, required this.spreviewController});
  SpreviewController spreviewController;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConfig.lightBG,
      child: RefreshIndicator(
        onRefresh: () =>
            Future.sync(() => spreviewController.pagingController.refresh()),
        child: PagedGridView(
          pagingController: spreviewController.pagingController,
          builderDelegate: PagedChildBuilderDelegate<AShopImage>(
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
                            value: loadingProgress.expectedTotalBytes != null
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
      ),
    );
  }
}
