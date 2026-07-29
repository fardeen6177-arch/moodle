import 'package:flutter/material.dart';
import '../../models/course_model.dart';
import '../../widgets/nav_drawer.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';

class CoursesListScreen extends StatefulWidget {
  const CoursesListScreen({super.key});

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  bool isGridView = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter courses based on search query
    final courseProvider = context.watch<CourseProvider>();

    final filteredCourses = courseProvider.courses.where((course) {
      final query = searchQuery.toLowerCase();
      return course.title.toLowerCase().contains(query) ||
          course.courseCode.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text(
          'My Courses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: 'Toggle View',
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Course List/Grid
          Expanded(
            child: filteredCourses.isEmpty
                ? const Center(child: Text('No courses found.'))
                : isGridView
                ? _buildGridView(filteredCourses)
                : _buildListView(filteredCourses),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<CourseModel> courses) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              // TODO: Navigate to Course Detail
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.courseCode,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: course.progress,
                    backgroundColor: Colors.grey.shade200,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(course.progress * 100).toInt()}% complete',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<CourseModel> courses) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.85,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/course/${course.id}');

              // TODO: Navigate to Course Detail
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      course.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    course.courseCode,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Spacer(),
                  LinearProgressIndicator(
                    value: course.progress,
                    backgroundColor: Colors.grey.shade200,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(course.progress * 100).toInt()}%',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
