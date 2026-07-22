import 'package:flutter/material.dart';

import '../../screens/home_sections_screen.dart';
import '../celebration_overlay.dart';
import 'home_drawer.dart';
import 'practice_list_panel.dart';
import 'super_buzzer_button.dart';

/// Primary home tab body: sections, practice panel, and celebration CTA.
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static const double _maxContentWidth = 720;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goonjan Kala Kendra'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Celebrate',
            icon: const Icon(Icons.celebration_outlined),
            onPressed: () {
              CelebrationOverlay.show(
                context,
                title: 'SUPER BUZZER!',
              );
            },
          ),
        ],
      ),
      drawer: const HomeDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 600;
            final horizontalPadding = wide ? 24.0 : 16.0;
            final verticalPadding = wide ? 20.0 : 16.0;

            // Extra bottom inset keeps SUPER BUZZER clear of the parent
            // bottom NavigationBar (Songs / Ragas tabs).
            final bottomPadding = verticalPadding + 32;

            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  verticalPadding,
                  horizontalPadding,
                  bottomPadding,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeSectionsContent(
                        showHeader: false,
                        showEvents: false,
                        showPractice: false,
                      ),
                      SizedBox(height: 20),
                      PracticeListPanel(),
                      SizedBox(height: 28),
                      SuperBuzzerButton(),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
