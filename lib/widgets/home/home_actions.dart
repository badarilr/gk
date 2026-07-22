import 'package:url_launcher/url_launcher.dart';

/// Shared launch helpers used by home widgets (channels, WhatsApp share).
class HomeActions {
  HomeActions._();

  static Future<void> launchChannel(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  static Future<void> sharePracticeItem(String name) async {
    final message = Uri.encodeComponent('Practice update: $name');
    await launchUrl(
      Uri.parse('https://wa.me/?text=$message'),
      mode: LaunchMode.externalApplication,
    );
  }
}
