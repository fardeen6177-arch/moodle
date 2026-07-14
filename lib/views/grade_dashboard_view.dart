import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';
import 'package:moodle/widgets/moodle_scaffold.dart';

class GradeModel {
  final String courseName;
  final String courseCode;
  final double grade;
  final String letterGrade;
  final int weight;

  GradeModel({
    required this.courseName,
    required this.courseCode,
    required this.grade,
    required this.letterGrade,
    required this.weight,
  });
}

class GradeDashboardView extends StatelessWidget {
  const GradeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock grade data
    final grades = [
      GradeModel(
        courseName: 'USER EXPERIENCE DESIGN AND IMPLEMENTATION',
        courseCode: 'M30235',
        grade: 87.5,
        letterGrade: 'A',
        weight: 30,
      ),
      GradeModel(
        courseName: 'PROGRAMMING APPLICATIONS',
        courseCode: 'M30234',
        grade: 78.0,
        letterGrade: 'B+',
        weight: 25,
      ),
      GradeModel(
        courseName: 'PROGRAMMING LANGUAGES',
        courseCode: 'M30236',
        grade: 82.3,
        letterGrade: 'A-',
        weight: 25,
      ),
      GradeModel(
        courseName: 'SOFTWARE ENGINEERING',
        courseCode: 'M30237',
        grade: 91.0,
        letterGrade: 'A',
        weight: 20,
      ),
    ];

    // Calculate weighted GPA
    double totalWeightedGrade = 0;
    int totalWeight = 0;
    for (final grade in grades) {
      totalWeightedGrade += grade.grade * grade.weight;
      totalWeight += grade.weight;
    }
    final gpa = totalWeightedGrade / totalWeight;

    return MoodleScaffold(
      title: 'Grades',
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/notifications'),
        ),
        const SizedBox(width: 8),
      ],
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Grade Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),
          const SizedBox(height: 24),
          // Overall GPA Card
          _OverallGpaCard(gpa: gpa),
          const SizedBox(height: 24),
          const Text(
            'Course Grades',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: moodleTextDark,
            ),
          ),
          const SizedBox(height: 16),
          // Grade cards for each course
          ...grades.map((grade) => _GradeCard(grade: grade)),
        ],
      ),
    );
  }
}

class _OverallGpaCard extends StatelessWidget {
  const _OverallGpaCard({required this.gpa});

  final double gpa;

  String _getGpaStatus(double gpa) {
    if (gpa >= 90) return 'Excellent';
    if (gpa >= 80) return 'Very Good';
    if (gpa >= 70) return 'Good';
    if (gpa >= 60) return 'Satisfactory';
    return 'Needs Improvement';
  }

  Color _getGpaColor(double gpa) {
    if (gpa >= 90) return moodlePurple;
    if (gpa >= 80) return moodleBlue;
    if (gpa >= 70) return const Color(0xFF4CAF50);
    if (gpa >= 60) return const Color(0xFFFFC107);
    return const Color(0xFFFF5252);
  }

  @override
  Widget build(BuildContext context) {
    final gpaColor = _getGpaColor(gpa);
    final gpaStatus = _getGpaStatus(gpa);

    return Card(
      color: moodleWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: gpaColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Overall GPA',
              style: TextStyle(fontSize: 18, color: moodleTextMuted),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  gpa.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: gpaColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  gpaStatus,
                  style: TextStyle(
                    fontSize: 18,
                    color: gpaColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: gpa / 100,
                minHeight: 8,
                backgroundColor: moodleGrayBg,
                valueColor: AlwaysStoppedAnimation<Color>(gpaColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeCard extends StatefulWidget {
  const _GradeCard({required this.grade});

  final GradeModel grade;

  @override
  State<_GradeCard> createState() => _GradeCardState();
}

class _GradeCardState extends State<_GradeCard> {
  bool _expanded = false;

  Color _getGradeColor(double grade) {
    if (grade >= 90) return moodlePurple;
    if (grade >= 80) return moodleBlue;
    if (grade >= 70) return const Color(0xFF4CAF50);
    if (grade >= 60) return const Color(0xFFFFC107);
    return const Color(0xFFFF5252);
  }

  @override
  Widget build(BuildContext context) {
    final gradeColor = _getGradeColor(widget.grade.grade);

    return Card(
      color: moodleWhite,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: moodleBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: gradeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              widget.grade.grade.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: gradeColor,
              ),
            ),
          ),
        ),
        title: Text(
          widget.grade.courseCode,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        subtitle: Text(widget.grade.courseName),
        trailing: Text(
          widget.grade.letterGrade,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: gradeColor,
          ),
        ),
        onTap: () => setState(() => _expanded = !_expanded),
      ),
    );
  }
}
