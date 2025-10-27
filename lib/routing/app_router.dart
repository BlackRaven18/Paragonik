// app_router.dart

import 'package:go_router/go_router.dart';
import 'package:paragonik/data/services/image_processing_service.dart';
import 'package:paragonik/data/services/ocr_service.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:paragonik/data/services/store_service.dart';
import 'package:paragonik/data/services/thumbnail_service.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';
import 'package:paragonik/notifiers/store_notifier.dart';
import 'package:paragonik/ui/core/base_scaffold.dart';
import 'package:paragonik/ui/screens/camera/camera_screen.dart';
import 'package:paragonik/ui/screens/receipts/receipt_edit_screen.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen.dart';
import 'package:paragonik/ui/screens/settings/settings_screen.dart';
import 'package:paragonik/ui/screens/stats/stats_screen.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:paragonik/view_models/screens/receipts/receipt_edit_view_model.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:provider/provider.dart';

final GoRouter router = GoRouter(
  initialLocation: '/camera',
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
            Provider<ThumbnailService>(create: (_) => ThumbnailService()),

            Provider<OcrService>(
              create: (context) => OcrService(
                context.read<StoreService>(),
                context.read<ImageProcessingService>(),
              ),
            ),
            ChangeNotifierProvider<ReceiptNotifier>(
              create: (context) => ReceiptNotifier(
                context.read<ReceiptService>(),
                context.read<ThumbnailService>(),
              ),
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
              builder: (context, state) {
                return ChangeNotifierProvider(
                  create: (context) => CameraViewModel(
                    ocrService: context.read<OcrService>(),
                    receiptNotifier: context.read<ReceiptNotifier>(),
                  ),
                  child: const CameraScreen(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/receipts',
              builder: (context, state) {
                return ChangeNotifierProvider(
                  create: (context) =>
                      ReceiptsViewModel(context.read<ReceiptNotifier>()),
                  child: const ReceiptsScreen(),
                );
              },
              routes: [
                GoRoute(
                  path: 'edit/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return ChangeNotifierProvider(
                      create: (context) => ReceiptEditViewModel(
                        receiptId: id,
                        receiptService: context.read<ReceiptService>(),
                        receiptNotifier: context.read<ReceiptNotifier>(),
                      ),
                      child: const ReceiptEditScreen(),
                    );
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
