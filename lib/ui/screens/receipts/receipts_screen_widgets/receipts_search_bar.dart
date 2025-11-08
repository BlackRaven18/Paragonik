import 'package:flutter/material.dart';
import 'package:paragonik/extensions/localization_extensions.dart';

class ReceiptsSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const ReceiptsSearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: context.l10n.screensReceiptsReceiptsScreenWidgetsSearchLabel,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
