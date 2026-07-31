import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/nav_drawer.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final courseProvider = context.watch<CourseProvider>();

    final user = authProvider.user;

    return Scaffold(
      drawer: const NavDrawer(),
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
                'assets/images/moodle_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              "Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () => context.go("/courses"),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () => context.go("/notifications"),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go("/profile"),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              await authProvider.logout();

              if (context.mounted) {
                context.go("/login");
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Container(
        color: moodleBg,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Welcome Section
              Text(
                "Welcome back, Fardeen",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: moodlePurple,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                user?.email ?? "",
                style: const TextStyle(color: moodleTextMuted, fontSize: 16),
              ),

              const SizedBox(height: 28),

              /// Statistics Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _StatCard(
                        width: isWide
                            ? (constraints.maxWidth - 16) / 2
                            : constraints.maxWidth,
                        icon: Icons.school_outlined,
                        title:
                            "${courseProvider.courses.length} Active Modules",
                        subtitle: "Courses currently available to you",
                      ),

                      _StatCard(
                        width: isWide
                            ? (constraints.maxWidth - 16) / 2
                            : constraints.maxWidth,
                        icon: Icons.assignment_outlined,
                        title: "Your Courses",
                        subtitle: "Browse enrolled modules and assignments",
                      ),

                      _StatCard(
                        width: isWide
                            ? (constraints.maxWidth - 16) / 2
                            : constraints.maxWidth,
                        icon: Icons.person_outline,
                        title: user?.name ?? "Student",
                        subtitle: "Signed in successfully",
                      ),

                      _StatCard(
                        width: isWide
                            ? (constraints.maxWidth - 16) / 2
                            : constraints.maxWidth,
                        icon: Icons.cloud_done_outlined,
                        title: "Firebase Connected",
                        subtitle: "Realtime course information",
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                "Quick Links",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: moodleTextDark,
                ),
              ),

              const SizedBox(height: 16),
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
                        title: "My courses",
                        subtitle: "Browse all enrolled courses",
                        onTap: () => context.go("/courses"),
                      ),

                      _ActionCard(
                        width: isWide
                            ? (constraints.maxWidth - 16) / 2
                            : constraints.maxWidth,
                        icon: Icons.assignment_outlined,
                        title: "Assessments",
                        subtitle: "View assignments and submissions",
                        onTap: () => context.go("/assessments"),
                      ),

                      _ActionCard(
                        width: isWide
                            ? (constraints.maxWidth - 16) / 2
                            : constraints.maxWidth,
                        icon: Icons.calendar_month_outlined,
                        title: "Calendar",
                        subtitle: "Upcoming deadlines",
                        onTap: () => context.go("/calendar"),
                      ),

                      _ActionCard(
                        width: isWide
                            ? (constraints.maxWidth - 16) / 2
                            : constraints.maxWidth,
                        icon: Icons.person_outline,
                        title: "Profile",
                        subtitle: "View your student profile",
                        onTap: () => context.go("/profile"),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                "Your Courses",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: moodleTextDark,
                ),
              ),

              const SizedBox(height: 16),

              Builder(
                builder: (context) {
                  if (courseProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (courseProvider.errorMessage != null) {
                    return Center(
                      child: Text(
                        courseProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (courseProvider.courses.isEmpty) {
                    return const Center(
                      child: Text(
                        "No courses available.",
                        style: TextStyle(color: moodleTextMuted, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courseProvider.courses.length,
                    itemBuilder: (context, index) {
                      final course = courseProvider.courses[index];

                      return Card(
                        color: moodleWhite,
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: moodleBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: moodlePurple,
                            child: Text(
                              (course.courseCode.length >= 2
                                      ? course.courseCode.substring(0, 2)
                                      : course.courseCode)
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            course.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: moodleTextDark,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "${course.courseCode} • ${course.instructor}",
                              style: const TextStyle(color: moodleTextMuted),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: moodlePurple,
                          ),
                          onTap: () {
                            context.push("/courses/${course.id}");
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
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
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedScale(
          scale: _hover ? 1.01 : 1,
          duration: const Duration(milliseconds: 180),
          child: Material(
            color: moodleWhite,
            elevation: _hover ? 6 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: moodleBorder),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: moodleTextDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(color: moodleTextMuted),
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
        child: AnimatedScale(
          scale: _hover ? 1.01 : 1,
          duration: const Duration(milliseconds: 180),
          child: Material(
            color: moodleWhite,
            elevation: _hover ? 6 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: moodleBorder),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: moodleGrayBg,
                        borderRadius: BorderRadius.circular(10),
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
                              fontWeight: FontWeight.bold,
                              color: moodleTextDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: const TextStyle(color: moodleTextMuted),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: moodlePurple),
                  ],
                ),
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
    required this.detail,
    required this.date,
  });

  final String title;
  final String detail;
  final String date;

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
      child: AnimatedScale(
        scale: _hover ? 1.01 : 1,
        duration: const Duration(milliseconds: 180),
        child: Material(
          color: moodleWhite,
          elevation: _hover ? 6 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: moodleBorder),
          ),
          child: ListTile(
            leading: const Icon(Icons.event_outlined, color: moodlePurple),
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.detail),
            trailing: Text(
              widget.date,
              style: const TextStyle(
                color: moodlePurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
