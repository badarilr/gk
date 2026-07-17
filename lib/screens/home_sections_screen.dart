import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/music_home_data.dart';
import '../services/music_home_repository.dart';

class HomeSectionsScreen extends StatelessWidget {
  const HomeSectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Updates & Schedule')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: const HomeSectionsContent(),
        ),
      ),
    );
  }
}

class HomeSectionsContent extends StatelessWidget {
  final bool showHeader;
  final bool showAnnouncements;
  final bool showEvents;
  final bool showClassSchedule;
  final bool showPractice;

  const HomeSectionsContent({
    super.key,
    this.showHeader = true,
    this.showAnnouncements = true,
    this.showEvents = true,
    this.showClassSchedule = true,
    this.showPractice = true,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MusicHomeData>(
      future: MusicHomeRepository.load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: SizedBox(height: 40, child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!;
        final sections = <Widget>[
          if (showHeader) _HeaderCard(institute: data.institute),
          if (showAnnouncements &&
              data.homeCards.showAnnouncements &&
              data.announcements.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Announcements',
              icon: Icons.campaign,
              children: data.announcements
                  .map((item) => _AnnouncementTile(item: item))
                  .toList(),
            ),
          ],
          if (showEvents &&
              data.homeCards.showEvents &&
              data.events.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Events',
              icon: Icons.event,
              children: data.events
                  .map((item) => _EventTile(item: item))
                  .toList(),
            ),
          ],
          if (showClassSchedule &&
              data.homeCards.showClassSchedule &&
              data.classSchedule.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Class Schedule',
              icon: Icons.calendar_today,
              children: data.classSchedule
                  .map((item) => _ScheduleTile(item: item))
                  .toList(),
            ),
          ],
          if (showPractice &&
              data.homeCards.showPractice &&
              data.practice.items.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: data.practice.title,
              icon: Icons.self_improvement,
              children: data.practice.items
                  .map((item) => _PracticeTile(text: item))
                  .toList(),
            ),
          ],
        ];

        if (sections.isEmpty) {
          return const SizedBox.shrink();
        }

        if (sections.first is SizedBox) {
          sections.removeAt(0);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sections,
        );
      },
    );
  }
}

class HomeTopCardsContent extends StatelessWidget {
  const HomeTopCardsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MusicHomeData>(
      future: MusicHomeRepository.load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 72,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!;
        final cards = <Widget>[
          if (data.homeCards.showAnnouncements && data.announcements.isNotEmpty)
            _TopInfoCard(
              title: 'Announcements',
              icon: Icons.campaign,
              accentColor: const Color(0xFF8B6E3C),
              children: data.announcements
                  .map((item) => _TopAnnouncementRow(item: item))
                  .toList(),
            ),
          if (data.homeCards.showEvents && data.events.isNotEmpty)
            _TopInfoCard(
              title: 'Events',
              icon: Icons.event,
              accentColor: const Color(0xFF8B4A63),
              children: data.events
                  .map((item) => _TopEventRow(item: item))
                  .toList(),
            ),
          if (data.homeCards.showClassSchedule && data.classSchedule.isNotEmpty)
            _TopInfoCard(
              title: 'Class Schedule',
              icon: Icons.calendar_today,
              accentColor: const Color(0xFF2F6F73),
              children: data.classSchedule
                  .map((item) => _TopScheduleRow(item: item))
                  .toList(),
            ),
        ];

        if (cards.isEmpty) {
          return const SizedBox.shrink();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 640 && cards.length > 1) {
              final columns = constraints.maxWidth >= 900 ? 3 : 2;
              final cardWidth =
                  (constraints.maxWidth - (12 * (columns - 1))) / columns;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final card in cards)
                    SizedBox(width: cardWidth, child: card),
                ],
              );
            }

            return Column(
              children: [
                for (var index = 0; index < cards.length; index++) ...[
                  if (index > 0) const SizedBox(height: 12),
                  cards[index],
                ],
              ],
            );
          },
        );
      },
    );
  }
}

class _TopInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<Widget> children;

  const _TopInfoCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: accentColor.withValues(alpha: 0.14),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _TopAnnouncementRow extends StatelessWidget {
  final AnnouncementItem item;
  const _TopAnnouncementRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
          if (item.date.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              item.date,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
            ),
          ],
        ],
      ),
    );
  }
}

class _TopEventRow extends StatelessWidget {
  final EventItem item;
  const _TopEventRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final detail = [
      item.date,
      item.location,
    ].where((value) => value.isNotEmpty).join(' | ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (detail.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              detail,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
            ),
          ],
          if (item.description.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              item.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _TopScheduleRow extends StatelessWidget {
  final ClassScheduleItem item;
  const _TopScheduleRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final time = [
      item.startTime,
      item.endTime,
    ].where((value) => value.isNotEmpty).join(' - ');
    final title = [
      item.day,
      time,
    ].where((value) => value.isNotEmpty).join(' | ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (item.mode.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(item.mode),
                ],
              ],
            ),
          ),
          if (item.meetingUrl.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.link, size: 18),
              label: const Text('Join class'),
              onPressed: () => _launchUrl(item.meetingUrl),
            ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final InstituteInfo institute;
  const _HeaderCard({required this.institute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7EFD8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8C7A4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            institute.name,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            institute.welcomeMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6D8B8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF8B6E3C)),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  final AnnouncementItem item;
  const _AnnouncementTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5EC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(item.description),
          const SizedBox(height: 4),
          Text(
            item.date,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final EventItem item;
  const _EventTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5EC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text('${item.date} | ${item.location}'),
          const SizedBox(height: 4),
          Text(item.description),
        ],
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  final ClassScheduleItem item;
  const _ScheduleTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5EC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.day} | ${item.startTime} - ${item.endTime}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(item.mode),
              ],
            ),
          ),
          if (item.meetingUrl.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.link, size: 18),
              label: const Text('Join class'),
              onPressed: () => _launchUrl(item.meetingUrl),
            ),
        ],
      ),
    );
  }
}

class _PracticeTile extends StatelessWidget {
  final String text;
  const _PracticeTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 18,
            color: Color(0xFF8B6E3C),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
