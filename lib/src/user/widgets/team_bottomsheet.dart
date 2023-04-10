import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/models/teams_model.dart';

class TeamBottomSheet extends StatelessWidget {
  TeamBottomSheet({
    super.key,
    required this.team,
  });
  UserTeam team;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Team Info',
                  style: GoogleFonts.firaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
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
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppConfig.primaryColor7,
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: team.profile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  30,
                                ),
                                child: Image.network(
                                  '${AppConfig.SERVER_IP}/${team.profile!.thumbnailUrl}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.person,
                                color: AppConfig.primaryColor7,
                              ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name as String,
                        style: GoogleFonts.firaSans(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        team.email as String,
                        style: GoogleFonts.firaSans(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(
                Icons.speed,
                color: AppConfig.primaryColor7,
              ),
              title: Text(
                'Odometer Details',
                style: GoogleFonts.firaSans(),
              ),
              subtitle: Text(
                team.odometers!.isEmpty
                    ? 'Attendance not marked yet'
                    : team.odometers![0].endReading == null
                        ? 'In Progress'
                        : 'Completed (${team.odometers![0].endReading! - team.odometers![0].startReading!} km)',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(
                Icons.paste_outlined,
                color: AppConfig.primaryColor7,
              ),
              title: Text(
                'Today Visits',
                style: GoogleFonts.firaSans(),
              ),
              subtitle: Text(
                team.visits!.isEmpty
                    ? 'No visits today'
                    : '${team.visits!.length} visits',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(
                Icons.timeline_rounded,
                color: AppConfig.primaryColor7,
              ),
              title: Text(
                'Last Active',
                style: GoogleFonts.firaSans(),
              ),
              subtitle: Text(
                team.lastActive == null
                    ? 'Not active yet'
                    : '${team.lastActive!.time}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
