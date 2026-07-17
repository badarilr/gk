String? _readString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    if (value != null) {
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
  }
  return null;
}

class SongBook {
  final List<SongPage> pages;

  SongBook({required this.pages});

  factory SongBook.fromJson(dynamic json) {
    if (json is List) {
      return SongBook(
        pages: json
            .map((page) => SongPage.fromJson(page as Map<String, dynamic>))
            .toList(),
      );
    }

    final map = json as Map<String, dynamic>;
    final pagesJson = map['pages'] as List<dynamic>? ?? [];
    final songsJson = map['songs'] as List<dynamic>? ?? [];

    if (pagesJson.isNotEmpty) {
      return SongBook(
        pages: pagesJson
            .map((page) => SongPage.fromJson(page as Map<String, dynamic>))
            .toList(),
      );
    }

    return SongBook(
      pages: songsJson
          .map((song) => SongPage.fromJson(song as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SongPage {
  final String pageNumber;
  final String? sourceImage;
  final String? note;
  final String? title;
  final List<SongEntry> songs;

  SongPage({
    required this.pageNumber,
    this.sourceImage,
    this.note,
    this.title,
    required this.songs,
  });

  String get displayTitle {
    if (title != null && title!.trim().isNotEmpty) return title!.trim();
    if (songs.isEmpty) return pageNumber.isEmpty ? 'Song page' : 'Page $pageNumber';
    final first = songs.first.displayTitle;
    if (first.isNotEmpty) return first;
    return pageNumber.isEmpty ? 'Song page' : 'Page $pageNumber';
  }

  factory SongPage.fromJson(Map<String, dynamic> json) {
    final songsJson = json['songs'] is List
        ? json['songs'] as List<dynamic>
        : (json['song'] != null ? [json['song']] : null);
    final songItems = songsJson ?? [];
    final isFlatSong = json['stanzas'] != null || json['lines'] != null || json['lyrics'] != null;

    return SongPage(
      pageNumber: json['pageNumber']?.toString() ?? json['page']?.toString() ?? '',
      sourceImage: json['sourceImage'] as String? ?? json['image'] as String?,
      note: json['note'] as String?,
      title: _readString(json, ['title', 'songTitle', 'song_title', 'name', 'song_name', 'heading']),
      songs: (isFlatSong ? [json] : songItems)
          .map((song) => SongEntry.fromJson(song as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SongEntry {
  final String? title;
  final String? raag;
  final String? taal;
  final String? attribution;
  final String? note;
  final List<SongStanza> stanzas;

  SongEntry({
    this.title,
    this.raag,
    this.taal,
    this.attribution,
    this.note,
    required this.stanzas,
  });

  String get displayTitle {
    if (title != null && title!.trim().isNotEmpty) return title!.trim();
    final parts = <String>[];
    if (raag != null && raag!.trim().isNotEmpty) parts.add(raag!.trim());
    if (taal != null && taal!.trim().isNotEmpty) parts.add(taal!.trim());
    if (attribution != null && attribution!.trim().isNotEmpty) parts.add(attribution!.trim());
    return parts.isEmpty ? '' : parts.join(' • ');
  }

  factory SongEntry.fromJson(Map<String, dynamic> json) {
    final stanzasJson = json['stanzas'] as List<dynamic>? ?? [];
    final lyricList = json['lyrics'] as List<dynamic>? ?? [];
    final stanzaItems = (stanzasJson.isEmpty && lyricList.isNotEmpty)
        ? [json]
        : stanzasJson;

    return SongEntry(
      title: _readString(json, ['title', 'songTitle', 'song_title', 'name', 'song_name', 'heading']),
      raag: _readString(json, ['raag', 'raga']),
      taal: _readString(json, ['taal', 'tala']),
      attribution: _readString(json, ['attribution', 'credit', 'composer', 'source']),
      note: _readString(json, ['note']),
      stanzas: stanzaItems
          .map((stanza) => SongStanza.fromJson(stanza as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SongStanza {
  final bool marked;
  final List<String> lines;

  SongStanza({required this.marked, required this.lines});

  factory SongStanza.fromJson(Map<String, dynamic> json) {
    final linesJson = json['lines'] as List<dynamic>? ?? [];
    final lyricLines = json['lyrics'] as List<dynamic>? ?? [];
    final textLines = json['text'] as List<dynamic>? ?? [];
    final rawLines = linesJson.isNotEmpty
        ? linesJson
        : (lyricLines.isNotEmpty ? lyricLines : textLines);
    return SongStanza(
      marked: json['marked'] as bool? ?? false,
      lines: rawLines.map((line) => line.toString()).toList(),
    );
  }
}
