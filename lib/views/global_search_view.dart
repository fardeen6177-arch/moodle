import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';
import 'package:moodle/widgets/moodle_scaffold.dart';

class SearchResultModel {
  final String type; // 'course', 'assignment', 'announcement', 'resource'
  final String title;
  final String subtitle;
  final String? icon;
  final VoidCallback onTap;

  SearchResultModel({
    required this.type,
    required this.title,
    required this.subtitle,
    this.icon,
    required this.onTap,
  });
}

class GlobalSearchView extends StatefulWidget {
  const GlobalSearchView({super.key});

  @override
  State<GlobalSearchView> createState() => _GlobalSearchViewState();
}

class _GlobalSearchViewState extends State<GlobalSearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResultModel> _searchResults = [];

  // Mock data for search
  final Map<String, List<Map<String, String>>> _searchDatabase = {
    'courses': [
      {
        'title': 'USER EXPERIENCE DESIGN AND IMPLEMENTATION',
        'code': 'M30235',
        'subtitle': 'FHEQ 5'
      },
      {
        'title': 'PROGRAMMING APPLICATIONS',
        'code': 'M30234',
        'subtitle': 'FHEQ 5'
      },
      {
        'title': 'PROGRAMMING LANGUAGES',
        'code': 'M30236',
        'subtitle': 'FHEQ 5'
      },
      {'title': 'SOFTWARE ENGINEERING', 'code': 'M30237', 'subtitle': 'FHEQ 5'},
    ],
    'materials': [
      {
        'title': 'Coursework brief PDF',
        'category': 'UXDI',
        'subtitle': 'Document'
      },
      {
        'title': 'Responsive layout checklist',
        'category': 'UXDI',
        'subtitle': 'Guide'
      },
      {
        'title': 'Starter wireframe examples',
        'category': 'UXDI',
        'subtitle': 'Resource'
      },
      {'title': 'User flow sketches', 'category': 'UXDI', 'subtitle': 'Visual'},
    ],
    'announcements': [
      {
        'title': 'New coursework brief available',
        'category': 'UXDI',
        'subtitle': 'Posted 2 days ago'
      },
      {
        'title': 'Demo booking deadline approaching',
        'category': 'System',
        'subtitle': 'Posted 1 day ago'
      },
      {
        'title': 'Assessment submission reminder',
        'category': 'System',
        'subtitle': 'Posted 3 hours ago'
      },
    ],
  };

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final results = <SearchResultModel>[];

    // Search courses
    for (final course in _searchDatabase['courses']!) {
      if (course['title']!.toLowerCase().contains(lowerQuery) ||
          course['code']!.toLowerCase().contains(lowerQuery)) {
        results.add(
          SearchResultModel(
            type: 'course',
            title: course['code']!,
            subtitle: course['title']!,
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/course-details'),
          ),
        );
      }
    }

    // Search materials
    for (final material in _searchDatabase['materials']!) {
      if (material['title']!.toLowerCase().contains(lowerQuery)) {
        results.add(
          SearchResultModel(
            type: 'resource',
            title: material['title']!,
            subtitle: material['category']!,
            onTap: () => _showMaterialDetail(material['title']!),
          ),
        );
      }
    }

    // Search announcements
    for (final announcement in _searchDatabase['announcements']!) {
      if (announcement['title']!.toLowerCase().contains(lowerQuery)) {
        results.add(
          SearchResultModel(
            type: 'announcement',
            title: announcement['title']!,
            subtitle: announcement['subtitle']!,
            onTap: () => _showAnnouncementDetail(announcement['title']!),
          ),
        );
      }
    }

    setState(() => _searchResults = results);
  }

  void _showMaterialDetail(String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: const Text('Resource details would be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAnnouncementDetail(String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: const Text('Full announcement text would be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MoodleScaffold(
      title: 'Search',
      actions: const [],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search courses, materials, announcements...',
                prefixIcon: const Icon(Icons.search_outlined),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: moodleWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: moodleBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: moodlePurple, width: 2),
                ),
              ),
            ),
          ),
          if (_searchController.text.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Start typing to search across courses, materials, and announcements.',
                textAlign: TextAlign.center,
                style: TextStyle(color: moodleTextMuted),
              ),
            )
          else if (_searchResults.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.search_off_outlined,
                      size: 48, color: moodleTextMuted),
                  const SizedBox(height: 16),
                  Text(
                    'No results for "${_searchController.text}"',
                    style: const TextStyle(color: moodleTextMuted),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return _SearchResultTile(result: result);
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.result});

  final SearchResultModel result;

  IconData _getIconForType(String type) {
    switch (type) {
      case 'course':
        return Icons.menu_book_outlined;
      case 'resource':
        return Icons.description_outlined;
      case 'announcement':
        return Icons.notifications_outlined;
      default:
        return Icons.search_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: moodleWhite,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: moodleBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(_getIconForType(result.type), color: moodlePurple),
        title: Text(
          result.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(result.subtitle),
        trailing: const Icon(Icons.chevron_right, color: moodleTextMuted),
        onTap: result.onTap,
      ),
    );
  }
}
