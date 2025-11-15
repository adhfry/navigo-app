import 'package:get/get.dart';

import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/main/dashboard/bindings/dashboard_binding.dart';
import '../modules/main/dashboard/views/dashboard_view.dart';
import '../modules/main/profile/bindings/profile_binding.dart';
import '../modules/main/profile/views/profile_view.dart';
import '../modules/onboarding/get_started/bindings/get_started_binding.dart';
import '../modules/onboarding/get_started/views/get_started_view.dart';
import '../modules/auth/complete_profile/bindings/complete_profile_binding.dart';
import '../modules/auth/complete_profile/views/complete_profile_view.dart';
import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_view.dart';
import '../modules/schedule/bindings/schedule_binding.dart';
import '../modules/schedule/views/schedule_search_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/help/bindings/help_binding.dart';
import '../modules/help/views/help_view.dart';
import '../modules/schedule_detail/bindings/schedule_detail_binding.dart';
import '../modules/schedule_detail/views/schedule_detail_view.dart';
import '../modules/ticket/bindings/ticket_binding.dart';
import '../modules/ticket/views/ticket_view.dart';
import '../modules/jastip/bindings/jastip_binding.dart';
import '../modules/jastip/views/jastip_view.dart';
import '../modules/navisafe/bindings/navisafe_binding.dart';
import '../modules/navisafe/views/navisafe_view.dart';
import '../modules/traveler_verification/bindings/traveler_verification_binding.dart';
import '../modules/traveler_verification/views/traveler_verification_view.dart';
import '../modules/activity_detail/bindings/activity_detail_binding.dart';
import '../modules/activity_detail/views/activity_detail_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.getStarted,
      page: () => const GetStartedView(),
      binding: GetStartedBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.scheduleSearch,
      page: () => const ScheduleSearchView(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: _Paths.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.completeProfile,
      page: () => const CompleteProfileView(),
      binding: CompleteProfileBinding(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.help,
      page: () => const HelpView(),
      binding: HelpBinding(),
    ),
    GetPage(
      name: _Paths.scheduleDetail,
      page: () => const ScheduleDetailView(),
      binding: ScheduleDetailBinding(),
    ),
    GetPage(
      name: _Paths.ticket,
      page: () => const TicketView(),
      binding: TicketBinding(),
    ),
    GetPage(
      name: _Paths.jastip,
      page: () => const JastipView(),
      binding: JastipBinding(),
    ),
    GetPage(
      name: _Paths.navisafe,
      page: () => const NavisafeView(),
      binding: NavisafeBinding(),
    ),
    GetPage(
      name: _Paths.travelerVerification,
      page: () => const TravelerVerificationView(),
      binding: TravelerVerificationBinding(),
    ),
    GetPage(
      name: _Paths.activityDetail,
      page: () => const ActivityDetailView(),
      binding: ActivityDetailBinding(),
    ),
    GetPage(
      name: _Paths.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
  ];
}
