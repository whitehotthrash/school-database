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
  "Mobile" BIGINT NOT NULL UNIQUE,
  CONSTRAINT instructor_mobile_8digits_only
    CHECK ("Mobile" BETWEEN 10000000 AND 99999999)
);

CREATE TABLE "Block" (
  "BlockCode" SERIAL PRIMARY KEY,
  "RoomNo" INTEGER NOT NULL,
  CONSTRAINT roomno_position CHECK ("RoomNo" > 0)
);

CREATE TABLE "Course" (
  "CourseID" SERIAL PRIMARY KEY,
  "CourseName" TEXT NOT NULL UNIQUE,
  "Credits" INTEGER NOT NULL DEFAULT 3,
  "BlockCode" INTEGER NOT NULL,
  CONSTRAINT course_credits_not_negative CHECK ("Credits" >= 0),
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

-- Insert seed data
INSERT INTO "Student" ("FullName", "DOB") VALUES
('Robert Gil', '1993-05-20'),
('Veronica Reyes', '1990-09-09'),
('Bob Brown', '1989-08-04'),
('Alice Elwood', '1997-07-27');

INSERT INTO "Instructor" ("FullName", "Mobile") VALUES
('Prof. Edward', 11112222),
('Prof. Zelinski', 22223333),
('Prof. Picard', 44445555),
('Prof. Michaels', 33333333);

INSERT INTO "Block" ("RoomNo") VALUES
(1),
(1),
(1);

INSERT INTO "Course" ("CourseName", "Credits", "BlockCode") VALUES
('Networking', 4, 1),
('Programming', 5, 2),
('Databases', 7, 3);

INSERT INTO "Enrollment" ("StudentID", "CourseID") VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 2),
(3, 3),
(4, 1),
(4, 2),
(4, 3);

INSERT INTO "CourseInstructor" ("CourseID", "InstructorID") VALUES
(1, 1),
(2, 2),
(3, 3),
(1, 4),
(3, 4);

-- ********** End of Session **********