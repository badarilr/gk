import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/song_page.dart';

class SongbookRepository {
  static Future<SongBook> load() async {
    final raw = await rootBundle.loadString('assets/data/songs_data_songbook.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return SongBook.fromJson(json);
  }
}
