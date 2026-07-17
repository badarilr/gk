import 'package:flutter/material.dart';
import '../models/song_page.dart';

class SongPageView extends StatefulWidget {
  final SongPage page;

  const SongPageView({super.key, required this.page});

  @override
  State<SongPageView> createState() => _SongPageViewState();
}

class _SongPageViewState extends State<SongPageView> {
  bool _showSource = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6E3C),
        foregroundColor: Colors.white,
        title: Text('Page ${widget.page.pageNumber}'),
        actions: [
          if (widget.page.sourceImage != null)
            IconButton(
              icon: Icon(_showSource ? Icons.article : Icons.image),
              tooltip: 'Toggle original page photo',
              onPressed: () => setState(() => _showSource = !_showSource),
            ),
        ],
      ),
      body: _showSource
          ? _SourceImageView(assetPath: widget.page.sourceImage!)
          : _TranscribedView(page: widget.page),
    );
  }
}

class _SourceImageView extends StatelessWidget {
  final String assetPath;
  const _SourceImageView({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 1,
      maxScale: 5,
      child: Center(child: Image.asset(assetPath)),
    );
  }
}

class _TranscribedView extends StatelessWidget {
  final SongPage page;
  const _TranscribedView({required this.page});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (page.note != null)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF7E8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD8C7A4)),
            ),
            child: Text(
              page.note!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
            ),
          ),
        ...page.songs.asMap().entries.map((entry) {
          final song = entry.value;
          final index = entry.key + 1;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6D8B8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.displayTitle.isNotEmpty ? 'Song $index • ${song.displayTitle}' : 'Song $index',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (song.taal != null || song.attribution != null) ...[
                  const SizedBox(height: 6),
                  if (song.taal != null)
                    Text('Taal: ${song.taal}', style: Theme.of(context).textTheme.bodySmall),
                  if (song.attribution != null)
                    Text('Attribution: ${song.attribution}', style: Theme.of(context).textTheme.bodySmall),
                ],
                const SizedBox(height: 8),
                ...song.stanzas.asMap().entries.expand((stanzaEntry) {
                  final stanzaIndex = stanzaEntry.key + 1;
                  final stanza = stanzaEntry.value;
                  return [
                    Text(
                      stanza.marked ? 'Stanza $stanzaIndex • marked' : 'Stanza $stanzaIndex',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    ...stanza.lines.map((line) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(line, style: Theme.of(context).textTheme.bodyMedium),
                        )),
                    const SizedBox(height: 6),
                  ];
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
