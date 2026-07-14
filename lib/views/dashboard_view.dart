import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';
import 'package:moodle/widgets/nav_drawer.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset('images/moodle_logo.png', fit: BoxFit.contain),
            ),
            const Flexible(
              child: Text(
                'Dashboard',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/courses'),
          ),
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
              'Welcome back, Fardeen',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: moodlePurple,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Here is your Moodle-style overview for today.',
              style: TextStyle(fontSize: 16, color: moodleTextMuted),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _StatCard(
                      icon: Icons.school_outlined,
                      title: '1 active module',
                      subtitle: 'Your UXDI coursework workspace',
                      width: isWide
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                    ),
                    _StatCard(
                      icon: Icons.assignment_outlined,
                      title: '3 upcoming items',
                      subtitle: 'Deadlines and demo preparation',
                      width: isWide
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                    ),
                    _StatCard(
                      icon: Icons.calendar_month_outlined,
                      title: 'Next deadline',
                      subtitle: '29 Jul 2026',
                      width: isWide
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                    ),
                    _StatCard(
                      icon: Icons.notifications_none_outlined,
                      title: '2 new alerts',
                      subtitle: 'Announcements and reminders',
                      width: isWide
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick links',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: moodleTextDark,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _ActionCard(
                      width: isWide
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                      icon: Icons.menu_book_outlined,
                      title: 'Open course details',
                      subtitle: 'Browse module sections and overview',
                      onTap: () => Navigator.pushReplacementNamed(
                          context, '/course-details'),
                    ),
                    _ActionCard(
                      width: isWide
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                      icon: Icons.search_outlined,
                      title: 'Search courses',
                      subtitle: 'Filter your modules and resources',
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/courses'),
                    ),
                    _ActionCard(
                      width: isWide
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                      icon: Icons.person_outline,
                      title: 'View profile',
                      subtitle: 'Check your student details',
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/profile'),
                    ),
                    _ActionCard(
                      width: isWide
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                      icon: Icons.login,
                      title: 'Login UI',
                      subtitle: 'Placeholder authentication screen',
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Upcoming deadlines',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: moodleTextDark,
              ),
            ),
            const SizedBox(height: 12),
            const _DeadlineCard(
              title: 'Referral / Deferral Re-assessment',
              date: '29 Jul 2026',
              detail: 'Submit the repository link to Moodle before 13:00 GMT.',
            ),
            const _DeadlineCard(
              title: 'Demo booking closes',
              date: '03 Aug 2026',
              detail: 'Book your 10-minute demo slot before the deadline.',
            ),
            const _DeadlineCard(
              title: 'Project review',
              date: '05 Aug 2026',
              detail:
                  'Prepare the app and a short explanation of your approach.',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.width,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final double width;

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Semantics(
        label: '${widget.title}: ${widget.subtitle}',
        button: false,
        enabled: true,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            child: AnimatedScale(
              scale: _hover ? 1.01 : 1.0,
              duration: const Duration(milliseconds: 180),
              child: Material(
                color: moodleWhite,
                elevation: _hover ? 6 : 0,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: moodleBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: moodleGrayBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(widget.icon, color: moodlePurple),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: moodleTextDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.subtitle,
                              style: const TextStyle(
                                  fontSize: 14, color: moodleTextMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatefulWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.width,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final double width;

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
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
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: moodleGrayBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon, color: moodlePurple),
                ),
                title: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: moodleTextDark,
                  ),
                ),
                subtitle: Text(widget.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: widget.onTap,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeadlineCard extends StatefulWidget {
  const _DeadlineCard({
    required this.title,
    required this.date,
    required this.detail,
  });

  final String title;
  final String date;
  final String detail;

  @override
  State<_DeadlineCard> createState() => _DeadlineCardState();
}

class _DeadlineCardState extends State<_DeadlineCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
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
            child: ListTile(
              leading: const Icon(Icons.event_outlined, color: moodlePurple),
              title: Text(widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(widget.detail),
              trailing: Text(
                widget.date,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: moodlePurple),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
