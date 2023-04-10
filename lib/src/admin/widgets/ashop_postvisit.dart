import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/maps/views/amap_view.dart';
import 'package:marketing/src/admin/models/AShopVisit.dart';

class AShopVisitPostWidget extends StatefulWidget {
  AShopVisitPostWidget({
    super.key,
    required this.visit,
  });
  AShopVisit visit;

  @override
  State<AShopVisitPostWidget> createState() => _VisitPostWidgetState();
}

class _VisitPostWidgetState extends State<AShopVisitPostWidget> {
  List local_text = [];
  bool flag = false;
  bool showMore = false;
  bool loadingShop = false;
  bool isError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.visit.remarks!.length > 80) {
      local_text = widget.visit.remarks!.substring(0, 80).split(' ');
      flag = true;
      showMore = true;
    } else {
      local_text = widget.visit.remarks!.split(' ');
      flag = false;
      showMore = false;
    }
  }

  showMoreAndLess() {
    if (showMore) {
      if (flag) {
        setState(() {
          local_text = widget.visit.remarks!.split(' ');
          flag = false;
        });
      } else {
        setState(() {
          local_text = widget.visit.remarks!.substring(0, 80).split(' ');
          flag = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.visit.toJson());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.paste_outlined,
                    color: AppConfig.primaryColor7,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.visit.type as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.visit.type == "SHOP_VISIT"
                              ? widget.visit.shop != null
                                  ? widget.visit.shop!.address ?? 'ADDRESS NOT FOUND'
                                  : "ADDRESS NOT FOUND"
                              : widget.visit.name == null
                                  ? "NAME NOT FOUND"
                                  : widget.visit.name as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.grey.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                widget.visit.type == "SHOP_VISIT"
                    ? widget.visit.shop != null ? widget.visit.shop!.name ?? 'N/A' : "NAME NOT FOUND"
                    : widget.visit.phone == null
                        ? "PHONE NOT FOUND"
                        : widget.visit.phone as String,
                style: GoogleFonts.firaSans(
                  color: AppConfig.primaryColor7,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: RichText(
                text: TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      children: local_text
                          .map(
                            (e) => e.contains('#')
                                ? TextSpan(
                                    text: e + ' ',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                    style: GoogleFonts.firaSans(
                                      color: Colors.indigo.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : TextSpan(
                                    text: e + ' ',
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                          )
                          .toList(),
                    ),
                    showMore
                        ? flag
                            ? TextSpan(
                                text: ' show more',
                                style: GoogleFonts.firaSans(
                                  color: Colors.indigo.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showMoreAndLess();
                                  })
                            : TextSpan(
                                text: ' show less',
                                style: GoogleFonts.firaSans(
                                  color: Colors.indigo.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showMoreAndLess();
                                  })
                        : const TextSpan(text: ''),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            widget.visit.images != null && widget.visit.images!.isNotEmpty
                ? Container(
                    height: 300,
                    color: Colors.grey.withOpacity(0.2),
                    child: PageView(
                      physics:
                          const ScrollPhysics(parent: BouncingScrollPhysics()),
                      children: widget.visit.images!
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                child: Image.network(
                                  '${AppConfig.SERVER_IP}/${e.url}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Image not found",
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateTime.parse(widget.visit.createdAt.toString())
                        .toLocal()
                        .toString()
                        .split('.')
                        .first,
                    style: GoogleFonts.poppins(
                      color: Colors.pink,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (widget.visit.location == null) {
                        Fluttertoast.showToast(msg: 'Location not found');
                      } else {
                        print(widget.visit.toJson());
                        Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
                        markers[MarkerId(widget.visit.sId.toString())] = Marker(
                          markerId: MarkerId(widget.visit.sId as String),
                          position: LatLng(
                            widget.visit.location!.latitude as double,
                            widget.visit.location!.longitude as double,
                          ),
                          infoWindow: InfoWindow(
                            title: widget.visit.shop!.name ?? '',
                          ),
                        );
                        Get.toNamed(AdminMaps.routeName, arguments: {
                          'markers': markers,
                          'points': [
                            LatLng(
                              widget.visit.location!.latitude as double,
                              widget.visit.location!.longitude as double,
                            ),
                          ],
                          'center': LatLng(
                            widget.visit.location!.latitude as double,
                            widget.visit.location!.longitude as double,
                          ),
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.map_outlined,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
