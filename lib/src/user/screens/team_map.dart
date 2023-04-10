import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/teams_controller.dart';
import 'package:marketing/src/user/widgets/getteams.dart';

class TeamsMap extends StatelessWidget {
  const TeamsMap({super.key});

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
          'My Teams',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          GetX<TeamsController>(
            builder: (team) {
              return team.selected.isFalse
                  ? Container()
                  : IconButton(
                      onPressed: team.changeVisitValue,
                      icon: Icon(
                        team.showVisit.isTrue
                            ? Icons.location_off_sharp
                            : Icons.location_on,
                        color: AppConfig.primaryColor7,
                      ),
                    );
            },
          )
        ],
      ),
      bottomSheet: GetX<TeamsController>(builder: (controller) {
        return Material(
          elevation: 10,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Container(
            height: controller.selected.isTrue
                ? MediaQuery.of(context).size.height * 0.35
                : MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: GetAllTeams(
              teamsController: controller,
            ),
          ),
        );
      }),
      body: GetX<TeamsController>(builder: (team) {
        return GoogleMap(
          initialCameraPosition: team.cameraPosition.value,
          markers: team.showVisit.isTrue
              ? Set<Marker>.of(team.userVisits.values)
              : Set<Marker>.of(team.markers.values),
          mapType: MapType.normal,
          onMapCreated: (cont) {
            team.registerLocationListner(
              cont,
              context,
            );
          },
          myLocationEnabled: true,
          onCameraMove: (position) {
            team.setCameraPosition(cameraPosition: position);
          },
        );
      }),
    );
  }
}


/* 

body : {title, reason} => title => file_field, reason => text_field || ""
image: [title]: imagebody

*/