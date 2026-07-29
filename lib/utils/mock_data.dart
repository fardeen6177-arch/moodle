import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/assignment_model.dart';
import '../models/announcement_model.dart';
import '../models/notification_model.dart';

class MockData {
  static final UserModel currentUser = UserModel(
    id: '2199439',
    name: 'Fardeen shaikh',
    email: 'student@university.edu',
    profileImageUrl: null,
  );

  static final List<CourseModel> courses = [
    CourseModel(
      id: 'c_001',
      title: 'Advanced Mathematics',
      courseCode: 'MATH501',
      description:
          'An in-depth study of Linear Algebra, Riemann Hypothesis, and advanced calculus.',
      instructor: 'Dr. A. Sharma',
      progress: 0.75,
    ),
    CourseModel(
      id: 'c_002',
      title: 'Cloud Computing Architecture',
      courseCode: 'CS601',
      description:
          'Design and implementation of cloud applications, microservices, and API integrations.',
      instructor: 'Prof. S. Gupta',
      progress: 0.40,
    ),
    CourseModel(
      id: 'c_003',
      title: 'Machine Learning & AI',
      courseCode: 'CS602',
      description:
          'Applied machine learning focusing on Neural Networks, OCR pipelines, and semantic similarity.',
      instructor: 'Dr. V. Patel',
      progress: 0.90,
    ),
  ];

  static final List<AssignmentModel> assignments = [
    AssignmentModel(
      id: 'a_001',
      courseId: 'c_001',
      title: 'Linear Algebra Problem Set 3',
      description:
          'Complete the attached proofs regarding vector spaces and eigenvalues.',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      isSubmitted: false,
    ),
    AssignmentModel(
      id: 'a_002',
      courseId: 'c_002',
      title: 'Smart Travel Planner Microservices',
      description:
          'Submit your architecture diagrams and initial API endpoints for the travel planner.',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isSubmitted: false,
    ),
    AssignmentModel(
      id: 'a_003',
      courseId: 'c_003',
      title: 'TrOCR Model Fine-tuning',
      description:
          'Report on the accuracy metrics of your fine-tuned OCR model for handwritten text.',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      isSubmitted: true,
      submissionText:
          'Attached is the technical report detailing the training pipeline.',
      grade: 95.0,
    ),
  ];

  static final List<AnnouncementModel> announcements = [
    AnnouncementModel(
      id: 'ann_001',
      title: 'Welcome to the New Semester!',
      content:
          'Please ensure your course registrations are finalized by the end of the week.',
      datePosted: DateTime.now().subtract(const Duration(days: 7)),
      authorName: 'University Administration',
    ),
    AnnouncementModel(
      id: 'ann_002',
      courseId: 'c_002',
      title: 'Hackathon Registration Open',
      content:
          'Registration for the upcoming 9-hour innovation challenge is now live. Form your teams!',
      datePosted: DateTime.now().subtract(const Duration(days: 1)),
      authorName: 'Prof. S. Gupta',
    ),
  ];

  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'n_001',
      title: 'Assignment Graded',
      message: 'Your assignment "TrOCR Model Fine-tuning" has been graded.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationModel(
      id: 'n_002',
      title: 'Upcoming Deadline',
      message: '"Linear Algebra Problem Set 3" is due in 2 days.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
  ];
}
