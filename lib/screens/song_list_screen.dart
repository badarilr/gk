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
          final songs = book.songs;
          final filteredSongs = songs.where((item) {
            final query = _searchText.trim().toLowerCase();
            if (query.isEmpty) return true;
            final haystack = [
              item.indexLabel,
              item.displayTitle,
              item.song.indexTitle ?? '',
              item.song.title ?? '',
              item.pageLabel,
            ].join('\n').toLowerCase();
            return haystack.contains(query);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search song title',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _searchText = value),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final item = filteredSongs[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF8B6E3C),
                          foregroundColor: Colors.white,
                          child: Text(
                            item.indexLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        title: Text(item.displayTitle),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SongPageView(item: item),
                          ),
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
