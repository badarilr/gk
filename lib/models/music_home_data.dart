class MusicHomeData {
  final InstituteInfo institute;
  final List<AnnouncementItem> announcements;
  final List<EventItem> events;
  final List<ClassScheduleItem> classSchedule;
  final HomeCards homeCards;
  final PracticeSection practice;

  MusicHomeData({
    required this.institute,
    required this.announcements,
    required this.events,
    required this.classSchedule,
    required this.homeCards,
    required this.practice,
  });

  factory MusicHomeData.fromJson(Map<String, dynamic> json) {
    return MusicHomeData(
      institute: InstituteInfo.fromJson(json['institute'] as Map<String, dynamic>? ?? {}),
      announcements: (json['announcements'] as List<dynamic>? ?? [])
          .map((item) => AnnouncementItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      events: (json['events'] as List<dynamic>? ?? [])
          .map((item) => EventItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      classSchedule: (json['classSchedule'] as List<dynamic>? ?? [])
          .map((item) => ClassScheduleItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      homeCards: HomeCards.fromJson(json['homeCards'] as Map<String, dynamic>? ?? {}),
      practice: PracticeSection.fromJson(json['practice'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class InstituteInfo {
  final String name;
  final String welcomeMessage;

  InstituteInfo({required this.name, required this.welcomeMessage});

  factory InstituteInfo.fromJson(Map<String, dynamic> json) {
    return InstituteInfo(
      name: json['name'] as String? ?? 'Goonjan Kala Kendra',
      welcomeMessage: json['welcomeMessage'] as String? ?? 'Welcome',
    );
  }
}

class AnnouncementItem {
  final int id;
  final String title;
  final String description;
  final String date;
  final String type;

  AnnouncementItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
  });

  factory AnnouncementItem.fromJson(Map<String, dynamic> json) {
    return AnnouncementItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }
}

class EventItem {
  final int id;
  final String title;
  final String date;
  final String location;
  final String description;

  EventItem({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class ClassScheduleItem {
  final String day;
  final String startTime;
  final String endTime;
  final String mode;
  final String meetingUrl;

  ClassScheduleItem({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.mode,
    required this.meetingUrl,
  });

  factory ClassScheduleItem.fromJson(Map<String, dynamic> json) {
    return ClassScheduleItem(
      day: json['day'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      meetingUrl: json['meetingUrl'] as String? ?? '',
    );
  }
}

class HomeCards {
  final bool showAnnouncements;
  final bool showEvents;
  final bool showClassSchedule;
  final bool showPractice;

  HomeCards({
    required this.showAnnouncements,
    required this.showEvents,
    required this.showClassSchedule,
    required this.showPractice,
  });

  factory HomeCards.fromJson(Map<String, dynamic> json) {
    return HomeCards(
      showAnnouncements: json['showAnnouncements'] as bool? ?? true,
      showEvents: json['showEvents'] as bool? ?? true,
      showClassSchedule: json['showClassSchedule'] as bool? ?? true,
      showPractice: json['showPractice'] as bool? ?? true,
    );
  }
}

class PracticeSection {
  final String title;
  final List<String> items;

  PracticeSection({required this.title, required this.items});

  factory PracticeSection.fromJson(Map<String, dynamic> json) {
    return PracticeSection(
      title: json['title'] as String? ?? 'Practice',
      items: (json['items'] as List<dynamic>? ?? []).map((item) => item.toString()).toList(),
    );
  }
}
