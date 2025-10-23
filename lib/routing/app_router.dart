// app_router.dart

import 'package:go_router/go_router.dart';
import 'package:paragonik/data/services/image_processing_service.dart';
import 'package:paragonik/data/services/ocr_service.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:paragonik/data/services/store_service.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';
import 'package:paragonik/notifiers/store_notifier.dart';
import 'package:paragonik/ui/core/base_scaffold.dart';
import 'package:paragonik/ui/screens/camera/camera_screen.dart';
import 'package:paragonik/ui/screens/camera2/camera_screen_2.dart';
import 'package:paragonik/ui/screens/receipts/receipt_edit_screen.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen.dart';
import 'package:paragonik/ui/screens/settings_screen.dart';
import 'package:paragonik/ui/screens/stats_screen.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:provider/provider.dart';

final GoRouter router = GoRouter(
  initialLocation: '/camera2',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MultiProvider(
          providers: [
            Provider<ImageProcessingService>(
              create: (_) => ImageProcessingService(),
            ),
            Provider<ReceiptService>(create: (_) => ReceiptService()),
            Provider<StoreService>(create: (_) => StoreService()),

            Provider<OcrService>(
              create: (context) => OcrService(
                context.read<StoreService>(),
                context.read<ImageProcessingService>(),
              ),
            ),
            ChangeNotifierProvider<ReceiptNotifier>(
              create: (context) =>
                  ReceiptNotifier(context.read<ReceiptService>()),
            ),
            ChangeNotifierProvider<StoreNotifier>(
              create: (context) => StoreNotifier(context.read<StoreService>()),
            ),
          ],
          child: BaseScaffold(child: navigationShell),
        );
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
              path: '/camera2',
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) => CameraViewModel(),
                child: CameraScreen2(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/receipts',
              builder: (context, state) => const ReceiptsScreen(),
              routes: [
                GoRoute(
                  path: 'edit/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return ReceiptEditScreen(receiptId: id);
                  },
                ),
              ],
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
