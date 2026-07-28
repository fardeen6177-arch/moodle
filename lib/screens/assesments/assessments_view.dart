import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:module_clone/constants.dart';

import '../../models/assignment_model.dart';
import '../../models/course_model.dart';
import '../../providers/assignment_provider.dart';
import '../../providers/course_provider.dart';

class AssessmentsView extends StatelessWidget {
  const AssessmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final assignmentProvider = context.watch<AssignmentProvider>();
    final courseProvider = context.watch<CourseProvider>();

    if (assignmentProvider.isLoading || courseProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (assignmentProvider.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Assessments")),
        body: Center(child: Text(assignmentProvider.errorMessage!)),
      );
    }

    final assignments = assignmentProvider.assignments;
    final courses = courseProvider.courses;

    final pendingAssignments = assignments.where((a) => !a.isSubmitted).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    final completedAssignments =
        assignments.where((a) => a.isSubmitted).toList()
          ..sort((a, b) => b.dueDate.compareTo(a.dueDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assessments"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () => context.go('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        foregroundColor: moodlePurple,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Assessment List",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: moodlePurple,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Track your submission status and important deadlines.",
              style: TextStyle(color: moodleTextMuted),
            ),

            const SizedBox(height: 20),

            const TabBar(
              labelColor: moodlePurple,
              indicatorColor: moodlePurple,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Pending"),
                Tab(text: "Completed"),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TabBarView(
                children: [
                  _buildAssignmentList(
                    context,
                    pendingAssignments,
                    courses,
                    true,
                  ),
                  _buildAssignmentList(
                    context,
                    completedAssignments,
                    courses,
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: moodleWhite,
    );
  }

  Widget _buildAssignmentList(
    BuildContext context,
    List<AssignmentModel> assignments,
    List<CourseModel> courses,
    bool isPending,
  ) {
    if (assignments.isEmpty) {
      return Center(
        child: Text(
          isPending ? "No pending assessments." : "No completed assessments.",
          style: const TextStyle(color: moodleTextMuted, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final assignment = assignments[index];

        final courseName = courses
            .firstWhere(
              (course) => course.id == assignment.courseId,
              orElse: () => CourseModel(
                id: '',
                title: 'Unknown Course',
                courseCode: '',
                description: '',
                instructor: '',
              ),
            )
            .title;

        return Card(
          color: moodleWhite,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: moodleBorder),
          ),
          child: ListTile(
            onTap: () {
              context.push('/assignment/${assignment.id}');
            },
            leading: Icon(
              isPending
                  ? Icons.assignment_outlined
                  : Icons.check_circle_outline,
              color: moodlePurple,
            ),
            title: Text(
              assignment.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(courseName),
                const SizedBox(height: 4),
                Text(
                  isPending
                      ? "Due: ${assignment.dueDate.toString().substring(0, 10)}"
                      : "Submitted",
                ),
              ],
            ),
            trailing: isPending
                ? const Icon(Icons.chevron_right)
                : assignment.grade != null
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
                      "${assignment.grade}/${assignment.maxGrade}",
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
