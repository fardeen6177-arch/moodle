import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:module_clone/constants.dart';

import '../../providers/course_provider.dart';
import '../../providers/assignment_provider.dart';
import '../../models/course_model.dart';
import '../../models/assignment_model.dart';

class CourseDetailsView extends StatelessWidget {
  final String courseId;

  const CourseDetailsView({super.key, required this.courseId});

  Widget buildScaffold({
    required String title,
    List<Widget> actions = const [],
    required Widget body,
  }) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final assignmentProvider = context.watch<AssignmentProvider>();

    final CourseModel course = courseProvider.courses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => throw Exception("Course not found"),
    );

    final List<AssignmentModel> assignments = assignmentProvider
        .getAssignmentsForCourse(courseId);

    return buildScaffold(
      title: "Course Details",
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed: () => context.go('/notifications'),
        ),
        const SizedBox(width: 8),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            course.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            course.courseCode,
            style: const TextStyle(color: moodleTextMuted),
          ),

          const SizedBox(height: 24),

          Card(
            color: moodleWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: moodleBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                course.description,
                style: const TextStyle(color: moodleTextDark),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Assignments",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: assignments.isEmpty
                ? const Center(
                    child: Text(
                      "No assignments available.",
                      style: TextStyle(color: moodleTextMuted),
                    ),
                  )
                : ListView.builder(
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      final assignment = assignments[index];

                      return _AssignmentCard(assignment: assignment);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final AssignmentModel assignment;

  const _AssignmentCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: moodleWhite,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: moodleBorder),
      ),
      child: ExpansionTile(
        iconColor: moodlePurple,
        collapsedIconColor: moodlePurple,
        leading: const Icon(Icons.assignment_outlined, color: moodlePurple),
        title: Text(
          assignment.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: moodlePurple,
          ),
        ),
        subtitle: Text(
          "Due: ${assignment.dueDate.toLocal().toString().split(' ')[0]}",
        ),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              assignment.description,
              style: const TextStyle(color: moodleTextDark),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                context.push("/assignment/${assignment.id}");
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Open Submission"),
            ),
          ),
        ],
      ),
    );
  }
}
