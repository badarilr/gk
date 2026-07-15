import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gk/models/raag_page.dart';

void main() {
  test('uses the JSON index order for display entries', () {
    final raw = File('assets/data/raagbook.json').readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final book = RaagBook.fromJson(json);
    final titles = book.indexEntries.map((entry) => entry.title).toList();

    expect(
      titles,
      [
        'alankar Prarambik',
        'Alankar Praveshika',
        'Durga alankar Praveshika',
        'Extra alankars',
        'Bhoopali',
        'Durga',
        'Bhageshree',
        'bheempalas',
        'Kafi',
        'Khamaj',
        'Des',
        'Yaman',
        'drupad',
        'taal',
      ],
    );
  });

  test('maps the first four index entries to their pages', () {
    final raw = File('assets/data/raagbook.json').readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final book = RaagBook.fromJson(json);

    expect(book.pagesForRaag('alankar Prarambik').map((page) => page.pageNumber).toList(), [1]);
    expect(book.pagesForRaag('Alankar Praveshika').map((page) => page.pageNumber).toList(), [2]);
    expect(book.pagesForRaag('Durga alankar Praveshika').map((page) => page.pageNumber).toList(), [3]);
    expect(book.pagesForRaag('Extra alankars').map((page) => page.pageNumber).toList(), [4]);
  });

  test('falls back to the index page number when a raaga mapping is missing', () {
    final raw = File('assets/data/raagbook.json').readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final book = RaagBook.fromJson(json);
    final entry = book.indexEntries.firstWhere((item) => item.title == 'alankar Prarambik');

    expect(book.pagesForIndexEntry(entry).map((page) => page.pageNumber).toList(), [1]);
  });
}
