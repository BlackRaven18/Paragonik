import 'package:flutter/material.dart';
import 'package:paragonik/notifiers/store_notifier.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/modals/filter_modal_content.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:paragonik/view_models/widgets/modals/store_selection_view_model.dart';
import 'package:provider/provider.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.filter_list,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: context.read<ReceiptsViewModel>(),
              ),
              ChangeNotifierProvider(
                create: (context) =>
                    StoreSelectionViewModel(context.read<StoreNotifier>()),
              ),
            ],
            child: const FilterModalContent(),
          ),
        );
      },
    );
  }
}
