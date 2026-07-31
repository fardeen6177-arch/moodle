import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:module_clone/constants.dart';
import 'package:module_clone/widgets/moodle_scaffold.dart';

import '../../providers/course_provider.dart';
import '../../providers/assignment_provider.dart';
import '../../models/course_model.dart';
import '../../models/assignment_model.dart';

class CourseDetailsView extends StatefulWidget {
  final String courseId;

  const CourseDetailsView({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailsView> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends State<CourseDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Quick submission dialog logic
  void _showDirectSubmitDialog(
    BuildContext context,
    AssignmentModel assignment,
    AssignmentProvider assignmentProvider,
  ) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Submit: ${assignment.title}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assignment.description,
                style: const TextStyle(color: moodleTextMuted, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Enter your submission response or text here...",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: moodlePurple, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: moodlePurple),
              icon: const Icon(Icons.send, size: 16),
              label: const Text("Submit Now"),
              onPressed: () async {
                final text = textController.text.trim();
                if (text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter submission text")),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                final success = await assignmentProvider.submitAssignment(
                  assignmentId: assignment.id,
                  submissionText: text,
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? "Assignment submitted successfully!"
                            : "Submission failed. Please try again.",
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final assignmentProvider = context.watch<AssignmentProvider>();

    final CourseModel course = courseProvider.courses.firstWhere(
      (c) => c.id == widget.courseId,
      orElse: () => CourseModel(
        id: widget.courseId,
        title: 'Functional Programming',
        courseCode: 'CS501',
        description:
            'Functional Programming information, including assessment and course syllabus.',
        instructor: 'Dr. Lecturer',
        progress: 0.5,
      ),
    );

    final List<AssignmentModel> assignments =
        assignmentProvider.getAssignmentsForCourse(widget.courseId);

    return MoodleScaffold(
      title: course.title,
      scrollable: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed: () => context.go('/notifications'),
        ),
        const SizedBox(width: 8),
      ],
      body: Column(
        children: [
          // Sub-navigation bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: moodlePurple,
              unselectedLabelColor: moodleTextDark,
              indicatorColor: moodlePurple,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: "Course"),
                Tab(text: "Module Info"),
                Tab(text: "Assessment Information (AIR)"),
                Tab(text: "Reading Lists"),
                Tab(text: "Grades"),
                Tab(text: "More v"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Main split container inside Expanded
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Course Tab
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 900;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Content (Weekly Modules)
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: moodleBorder),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    _buildCourseModuleTile(
                                      title:
                                          "${course.title} information, including assessment",
                                      content: course.description,
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 1",
                                      content:
                                          "Introduction to functional concepts and immutability.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 2",
                                      content:
                                          "Syntax, Functions & Type Systems.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 3",
                                      content:
                                          "Higher Order Functions and Lambdas.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 4",
                                      content:
                                          "Recursion & Persistent Data Structures.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 5",
                                      content:
                                          "Lazy Evaluation & Infinite Streams.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 6",
                                      content: "State Management & Monads.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 7 & DM-inclass test",
                                      content: "Mid-term In-Class Assessment.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 8",
                                      content:
                                          "Advanced Architectural Design Patterns.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 9",
                                      content:
                                          "Concurrency & Parallel Processing.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 10",
                                      content:
                                          "Automated Testing & Property Verification.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 11",
                                      content: "Revision & Case Studies.",
                                    ),
                                    _buildCourseModuleTile(
                                      title: "Week 12",
                                      content:
                                          "Course Wrap-up & Final Exam Guidance.",
                                    ),
                                    _buildCourseModuleTile(
                                      title:
                                          "On-campus Computer Based Assessments",
                                      assignments: assignments,
                                      assignmentProvider: assignmentProvider,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Panopto Sidebar
                        if (isWide) ...[
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 280,
                            child: SingleChildScrollView(
                              child: _buildPanoptoSidebar(),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),

                // 2. Module Info Tab
                SingleChildScrollView(
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: moodleBorder),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: moodlePurple,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Course Code: ${course.courseCode}",
                            style: const TextStyle(color: moodleTextMuted),
                          ),
                          Text(
                            "Instructor: ${course.instructor}",
                            style: const TextStyle(color: moodleTextMuted),
                          ),
                          const Divider(height: 32),
                          Text(
                            course.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: moodleTextDark,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Assessment Tab (AIR)
                _buildAssignmentsList(assignments, assignmentProvider),

                // 4. Reading Lists Tab
                const Center(
                  child: Text(
                    "No Reading Lists Available.",
                    style: TextStyle(color: moodleTextMuted),
                  ),
                ),

                // 5. Grades Tab
                const Center(
                  child: Text(
                    "Grades will be updated here.",
                    style: TextStyle(color: moodleTextMuted),
                  ),
                ),

                // 6. More Tab
                const Center(
                  child: Text(
                    "Additional Course Tools.",
                    style: TextStyle(color: moodleTextMuted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseModuleTile({
    required String title,
    String? content,
    List<AssignmentModel>? assignments,
    AssignmentProvider? assignmentProvider,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ExpansionTile(
        shape: Border.all(color: Colors.transparent),
        collapsedShape: Border.all(color: Colors.transparent),
        leading: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.chevron_right,
            color: moodlePurple,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: moodleTextDark,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (content != null)
                  Text(
                    content,
                    style: const TextStyle(color: moodleTextDark),
                  ),
                if (assignments != null && assignments.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      final assignment = assignments[index];
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
                          title: Text(assignment.title),
                          subtitle: Text(
                            assignment.isSubmitted
                                ? "Status: Submitted ${assignment.grade != null ? '(Grade: ${assignment.grade})' : ''}"
                                : "Due: ${assignment.dueDate.toLocal().toString().split(' ')[0]}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Quick submit modal button
                              if (!assignment.isSubmitted &&
                                  assignmentProvider != null)
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: moodlePurple,
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: const Icon(Icons.upload, size: 16),
                                  label: const Text("Submit"),
                                  onPressed: () => _showDirectSubmitDialog(
                                    context,
                                    assignment,
                                    assignmentProvider,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              // Full screen button
                              OutlinedButton(
                                onPressed: () => context.push(
                                  '/assignment/${assignment.id}',
                                ),
                                child: const Text("Open Details"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanoptoSidebar() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: moodleBorder),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Panopto",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: moodlePurple,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Live sessions",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: moodleTextDark,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "No live sessions",
              style: TextStyle(color: moodleTextMuted, fontSize: 13),
            ),
            SizedBox(height: 16),
            Text(
              "Completed recordings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: moodleTextDark,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "No completed recordings",
              style: TextStyle(color: moodleTextMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentsList(
    List<AssignmentModel> assignments,
    AssignmentProvider assignmentProvider,
  ) {
    if (assignments.isEmpty) {
      return const Center(
        child: Text(
          "No assignments available for this module.",
          style: TextStyle(color: moodleTextMuted),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: moodleBorder),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              assignment.isSubmitted
                  ? Icons.check_circle_outline
                  : Icons.assignment,
              color: assignment.isSubmitted ? Colors.green : moodlePurple,
            ),
            title: Text(assignment.title),
            subtitle: Text(
              "${assignment.description}\nDue: ${assignment.dueDate.toLocal().toString().split(' ')[0]}",
            ),
            trailing: assignment.isSubmitted
                ? const Chip(
                    label: Text("Submitted"),
                    avatar: Icon(Icons.check, color: Colors.green, size: 16),
                  )
                : FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: moodlePurple),
                    onPressed: () => _showDirectSubmitDialog(
                      context,
                      assignment,
                      assignmentProvider,
                    ),
                    child: const Text("Submit"),
                  ),
          ),
        );
      },
    );
  }
}