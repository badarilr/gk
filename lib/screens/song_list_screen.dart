import 'package:flutter/material.dart';
import '../models/song_page.dart';
import '../services/songbook_repository.dart';
import 'song_page_view.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Songs')),
      body: FutureBuilder<SongBook>(
        future: SongbookRepository.load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final book = snapshot.data!;
          final filteredPages = book.pages.where((page) {
            final query = _searchText.trim().toLowerCase();
            if (query.isEmpty) return true;
            final haystack = [
              page.displayTitle,
              page.title ?? '',
              page.pageNumber,
              ...page.songs.map((song) => [
                    song.displayTitle,
                    song.title ?? '',
                    song.raag ?? '',
                    song.taal ?? '',
                    song.attribution ?? '',
                  ].join(' ')),
            ].join('\n').toLowerCase();
            return haystack.contains(query);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search song, raga, taal or attribution',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _searchText = value),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredPages.length,
                  itemBuilder: (context, index) {
                    final page = filteredPages[index];
                    final title = page.displayTitle;
                    final subtitle = page.songs.isEmpty
                        ? 'No songs transcribed yet'
                        : '${page.songs.length} song${page.songs.length == 1 ? '' : 's'}';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        leading: page.sourceImage != null
                            ? Image.asset(
                                page.sourceImage!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.music_note),
                              )
                            : const Icon(Icons.music_note, size: 32),
                        title: Text(title),
                        subtitle: Text(subtitle),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SongPageView(page: page)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
