import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:module_clone/constants.dart';

import '../../models/assignment_model.dart';
import '../../providers/assignment_provider.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  final Map<DateTime, List<AssignmentModel>> _events = {};

  @override
  void initState() {
    super.initState();

    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  void _groupAssignments(List<AssignmentModel> assignments) {
    _events.clear();

    for (final assignment in assignments) {
      final date = DateTime(
        assignment.dueDate.year,
        assignment.dueDate.month,
        assignment.dueDate.day,
      );

      _events.putIfAbsent(date, () => []);
      _events[date]!.add(assignment);
    }
  }

  List<AssignmentModel> _eventsForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);

    return _events[normalized] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final assignmentProvider = context.watch<AssignmentProvider>();

    if (assignmentProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (assignmentProvider.errorMessage != null) {
      return const Scaffold(
        body: Center(child: Text("Unable to load assignments.")),
      );
    }

    _groupAssignments(assignmentProvider.assignments);

    final selectedEvents = _eventsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () => context.go('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Upcoming Deadlines",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Select a date to view assignment deadlines.",
            style: TextStyle(color: moodleTextMuted),
          ),

          const SizedBox(height: 20),

          Card(
            color: moodleWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: moodleBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TableCalendar<AssignmentModel>(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _focusedDay,
                eventLoader: _eventsForDay,
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: moodleBlue.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: moodlePurple,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Deadlines",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: selectedEvents.isEmpty
                ? const Center(
                    child: Text(
                      "No deadlines on this date.",
                      style: TextStyle(color: moodleTextMuted),
                    ),
                  )
                : ListView.builder(
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      final assignment = selectedEvents[index];

                      return Card(
                        color: moodleWhite,
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: moodleBorder),
                        ),
                        child: ListTile(
                          leading: Icon(
                            assignment.isSubmitted
                                ? Icons.check_circle
                                : Icons.assignment_outlined,
                            color: assignment.isSubmitted
                                ? Colors.green
                                : moodlePurple,
                          ),
                          title: Text(
                            assignment.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                assignment.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Due: ${assignment.dueDate.toString().substring(0, 16)}",
                                style: const TextStyle(color: moodleTextMuted),
                              ),
                            ],
                          ),
                          trailing: assignment.isSubmitted
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    assignment.grade == null
                                        ? "Submitted"
                                        : "${assignment.grade}/${assignment.maxGrade}",
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.chevron_right),
                          onTap: () {
                            context.push("/assignment/${assignment.id}");
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
