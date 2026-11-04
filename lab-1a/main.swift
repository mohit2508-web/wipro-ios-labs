import Foundation

// Lab 1A: Swift Basics, Variables, Types, and Operators

// MARK: - R1: Student data
// The struct uses `let` because a student's record should not change once created.
struct Student {
    let name: String
    let rollNumber: String
    let marks: [Int]        // marks in five subjects, each 0...100
    let attendance: Double  // attendance percentage, 0...100
}

// The rules never change, so they are `let` constants.
let subjectCount = 5
let maxMarkPerSubject = 100
let passMark = 40
let minAttendance = 75.0

func two(_ x: Double) -> String { String(format: "%.2f", x) }

// MARK: - R5: Validation (0, 100, failing mark, invalid attendance)
enum InputError: CustomStringConvertible {
    case wrongSubjectCount(Int)
    case markOutOfRange(subject: Int, mark: Int)
    case attendanceOutOfRange(Double)

    var description: String {
        switch self {
        case .wrongSubjectCount(let n): return "expected \(subjectCount) marks, got \(n)"
        case .markOutOfRange(let subject, let mark): return "subject \(subject) mark \(mark) is outside 0-\(maxMarkPerSubject)"
        case .attendanceOutOfRange(let a): return "attendance \(a)% is outside 0-100"
        }
    }
}

func validate(_ s: Student) -> InputError? {
    guard s.marks.count == subjectCount else { return .wrongSubjectCount(s.marks.count) }
    for (index, mark) in s.marks.enumerated() where mark < 0 || mark > maxMarkPerSubject {
        return .markOutOfRange(subject: index + 1, mark: mark)
    }
    guard (0...100).contains(s.attendance) else { return .attendanceOutOfRange(s.attendance) }
    return nil
}

// MARK: - R4: Grade with switch (extension: a reusable function)
func letterGrade(for percentage: Double) -> String {
    switch percentage {
    case 90...100: return "A+"
    case 80..<90:  return "A"
    case 70..<80:  return "B"
    case 60..<70:  return "C"
    case 50..<60:  return "D"
    case 40..<50:  return "E"
    default:       return "F"
    }
}

// MARK: - R2 + R4: Total, average, percentage, pass/fail, formatted result
func report(for s: Student) -> String {
    if let error = validate(s) {
        return "\(s.name) (\(s.rollNumber)) | INVALID INPUT: \(error)"
    }
    let total = s.marks.reduce(0, +)                                   // Int
    let average = Double(total) / Double(subjectCount)                 // Double
    let percentage = Double(total) * 100 / Double(subjectCount * maxMarkPerSubject)
    let failedSubjects = s.marks.filter { $0 < passMark }.count

    let status: String                                                 // set once, in if/else
    if failedSubjects > 0 {
        status = "FAIL (\(failedSubjects) subject(s) below \(passMark))"
    } else if s.attendance < minAttendance {
        status = "FAIL (attendance below \(Int(minAttendance))%)"
    } else {
        status = "PASS"
    }
    let grade = status == "PASS" ? letterGrade(for: percentage) : "F"

    return "\(s.name) (\(s.rollNumber)) | Total \(total)/\(subjectCount * maxMarkPerSubject)"
        + " | Average \(two(average)) | Percentage \(two(percentage))%"
        + " | Attendance \(String(format: "%.1f", s.attendance))% | \(status) | Grade \(grade)"
}

// MARK: - R3: Operators, each in its own example
func operatorDemo() {
    print("--- R3: Operators ---")
    let a = 17, b = 5
    print("Arithmetic: \(a)+\(b)=\(a + b), \(a)-\(b)=\(a - b), \(a)*\(b)=\(a * b), \(a)/\(b)=\(a / b), \(a)%\(b)=\(a % b)")
    print("Comparison: \(a)>\(b) is \(a > b), \(a)==\(b) is \(a == b), \(a)<=\(b) is \(a <= b)")

    let hasMarks = true, hasAttendance = false
    print("Logical: AND=\(hasMarks && hasAttendance), OR=\(hasMarks || hasAttendance), NOT=\(!hasMarks)")

    var bonus = 10            // var: it changes below
    bonus += 5                // 15
    bonus -= 3                // 12
    bonus *= 2                // 24
    bonus /= 4                // 6
    print("Compound assignment: 10 += 5, -= 3, *= 2, /= 4 -> \(bonus)")

    let missingMark: Int? = nil
    let practicalMark: Int? = 38
    print("Nil-coalescing: missing -> \(missingMark ?? 0), practical -> \(practicalMark ?? 0)")
}

// MARK: - Run
operatorDemo()
print("\n--- R2 / R4 / R5: Results ---")
let students: [Student] = [
    Student(name: "Asha",  rollNumber: "22CS101", marks: [85, 90, 78, 92, 88],      attendance: 92),
    Student(name: "Ravi",  rollNumber: "22CS102", marks: [100, 100, 100, 100, 100], attendance: 100),
    Student(name: "Meena", rollNumber: "22CS103", marks: [40, 40, 40, 40, 40],      attendance: 75),
    Student(name: "Dev",   rollNumber: "22CS104", marks: [65, 72, 58, 61, 69],      attendance: 76),
    Student(name: "Karan", rollNumber: "22CS105", marks: [39, 80, 80, 80, 80],      attendance: 90),
    Student(name: "Priya", rollNumber: "22CS106", marks: [90, 85, 88, 92, 95],      attendance: 60),
    Student(name: "Zoya",  rollNumber: "22CS107", marks: [0, 0, 0, 0, 0],           attendance: 80),
    Student(name: "Arjun", rollNumber: "22CS108", marks: [70, 70, 70, 70, 70],      attendance: 105),
    Student(name: "Neha",  rollNumber: "22CS109", marks: [70, 101, 70, 70, 70],     attendance: 80),
    Student(name: "Sam",   rollNumber: "22CS110", marks: [70, 70, 70, 70, 70],      attendance: -5),
]
for s in students { print(report(for: s)) }
