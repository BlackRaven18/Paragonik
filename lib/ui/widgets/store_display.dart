import 'package:flutter/material.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/notifiers/store_notifier.dart';
import 'package:provider/provider.dart';

class StoreDisplay extends StatelessWidget {
  final String storeName;
  final TextStyle? textStyle;

  const StoreDisplay({required this.storeName, this.textStyle, super.key});

  @override
  Widget build(BuildContext context) {
    final storeNotifier = context.watch<StoreNotifier>();

    final displayName = storeName.isEmpty
        ? context.l10n.widgetsStoreDisplayUnknownStore
        : storeName;

    if (storeNotifier.isLoading) {
      return Text(
        displayName,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
      );
    }

    final store = storeNotifier.getStoreByName(storeName);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (store.iconPath != null) ...[
          Image.asset(store.iconPath!, width: 36, height: 36),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            displayName,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
