// Models matching assets/data/raagbook.json.
// Keep these in sync if you change the JSON shape later.

class IndexEntry {
  final int no;
  final String title;
  final int page;

  IndexEntry({required this.no, required this.title, required this.page});

  factory IndexEntry.fromJson(Map<String, dynamic> json) {
    return IndexEntry(
      no: json['no'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      page: json['page'] as int? ?? 0,
    );
  }
}

class RaagBook {
  final List<RaagPage> pages;
  final Map<String, List<int>> raagIndex;
  final List<IndexEntry> indexEntries;

  RaagBook({required this.pages, required this.raagIndex, required this.indexEntries});

  factory RaagBook.fromJson(Map<String, dynamic> json) {
    final pagesJson = json['pages'] as List<dynamic>;
    final raagIndexJson = json['raagIndex'] as Map<String, dynamic>? ?? {};
    final indexJson = json['index'] as List<dynamic>? ?? [];

    return RaagBook(
      pages: pagesJson
          .map((p) => RaagPage.fromJson(p as Map<String, dynamic>))
          .toList(),
      raagIndex: raagIndexJson.map(
        (key, value) => MapEntry(key, List<int>.from(value as List)),
      ),
      indexEntries: indexJson
          .map((entry) => IndexEntry.fromJson(entry as Map<String, dynamic>))
          .toList(),
    );
  }

  /// All pages belonging to a raag, in page order.
  List<RaagPage> pagesForRaag(String raagName) {
    final normalizedName = raagName.trim().toLowerCase();
    final matchedKey = raagIndex.keys.firstWhere(
      (key) => key.toLowerCase() == normalizedName,
      orElse: () => '',
    );
    final numbers = matchedKey.isEmpty ? <int>[] : raagIndex[matchedKey] ?? [];

    return pages.where((p) => numbers.contains(p.pageNumber)).toList()
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
  }

  /// Resolve the pages for an index entry using the index page number when
  /// the raaga lookup map is absent or incomplete.
  List<RaagPage> pagesForIndexEntry(IndexEntry entry) {
    final byRaag = pagesForRaag(entry.title);
    if (byRaag.isNotEmpty) return byRaag;

    final matchingPage = pages.where((p) => p.pageNumber == entry.page).toList();
    if (matchingPage.isNotEmpty) return matchingPage;

    final normalizedTitle = entry.title.trim().toLowerCase();
    final titleMatch = pages.where((p) {
      final title = p.title.trim().toLowerCase();
      return title.contains(normalizedTitle) || normalizedTitle.contains(title);
    }).toList()
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
    return titleMatch;
  }

  RaagPage? pageByNumber(int number) {
    try {
      return pages.firstWhere((p) => p.pageNumber == number);
    } catch (_) {
      return null;
    }
  }
}

class RaagPage {
  final int pageNumber;
  final String title;
  final String? raag;
  final String? status; // e.g. "pending_verification"
  final String? note;
  final String? sourceImage;
  final List<PageBlock> blocks;

  RaagPage({
    required this.pageNumber,
    required this.title,
    this.raag,
    this.status,
    this.note,
    this.sourceImage,
    required this.blocks,
  });

  bool get needsVerification => status == 'pending_verification';

  factory RaagPage.fromJson(Map<String, dynamic> json) {
    final blocksJson = json['blocks'] as List<dynamic>? ?? [];
    return RaagPage(
      pageNumber: json['pageNumber'] as int,
      title: json['title'] as String? ?? '',
      raag: json['raag'] as String?,
      status: json['status'] as String?,
      note: json['note'] as String?,
      sourceImage: json['sourceImage'] as String?,
      blocks: blocksJson
          .map((b) => PageBlock.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// A single content block on a page: header info, a swara grid,
/// a grid with matched lyrics, or a plain text note.
class PageBlock {
  final String type; // "header" | "grid" | "grid_with_lyrics" | "text" | "alankar_set"
  final String? label;
  final Map<String, dynamic>? headerData;
  final List<String>? taalMarkers;
  final List<List<String>>? rows; // for type "grid"
  final List<List<String>>? swaraRows; // for type "grid_with_lyrics"
  final List<List<String>>? lyricRows; // for type "grid_with_lyrics"
  final String? content; // for type "text"
  final List<String>? aroh; // for type "alankar_set"
  final List<String>? avroh; // for type "alankar_set"
  final String? taal; // for type "alankar_set"
  final String? confidence; // for type "alankar_set"
  final String? note; // for type "alankar_set"

  PageBlock({
    required this.type,
    this.label,
    this.headerData,
    this.taalMarkers,
    this.rows,
    this.swaraRows,
    this.lyricRows,
    this.content,
    this.aroh,
    this.avroh,
    this.taal,
    this.confidence,
    this.note,
  });

  factory PageBlock.fromJson(Map<String, dynamic> json) {
    List<List<String>>? parseGrid(dynamic raw) {
      if (raw == null) return null;
      return (raw as List<dynamic>)
          .map((row) => List<String>.from(row as List))
          .toList();
    }

    return PageBlock(
      type: json['type'] as String,
      label: json['label'] as String?,
      headerData: json['data'] as Map<String, dynamic>?,
      taalMarkers: json['taalMarkers'] != null
          ? List<String>.from(json['taalMarkers'] as List)
          : null,
      rows: parseGrid(json['rows']),
      swaraRows: parseGrid(json['swaraRows']),
      lyricRows: parseGrid(json['lyricRows']),
      content: json['content'] as String?,
      aroh: json['aroh'] != null ? List<String>.from(json['aroh'] as List) : null,
      avroh: json['avroh'] != null ? List<String>.from(json['avroh'] as List) : null,
      taal: json['taal'] as String?,
      confidence: json['confidence'] as String?,
      note: json['note'] as String?,
    );
  }
}
