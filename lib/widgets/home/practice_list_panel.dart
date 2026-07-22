import 'package:flutter/material.dart';

import '../celebration_overlay.dart';
import 'home_actions.dart';
import 'practice_item.dart';
import 'practice_list_row.dart';

/// Home practice checklist card with share-to-WhatsApp actions.
class PracticeListPanel extends StatefulWidget {
  const PracticeListPanel({super.key});

  @override
  State<PracticeListPanel> createState() => _PracticeListPanelState();
}

class _PracticeListPanelState extends State<PracticeListPanel> {
  final List<PracticeItem> _items = [
    PracticeItem('song name'),
    PracticeItem('song name'),
    PracticeItem('song name'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: colorScheme.primaryContainer,
            child: Text(
              'practice makes perfect',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[new] practice list',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    for (var index = 0; index < _items.length; index++) ...[
                      PracticeListRow(
                        item: _items[index],
                        onChanged: (value) {
                          final done = value ?? false;
                          setState(() => _items[index].done = done);
                          if (done) {
                            CelebrationOverlay.show(
                              context,
                              title: 'SUPER BUZZER!',
                            );
                          }
                        },
                        onShare: () async {
                          await HomeActions.sharePracticeItem(
                            _items[index].name,
                          );
                          if (!mounted) return;
                          setState(() => _items[index].sent = true);
                        },
                      ),
                      if (index < _items.length - 1)
                        Divider(
                          height: 1,
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.7,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
