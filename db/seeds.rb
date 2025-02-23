puts "Seeding data..."

# Create Schools
school1 = School.create!(name: "Piti Academy", address: "123 Main St, Bangkok")
school2 = School.create!(name: "Kanat Kitty School", address: "456 Algorithm Rd, Nakhon Pathom")

# Create Classrooms
classroom1 = Classroom.create!(class_id: "5A", grade_level: 5)
classroom2 = Classroom.create!(class_id: "6B", grade_level: 6)
classroom3 = Classroom.create!(class_id: "6A", grade_level: 6)

# Create Users (Principals, Teachers, Students)
principal1 = User.create!(
  first_name: "Alice",
  last_name: "Johnson",
  personal_email: "alice.johnson@example.com",
  email_address: "alice.j@principal.schoolname.edu",
  password: "password123",
  password_confirmation: "password123",
  role: "principal",
  school_id: school1.id,
  approved: true
)

principal2 = User.create!(
  first_name: "Bob",
  last_name: "Smith",
  personal_email: "bob.smith@example.com",
  email_address: "bob.s@principal.schoolname.edu",
  password: "password123",
  password_confirmation: "password123",
  role: "principal",
  school_id: school2.id,
  approved: true
)

teacher1 = User.create!(
  first_name: "John",
  last_name: "Doe",
  personal_email: "john.doe@example.com",
  email_address: "john.d@teacher.schoolname.edu",
  password: "password123",
  password_confirmation: "password123",
  role: "teacher",
  school_id: school1.id,
  approved: false
)

teacher2 = User.create!(
  first_name: "Jane",
  last_name: "Doe",
  personal_email: "jane.doe@example.com",
  email_address: "jane.d@teacher.schoolname.edu",
  password: "password123",
  password_confirmation: "password123",
  role: "teacher",
  school_id: school2.id,
  approved: false
)

teacher3 = User.create!(
  first_name: "Mike",
  last_name: "Brown",
  personal_email: "mike.brown@example.com",
  email_address: "mike.b@teacher.schoolname.edu",
  password: "password123",
  password_confirmation: "password123",
  role: "teacher",
  school_id: school2.id,
  approved: false
)

# Create Students (Separate Student Model)
student1 = Student.create!(
  name: "Tyla Nojokes",
  grade: 5,
  student_email_address: "student1@example.com",
  parent_email_address: "parent1@example.com",
  classroom_id: classroom1.id
)

student2 = Student.create!(
  name: "Mark Zuck",
  grade: 6,
  student_email_address: "student2@example.com",
  parent_email_address: "parent2@example.com",
  classroom_id: classroom2.id
)

student3 = Student.create!(
  name: "Harry Singh",
  grade: 6,
  student_email_address: "student3@example.com",
  parent_email_address: "parent2@example.com",
  classroom_id: classroom3.id
)

# Create Homerooms
Homeroom.create!(teacher_id: teacher1.id, classroom_id: classroom1.id)
Homeroom.create!(teacher_id: teacher2.id, classroom_id: classroom2.id)
Homeroom.create!(teacher_id: teacher3.id, classroom_id: classroom3.id)

# Create School Tiers
SchoolTier.create!(school_id: school1.id, tier: "Basic")
SchoolTier.create!(school_id: school2.id, tier: "Premium")

# Create Teacher-Student Relationships
TeacherStudentRelationship.create!(teacher_id: teacher1.id, student_id: student1.id)
TeacherStudentRelationship.create!(teacher_id: teacher2.id, student_id: student2.id)
TeacherStudentRelationship.create!(teacher_id: teacher3.id, student_id: student3.id)

# Create Principal-Teacher Relationships
PrincipalTeacherRelationship.create!(principal_id: principal1.id, teacher_id: teacher1.id)
PrincipalTeacherRelationship.create!(principal_id: principal2.id, teacher_id: teacher2.id)

# Create Attendance Records
Attendance.create!(student_id: student1.id, user_id: teacher1.id, timestamp: Time.current)
Attendance.create!(student_id: student2.id, user_id: teacher2.id, timestamp: Time.current)
Attendance.create!(student_id: student3.id, user_id: teacher3.id, timestamp: Time.current)

puts "Seeding complete!"
