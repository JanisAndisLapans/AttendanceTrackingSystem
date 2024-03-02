DROP TABLE attendance CASCADE CONSTRAINTS;

DROP TABLE attendance_file CASCADE CONSTRAINTS;

DROP TABLE attendance_status CASCADE CONSTRAINTS;

DROP TABLE course CASCADE CONSTRAINTS;

DROP TABLE error_log CASCADE CONSTRAINTS;

DROP TABLE lecture CASCADE CONSTRAINTS;

DROP TABLE semester CASCADE CONSTRAINTS;

DROP TABLE student_course CASCADE CONSTRAINTS;

DROP TABLE "user" CASCADE CONSTRAINTS;

DROP TABLE user_type CASCADE CONSTRAINTS;

drop SEQUENCE attendance_sq;
drop SEQUENCE attendance_file_sq;
drop SEQUENCE course_sq;
drop SEQUENCE error_log_sq;
drop SEQUENCE lecture_sq;
drop SEQUENCE semester_sq;
drop SEQUENCE student_course_sq;
drop SEQUENCE user_sq;