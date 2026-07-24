import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/guitar/presentation/guitar_tuner_screen.dart';
import '../features/ukulele/presentation/ukulele_tuner_screen.dart';
import '../features/yangqin/presentation/yangqin_tuner_screen.dart';
import '../features/tuning_library/tuning_library_screen.dart';
import '../features/pro/pro_screen.dart';
import '../features/privacy/privacy_screen.dart';
import '../features/support/support_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/orders/orders_screen.dart';

/// App router configuration
/// Routes match the existing Vue project
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Free tuning pages - no auth required
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/guitar',
      name: 'guitar',
      builder: (context, state) => const GuitarTunerScreen(),
    ),
    GoRoute(
      path: '/ukulele',
      name: 'ukulele',
      builder: (context, state) => const UkuleleTunerScreen(),
    ),
    GoRoute(
      path: '/yangqin',
      name: 'yangqin',
      builder: (context, state) => const YangqinTunerScreen(),
    ),
    GoRoute(
      path: '/tuning-library',
      name: 'tuning-library',
      builder: (context, state) => const TuningLibraryScreen(),
    ),

    // Public info pages
    GoRoute(
      path: '/pro',
      name: 'pro',
      builder: (context, state) => const ProScreen(),
    ),
    GoRoute(
      path: '/privacy',
      name: 'privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
    GoRoute(
      path: '/support',
      name: 'support',
      builder: (context, state) => const SupportScreen(),
    ),

    // Login page
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Auth required pages
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (context, state) => const OrdersScreen(),
    ),
  ],
  redirect: (context, state) {
    // VIP redirect to Pro
    if (state.uri.path == '/vip') {
      return '/pro';
    }

    // Auth check for protected routes
    final authRequired =
        state.uri.path == '/profile' || state.uri.path == '/orders';

    if (authRequired) {
      // TODO: Check auth state from Riverpod
      final token = ''; // placeholder
      if (token.isEmpty) {
        return '/login';
      }
    }

    return null;
  },
);
