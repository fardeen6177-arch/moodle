import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../utils/mock_data.dart';
import '../../models/assignment_model.dart';

class AssignmentSubmissionScreen extends StatefulWidget {
  final String assignmentId;

  const AssignmentSubmissionScreen({super.key, required this.assignmentId});

  @override
  State<AssignmentSubmissionScreen> createState() =>
      _AssignmentSubmissionScreenState();
}

class _AssignmentSubmissionScreenState
    extends State<AssignmentSubmissionScreen> {
  late AssignmentModel assignment;
  final TextEditingController _textController = TextEditingController();
  String? _selectedFileName;

  @override
  void initState() {
    super.initState();
    _loadAssignment();
  }

  void _loadAssignment() {
    assignment = MockData.assignments.firstWhere(
      (a) => a.id == widget.assignmentId,
      orElse: () => MockData.assignments.first,
    );
    if (assignment.submissionText != null) {
      _textController.text = assignment.submissionText!;
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
    }
  }

  void _submitAssignment() {
    // In a real app, this would use a Provider/Repository to upload to Firebase
    setState(() {
      assignment = assignment.copyWith(
        isSubmitted: true,
        submissionText: _textController.text.isNotEmpty
            ? _textController.text
            : null,
        fileUrl: _selectedFileName,
      );

      // Update mock data for immediate UI feedback
      final index = MockData.assignments.indexWhere(
        (a) => a.id == widget.assignmentId,
      );
      if (index != -1) {
        MockData.assignments[index] = assignment;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assignment submitted successfully!')),
    );
    Navigator.pop(context); // Return to the previous screen
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Assignment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Due: ${assignment.dueDate.toString().split('.')[0]}',
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(assignment.description),
            const SizedBox(height: 24),

            // Submission Status Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: assignment.isSubmitted ? Colors.green : Colors.orange,
                ),
              ),
              color: assignment.isSubmitted
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              child: ListTile(
                leading: Icon(
                  assignment.isSubmitted
                      ? Icons.check_circle
                      : Icons.pending_actions,
                  color: assignment.isSubmitted ? Colors.green : Colors.orange,
                ),
                title: Text(
                  'Submission Status: ${assignment.isSubmitted ? 'Submitted' : 'Not Attempted'}',
                ),
                subtitle: assignment.grade != null
                    ? Text(
                        'Grade: ${assignment.grade} / ${assignment.maxGrade}',
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 24),

            // Input Fields (Only show if not submitted or if resubmission is allowed)
            if (!assignment.isSubmitted || assignment.grade == null) ...[
              const Text(
                'Online Text:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _textController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Type your submission here...',
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'File Attachment:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(_selectedFileName ?? 'Add File'),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitAssignment,
                  child: const Text('Submit Assignment'),
                ),
              ),
            ] else ...[
              // Read-only view for graded/submitted assignments
              if (assignment.submissionText != null) ...[
                const Text(
                  'Your Submission:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(assignment.submissionText!),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
