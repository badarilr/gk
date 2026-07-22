import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

/// Full-screen celebration overlay shown above the current screen via [OverlayEntry].
///
/// Usage:
/// ```dart
/// CelebrationOverlay.show(context, title: 'SUPER BUZZER!');
/// ```
///
/// Optional assets (skipped gracefully when missing):
/// - `assets/animations/fireworks.json` — Lottie behind the title
/// - `assets/audio/applause.mp3` — one-shot applause
class CelebrationOverlay {
  CelebrationOverlay._();

  static const Duration displayDuration = Duration(seconds: 4);
  static const String fireworksAsset = 'assets/animations/fireworks.json';
  static const String applauseAsset = 'assets/audio/applause.mp3';

  static OverlayEntry? _activeEntry;

  /// Inserts a celebration overlay above the root [Overlay].
  ///
  /// Automatically dismisses after [displayDuration]. Safe to call repeatedly;
  /// a previous celebration is removed first.
  static void show(
    BuildContext context, {
    required String title,
  }) {
    final overlay = _resolveOverlay(context);
    if (overlay == null) {
      debugPrint('CelebrationOverlay: no Overlay found for context');
      return;
    }

    dismiss();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) {
        // Positioned.fill ensures the entry paints over the full screen
        // inside the root Overlay Stack (including above bottom navigation).
        return Positioned.fill(
          child: _CelebrationOverlayBody(
            title: title,
            onFinished: () => _removeEntry(entry),
          ),
        );
      },
    );

    _activeEntry = entry;
    overlay.insert(entry);
  }

  /// Prefer the root navigator overlay so nested Scaffolds cannot hide effects.
  static OverlayState? _resolveOverlay(BuildContext context) {
    final rootNavigator = Navigator.maybeOf(context, rootNavigator: true);
    if (rootNavigator?.overlay != null) {
      return rootNavigator!.overlay;
    }

    final localNavigator = Navigator.maybeOf(context);
    if (localNavigator?.overlay != null) {
      return localNavigator!.overlay;
    }

    return Overlay.maybeOf(context, rootOverlay: true) ??
        Overlay.maybeOf(context);
  }

  /// Removes the active celebration overlay, if any.
  static void dismiss() {
    final entry = _activeEntry;
    _activeEntry = null;
    if (entry != null && entry.mounted) {
      entry.remove();
    }
  }

  static void _removeEntry(OverlayEntry entry) {
    if (_activeEntry == entry) {
      _activeEntry = null;
    }
    if (entry.mounted) {
      entry.remove();
    }
  }
}

class _CelebrationOverlayBody extends StatefulWidget {
  final String title;
  final VoidCallback onFinished;

  const _CelebrationOverlayBody({
    required this.title,
    required this.onFinished,
  });

  @override
  State<_CelebrationOverlayBody> createState() =>
      _CelebrationOverlayBodyState();
}

class _CelebrationOverlayBodyState extends State<_CelebrationOverlayBody> {
  late final ConfettiController _centerController;
  late final ConfettiController _leftController;
  late final ConfettiController _rightController;
  AudioPlayer? _audioPlayer;
  Timer? _dismissTimer;

  bool _hasFireworks = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _centerController = ConfettiController(
      duration: CelebrationOverlay.displayDuration,
    );
    _leftController = ConfettiController(
      duration: CelebrationOverlay.displayDuration,
    );
    _rightController = ConfettiController(
      duration: CelebrationOverlay.displayDuration,
    );

    // Start after the first frame so particle layout has a real size.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _finished) return;
      _centerController.play();
      _leftController.play();
      _rightController.play();
    });

    _dismissTimer = Timer(CelebrationOverlay.displayDuration, _finish);
    unawaited(_bootstrapOptionalMedia());
  }

  Future<void> _bootstrapOptionalMedia() async {
    final results = await Future.wait<bool>([
      _assetExists(CelebrationOverlay.fireworksAsset),
      _assetExists(CelebrationOverlay.applauseAsset),
    ]);

    if (!mounted || _finished) {
      return;
    }

    final hasFireworks = results[0];
    final hasApplause = results[1];

    if (hasFireworks) {
      setState(() => _hasFireworks = true);
    }

    if (hasApplause) {
      await _playApplauseOnce();
    }
  }

  Future<void> _playApplauseOnce() async {
    if (!mounted || _finished) {
      return;
    }

    try {
      final player = AudioPlayer();
      _audioPlayer = player;
      await player.setReleaseMode(ReleaseMode.stop);
      await player.play(AssetSource('audio/applause.mp3'));
    } catch (_) {
      // Missing or unplayable asset — continue without sound.
    }
  }

  Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _finish() {
    if (_finished) {
      return;
    }
    _finished = true;
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _centerController.stop();
    _leftController.stop();
    _rightController.stop();
    widget.onFinished();
  }

  Future<void> _disposeAudioPlayer() async {
    final player = _audioPlayer;
    _audioPlayer = null;
    if (player == null) {
      return;
    }
    try {
      await player.stop();
    } catch (_) {
      // Ignore stop failures during teardown.
    }
    try {
      await player.dispose();
    } catch (_) {
      // Ignore dispose failures during teardown.
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _centerController.dispose();
    _leftController.dispose();
    _rightController.dispose();
    unawaited(_disposeAudioPlayer());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = size.width < 360 ? 16.0 : 32.0;
    final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          shadows: const [
            Shadow(
              color: Colors.black54,
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        );

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Dim scrim — tap to dismiss early.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _finish,
              child: const ColoredBox(
                color: Color(0x8C000000),
              ),
            ),
          ),

          // Optional Lottie fireworks behind the title.
          if (_hasFireworks)
            Positioned.fill(
              child: IgnorePointer(
                child: Lottie.asset(
                  CelebrationOverlay.fireworksAsset,
                  fit: BoxFit.cover,
                  repeat: true,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),

          // Confetti cannons — full-width layer so particles are visible.
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _centerController,
                      blastDirectionality: BlastDirectionality.explosive,
                      emissionFrequency: 0.06,
                      numberOfParticles: 28,
                      maxBlastForce: 35,
                      minBlastForce: 12,
                      gravity: 0.16,
                      shouldLoop: false,
                      colors: _confettiColors,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ConfettiWidget(
                      confettiController: _leftController,
                      blastDirection: 0, // rightward
                      emissionFrequency: 0.05,
                      numberOfParticles: 16,
                      maxBlastForce: 30,
                      minBlastForce: 10,
                      gravity: 0.18,
                      shouldLoop: false,
                      colors: _confettiColors,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ConfettiWidget(
                      confettiController: _rightController,
                      blastDirection: math.pi, // leftward
                      emissionFrequency: 0.05,
                      numberOfParticles: 16,
                      maxBlastForce: 30,
                      minBlastForce: 10,
                      gravity: 0.18,
                      shouldLoop: false,
                      colors: _confettiColors,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Centered title with responsive padding.
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: titleStyle,
                  )
                      .animate()
                      .fadeIn(duration: 350.ms, curve: Curves.easeOut)
                      .scale(
                        begin: const Offset(0.6, 0.6),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      )
                      .then()
                      .shimmer(
                        duration: 1200.ms,
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _confettiColors = [
    Color(0xFFFFD54F),
    Color(0xFFFF7043),
    Color(0xFF42A5F5),
    Color(0xFF66BB6A),
    Color(0xFFAB47BC),
    Color(0xFFEF5350),
  ];
}
