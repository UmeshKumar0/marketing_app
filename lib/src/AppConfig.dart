// ignore_for_file: non_constant_identifier_names, file_names
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:marketing/src/admin/bindings/admin_bindings.dart';
import 'package:marketing/src/admin/maps/views/amap_view.dart';
import 'package:marketing/src/admin/screens/MO/views/mo_view.dart';
import 'package:marketing/src/admin/screens/add_user/views/AddUserView.dart';
import 'package:marketing/src/admin/screens/admin_home.dart';
import 'package:marketing/src/admin/screens/all_visits/views/all_visits_views.dart';
import 'package:marketing/src/admin/screens/chat_module/views/AdminChatPreview.dart';
import 'package:marketing/src/admin/screens/chat_module/views/ChatModuleView.dart';
import 'package:marketing/src/admin/screens/constants/view/constants_view.dart';
import 'package:marketing/src/admin/screens/ddoc/views/DdocView.dart';
import 'package:marketing/src/admin/screens/dealer/views/DealerView.dart';
import 'package:marketing/src/admin/screens/deleted_users/views/deleted_userd_view.dart';
import 'package:marketing/src/admin/screens/groups/views/group_views.dart';
import 'package:marketing/src/admin/screens/headers_profilelist/views/headers_profilelist_view.dart';
import 'package:marketing/src/admin/screens/leaves/views/LeavesView.dart';
import 'package:marketing/src/admin/screens/meetings/views/adminMeeting_views.dart';
import 'package:marketing/src/admin/screens/odometer/views/login_history.dart';
import 'package:marketing/src/admin/screens/odometer/views/odometer_screen.dart';
import 'package:marketing/src/admin/screens/officers_profile/views/officers_profile_view.dart';
import 'package:marketing/src/admin/screens/permissions/views/permission_views.dart';
import 'package:marketing/src/admin/screens/reports/views/ReportsView.dart';
import 'package:marketing/src/admin/screens/shop_preview/admin_shop_preview.dart';
import 'package:marketing/src/admin/screens/admin_shops_screen.dart';
import 'package:marketing/src/admin/screens/sponsor/views/SponsorView.dart';
import 'package:marketing/src/admin/screens/teams/views/TeamsView.dart';
import 'package:marketing/src/user/chat/models/message.model.dart';
import 'package:marketing/src/user/chat/views/chats.screen.dart';
import 'package:marketing/src/user/models/create_odometer.dart';
import 'package:marketing/src/user/models/create_reminder.dart';
import 'package:marketing/src/user/models/create_visit.dart';
import 'package:marketing/src/user/models/image_model.dart';
import 'package:marketing/src/user/models/index.dart';
import 'package:marketing/src/user/models/location_model.dart';
import 'package:marketing/src/user/models/meetings/meeting_model.dart';
import 'package:marketing/src/user/models/meetings/meeting_user.dart';
import 'package:marketing/src/user/models/reminder_model.dart';
import 'package:marketing/src/user/models/rtlLocation_model.dart';
import 'package:marketing/src/user/models/shopCreate.dart';
import 'package:marketing/src/user/models/types.dart';
import 'package:marketing/src/user/models/visit_model.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:marketing/src/bindings/bindings.dart';
import 'package:marketing/src/user/models/attendanceData.dart';
import 'package:marketing/src/user/models/odometers.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/models/teams_model.dart';
import 'package:marketing/src/user/models/user_model.dart';
import 'package:marketing/src/user/models/user_notification.dart';
import 'package:marketing/src/user/screens/LocationError_screen.dart';
import 'package:marketing/src/user/screens/MyMeetings.dart';
import 'package:marketing/src/user/screens/action_screens/attendance_screen.dart';
import 'package:marketing/src/user/screens/action_screens/create_meeting.dart';
import 'package:marketing/src/user/screens/action_screens/help_center.dart';
import 'package:marketing/src/user/screens/action_screens/leave_application_screen.dart';
import 'package:marketing/src/user/screens/action_screens/local_database.dart';
import 'package:marketing/src/user/screens/action_screens/meetings_screen.dart';
import 'package:marketing/src/user/screens/action_screens/today_reminders.dart';
import 'package:marketing/src/user/screens/action_screens/today_visits.dart';
import 'package:marketing/src/user/screens/actions_screen.dart';
import 'package:marketing/src/user/screens/app_permission/views/AppPermissionView.dart';
import 'package:marketing/src/user/screens/camera_screen.dart';
import 'package:marketing/src/user/screens/create_odometer.dart';
import 'package:marketing/src/user/screens/create_reminder.dart';
import 'package:marketing/src/user/screens/create_shop_screen.dart';
import 'package:marketing/src/user/screens/create_visit.dart';
import 'package:marketing/src/user/screens/dealership/dealership_form.dart';
import 'package:marketing/src/user/screens/home_screen.dart';
import 'package:marketing/src/user/screens/login_screen.dart';
import 'package:marketing/src/user/screens/meeting_response.dart';
import 'package:marketing/src/user/screens/notification_screen.dart';
import 'package:marketing/src/user/screens/paints/views/PaintsView.dart';
import 'package:marketing/src/user/screens/pdf.dart';
import 'package:marketing/src/user/screens/profile_screen.dart';
import 'package:marketing/src/user/screens/reminders_visit.dart';
import 'package:marketing/src/user/screens/search_shop.dart';
import 'package:marketing/src/user/screens/shop_preview.dart';
import 'package:marketing/src/user/screens/shop_reminders.dart';
import 'package:marketing/src/user/screens/shop_visits.dart';
import 'package:marketing/src/user/screens/splash_screen.dart';
import 'package:marketing/src/user/screens/team_map.dart';
import 'package:marketing/src/user/screens/utils_screen.dart';
import 'package:marketing/src/user/screens/validation/views/ValidationView.dart';
import 'package:marketing/src/user/screens/verify_screen.dart';
import 'package:marketing/src/user/widgets/cool_button.dart';

