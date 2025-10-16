
import 'package:go_router/go_router.dart';
import 'package:paragonik/ui/core/base_scaffold.dart';
import 'package:paragonik/ui/screens/camera_screen.dart';
import 'package:paragonik/ui/screens/receipts_screen.dart';
import 'package:paragonik/ui/screens/settings_screen.dart';
import 'package:paragonik/ui/screens/stats_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/receipts',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BaseScaffold(child: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/camera',
              builder: (context, state) => const CameraScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/receipts',
              builder: (context, state) => const ReceiptsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const StatsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);