-- ********** Start of Session **********

-- run local session in VSCode

-- safely drop tables
DROP TABLE IF EXISTS "CourseInstructor" CASCADE;
DROP TABLE IF EXISTS "Enrollment" CASCADE;
DROP TABLE IF EXISTS "Course" CASCADE;
DROP TABLE IF EXISTS "Block" CASCADE;
DROP TABLE IF EXISTS "Instructor" CASCADE;
DROP TABLE IF EXISTS "Student" CASCADE;

-- Core tables
CREATE TABLE "Student" (
  "StudentID" SERIAL PRIMARY KEY,
  "FullName" TEXT NOT NULL,
  "DOB" DATE NOT NULL,
  CONSTRAINT ck_student_dob_past CHECK ("DOB" < CURRENT_DATE)
);

CREATE TABLE "Instructor" (
  "InstructorID" SERIAL PRIMARY KEY,
  "FullName" TEXT NOT NULL,
  "Mobile" BIGINT NOT NULL
);

CREATE TABLE "Block" (
  "BlockCode" SERIAL PRIMARY KEY,
  "RoomNo" INTEGER NOT NULL,
  CONSTRAINT ck_block_roomno_pos CHECK ("RoomNo" > 0)
);

CREATE TABLE "Course" (
  "CourseID" SERIAL PRIMARY KEY,
  "CourseName" TEXT NOT NULL UNIQUE,
  "Credits" INTEGER NOT NULL DEFAULT 3,
  "BlockCode" INTEGER NOT NULL,
  CONSTRAINT ck_course_credits_nonneg CHECK ("Credits" >= 0),
  CONSTRAINT fk_course_block
    FOREIGN KEY ("BlockCode") REFERENCES "Block"("BlockCode") 
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Junction tables
CREATE TABLE "Enrollment" (
  "StudentID" INTEGER NOT NULL,
  "CourseID" INTEGER NOT NULL,
  PRIMARY KEY ("StudentID", "CourseID"),
  FOREIGN KEY ("StudentID") REFERENCES "Student"("StudentID") ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY ("CourseID") REFERENCES "Course"("CourseID") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "CourseInstructor" (
  "CourseID" INTEGER NOT NULL,
  "InstructorID" INTEGER NOT NULL,
  PRIMARY KEY ("CourseID", "InstructorID"),
  FOREIGN KEY ("CourseID") REFERENCES "Course"("CourseID") ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY ("InstructorID") REFERENCES "Instructor"("InstructorID") ON UPDATE CASCADE ON DELETE CASCADE
);

-- ********** End of Session **********