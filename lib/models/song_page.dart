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

  List<SongBookSong> get songs {
    final items = <SongBookSong>[];
    for (final page in pages) {
      for (var i = 0; i < page.songs.length; i++) {
        items.add(
          SongBookSong(
            pageNumber: page.pageNumber,
            sourceImage: page.sourceImage,
            pageNote: page.note,
            pageTitle: page.title,
            song: page.songs[i],
            songIndexOnPage: i + 1,
            totalSongsOnPage: page.songs.length,
            fallbackIndex: items.length + 1,
          ),
        );
      }
    }

    items.sort((a, b) {
      final aNo = a.song.indexNo;
      final bNo = b.song.indexNo;
      if (aNo != null && bNo != null) return aNo.compareTo(bNo);
      if (aNo != null) return -1;
      if (bNo != null) return 1;
      return a.fallbackIndex.compareTo(b.fallbackIndex);
    });

    return items;
  }

  static const _availableSongSourceImages = {
    'assets/songs/page_001.jpg',
    'assets/songs/page_001A.jpg',
    'assets/songs/page_002.jpg',
    'assets/songs/page_003.jpg',
    'assets/songs/page_004.jpg',
    'assets/songs/page_005.jpg',
    'assets/songs/page_006.jpg',
    'assets/songs/page_007.jpg',
    'assets/songs/page_008.jpg',
    'assets/songs/page_009.jpg',
    'assets/songs/page_010.jpg',
    'assets/songs/page_011.jpg',
    'assets/songs/page_012.jpg',
    'assets/songs/page_013.jpg',
    'assets/songs/page_014.jpg',
    'assets/songs/page_015.jpg',
    'assets/songs/page_016.jpg',
    'assets/songs/page_017.jpg',
    'assets/songs/page_018.jpg',
    'assets/songs/page_019.jpg',
    'assets/songs/page_020.jpg',
    'assets/songs/page_021.jpg',
    'assets/songs/page_022.jpg',
    'assets/songs/page_023.jpg',
  };

  static String? normalizeSongSourceImage(String? sourceImage) {
    if (sourceImage == null || sourceImage.trim().isEmpty) return null;
    final path = sourceImage.trim();
    return _availableSongSourceImages.contains(path) ? path : null;
  }

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

class SongBookSong {
  final String pageNumber;
  final String? sourceImage;
  final String? pageNote;
  final String? pageTitle;
  final SongEntry song;
  final int songIndexOnPage;
  final int totalSongsOnPage;
  final int fallbackIndex;

  SongBookSong({
    required this.pageNumber,
    this.sourceImage,
    this.pageNote,
    this.pageTitle,
    required this.song,
    required this.songIndexOnPage,
    required this.totalSongsOnPage,
    required this.fallbackIndex,
  });

  String get indexLabel => song.indexNo?.toString() ?? '$fallbackIndex';

  String get pageLabel {
    final base = pageNumber.isEmpty ? 'Page' : 'Page $pageNumber';
    if (totalSongsOnPage <= 1) return base;
    return '$base ($songIndexOnPage/$totalSongsOnPage)';
  }

  String get displayTitle {
    final songTitle = song.displayTitle;
    if (songTitle.isNotEmpty) return songTitle;

    for (final stanza in song.stanzas) {
      for (final line in stanza.lines) {
        final text = line.trim();
        if (text.isNotEmpty) return text;
      }
    }

    if (pageTitle != null && pageTitle!.trim().isNotEmpty) {
      return pageTitle!.trim();
    }

    return pageLabel;
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
    if (songs.isEmpty) {
      return pageNumber.isEmpty ? 'Song page' : 'Page $pageNumber';
    }
    final first = songs.first.displayTitle;
    if (first.isNotEmpty) return first;
    return pageNumber.isEmpty ? 'Song page' : 'Page $pageNumber';
  }

  factory SongPage.fromJson(Map<String, dynamic> json) {
    final songsJson = json['songs'] is List
        ? json['songs'] as List<dynamic>
        : (json['song'] != null ? [json['song']] : null);
    final songItems = songsJson ?? [];
    final isFlatSong =
        json['stanzas'] != null ||
        json['lines'] != null ||
        json['lyrics'] != null;

    return SongPage(
      pageNumber:
          json['pageNumber']?.toString() ?? json['page']?.toString() ?? '',
      sourceImage: SongBook.normalizeSongSourceImage(
        json['sourceImage'] as String? ?? json['image'] as String?,
      ),
      note: json['note'] as String?,
      title: _readString(json, [
        'title',
        'titke',
        'songTitle',
        'songTitke',
        'song_title',
        'name',
        'song_name',
        'heading',
      ]),
      songs: (isFlatSong ? [json] : songItems)
          .map((song) => SongEntry.fromJson(song as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SongEntry {
  final int? indexNo;
  final String? indexTitle;
  final String? title;
  final String? raag;
  final String? taal;
  final String? attribution;
  final String? note;
  final List<SongStanza> stanzas;

  SongEntry({
    this.indexNo,
    this.indexTitle,
    this.title,
    this.raag,
    this.taal,
    this.attribution,
    this.note,
    required this.stanzas,
  });

  String get displayTitle {
    if (indexTitle != null && indexTitle!.trim().isNotEmpty) {
      return indexTitle!.trim();
    }
    if (title != null && title!.trim().isNotEmpty) {
      return title!.trim();
    }
    return '';
  }

  factory SongEntry.fromJson(Map<String, dynamic> json) {
    final stanzasJson = json['stanzas'] as List<dynamic>? ?? [];
    final lyricList = json['lyrics'] as List<dynamic>? ?? [];
    final stanzaItems = (stanzasJson.isEmpty && lyricList.isNotEmpty)
        ? [json]
        : stanzasJson;

    return SongEntry(
      indexNo: int.tryParse(json['indexNo']?.toString() ?? ''),
      indexTitle: _readString(json, [
        'indexTitle',
        'indexTitke',
        'index_title',
        'index_titke',
        'indexName',
        'index_name',
      ]),
      title: _readString(json, [
        'title',
        'titke',
        'songTitle',
        'songTitke',
        'song_title',
        'name',
        'song_name',
        'heading',
      ]),
      raag: _readString(json, ['raag', 'raga']),
      taal: _readString(json, ['taal', 'tala']),
      attribution: _readString(json, [
        'attribution',
        'credit',
        'composer',
        'source',
      ]),
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
