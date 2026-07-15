import 'package:flutter/material.dart';
import '../models/raag_page.dart';
import '../services/raagbook_repository.dart';
import 'raag_page_view.dart';

class RaagListScreen extends StatelessWidget {
  const RaagListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Raagbook')),
      body: FutureBuilder<RaagBook>(
        future: RaagbookRepository.load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final book = snapshot.data!;
          final indexEntries = book.indexEntries;

          return ListView.builder(
            itemCount: indexEntries.length,
            itemBuilder: (context, index) {
              final entry = indexEntries[index];
              final pages = book.pagesForIndexEntry(entry);
              return ExpansionTile(
                title: Text(entry.title),
                subtitle: Text(
                  pages.isEmpty
                      ? 'Index page ${entry.page} • no pages mapped yet'
                      : '${pages.length} page(s) • index p.${entry.page}',
                ),
                children: pages.isEmpty
                    ? [
                        const ListTile(
                          dense: true,
                          title: Text('No transcribed pages available yet.'),
                        ),
                      ]
                    : pages.map((page) {
                        return ListTile(
                          dense: true,
                          leading: page.needsVerification
                              ? const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20)
                              : const Icon(Icons.check_circle_outline, size: 20),
                          title: Text('p.${page.pageNumber} — ${page.title}'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RaagPageView(page: page)),
                          ),
                        );
                      }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
