import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/raag_page.dart';

/// Loads assets/data/raagbook.json and hands back a parsed RaagBook.
/// Call RaagbookRepository.load() from a FutureBuilder or during app init.
class RaagbookRepository {
  static Future<RaagBook> load() async {
    final raw = await rootBundle.loadString('assets/data/raagbook.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return RaagBook.fromJson(json);
  }
}
