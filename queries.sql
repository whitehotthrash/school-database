-- Queries

-- simple select
SELECT * FROM "Student"
WHERE "FullName" = 'Bob Brown';

-- quick reference
SELECT * FROM "Block";

-- join tables for single record
SELECT s."FullName", c."CourseName", c."Credits", b."RoomNo"
FROM "Enrollment" e
JOIN "Student" s ON s."StudentID" = e."StudentID"
JOIN "Course"  c ON c."CourseID"  = e."CourseID"
JOIN "Block"   b ON b."BlockCode" = c."BlockCode"
WHERE s."FullName" = 'Veronica Reyes'
LIMIT 1;

-- insert record into a table
INSERT INTO "Block" ("RoomNo") 
VALUES (2)
RETURNING *;

-- insert record into table with FK data
WITH new_student AS (
  INSERT INTO "Student" ("FullName", "DOB")
  VALUES ('Amuro Ray', '2000-01-01')
  RETURNING "StudentID"
)
INSERT INTO "Enrollment" ("StudentID", "CourseID")
SELECT ns."StudentID", c."CourseID"
FROM new_student ns
JOIN "Course" c ON c."CourseName" = 'Networking'
RETURNING *;

-- update a record
UPDATE "Course"
SET "Credits" = 6
WHERE "CourseName" = 'Programming'
RETURNING *;

-- deleting a record, using USING with joins
DELETE FROM "Enrollment" e 
USING "Student" s, "Course" c 
WHERE e."StudentID" = s."StudentID"
  AND e."CourseID" = c."CourseID"
  AND s."FullName" = 'Robert Gil'
  AND c."CourseName" = 'Networking'
RETURNING e.*;

-- lets order data by a specific value
SELECT "CourseName", "Credits"
FROM "Course"
ORDER BY "Credits" DESC, "CourseName" ASC;

-- calculating data based on values from tables
-- total credits a specific student can gain
SELECT s."FullName", 
  COALESCE(SUM(c."Credits"), 0) AS "TotalCredits"
FROM "Student" s 
LEFT JOIN "Enrollment" e ON e."StudentID" = s."StudentID"
LEFT JOIN "Course" c ON c."CourseID" = e."CourseID"
WHERE s."FullName" = 'Alice Elwood'
GROUP BY s."FullName";


-- min and max credits per instructor across their assigned courses
SELECT i."FullName",
       MIN(c."Credits") AS min_credits,
       MAX(c."Credits") AS max_credits,
       COUNT(*)         AS taught_courses
FROM "Instructor" i
JOIN "CourseInstructor" ci ON ci."InstructorID" = i."InstructorID"
JOIN "Course" c            ON c."CourseID"      = ci."CourseID"
GROUP BY i."FullName"
ORDER BY max_credits DESC, i."FullName";


-- rank students by total credits
SELECT s."FullName",
       COALESCE(SUM(c."Credits"),0) AS total_credits,
       RANK() OVER (ORDER BY COALESCE(SUM(c."Credits"),0) DESC) AS rank_by_credits
FROM "Student" s
LEFT JOIN "Enrollment" e ON e."StudentID" = s."StudentID"
LEFT JOIN "Course"     c ON c."CourseID"  = e."CourseID"
GROUP BY s."FullName"
ORDER BY total_credits DESC, s."FullName";


-- filtering data based on a specific value
SELECT c."CourseName", c."Credits", c."BlockCode"
FROM "Course" c 
WHERE c."BlockCode" = 2;