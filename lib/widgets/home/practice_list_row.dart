import 'package:flutter/material.dart';

import 'practice_item.dart';

/// One practice list row: name, done checkbox, and WhatsApp share action.
class PracticeListRow extends StatelessWidget {
  final PracticeItem item;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onShare;

  const PracticeListRow({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                decoration: item.done ? TextDecoration.lineThrough : null,
                color: item.done
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurface,
              ),
            ),
          ),
          Checkbox(
            value: item.done,
            onChanged: onChanged,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          IconButton(
            tooltip: 'Send on WhatsApp',
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            onPressed: onShare,
            icon: Icon(
              Icons.chat_outlined,
              color: item.sent
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 88, maxWidth: 110),
            child: Text(
              item.sent ? 'sent on whatsapp' : 'send on whatsapp',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: item.sent
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
