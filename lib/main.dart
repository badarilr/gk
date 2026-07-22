import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Flutter error: ${details.exception}');
  };

  runApp(const RaagbookApp());
}

class RaagbookApp extends StatelessWidget {
  const RaagbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E5A9D),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Goonjan Kala Kendra',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: colorScheme.surfaceTint,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 0,
          backgroundColor: colorScheme.surfaceContainer,
          indicatorColor: colorScheme.secondaryContainer,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            );
          }),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: colorScheme.outlineVariant,
          space: 1,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
