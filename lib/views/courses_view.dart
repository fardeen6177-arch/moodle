import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';
import 'package:moodle/widgets/nav_drawer.dart';

class CoursesView extends StatefulWidget {
  const CoursesView({super.key});

  @override
  State<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<CoursesView> {
  final TextEditingController _searchController = TextEditingController();

  final List<_CourseItem> _courses = const [
    _CourseItem(
      title: 'USER EXPERIENCE DESIGN AND IMPLEMENTATION',
      code: 'M30235',
      subtitle: 'Current assessment module',
      progress: 0.76,
      color: moodlePurple,
    ),
    _CourseItem(
      title: 'PROGRAMMING APPLICATIONS',
      code: 'M30234',
      subtitle: 'Support and reference materials',
      progress: 0.62,
      color: moodleBlue,
    ),
    _CourseItem(
      title: 'PROGRAMMING LANGUAGES',
      code: 'M30236',
      subtitle: 'Lecture notes and exercises',
      progress: 0.43,
      color: moodleDarkPurple,
    ),
    _CourseItem(
      title: 'SOFTWARE ENGINEERING',
      code: 'M30237',
      subtitle: 'Teamwork and planning module',
      progress: 0.84,
      color: moodleSecondary,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase().trim();
    final filteredCourses = _courses.where((course) {
      return course.title.toLowerCase().contains(query) ||
          course.code.toLowerCase().contains(query) ||
          course.subtitle.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: moodleWhite,
        foregroundColor: moodleTextDark,
        elevation: 1,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: 32,
              height: 32,
              child: Image.asset(
                'images/moodle_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const Flexible(
              child: Text(
                'My courses',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/assessments'),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: moodleGrayBg,
            foregroundColor: moodlePurple,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
              child: const Text(
                'FS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const NavDrawer(),
      body: Container(
        color: moodleBg,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const Text(
              'My courses',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: moodlePurple,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Search and open your current modules.',
              style: TextStyle(fontSize: 16, color: moodleTextMuted),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_outlined),
                hintText: 'Search courses',
                filled: true,
                fillColor: moodleWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: moodleBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: moodleBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: moodlePurple, width: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: filteredCourses.map((course) {
                    return SizedBox(
                      width: isWide
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                      child: _CourseCard(
                        course: course,
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/course-details',
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            if (filteredCourses.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text(
                  'No courses match your search.',
                  style: TextStyle(color: moodleTextMuted),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CourseItem {
  const _CourseItem({
    required this.title,
    required this.code,
    required this.subtitle,
    required this.progress,
    required this.color,
  });

  final String title;
  final String code;
  final String subtitle;
  final double progress;
  final Color color;
}

class _CourseCard extends StatefulWidget {
  const _CourseCard({required this.course, required this.onTap});

  final _CourseItem course;
  final VoidCallback onTap;

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.01 : 1.0,
        duration: const Duration(milliseconds: 160),
        child: Material(
          color: moodleWhite,
          elevation: _hover ? 6 : 0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: moodleBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(
                            (widget.course.color.r * 255.0).round(),
                            (widget.course.color.g * 255.0).round(),
                            (widget.course.color.b * 255.0).round(),
                            0.12,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.menu_book_outlined,
                            color: widget.course.color),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.course.code,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: moodleTextMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.course.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: moodleTextDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.course.subtitle,
                    style: const TextStyle(color: moodleTextMuted),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: widget.course.progress,
                      minHeight: 8,
                      backgroundColor: moodleGrayBg,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(widget.course.color),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Progress ${(widget.course.progress * 100).round()}%',
                    style:
                        const TextStyle(fontSize: 12, color: moodleTextMuted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
