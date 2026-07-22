import 'package:flutter/material.dart';
import '../models/raag_page.dart';
import '../widgets/swara_text.dart';

class RaagPageView extends StatefulWidget {
  final RaagPage page;

  const RaagPageView({super.key, required this.page});

  @override
  State<RaagPageView> createState() => _RaagPageViewState();
}

class _RaagPageViewState extends State<RaagPageView> {
  bool _showSource = false;

  @override
  Widget build(BuildContext context) {
    final page = widget.page;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6E3C),
        foregroundColor: Colors.white,
        title: Text('${page.title} (p.${page.pageNumber})'),
        actions: [
          if (page.sourceImage != null)
            IconButton(
              icon: Icon(_showSource ? Icons.article : Icons.image),
              tooltip: 'Toggle original page photo',
              onPressed: () => setState(() => _showSource = !_showSource),
            ),
        ],
      ),
      body: _showSource
          ? _SourceImageView(assetPath: page.sourceImage!)
          : _TranscribedView(page: page),
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
  final RaagPage page;
  const _TranscribedView({required this.page});

  @override
  Widget build(BuildContext context) {
    if (page.needsVerification) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Not transcribed yet — use the photo toggle above to view the original page.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (page.note != null) ...[
              const SizedBox(height: 8),
              Text(page.note!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF7E8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD8C7A4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                page.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4A3A1A),
                ),
              ),
              if (page.note != null) ...[
                const SizedBox(height: 6),
                Text(
                  page.note!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                ),
              ],
            ],
          ),
        ),
        ...page.blocks.map(_buildBlock),
      ],
    );
  }

  Widget _buildBlock(PageBlock block) {
    switch (block.type) {
      case 'header':
        return _HeaderCard(data: block.headerData ?? {});
      case 'grid':
        return _GridCard(
          label: block.label,
          taalMarkers: block.taalMarkers,
          rows: block.rows ?? [],
        );
      case 'grid_with_lyrics':
        return _GridWithLyricsCard(
          label: block.label,
          taalMarkers: block.taalMarkers,
          swaraRows: block.swaraRows ?? [],
          lyricRows: block.lyricRows ?? [],
        );
      case 'text':
        return _TextCard(label: block.label, content: block.content ?? '');
      case 'alankar_set':
        return _AlankarSetCard(block: block);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _AlankarSetCard extends StatelessWidget {
  final PageBlock block;

  const _AlankarSetCard({required this.block});

  @override
  Widget build(BuildContext context) {
    final aroh = block.aroh ?? [];
    final avroh = block.avroh ?? [];
    final label = block.label ?? 'Alankar set';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9CBB2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF5A4222),
            ),
          ),
          if (block.taal != null) ...[
            const SizedBox(height: 4),
            Text(
              'Taal: ${block.taal}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (block.confidence != null) ...[
            const SizedBox(height: 4),
            Text(
              'Confidence: ${block.confidence}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (block.note != null) ...[
            const SizedBox(height: 4),
            Text(block.note!, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 10),
          if (aroh.isNotEmpty) ...[
            Text(
              'Aroh',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: aroh
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF4E9D5),
                        border: Border.all(color: const Color(0xFFE2D3AB)),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (avroh.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Avroh',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: avroh
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF7F2EA),
                        border: Border.all(color: const Color(0xFFE8DFC8)),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _HeaderCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9CBB2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.entries.map((e) {
          final value = e.value is List
              ? (e.value as List).join(' ')
              : e.value.toString();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(height: 1.4),
                children: [
                  TextSpan(
                    text: '${e.key}: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GridCard extends StatelessWidget {
  final String? label;
  final List<String>? taalMarkers;
  final List<List<String>> rows;

  const _GridCard({this.label, this.taalMarkers, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9CBB2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5A4222),
              ),
            ),
          const SizedBox(height: 8),
          Table(
            border: TableBorder.all(color: const Color(0xFFE4D8C2)),
            children: [
              if (taalMarkers != null)
                TableRow(
                  decoration: BoxDecoration(color: const Color(0xFFF3EAD8)),
                  children: taalMarkers!
                      .map(
                        (m) => Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            m,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                      .toList(),
                ),
              for (final row in rows)
                TableRow(
                  children: row
                      .map(
                        (cell) => Padding(
                          padding: const EdgeInsets.all(6),
                          child: SwaraCellText(cell),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridWithLyricsCard extends StatelessWidget {
  final String? label;
  final List<String>? taalMarkers;
  final List<List<String>> swaraRows;
  final List<List<String>> lyricRows;

  const _GridWithLyricsCard({
    this.label,
    this.taalMarkers,
    required this.swaraRows,
    required this.lyricRows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9CBB2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5A4222),
              ),
            ),
          const SizedBox(height: 8),
          Table(
            border: TableBorder.all(color: const Color(0xFFE4D8C2)),
            children: [
              if (taalMarkers != null)
                TableRow(
                  decoration: BoxDecoration(color: const Color(0xFFF3EAD8)),
                  children: taalMarkers!
                      .map(
                        (m) => Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            m,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                      .toList(),
                ),
              for (var i = 0; i < swaraRows.length; i++) ...[
                TableRow(
                  children: swaraRows[i]
                      .map(
                        (cell) => Padding(
                          padding: const EdgeInsets.all(6),
                          child: SwaraCellText(
                            cell,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                      .toList(),
                ),
                if (i < lyricRows.length)
                  TableRow(
                    children: lyricRows[i]
                        .map(
                          (cell) => Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              cell,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TextCard extends StatelessWidget {
  final String? label;
  final String content;
  const _TextCard({this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9CBB2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5A4222),
              ),
            ),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }
}
