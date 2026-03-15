// ============================================================
// Project Milestone 2: Student Grade Calculator - Dart
// Console Application
// Run: dart run student_grade_calculator.dart
// ============================================================

// ── Data Model ────────────────────────────────────────────
class Student {
  final String id;
  final String name;
  final List<double> grades;

  Student({required this.id, required this.name, List<double>? grades})
      : grades = grades ?? [];

  // Function 1: Calculate average with validation
  double calculateAverage() {
    if (grades.isEmpty) return 0.0;
    return grades.reduce((a, b) => a + b) / grades.length;
  }

  // Function 2: Determine letter grade using when-style switch
  String getLetterGrade() {
    final avg = calculateAverage();
    if (avg >= 90) return 'A';
    if (avg >= 80) return 'B';
    if (avg >= 70) return 'C';
    if (avg >= 60) return 'D';
    return 'F';
  }

  // Function 3: Validate and add a grade
  bool addGrade(double grade) {
    if (grade >= 0.0 && grade <= 100.0) {
      grades.add(grade);
      return true;
    }
    return false;
  }

  // Function 4: Check pass/fail
  bool isPassing() => calculateAverage() >= 60;

  // Function 5: Format summary
  String formatSummary() {
    final avg    = calculateAverage();
    final letter = getLetterGrade();
    final status = isPassing() ? 'PASS' : 'FAIL';
    return '''
Student: $name (ID: $id)
Grades : ${grades.join(', ')}
Average: ${avg.toStringAsFixed(2)}
Grade  : $letter  [$status]''';
  }
}

// ── Higher-Order Functions ────────────────────────────────

// Apply an operation (lambda) to every student
void processStudents(List<Student> students, void Function(Student) action) {
  students.forEach(action);
}

// Filter students by a predicate
List<Student> filterStudents(
    List<Student> students, bool Function(Student) predicate) {
  return students.where(predicate).toList();
}

// Map students to a new type using a transform lambda
List<T> mapStudents<T>(
    List<Student> students, T Function(Student) transform) {
  return students.map(transform).toList();
}

// Custom higher-order function: reduce to a scalar
T reduceStudents<T>(
    List<Student> students, T initial, T Function(T acc, Student s) combiner) {
  return students.fold(initial, combiner);
}

// ── MAIN ──────────────────────────────────────────────────
void main() {
  print('╔══════════════════════════════════════════╗');
  print('║   Student Grade Calculator - Dart        ║');
  print('║   Project Milestone 2                    ║');
  print('╚══════════════════════════════════════════╝\n');

  // Build student list
  final students = <Student>[
    Student(id: 'STU001', name: 'Alice Johnson', grades: [92, 88, 95, 91, 87]),
    Student(id: 'STU002', name: 'Bob Smith',     grades: [74, 68, 72, 65, 70]),
    Student(id: 'STU003', name: 'Carol White',   grades: [55, 60, 58, 52, 57]),
    Student(id: 'STU004', name: 'David Brown',   grades: [81, 85, 79, 88, 82]),
    Student(id: 'STU005', name: 'Eva Martinez',  grades: [98, 96, 99, 97, 95]),
  ];

  // ── Demo 1: Lambda passed to higher-order function ─────────
  print('── All Student Summaries ──────────────────────');
  processStudents(students, (student) {
    print(student.formatSummary());
    print('');
  });

  // ── Demo 2: Filter collection operation ───────────────────
  print('── Passing Students (avg >= 60) ───────────────');
  final passing = filterStudents(students, (s) => s.isPassing());
  for (final s in passing) {
    print('  ✓ ${s.name.padRight(20)} ${s.getLetterGrade()}'
        '  (${s.calculateAverage().toStringAsFixed(2)})');
  }

  print('');
  print('── Failing Students (avg < 60) ────────────────');
  final failing = filterStudents(students, (s) => !s.isPassing());
  if (failing.isEmpty) {
    print('  (none)');
  } else {
    for (final s in failing) {
      print('  ✗ ${s.name.padRight(20)} ${s.calculateAverage().toStringAsFixed(2)}');
    }
  }

  // ── Demo 3: Map to summaries ───────────────────────────────
  print('');
  print('── Averages via map() ─────────────────────────');
  final summaries = mapStudents(
      students, (s) => '${s.name}: ${s.calculateAverage().toStringAsFixed(2)}');
  summaries.forEach((line) => print('  $line'));

  // ── Demo 4: Reduce – total class score ────────────────────
  print('');
  final totalScore = reduceStudents<double>(
      students, 0.0, (acc, s) => acc + s.calculateAverage());
  final classAvg = totalScore / students.length;
  print('── Class Statistics ───────────────────────────');
  print('  Class Average : ${classAvg.toStringAsFixed(2)}');

  final top    = students.reduce((a, b) =>
      a.calculateAverage() >= b.calculateAverage() ? a : b);
  final bottom = students.reduce((a, b) =>
      a.calculateAverage() <= b.calculateAverage() ? a : b);
  print('  Top Student   : ${top.name} (${top.calculateAverage().toStringAsFixed(2)})');
  print('  Needs Support : ${bottom.name} (${bottom.calculateAverage().toStringAsFixed(2)})');

  // ── Demo 5: Grade distribution ─────────────────────────────
  print('');
  print('── Grade Distribution ─────────────────────────');
  final dist = <String, int>{'A': 0, 'B': 0, 'C': 0, 'D': 0, 'F': 0};
  students.forEach((s) => dist[s.getLetterGrade()] = (dist[s.getLetterGrade()] ?? 0) + 1);
  dist.forEach((letter, count) {
    final bar = '█' * count;
    print('  $letter : $bar ($count)');
  });

  print('');
  print('╔══════════════════════════════════════════╗');
  print('║            End of Report                 ║');
  print('╚══════════════════════════════════════════╝');
}
