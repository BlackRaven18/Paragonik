
import 'package:go_router/go_router.dart';
import 'package:paragonik/data/services/ocr_service.dart';
import 'package:paragonik/ui/core/base_scaffold.dart';
import 'package:paragonik/ui/screens/camera_screen.dart';
import 'package:paragonik/ui/screens/receipts_screen.dart';
import 'package:paragonik/ui/screens/settings_screen.dart';
import 'package:paragonik/ui/screens/stats_screen.dart';
import 'package:provider/provider.dart';

final GoRouter router = GoRouter(
  initialLocation: '/camera',
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
              builder: (context, state) {
                return Provider<OcrService>(
                  create: (_) => OcrService(),
                  child: const CameraScreen(),
                );
              }
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