import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Rich data model stored in Event.data
// ─────────────────────────────────────────────────────────────────────────────

enum PostStatus { inReview, published, draft, scheduled }

enum ChannelType { instagram, facebook, linkedin, youtube, web, email, twitter }

class EventData {
  final String id;
  final String postTitle;
  final String initiative; // e.g. "Wellness Webinar Week"
  final String story; // e.g. "Story"
  final String topic; // e.g. "Nutrition"
  final String strategy; // e.g. "Brand Awareness"
  final PostStatus status;
  final ChannelType channel;
  final String authorName;
  final String authorInitial;
  final Color authorColor;
  final String? thumbnailAsset; // optional local asset path (null = use icon)

  const EventData({
    required this.id,
    required this.postTitle,
    required this.initiative,
    required this.story,
    required this.topic,
    required this.strategy,
    required this.status,
    required this.channel,
    required this.authorName,
    required this.authorInitial,
    required this.authorColor,
    this.thumbnailAsset,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Channel helpers
// ─────────────────────────────────────────────────────────────────────────────

extension ChannelTypeX on ChannelType {
  String get label {
    switch (this) {
      case ChannelType.instagram:
        return 'Instagram';
      case ChannelType.facebook:
        return 'Facebook';
      case ChannelType.linkedin:
        return 'LinkedIn';
      case ChannelType.youtube:
        return 'YouTube';
      case ChannelType.web:
        return 'Web';
      case ChannelType.email:
        return 'Email';
      case ChannelType.twitter:
        return 'Twitter/X';
    }
  }

  Color get color {
    switch (this) {
      case ChannelType.instagram:
        return const Color(0xFFE1306C);
      case ChannelType.facebook:
        return const Color(0xFF1877F2);
      case ChannelType.linkedin:
        return const Color(0xFF0A66C2);
      case ChannelType.youtube:
        return const Color(0xFFFF0000);
      case ChannelType.web:
        return const Color(0xFF34A853);
      case ChannelType.email:
        return const Color(0xFFEA4335);
      case ChannelType.twitter:
        return const Color(0xFF00B2FF);
    }
  }

  IconData get icon {
    switch (this) {
      case ChannelType.instagram:
        return Icons.camera_alt_rounded;
      case ChannelType.facebook:
        return Icons.facebook_rounded;
      case ChannelType.linkedin:
        return Icons.share_rounded;
      case ChannelType.youtube:
        return Icons.play_circle_fill_rounded;
      case ChannelType.web:
        return Icons.language_rounded;
      case ChannelType.email:
        return Icons.mail_rounded;
      case ChannelType.twitter:
        return Icons.message_rounded;
    }
  }
}

extension PostStatusX on PostStatus {
  String get label {
    switch (this) {
      case PostStatus.inReview:
        return 'In review';
      case PostStatus.published:
        return 'Published';
      case PostStatus.draft:
        return 'Draft';
      case PostStatus.scheduled:
        return 'Scheduled';
    }
  }

  Color get bgColor {
    switch (this) {
      case PostStatus.inReview:
        return const Color(0xFFFFF3CD);
      case PostStatus.published:
        return const Color(0xFFD1FAE5);
      case PostStatus.draft:
        return const Color(0xFFF1F5F9);
      case PostStatus.scheduled:
        return const Color(0xFFEDE9FE);
    }
  }

  Color get textColor {
    switch (this) {
      case PostStatus.inReview:
        return const Color(0xFF856404);
      case PostStatus.published:
        return const Color(0xFF065F46);
      case PostStatus.draft:
        return const Color(0xFF475569);
      case PostStatus.scheduled:
        return const Color(0xFF5B21B6);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sample events generator
// ─────────────────────────────────────────────────────────────────────────────

List<Event> generateSampleEvents() {
  final now = DateTime.now();
  final year = now.year;
  final month = now.month;

  DateTime d(int day, [int hour = 0, int minute = 0]) =>
      DateTime(year, month, day, hour, minute);
  DateTime dn(int day, [int hour = 0, int minute = 0]) =>
      DateTime(year, month + 1, day, hour, minute);

  int _clampDay(int day) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return day.clamp(1, daysInMonth);
  }

  // ── Full-day / multi-day events ──────────────────────────────────────────

  final List<Event> events = [
    Event(
      title: 'First Ever Event',
      startTime: d(1, 1, 0),
      endTime: d(5, 23, 59),
      isFullDay: true,
      color: const Color(0xFFFFE0B2),
      textColor: const Color(0xFFE65100),
      data: EventData(
        id: 'evt-001',
        postTitle: 'First Ever Event',
        initiative: 'Wellness Webinar Week',
        story: 'Launch Story',
        topic: 'Nutrition',
        strategy: 'Brand Awareness',
        status: PostStatus.published,
        channel: ChannelType.instagram,
        authorName: 'Alice',
        authorInitial: 'A',
        authorColor: const Color(0xFF9C27B0),
      ),
    ),
    Event(
      title: 'Everyday Nutrition & Wellness',
      startTime: d(1, 2, 1),
      endTime: d(3, 23, 59),
      isFullDay: true,
      color: const Color(0xFFACCCEC),
      textColor: const Color(0xFF1565C0),
      data: EventData(
        id: 'evt-002',
        postTitle: 'Everyday Nutrition & Wellness',
        initiative: 'Wellness Webinar Week',
        story: 'Health Story',
        topic: 'Wellness',
        strategy: 'Engagement',
        status: PostStatus.inReview,
        channel: ChannelType.facebook,
        authorName: 'Joe',
        authorInitial: 'J',
        authorColor: const Color(0xFF3A7BD5),
      ),
    ),
    Event(
      title: 'Bonds that Heal',
      startTime: d(2, 3, 2),
      endTime: d(4, 23, 59),
      isFullDay: true,
      color: const Color(0xFF89F48E),
      textColor: const Color(0xFF006306),
      data: EventData(
        id: 'evt-003',
        postTitle: 'Bonds that Heal',
        initiative: 'Wellness Webinar Week',
        story: 'Community Story',
        topic: 'Mental Health',
        strategy: 'Retention',
        status: PostStatus.draft,
        channel: ChannelType.linkedin,
        authorName: 'Sara',
        authorInitial: 'S',
        authorColor: const Color(0xFF00897B),
      ),
    ),
    Event(
      title: 'Acts of Green',
      startTime: d(6, 4, 5),
      endTime: d(14, 23, 59),
      isFullDay: true,
      color: const Color(0xFF74C57A),
      textColor: const Color(0xFF2E7D32),
      data: EventData(
        id: 'evt-004',
        postTitle: 'Acts of Green',
        initiative: 'Eco Week',
        story: 'Sustainability Story',
        topic: 'Environment',
        strategy: 'Awareness',
        status: PostStatus.scheduled,
        channel: ChannelType.youtube,
        authorName: 'Raj',
        authorInitial: 'R',
        authorColor: const Color(0xFFE53935),
      ),
    ),
    Event(
      title: 'Acts II',
      startTime: d(6, 4, 6),
      endTime: d(14, 23, 59),
      isFullDay: true,
      color: const Color(0xFF74C57A),
      textColor: const Color(0xFF2E7D32),
      data: EventData(
        id: 'evt-005',
        postTitle: 'Acts II',
        initiative: 'Eco Week',
        story: 'Sustainability Story',
        topic: 'Recycling',
        strategy: 'Awareness',
        status: PostStatus.inReview,
        channel: ChannelType.instagram,
        authorName: 'Joe',
        authorInitial: 'J',
        authorColor: const Color(0xFF3A7BD5),
      ),
    ),
    Event(
      title: 'Acts III',
      startTime: d(6, 4, 3),
      endTime: d(14, 23, 59),
      isFullDay: true,
      color: const Color(0xFF74C57A),
      textColor: const Color(0xFF2E7D32),
      data: EventData(
        id: 'evt-006',
        postTitle: 'Acts III',
        initiative: 'Eco Week',
        story: 'Green Living',
        topic: 'Solar Energy',
        strategy: 'Lead Gen',
        status: PostStatus.draft,
        channel: ChannelType.web,
        authorName: 'Nina',
        authorInitial: 'N',
        authorColor: const Color(0xFF8E24AA),
      ),
    ),
    Event(
      title: 'Everyday Energy',
      startTime: d(1, 5, 4),
      endTime: d(2, 23, 59),
      isFullDay: true,
      color: const Color(0xFFEDB5F4),
      textColor: const Color(0xFF6A1B9A),
      data: EventData(
        id: 'evt-007',
        postTitle: 'Everyday Energy',
        initiative: 'Wellness Webinar Week',
        story: 'Energy Story',
        topic: 'Productivity',
        strategy: 'Brand Awareness',
        status: PostStatus.inReview,
        channel: ChannelType.twitter,
        authorName: 'Joe',
        authorInitial: 'J',
        authorColor: const Color(0xFF3A7BD5),
      ),
    ),
    Event(
      title: 'Egg Most Nutritious Food',
      startTime: d(8, 6, 5),
      endTime: d(10, 23, 59),
      isFullDay: true,
      color: const Color(0xFFA7CFEF),
      textColor: const Color(0xFF1565C0),
      data: EventData(
        id: 'evt-008',
        postTitle: 'Egg Most Nutritious Food',
        initiative: 'Food Week',
        story: 'Nutrition Facts',
        topic: 'Protein',
        strategy: 'Education',
        status: PostStatus.published,
        channel: ChannelType.facebook,
        authorName: 'Alice',
        authorInitial: 'A',
        authorColor: const Color(0xFF9C27B0),
      ),
    ),
    Event(
      title: 'Wellness at Work',
      startTime: d(15, 7, 6),
      endTime: d(16, 23, 59),
      isFullDay: true,
      color: const Color(0xFFECD0A7),
      textColor: const Color(0xFFE65100),
      data: EventData(
        id: 'evt-009',
        postTitle: 'Wellness at Work',
        initiative: 'Corporate Wellness',
        story: 'Workplace Story',
        topic: 'Work-Life Balance',
        strategy: 'Retention',
        status: PostStatus.scheduled,
        channel: ChannelType.linkedin,
        authorName: 'Sara',
        authorInitial: 'S',
        authorColor: const Color(0xFF00897B),
      ),
    ),
    Event(
      title: 'Wellness at Work Extended',
      startTime: d(16, 7, 0),
      endTime: d(20, 23, 59),
      isFullDay: true,
      color: const Color(0xFFECD0A7),
      textColor: const Color(0xFFE65100),
      data: EventData(
        id: 'evt-010',
        postTitle: 'Wellness at Work Extended',
        initiative: 'Corporate Wellness',
        story: 'Workplace Story',
        topic: 'Ergonomics',
        strategy: 'Engagement',
        status: PostStatus.inReview,
        channel: ChannelType.youtube,
        authorName: 'Raj',
        authorInitial: 'R',
        authorColor: const Color(0xFFE53935),
      ),
    ),
    Event(
      title: 'Hello World',
      startTime: d(15, 8, 0),
      endTime: d(19, 23, 59),
      isFullDay: true,
      color: const Color(0xFF95BCD8),
      textColor: const Color(0xFF1565C0),
      data: EventData(
        id: 'evt-011',
        postTitle: 'Hello World',
        initiative: 'Tech Launch',
        story: 'Product Story',
        topic: 'Technology',
        strategy: 'Lead Gen',
        status: PostStatus.draft,
        channel: ChannelType.web,
        authorName: 'Nina',
        authorInitial: 'N',
        authorColor: const Color(0xFF8E24AA),
      ),
    ),
    Event(
      title: 'Flutter Lang',
      startTime: d(20, 9, 0),
      endTime: d(22, 23, 59),
      isFullDay: true,
      color: const Color(0xFF9FC9ED),
      textColor: const Color(0xFF1565C0),
      data: EventData(
        id: 'evt-012',
        postTitle: 'Flutter Lang',
        initiative: 'Dev Week',
        story: 'Developer Story',
        topic: 'Flutter',
        strategy: 'Education',
        status: PostStatus.published,
        channel: ChannelType.twitter,
        authorName: 'Joe',
        authorInitial: 'J',
        authorColor: const Color(0xFF3A7BD5),
      ),
    ),
    Event(
      title: 'Weekend Reset',
      startTime: d(21, 10, 0),
      endTime: d(22, 23, 59),
      isFullDay: true,
      color: const Color(0xFF8CC890),
      textColor: const Color(0xFF2E7D32),
      data: EventData(
        id: 'evt-013',
        postTitle: 'Weekend Reset',
        initiative: 'Wellness Webinar Week',
        story: 'Recovery Story',
        topic: 'Rest & Sleep',
        strategy: 'Engagement',
        status: PostStatus.inReview,
        channel: ChannelType.instagram,
        authorName: 'Alice',
        authorInitial: 'A',
        authorColor: const Color(0xFF9C27B0),
      ),
    ),
    Event(
      title: 'Gandhi Movement',
      startTime: d(21, 11, 0),
      endTime: d(25, 23, 59),
      isFullDay: true,
      color: const Color(0xFFF0B8F8),
      textColor: const Color(0xFF6A1B9A),
      data: EventData(
        id: 'evt-014',
        postTitle: 'Gandhi Movement',
        initiative: 'History Week',
        story: 'Heritage Story',
        topic: 'Peace',
        strategy: 'Brand Awareness',
        status: PostStatus.scheduled,
        channel: ChannelType.facebook,
        authorName: 'Sara',
        authorInitial: 'S',
        authorColor: const Color(0xFF00897B),
      ),
    ),
    Event(
      title: 'Planet Friendly Choices',
      startTime: d(28, 12, 0),
      endTime: d(30, 23, 59),
      isFullDay: true,
      color: const Color(0xFFE1A6A6),
      textColor: const Color(0xFFB71C1C),
      data: EventData(
        id: 'evt-015',
        postTitle: 'Planet Friendly Choices',
        initiative: 'Eco Week',
        story: 'Green Story',
        topic: 'Sustainability',
        strategy: 'Awareness',
        status: PostStatus.draft,
        channel: ChannelType.youtube,
        authorName: 'Raj',
        authorInitial: 'R',
        authorColor: const Color(0xFFE53935),
      ),
    ),
    Event(
      title: 'Nuclear Energy',
      startTime: d(28, 13, 0),
      endTime: dn(2, 23, 59),
      isFullDay: true,
      color: const Color(0xFFA6CAE4),
      textColor: const Color(0xFF1565C0),
      data: EventData(
        id: 'evt-016',
        postTitle: 'Nuclear Energy',
        initiative: 'Science Week',
        story: 'Energy Story',
        topic: 'Nuclear Power',
        strategy: 'Education',
        status: PostStatus.inReview,
        channel: ChannelType.web,
        authorName: 'Nina',
        authorInitial: 'N',
        authorColor: const Color(0xFF8E24AA),
      ),
    ),
    Event(
      title: 'Plutonium',
      startTime: d(6, 14, 0),
      endTime: d(7, 23, 59),
      isFullDay: true,
      color: const Color(0xFFD6BA8D),
      textColor: const Color(0xFFAF3F00),
      data: EventData(
        id: 'evt-017',
        postTitle: 'Plutonium',
        initiative: 'Science Week',
        story: 'Elements Story',
        topic: 'Chemistry',
        strategy: 'Education',
        status: PostStatus.published,
        channel: ChannelType.twitter,
        authorName: 'Joe',
        authorInitial: 'J',
        authorColor: const Color(0xFF3A7BD5),
      ),
    ),
    Event(
      title: 'Uranium',
      startTime: d(13, 15, 0),
      endTime: d(14, 23, 59),
      isFullDay: true,
      color: const Color(0xFFFFE0B2),
      textColor: const Color(0xFFE65100),
      data: EventData(
        id: 'evt-018',
        postTitle: 'Uranium',
        initiative: 'Science Week',
        story: 'Elements Story',
        topic: 'Physics',
        strategy: 'Education',
        status: PostStatus.draft,
        channel: ChannelType.instagram,
        authorName: 'Alice',
        authorInitial: 'A',
        authorColor: const Color(0xFF9C27B0),
      ),
    ),
    Event(
      title: 'Green World',
      startTime: d(13, 16, 1),
      endTime: d(19, 23, 59),
      isFullDay: true,
      color: const Color(0xFF93E199),
      textColor: const Color(0xFF2E7D32),
      data: EventData(
        id: 'evt-019',
        postTitle: 'Green World',
        initiative: 'Eco Week',
        story: 'Nature Story',
        topic: 'Biodiversity',
        strategy: 'Engagement',
        status: PostStatus.scheduled,
        channel: ChannelType.facebook,
        authorName: 'Sara',
        authorInitial: 'S',
        authorColor: const Color(0xFF00897B),
      ),
    ),

    // ── Timed events ────────────────────────────────────────────────────────

    Event(
      title: 'Aarigato',
      startTime: d(now.day, 9, 0),
      endTime: d(now.day, 9, 30),
      color: const Color(0xFFADD1EC),
      textColor: const Color(0xFF1565C0),
      data: EventData(
        id: 'evt-020',
        postTitle: 'Aarigato',
        initiative: 'Culture Week',
        story: 'Japan Story',
        topic: 'Gratitude',
        strategy: 'Brand Awareness',
        status: PostStatus.inReview,
        channel: ChannelType.instagram,
        authorName: 'Joe',
        authorInitial: 'J',
        authorColor: const Color(0xFF3A7BD5),
      ),
    ),
    Event(
      title: 'Purple Day',
      startTime: d(now.day, 9, 15),
      endTime: d(now.day, 11, 0),
      color: const Color(0xFFE8A7F3),
      textColor: const Color(0xFFAB47BC),
      data: EventData(
        id: 'evt-021',
        postTitle: 'Purple Day',
        initiative: 'Awareness Week',
        story: 'Epilepsy Story',
        topic: 'Health',
        strategy: 'Awareness',
        status: PostStatus.scheduled,
        channel: ChannelType.facebook,
        authorName: 'Alice',
        authorInitial: 'A',
        authorColor: const Color(0xFF9C27B0),
      ),
    ),
    Event(
      title: 'Lunch Break',
      startTime: d(now.day, 12, 0),
      endTime: d(now.day, 13, 0),
      color: const Color(0xFF9BDC9E),
      textColor: const Color(0xFF2E7D32),
      data: EventData(
        id: 'evt-022',
        postTitle: 'Lunch Break',
        initiative: 'Daily Routine',
        story: 'Wellness Story',
        topic: 'Food',
        strategy: 'Engagement',
        status: PostStatus.published,
        channel: ChannelType.linkedin,
        authorName: 'Sara',
        authorInitial: 'S',
        authorColor: const Color(0xFF00897B),
      ),
    ),
    Event(
      title: 'Design Workshop',
      startTime: d(now.day, 14, 0),
      endTime: d(now.day, 16, 0),
      color: const Color(0xFFF6AC92),
      textColor: const Color(0xFFDA1919),
      data: EventData(
        id: 'evt-023',
        postTitle: 'Design Workshop',
        initiative: 'Creative Week',
        story: 'Design Story',
        topic: 'UX Design',
        strategy: 'Education',
        status: PostStatus.inReview,
        channel: ChannelType.youtube,
        authorName: 'Raj',
        authorInitial: 'R',
        authorColor: const Color(0xFFE53935),
      ),
    ),
    Event(
      title: 'Team Sync',
      startTime: d(now.day, 16, 30),
      endTime: d(now.day, 17, 0),
      color: const Color(0xFF54C8BD),
      textColor: const Color(0xFF004D40),
      data: EventData(
        id: 'evt-024',
        postTitle: 'Team Sync',
        initiative: 'Internal',
        story: 'Team Story',
        topic: 'Collaboration',
        strategy: 'Retention',
        status: PostStatus.draft,
        channel: ChannelType.web,
        authorName: 'Nina',
        authorInitial: 'N',
        authorColor: const Color(0xFF8E24AA),
      ),
    ),
    Event(
      title: 'Sprint Planning',
      startTime: d(_clampDay(now.day - 1), 9, 0),
      endTime: d(_clampDay(now.day - 1), 10, 30),
      color: const Color(0xFFB9C2E6),
      textColor: const Color(0xFF0095FB),
      data: EventData(
        id: 'evt-025',
        postTitle: 'Sprint Planning',
        initiative: 'Dev Week',
        story: 'Agile Story',
        topic: 'Project Mgmt',
        strategy: 'Lead Gen',
        status: PostStatus.published,
        channel: ChannelType.twitter,
        authorName: 'Joe',
        authorInitial: 'J',
        authorColor: const Color(0xFF3A7BD5),
      ),
    ),
    Event(
      title: 'Client Call',
      startTime: d(_clampDay(now.day - 1), 11, 0),
      endTime: d(_clampDay(now.day - 1), 12, 0),
      color: const Color(0xFFDFA9A7),
      textColor: const Color(0xFFE65100),
      data: EventData(
        id: 'evt-026',
        postTitle: 'Client Call',
        initiative: 'Sales',
        story: 'Client Story',
        topic: 'Sales',
        strategy: 'Conversion',
        status: PostStatus.inReview,
        channel: ChannelType.instagram,
        authorName: 'Alice',
        authorInitial: 'A',
        authorColor: const Color(0xFF9C27B0),
      ),
    ),
    Event(
      title: 'Content Review',
      startTime: d(_clampDay(now.day + 1), 10, 0),
      endTime: d(_clampDay(now.day + 1), 11, 30),
      color: const Color(0xFFFFCA28),
      textColor: const Color(0xFF333333),
      data: EventData(
        id: 'evt-027',
        postTitle: 'Content Review',
        initiative: 'Content Week',
        story: 'Editorial Story',
        topic: 'Content Strategy',
        strategy: 'Brand Awareness',
        status: PostStatus.scheduled,
        channel: ChannelType.facebook,
        authorName: 'Sara',
        authorInitial: 'S',
        authorColor: const Color(0xFF00897B),
      ),
    ),
    Event(
      title: 'Strategy Meeting',
      startTime: d(_clampDay(now.day + 1), 14, 0),
      endTime: d(_clampDay(now.day + 1), 15, 30),
      color: const Color(0xFFFFCA28),
      textColor: const Color(0xFF333333),
      data: EventData(
        id: 'evt-028',
        postTitle: 'Strategy Meeting',
        initiative: 'Quarterly Planning',
        story: 'Growth Story',
        topic: 'Marketing',
        strategy: 'Conversion',
        status: PostStatus.draft,
        channel: ChannelType.linkedin,
        authorName: 'Raj',
        authorInitial: 'R',
        authorColor: const Color(0xFFE53935),
      ),
    ),
    Event(
      title: 'Analytics Review',
      startTime: d(_clampDay(now.day + 2), 9, 0),
      endTime: d(_clampDay(now.day + 2), 10, 0),
      color: const Color(0xFFFFCA28),
      textColor: const Color(0xFF333333),
      data: EventData(
        id: 'evt-029',
        postTitle: 'Analytics Review',
        initiative: 'Data Week',
        story: 'Insights Story',
        topic: 'Analytics',
        strategy: 'Education',
        status: PostStatus.published,
        channel: ChannelType.youtube,
        authorName: 'Nina',
        authorInitial: 'N',
        authorColor: const Color(0xFF8E24AA),
      ),
    ),
    Event(
      title: 'User Testing',
      startTime: d(_clampDay(now.day + 2), 11, 0),
      endTime: d(_clampDay(now.day + 2), 13, 0),
      color: const Color(0xFFFFCA28),
      textColor: const Color(0xFF333333),
      data: EventData(
        id: 'evt-030',
        postTitle: 'User Testing',
        initiative: 'Product Week',
        story: 'UX Story',
        topic: 'Research',
        strategy: 'Engagement',
        status: PostStatus.inReview,
        channel: ChannelType.web,
        authorName: 'Joe',
        authorInitial: 'J',
        authorColor: const Color(0xFF3A7BD5),
      ),
    ),
    Event(
      title: 'Retrospective',
      startTime: d(_clampDay(now.day + 3), 15, 0),
      endTime: d(_clampDay(now.day + 3), 16, 0),
      color: const Color(0xFFFFCA28),
      textColor: const Color(0xFF333333),
      data: EventData(
        id: 'evt-031',
        postTitle: 'Retrospective',
        initiative: 'Dev Week',
        story: 'Agile Story',
        topic: 'Team Health',
        strategy: 'Retention',
        status: PostStatus.scheduled,
        channel: ChannelType.twitter,
        authorName: 'Alice',
        authorInitial: 'A',
        authorColor: const Color(0xFF9C27B0),
      ),
    ),
    Event(
      title: 'Onboarding Session',
      startTime: d(_clampDay(now.day - 2), 10, 0),
      endTime: d(_clampDay(now.day - 2), 11, 0),
      color: const Color(0xFFFFCA28),
      textColor: const Color(0xFF333333),
      data: EventData(
        id: 'evt-032',
        postTitle: 'Onboarding Session',
        initiative: 'HR Week',
        story: 'People Story',
        topic: 'Onboarding',
        strategy: 'Retention',
        status: PostStatus.published,
        channel: ChannelType.instagram,
        authorName: 'Sara',
        authorInitial: 'S',
        authorColor: const Color(0xFF00897B),
      ),
    ),
    Event(
      title: 'Budget Planning',
      startTime: d(_clampDay(now.day - 2), 14, 0),
      endTime: d(_clampDay(now.day - 2), 15, 30),
      color: const Color(0xFFFFCA28),
      textColor: const Color(0xFF333333),
      data: EventData(
        id: 'evt-033',
        postTitle: 'Budget Planning',
        initiative: 'Finance Week',
        story: 'Money Story',
        topic: 'Finance',
        strategy: 'Lead Gen',
        status: PostStatus.draft,
        channel: ChannelType.facebook,
        authorName: 'Raj',
        authorInitial: 'R',
        authorColor: const Color(0xFFE53935),
      ),
    ),
    Event(
      title: 'All-Hands Meeting',
      startTime: d(_clampDay(now.day - 3), 13, 0),
      endTime: d(_clampDay(now.day - 3), 14, 0),
      color: const Color(0xFFFFCA28),
      textColor: const Color(0xFF333333),
      data: EventData(
        id: 'evt-034',
        postTitle: 'All-Hands Meeting',
        initiative: 'Internal',
        story: 'Company Story',
        topic: 'Leadership',
        strategy: 'Brand Awareness',
        status: PostStatus.inReview,
        channel: ChannelType.linkedin,
        authorName: 'Nina',
        authorInitial: 'N',
        authorColor: const Color(0xFF8E24AA),
      ),
    ),
  ];

  return events;
}
