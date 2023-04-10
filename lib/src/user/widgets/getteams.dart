import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/teams_controller.dart';

class GetAllTeams extends StatefulWidget {
  GetAllTeams({
    super.key,
    required this.teamsController,
  });
  TeamsController teamsController;

  @override
  State<GetAllTeams> createState() => _GetAllTeamsState();
}

class _GetAllTeamsState extends State<GetAllTeams> {
  @override
  void initState() {
    super.initState();
    widget.teamsController.getTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Obx(
            () {
              return widget.teamsController.selected.isTrue
                  ? Container(
                      height: 60,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppConfig.primaryColor7,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: widget.teamsController.userTeam.value
                                          .profile !=
                                      null
                                  ? Image.network(
                                      '${AppConfig.SERVER_IP}/${widget.teamsController.userTeam.value.profile!.thumbnailUrl!}',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.person);
                                      },
                                    )
                                  : const Icon(Icons.person),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.teamsController.userTeam.value.name
                                      .toString(),
                                  style: GoogleFonts.firaSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Today visits:  ${widget.teamsController.userTeam.value.visits!.length}',
                                      style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : Text(
                      'Teams',
                      style: GoogleFonts.firaSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    );
            },
          ),
        ),
        Expanded(
          child: Obx(
            () {
              return widget.teamsController.loadingTeams.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : widget.teamsController.teams.isEmpty
                      ? const Center(
                          child: Text('Teams not found'),
                        )
                      : ListView.builder(
                          itemCount: widget.teamsController.teams.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                widget.teamsController.selectTeam(
                                  team: widget.teamsController.teams[index],
                                );
                              },
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: widget.teamsController.teams[index]
                                              .profile ==
                                          null
                                      ? const Icon(Icons.person)
                                      : Image.network(
                                          '${AppConfig.SERVER_IP}/${widget.teamsController.teams[index].profile!.thumbnailUrl}',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.person);
                                          },
                                        ),
                                ),
                              ),
                              title: Text(widget
                                  .teamsController.teams[index].name
                                  .toString()),
                              subtitle: Text(
                                widget.teamsController.teams[index]
                                            .lastActive !=
                                        null
                                    ? DateTime.parse(
                                        widget.teamsController.teams[index]
                                            .lastActive!.time
                                            .toString(),
                                      ).toLocal().toString()
                                    : "Not active",
                                style: GoogleFonts.firaSans(
                                  color: widget.teamsController.teams[index]
                                              .lastActive !=
                                          null
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                ),
                              ),
                            );
                          },
                        );
            },
          ),
        )
      ],
    );
  }
}
