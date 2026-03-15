// ============================================================
// Project Milestone 2: Student Grade Calculator - Kotlin
// Console Application
// ============================================================

// Data class representing a Student
data class Student(
    val name: String,
    val id: String,
    val grades: MutableList<Double> = mutableListOf()
) {
    // Function 1: Calculate average grade (validation + computation)
    fun calculateAverage(): Double {
        if (grades.isEmpty()) return 0.0
        return grades.sum() / grades.size
    }

    // Function 2: Get letter grade based on average
    fun getLetterGrade(): String {
        return when {
            calculateAverage() >= 90 -> "A"
            calculateAverage() >= 80 -> "B"
            calculateAverage() >= 70 -> "C"
            calculateAverage() >= 60 -> "D"
            else                     -> "F"
        }
    }

    // Function 3: Validate and add a grade
    fun addGrade(grade: Double): Boolean {
        return if (grade in 0.0..100.0) {
            grades.add(grade)
            true
        } else {
            false
        }
    }

    // Function 4: Format student info for display
    fun formatSummary(): String {
        val avg = calculateAverage()
        val letter = getLetterGrade()
        val status = if (avg >= 60) "PASS" else "FAIL"
        return """
            |Student: $name (ID: $id)
            |Grades : ${grades.joinToString(", ")}
            |Average: ${"%.2f".format(avg)}
            |Grade  : $letter  [$status]
        """.trimMargin()
    }
}

// Higher-order function: apply an operation to a list of students
fun processStudents(students: List<Student>, operation: (Student) -> Unit) {
    students.forEach { operation(it) }
}

// Higher-order function: filter students by condition
fun filterStudents(students: List<Student>, predicate: (Student) -> Boolean): List<Student> {
    return students.filter(predicate)
}

// Higher-order function: map students to a transformed result
fun <T> mapStudents(students: List<Student>, transform: (Student) -> T): List<T> {
    return students.map(transform)
}

// ============================================================
// MAIN FUNCTION - Console Application Entry Point
// ============================================================
fun main() {
    println("╔══════════════════════════════════════════╗")
    println("║   Student Grade Calculator - Kotlin      ║")
    println("║   Project Milestone 2                    ║")
    println("╚══════════════════════════════════════════╝\n")

    // Sample student data
    val students = mutableListOf(
        Student("Alice Johnson", "STU001"),
        Student("Bob Smith",     "STU002"),
        Student("Carol White",   "STU003"),
        Student("David Brown",   "STU004"),
        Student("Eva Martinez",  "STU005")
    )

    // Add grades for each student
    students[0].apply { listOf(92.0, 88.0, 95.0, 91.0, 87.0).forEach { addGrade(it) } }
    students[1].apply { listOf(74.0, 68.0, 72.0, 65.0, 70.0).forEach { addGrade(it) } }
    students[2].apply { listOf(55.0, 60.0, 58.0, 52.0, 57.0).forEach { addGrade(it) } }
    students[3].apply { listOf(81.0, 85.0, 79.0, 88.0, 82.0).forEach { addGrade(it) } }
    students[4].apply { listOf(98.0, 96.0, 99.0, 97.0, 95.0).forEach { addGrade(it) } }

    // ── Demo 1: Higher-order function with lambda ─────────────────
    println("── All Student Summaries ──────────────────────")
    processStudents(students) { student ->
        println(student.formatSummary())
        println()
    }

    // ── Demo 2: Collection operation - filter passing students ─────
    println("── Passing Students (avg >= 60) ───────────────")
    val passingStudents = filterStudents(students) { it.calculateAverage() >= 60 }
    passingStudents.forEach { println("  ✓ ${it.name}  -  ${it.getLetterGrade()}  (${"%.2f".format(it.calculateAverage())})") }

    println()
    println("── Failing Students (avg < 60) ────────────────")
    val failingStudents = filterStudents(students) { it.calculateAverage() < 60 }
    if (failingStudents.isEmpty()) {
        println("  (none)")
    } else {
        failingStudents.forEach { println("  ✗ ${it.name}  -  ${"%.2f".format(it.calculateAverage())}") }
    }

    // ── Demo 3: Map students to averages ───────────────────────────
    println()
    println("── Class Averages (map) ───────────────────────")
    val averages = mapStudents(students) { "${it.name}: ${"%.2f".format(it.calculateAverage())}" }
    averages.forEach { println("  $it") }

    // ── Demo 4: Class statistics ───────────────────────────────────
    println()
    println("── Class Statistics ───────────────────────────")
    val allAverages = students.map { it.calculateAverage() }
    val classAvg   = allAverages.average()
    val highest    = students.maxByOrNull { it.calculateAverage() }
    val lowest     = students.minByOrNull { it.calculateAverage() }

    println("  Class Average : ${"%.2f".format(classAvg)}")
    println("  Top Student   : ${highest?.name} (${"%.2f".format(highest?.calculateAverage() ?: 0.0)})")
    println("  Needs Support : ${lowest?.name}  (${"%.2f".format(lowest?.calculateAverage() ?: 0.0)})")

    // ── Demo 5: Grade distribution ─────────────────────────────────
    println()
    println("── Grade Distribution ─────────────────────────")
    val distribution = students.groupBy { it.getLetterGrade() }
    listOf("A", "B", "C", "D", "F").forEach { letter ->
        val count = distribution[letter]?.size ?: 0
        val bar   = "█".repeat(count)
        println("  $letter : $bar ($count)")
    }

    println()
    println("╔══════════════════════════════════════════╗")
    println("║            End of Report                 ║")
    println("╚══════════════════════════════════════════╝")
}
