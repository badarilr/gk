import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_sections_screen.dart';
import 'raag_list_screen.dart';
import 'song_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const _HomeTab(),
          const SongListScreen(),
          const RaagListScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.music_note_outlined),
            selectedIcon: Icon(Icons.music_note),
            label: 'Songs',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music),
            label: 'Ragas',
          ),
        ],
      ),
    );
  }

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gk Book'), centerTitle: true),
      drawer: const _HomeDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: const Column(
            children: [
              HomeSectionsContent(
                showHeader: false,
                showEvents: false,
                showPractice: false,
              ),
              SizedBox(height: 16),
              _PracticeListPanel(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeListPanel extends StatefulWidget {
  const _PracticeListPanel();

  @override
  State<_PracticeListPanel> createState() => _PracticeListPanelState();
}

class _PracticeListPanelState extends State<_PracticeListPanel> {
  final List<_PracticeItem> _items = [
    _PracticeItem('song name'),
    _PracticeItem('song name'),
    _PracticeItem('song name'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF7DB2F0),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFD7E9FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF7DB2F0)),
            ),
            child: Text(
              'practice makes perfect',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF1E5A9D),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF7DB2F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[new] practice list',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF005BBB),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                for (var index = 0; index < _items.length; index++) ...[
                  _PracticeListRow(
                    item: _items[index],
                    onChanged: (value) {
                      setState(() => _items[index].done = value ?? false);
                    },
                    onShare: () async {
                      await _sharePracticeItem(_items[index].name);
                      setState(() => _items[index].sent = true);
                    },
                  ),
                  if (index < _items.length - 1)
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeListRow extends StatelessWidget {
  final _PracticeItem item;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onShare;

  const _PracticeListRow({
    required this.item,
    required this.onChanged,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Checkbox(
              value: item.done,
              onChanged: onChanged,
              visualDensity: VisualDensity.compact,
            ),
          ),
          SizedBox(
            width: 28,
            height: 28,
            child: IconButton(
              tooltip: 'Send on WhatsApp',
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.chat_outlined, size: 17),
              onPressed: onShare,
            ),
          ),
          SizedBox(
            width: 94,
            child: Text(
              item.sent ? 'sent on whatsapp' : 'send on whatsapp',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeItem {
  final String name;
  bool done = false;
  bool sent = false;

  _PracticeItem(this.name);
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: Color(0xFFF7EFD8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logo/gk.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.music_note, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Goonjan Kalakendra',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.smart_display),
              title: const Text('Goonjan Kala Kendra'),
              subtitle: const Text('YouTube channel'),
              onTap: () {
                Navigator.pop(context);
                _launchChannel('https://www.youtube.com/@goonjankalakendra');
              },
            ),
            ListTile(
              leading: const Icon(Icons.smart_display),
              title: const Text('Jyothi Hegde'),
              subtitle: const Text('YouTube channel'),
              onTap: () {
                Navigator.pop(context);
                _launchChannel('https://www.youtube.com/@jyotihegde-n6f');
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchChannel(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

Future<void> _sharePracticeItem(String name) async {
  final message = Uri.encodeComponent('Practice update: $name');
  await launchUrl(
    Uri.parse('https://wa.me/?text=$message'),
    mode: LaunchMode.externalApplication,
  );
}