class AppConfig {
  static int alaermID = 404;
  static String MODE = "PROD";
  static String appName = 'Magadh Industries';
  static Color lightPrimary = const Color(0xfff3f4f9);
  static Color lightAccent = const Color(0xff416d6d);
  static Color lightBG = const Color(0xfff3f4f9);
  static ThemeData lightTheme = ThemeData(
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: lightPrimary,
      surfaceTintColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Color(0xff416d6d),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  static List<String> status = ['connecting', 'connect', 'disconnect', 'error'];

  static String locationAdress =
      'https://maps.google.com/maps/api/geocode/json';

  // static String SERVER_IP = 'http://172.30.1.87:9002';
  // static String SOCKET = 'http://172.30.1.87:9003';

  static String SOCKET = 'http://65.1.184.183:9003';
  static String SERVER_IP = 'http://65.1.184.183:9002';
  static String host = '$SERVER_IP/api/v2';
  static String NOTIFICATION_HOST = 'http://65.1.184.183/api';

  // static String NOTIFICATION_HOST = 'http://192.168.135.159:3000/api';
  static String SocketServer = 'http://192.168.43.59:9000';

  static String locationApiKey = 'AIzaSyDC39hfMT9JMv8M7HkITjgCiTwXYAtxM00';
  static String SPLASH_ROUTE = '/';
  static String LOGIN_ROUTE = '/login';
  static String UTILS_SCREEN = '/utils';
  static String HOME_ROUTE = '/home';
  static String VERIFY_SCREEN = '/verification';
  static String SEARCH_SCREEN = '/search';
  static String CREATE_SHOP_SCREEN = '/create-shop-screen';
  static String SHOP_PREVIEW = '/shop-preview';
  static String API_CALL_SCREEN = '/api-call';
  static String CREATE_ODOMETER_SCREEN = '/create-odometer';
  static String SHOP_REMINDER = '/shop-reminder';
  static String SHOP_VISIT = '/shop-visit';
  static String REMINDER_VISIT = '/reminder-visit';
  static String CREATE_REMINDER = '/create-reminder';
  static String CREATE_VISIT = '/create_visit';
  static String PROFILE = '/profile';
  static String NOTIFICATION_SCREEN = '/notification';
  static String DEALERSHIP_FORM = '/dealership_form';
  static String ACTIONS_SCREEN = '/actions_screen';
  static String TODAY_VISIT_SCREEN = '/today_visit_screen';
  static String TODAY_REMINDERS = '/today_reminders';
  static String ATTENDANCE_SCREEN = '/attendance_screen';
  static String MEETING_SCREEN = '/meeting_screen';
  static String TEAMSSCREEN = '/teams-screen';
  static String PDF_SCREEN = '/pdf-screen';
  static String LOCALDATABASE = '/local_db';
  static String CREATE_MEETING = '/create_meeting';
  static String LOCATION_ERROR_SCREEN = '/location_error_screen';
  static String CAMERA_SCREEN = '/camera_screen';
  static String LEAVE_SCREEN = '/leave_screen';
  static String MYMEETINGS_SCREEN = '/my_meetings_screen';
  static String MEETING_RESPONSE = '/meeting_response';
  static String HELP_SCREEN = '/help_screen';
  static String CHAT_SCREEN = '/chat_screen';

  // Admin Route Strings

  static List<GetPage> pages = [
    GetPage(
      name: CAMERA_SCREEN,
      page: () => CameraScreen(),
    ),
    GetPage(
      name: LEAVE_SCREEN,
      page: () => const LeaveScreen(),
      binding: LeaveBindigs(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: CREATE_MEETING,
      page: () => const CreateMeeting(),
      binding: MeetingsBindings(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: LOCATION_ERROR_SCREEN,
      page: () => const LocationErrorScreen(),
    ),
    GetPage(
      name: PDF_SCREEN,
      page: () => PDFScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: SPLASH_ROUTE,
      page: () => SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: UTILS_SCREEN,
      page: () => UtilsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: LOGIN_ROUTE,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
      binding: LoginBinding(),
    ),
    GetPage(
      name: VERIFY_SCREEN,
      page: () => const VerificationScreen(),
      binding: VerificationBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: AppConfig.HOME_ROUTE,
      page: () => const HomeScreen(),
      binding: HomeBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: SEARCH_SCREEN,
      page: () => const SearchShop(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: CREATE_SHOP_SCREEN,
      page: () => const CreateShopScreen(),
      binding: CreateShopBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: SHOP_PREVIEW,
      page: () => const ShopPreview(),
      binding: ShopDetailsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: CREATE_ODOMETER_SCREEN,
      page: () => const CreateOdoMeterScreen(),
      binding: OdometerBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: SHOP_REMINDER,
      page: () => const ShopRemindersScreen(),
      binding: ShopReminderBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: SHOP_VISIT,
      page: () => const ShopVisitScreen(),
      binding: ShopVisitBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: REMINDER_VISIT,
      page: () => const ReminderByVisit(),
      binding: ShopVisitBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: CREATE_REMINDER,
      page: () => const CreateReminderScreen(),
      binding: ReminderBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: CREATE_VISIT,
      binding: VisitBindings(),
      page: () => CreateVisitScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: PROFILE,
      page: () => const ProfileScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: NOTIFICATION_SCREEN,
      page: () => const NotificationScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: DEALERSHIP_FORM,
      page: () => const DealerShipForm(),
      binding: DealerShipBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: ACTIONS_SCREEN,
      page: () => const ActionsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: TODAY_VISIT_SCREEN,
      page: () => const TodayVisits(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: TODAY_REMINDERS,
      page: () => const TodayReminders(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: ATTENDANCE_SCREEN,
      page: () => const AttendanceScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: MEETING_SCREEN,
      page: () => const MeetingScreen(),
      binding: MeetingsBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: TEAMSSCREEN,
      page: () => const TeamsMap(),
      binding: TeamsBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: LOCALDATABASE,
      page: () => const LocalDatabase(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
      binding: ForegroundServiceBindings(),
    ),
    GetPage(
      name: MYMEETINGS_SCREEN,
      page: () => const MyMeetings(),
      binding: MyMeetingBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: MEETING_RESPONSE,
      page: () => const MeetingResponse(),
      binding: MyMeetingBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: HELP_SCREEN,
      page: () => const HelpCenterScreen(),
      binding: HelpCenterBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: CHAT_SCREEN,
      page: () => const ChatsScreen(),
      binding: SocketBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: AppPermissionViews.routeName,
      page: () => const AppPermissionViews(),
      binding: AppPermissionBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),

    GetPage(
      name: AdminHome.adminHomeRoute,
      page: () => AdminHome(),
      binding: AdminHomeBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: AdminShopsScreen.route,
      page: () => AdminShopsScreen(),
      binding: AdminShopBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: AShopPreview.route,
      page: () => AShopPreview(),
      binding: SPreviewBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: AOdometerScreen.routeName,
      page: () => AOdometerScreen(),
      binding: AOdometersBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: LoginHistory.routeName,
      page: () => LoginHistory(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: AdminMaps.routeName,
      page: () => AdminMaps(),
      binding: MapsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: OfficersProfileView.route,
      page: () => OfficersProfileView(),
      binding: OfficersProfileBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: MoViews.route,
      page: () => MoViews(),
      binding: MoBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: AllVisitsViews.routeName,
      page: () => AllVisitsViews(),
      binding: AllVisitsBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: HeaderProfileList.routeName,
      page: () => HeaderProfileList(),
      binding: HeadersProfileListBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: PaintsViews.routeName,
      page: () => PaintsViews(),
      binding: PaintBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),

    // Quick Actions routes
    GetPage(
      name: ConstantsViews.routeName,
      page: () => ConstantsViews(),
      binding: ConstantsBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: PermissionViews.routeName,
      page: () => PermissionViews(),
      binding: PermissionmBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: GroupViews.routeName,
      page: () => GroupViews(),
      binding: GroupBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: AdminMeetingViews.routeName,
      page: () => AdminMeetingViews(),
      binding: AdminMeetingBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: DeletedUser.routeName,
      page: () => DeletedUser(),
      binding: DeletedUserBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: DdocViews.routeName,
      page: () => DdocViews(),
      binding: DdocBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: LeavesViews.routeName,
      page: () => LeavesViews(),
      binding: LeaveBindigs(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: ReportsViews.routeName,
      page: () => ReportsViews(),
      binding: ReportsBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),

    GetPage(
      name: DealerViews.routeName,
      page: () => DealerViews(),
      binding: DealerBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: TeamsViews.routeName,
      page: () => TeamsViews(),
      binding: AdminTeamsBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: AddUserViews.routeName,
      page: () => AddUserViews(),
      binding: AddUserBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),

    GetPage(
      name: SponsorViews.routeName,
      page: () => SponsorViews(),
      binding: SponsorBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: ValidationViews.routeName,
      page: () => ValidationViews(),
      binding: ValidationBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: ChatModuleViews.routeName,
      page: () => ChatModuleViews(),
      binding: ChatModuleBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: AdminChatPreview.routeName,
      page: () => AdminChatPreview(),
      binding: AdminChatPreviewBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
  ];

  static String IDEAL_STATE = 'IDEAL_STATE';
  static String LOADING_STATE = 'LOADING_STATE';
  static String ERROR_STATE = 'ERROR_STATE';

  static List<String> widgetState = [
    IDEAL_STATE,
    LOADING_STATE,
    ERROR_STATE,
  ];

  static List<BottomNavyBarItem> navi = [
    BottomNavyBarItem(
      activeColor: Colors.red.withOpacity(0.7),
      inactiveColor: AppConfig.primaryColor7,
      title: const Text('Attendance'),
      icon: const Icon(
        Icons.calendar_month_outlined,
      ),
    ),
    BottomNavyBarItem(
      activeColor: Colors.red.withOpacity(0.7),
      inactiveColor: AppConfig.primaryColor7,
      title: const Text('Shop'),
      icon: const Icon(Icons.home_work),
    ),
    BottomNavyBarItem(
      activeColor: Colors.red.withOpacity(0.7),
      inactiveColor: AppConfig.primaryColor7,
      title: const Text('Maps'),
      icon: const Icon(Icons.map_rounded),
    ),
    BottomNavyBarItem(
      activeColor: Colors.red.withOpacity(0.7),
      inactiveColor: AppConfig.primaryColor7,
      title: const Text('Visit'),
      icon: const Icon(Icons.auto_graph),
    ),
    BottomNavyBarItem(
      activeColor: Colors.red.withOpacity(0.7),
      inactiveColor: AppConfig.primaryColor7,
      title: const Text('Reminders '),
      icon: const Icon(Icons.more_horiz_outlined),
    )
  ];

  static List<Widget> appTitles = [
    Text(
      'Attendance',
      style: GoogleFonts.firaSans(
        fontSize: 20,
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.w400,
      ),
    ),
    Text(
      'Shops',
      style: GoogleFonts.firaSans(
        fontSize: 20,
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.w400,
      ),
    ),
    Text(
      'Nearby Shops',
      style: GoogleFonts.firaSans(
        fontSize: 20,
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.w400,
      ),
    ),
    Text(
      'Visits',
      style: GoogleFonts.firaSans(
        fontSize: 20,
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.w400,
      ),
    ),
    Text(
      'Reminders',
      style: GoogleFonts.firaSans(
        fontSize: 20,
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.w400,
      ),
    ),
  ];
  static List<Widget> actionsButtons = [
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.color_lens,
      onTap: () {
        Get.toNamed(
          PaintsViews.routeName,
          arguments: null,
        );
      },
      text: "Paints",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.message,
      onTap: () {
        Get.toNamed(AppConfig.CHAT_SCREEN, arguments: null);
      },
      text: "Chats",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.paste_outlined,
      onTap: () {
        Get.toNamed(AppConfig.CREATE_VISIT, arguments: null);
      },
      text: "Create Visit",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.timer_outlined,
      onTap: () {
        Get.toNamed(AppConfig.LEAVE_SCREEN);
      },
      text: "Apply for leave",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.factory_rounded,
      onTap: () {
        Get.toNamed(AppConfig.CREATE_SHOP_SCREEN);
      },
      text: "Create Shop",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.list_alt_rounded,
      onTap: () {
        Get.toNamed(AppConfig.ATTENDANCE_SCREEN);
      },
      text: "Attendance",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.timer_10_outlined,
      onTap: () {
        Get.toNamed(AppConfig.TODAY_REMINDERS);
      },
      text: "Today Reminder",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.content_paste_go_outlined,
      onTap: () {
        Get.toNamed(AppConfig.TODAY_VISIT_SCREEN);
      },
      text: "Today Visit",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.meeting_room_outlined,
      onTap: () {
        Get.toNamed(AppConfig.MEETING_SCREEN);
      },
      text: "Meetings",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.group_work,
      onTap: () {
        Get.toNamed(AppConfig.MYMEETINGS_SCREEN);
      },
      text: "My Meetings",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.add,
      onTap: () {
        Get.toNamed(AppConfig.CREATE_MEETING);
      },
      text: "Create Meetings",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.group,
      onTap: () {
        Get.toNamed(AppConfig.PROFILE);
      },
      text: "Profile & Teams",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.person_add_alt_1_rounded,
      onTap: () {
        Get.toNamed(AppConfig.DEALERSHIP_FORM);
      },
      text: "Create Dealer",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.location_history,
      onTap: () {
        Get.toNamed(AppConfig.TEAMSSCREEN);
      },
      text: "My Teams",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.help_center,
      onTap: () => Get.toNamed(AppConfig.HELP_SCREEN),
      text: "Help Center",
    ),
    CoolButton(
      backgroundColor: Colors.indigo.shade400,
      iconColor: Colors.white,
      textColor: Colors.black,
      icon: Icons.storage,
      onTap: () => Get.toNamed(AppConfig.LOCALDATABASE),
      text: "Local Database",
    ),
  ];

  static Color primaryColor7 = Colors.indigo.shade400;
  static Color primaryColor5 = Colors.indigo.shade500;
  static Color primaryColor8 = Colors.red.withOpacity(0.8);

  static String PRESENT = 'PRESENT';
  static String ABSENT = 'ABSENT';
  static String HALFDAY = 'HALFDAY';
  static String NOTMARKED = 'NOTMARKED';
  static String COMPLETE = 'COMPLETE';

  // ----------------DB NAMES------------------
  static String IMAGE_MODEL = 'IMAGE_MODEL';
  static String USERMODEL = 'USER_MODEL';
  static String USER_DB = 'USER';
  static String USER_IMAGE = 'USER_IMAGE';
  static String SHOP_MODEL = "SHOP";
  static String SHOP_PROFILE = "SHOP_IMAGE";
  static String SHOP_LOCATION = "SHOP_ADDRESS";
  static String PERSONAL_SHOP = "PERSONAL_SHOP";
  static String PERSONAL_SHOP_IMAGE = "PERSONAL_SHOP_IMAGE";
  static String PERSONAL_SHOP_ADDRESS = "PERSONAL_SHOP_ADDRESS";
  static String ATTENDANCE = "ATTENDANCE";
  static String START_COORDINATES = "START_COORDINATES";
  static String ODOMETER_USER = 'ODOMETER_USER';
  static String ODOMETERS = 'ODOMETERS';

  static String TEAM_PROFILE = "TEAM_PROFILE";
  static String TEAM_LOCATION = "TEAM_LOCATION";
  static String LAST_ACTIVE = "LAST_ACTIVE";
  static String TEAM_ODOMETERS = "TEAM_ODOMETERS";
  static String ODOMETER_LOCATION = "ODOMETER_LOCATION";
  static String TEAM_VISIT = "TEAM_VISIT";
  static String USER_TEAM = "USER_TEAM";
  static String USER_NOTIFICATION = 'USER_NOTIFICATION';

  static String VISIT_IMAGES = 'VISIT_IMAGES';
  static String VISIT_USER_LOCATION = 'VISIT_USER_LOCATION';
  static String VISIT_EMP = 'VISIT_EMP';
  static String VISIT_SHOP_MODEL = 'VISIT_SHOP_MODEL';
  static String VISIT_MODEL = 'VISIT_MODEL';

  static String REMINDER_SHOP = 'REMINDER_SHOP';
  static String REMINDER_EMP = 'REMINDER_EMP';
  static String REMINDER_VISIT_DB = 'REMINDER_VISIT_DB';
  static String REMINDER_MODEL = 'REMINDER_MODEL';

  static String CREATE_ODOMETER = 'CREATE_ODOMETER';
  static String LATLONG = 'LATLONG';

  static String SHOP_CREATE = 'SHOP_CREATE';
  static String SHOP_CREATE_LOCATION = 'SHOP_CREATE_LOCATION';
  static String VISIT_TYPE = 'VISIT_TYPE';
  static String VISIT_CREATE_DB = 'VISIT_CREATE_DB';

  // Meetings Database

  static String MEETING_USERS = 'MEETING_USERS';
  static String MEETING_USER_PROFILE = 'MEETING_USER_PROFILE';

  static String MEETING_MODEL = 'MEETING_MODEL';
  static String MEETING_SHOP = 'MEETING_SHOP';

  // Chats database
  static String CHAT_DATABASE = 'CHAT_DATABASE';

  static Future register() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MeetingShopAdapter());
    await Hive.openBox<MeetingShop>(AppConfig.MEETING_SHOP);
    Hive.registerAdapter(MeetingModelAdapter());
    await Hive.openBox<MeetingModel>(AppConfig.MEETING_MODEL);
    Hive.registerAdapter(UserProfileAdapter());
    await Hive.openBox<UserProfile>(MEETING_USER_PROFILE);
    Hive.registerAdapter(MeetingUserAdapter());
    await Hive.openBox<MeetingUser>(MEETING_USERS);
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<User>(AppConfig.USER_DB);
    Hive.registerAdapter(ImagesAdapter());
    await Hive.openBox<Images>(AppConfig.USER_IMAGE);
    Hive.registerAdapter<UserModel>(UserModelAdapter());
    await Hive.openBox<UserModel>(AppConfig.USERMODEL);
    Hive.registerAdapter(LocationsAdapter());
    await Hive.openBox<Locations>(AppConfig.SHOP_LOCATION);
    await Hive.openBox<Locations>(AppConfig.PERSONAL_SHOP_ADDRESS);
    Hive.registerAdapter(ProfileAdapter());
    await Hive.openBox<Profile>(AppConfig.SHOP_PROFILE);
    await Hive.openBox<Profile>(AppConfig.PERSONAL_SHOP_IMAGE);
    Hive.registerAdapter(ShopsAdapter());
    await Hive.openBox<Shops>(AppConfig.SHOP_MODEL);
    await Hive.openBox<Shops>(AppConfig.PERSONAL_SHOP);
    Hive.registerAdapter(AttendanceDataAdapter());
    await Hive.openBox<AttendanceData>(AppConfig.ATTENDANCE);
    Hive.registerAdapter(StartCoordinateAdapter());
    await Hive.openBox<StartCoordinate>(AppConfig.START_COORDINATES);
    Hive.registerAdapter(OdoMeterUserAdapter());
    await Hive.openBox<OdoMeterUser>(AppConfig.ODOMETER_USER);
    Hive.registerAdapter(OdometersAdapter());
    await Hive.openBox<Odometers>(AppConfig.ODOMETERS);
    Hive.registerAdapter(TeamProfileAdapter());
    await Hive.openBox<TeamProfile>(AppConfig.TEAM_PROFILE);
    Hive.registerAdapter(TeamLocationAdapter());
    await Hive.openBox<TeamLocation>(AppConfig.TEAM_LOCATION);
    Hive.registerAdapter(LastActiveAdapter());
    await Hive.openBox<LastActive>(AppConfig.LAST_ACTIVE);
    Hive.registerAdapter(TeamOdometersAdapter());
    await Hive.openBox<TeamOdometers>(AppConfig.TEAM_ODOMETERS);
    Hive.registerAdapter(OdometerLocationAdapter());
    await Hive.openBox<OdometerLocation>(AppConfig.ODOMETER_LOCATION);
    Hive.registerAdapter(TeamVisitsAdapter());
    await Hive.openBox<TeamVisits>(AppConfig.TEAM_VISIT);
    Hive.registerAdapter(UserTeamAdapter());
    await Hive.openBox<UserTeam>(AppConfig.USER_TEAM);
    Hive.registerAdapter(UserNotificationAdapter());
    await Hive.openBox<UserNotification>(AppConfig.USER_NOTIFICATION);
    Hive.registerAdapter(VisitImagesAdapter());
    await Hive.openBox<VisitImages>(AppConfig.VISIT_IMAGES);
    Hive.registerAdapter(UserLocationAdapter());
    await Hive.openBox<UserLocation>(AppConfig.VISIT_USER_LOCATION);
    Hive.registerAdapter(EmpAdapter());
    await Hive.openBox<Emp>(AppConfig.VISIT_EMP);
    Hive.registerAdapter(ShopModelAdapter());
    await Hive.openBox<ShopModel>(AppConfig.VISIT_SHOP_MODEL);
    Hive.registerAdapter(VisitModelAdapter());
    await Hive.openBox<VisitModel>(AppConfig.VISIT_MODEL);
    Hive.registerAdapter(ReminderShopAdapter());
    await Hive.openBox<ReminderShop>(AppConfig.REMINDER_SHOP);
    Hive.registerAdapter(ReminderEmpAdapter());
    await Hive.openBox<ReminderEmp>(AppConfig.REMINDER_EMP);
    Hive.registerAdapter(ReminderVisitAdapter());
    await Hive.openBox<ReminderVisit>(AppConfig.REMINDER_VISIT_DB);
    Hive.registerAdapter(RemindersAdapter());
    await Hive.openBox<Reminders>(AppConfig.REMINDER_MODEL);
    Hive.registerAdapter(LatLongAdapter());
    await Hive.openBox<LatLong>(AppConfig.LATLONG);
    Hive.registerAdapter(CreateOdometerModelAdapter());
    await Hive.openBox<CreateOdometerModel>(AppConfig.CREATE_ODOMETER);
    Hive.registerAdapter(LocationModelAdapter());
    await Hive.openBox<LocationModel>(AppConfig.SHOP_CREATE_LOCATION);
    Hive.registerAdapter(ShopCreateAdapter());
    await Hive.openBox<ShopCreate>(AppConfig.SHOP_CREATE);
    Hive.registerAdapter(VisitTypeAdapter());
    await Hive.openBox<VisitType>(AppConfig.VISIT_TYPE);
    Hive.registerAdapter(CreateReminderAdapter());
    await Hive.openBox<CreateReminder>("CREATE_REMINDER_BOX");
    Hive.registerAdapter(CreateVisitAdapter());
    await Hive.openBox<CreateVisit>(AppConfig.VISIT_CREATE_DB);
    Hive.registerAdapter(ImageModelAdapter());
    await Hive.openBox<ImageModel>(AppConfig.IMAGE_MODEL);
    Hive.registerAdapter(MessageAdapter());
    await Hive.openBox<Message>(AppConfig.CHAT_DATABASE);
    return;
  }
}
