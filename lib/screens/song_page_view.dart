import 'package:flutter/material.dart';
import '../models/song_page.dart';

class SongPageView extends StatefulWidget {
  final SongBookSong item;

  const SongPageView({super.key, required this.item});

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
        title: Text(widget.item.pageLabel),
        actions: [
          if (widget.item.sourceImage != null)
            IconButton(
              icon: Icon(_showSource ? Icons.article : Icons.image),
              tooltip: 'Toggle original page photo',
              onPressed: () => setState(() => _showSource = !_showSource),
            ),
        ],
      ),
      body: _showSource
          ? _SourceImageView(assetPath: widget.item.sourceImage!)
          : _TranscribedView(item: widget.item),
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
      child: Center(
        child: Image.asset(
          assetPath,
          errorBuilder: (context, error, stackTrace) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Source image unavailable',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TranscribedView extends StatelessWidget {
  final SongBookSong item;
  const _TranscribedView({required this.item});

  @override
  Widget build(BuildContext context) {
    final song = item.song;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (item.pageNote != null)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF7E8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD8C7A4)),
            ),
            child: Text(
              item.pageNote!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
            ),
          ),
        Container(
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
                item.displayTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (song.title != null &&
                  song.indexTitle != null &&
                  song.title != song.indexTitle) ...[
                const SizedBox(height: 6),
                Text(song.title!, style: Theme.of(context).textTheme.bodySmall),
              ],
              if (song.taal != null || song.attribution != null) ...[
                const SizedBox(height: 6),
                if (song.taal != null)
                  Text(
                    'Taal: ${song.taal}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (song.attribution != null)
                  Text(
                    'Attribution: ${song.attribution}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
              const SizedBox(height: 8),
              ...song.stanzas.asMap().entries.expand((stanzaEntry) {
                final stanzaIndex = stanzaEntry.key + 1;
                final stanza = stanzaEntry.value;
                return [
                  Text(
                    stanza.marked
                        ? 'Stanza $stanzaIndex - marked'
                        : 'Stanza $stanzaIndex',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...stanza.lines.map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        line,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ];
              }),
            ],
          ),
        ),
      ],
    );
  }
}
