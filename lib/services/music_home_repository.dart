import 'dart:convert';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import '../models/music_home_data.dart';

class MusicHomeRepository {
  static const localAssetPath = 'assets/data/music_home.json';

  static Future<MusicHomeData> load({AssetBundle? bundle}) async {
    final raw = await (bundle ?? rootBundle).loadString(localAssetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return MusicHomeData.fromJson(json);
  }
}
