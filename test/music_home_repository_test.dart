import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gk/services/music_home_repository.dart';

void main() {
  test('loads announcements and events from the bundled local asset', () async {
    final bundle = _RecordingAssetBundle();

    final data = await MusicHomeRepository.load(bundle: bundle);

    expect(bundle.requestedKey, MusicHomeRepository.localAssetPath);
    expect(bundle.requestedKey, isNot(startsWith('http')));
    expect(bundle.requestedKey, isNot(contains('github')));
    expect(data.announcements.single.title, 'Local announcement');
    expect(data.events.single.title, 'Local event');
  });
}

class _RecordingAssetBundle extends CachingAssetBundle {
  String? requestedKey;

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    requestedKey = key;
    return jsonEncode({
      'announcements': [
        {
          'id': 1,
          'title': 'Local announcement',
          'description': 'Loaded from app assets.',
          'date': '2026-07-16',
          'type': 'info',
        },
      ],
      'events': [
        {
          'id': 1,
          'title': 'Local event',
          'date': '2026-07-16',
          'location': 'Local',
          'description': 'Loaded from app assets.',
        },
      ],
    });
  }

  @override
  Future<ByteData> load(String key) async => ByteData(0);
}
