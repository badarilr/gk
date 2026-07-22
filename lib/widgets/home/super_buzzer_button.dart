import 'package:flutter/material.dart';

import '../celebration_overlay.dart';

/// Full-width Material 3 button that launches the celebration overlay.
class SuperBuzzerButton extends StatelessWidget {
  final String title;

  const SuperBuzzerButton({
    super.key,
    this.title = 'SUPER BUZZER!',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () {
            CelebrationOverlay.show(context, title: title);
          },
          icon: const Icon(Icons.celebration),
          label: Text(title),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
          ),
        ),
      ),
    );
  }
}
