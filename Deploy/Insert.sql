-- Konstantes

insert into user_type (id, name)
values (1, 'Students');
insert into user_type (id, name)
values (2, 'Pasniedz?js');
insert into user_type (id, name)
values (3, 'Administrators');

-- Ievietojam adminu, ko var?s izmantot, lai manu?li datub?z? palaistu proced?ras, kas pieprasa lietot?ja ties?bu p?rbaudi (šaj? kont? nedr?kst?s autoriz?ties)
insert into "user" (id, username, password, email, first_name, last_name, student_code, warn_unattended, send_end_statistic, send_lecture_statistic, user_type, first_login)
values (USER_SQ.nextval, 'admin', 'dummy', 'dummy', 'admin', 'admin', 'dummy', 0, 0, 0, 3, 0);

insert into attendance_status (id, name)
values (1, 'Neapmekl?ts');
insert into attendance_status (id, name)
values (2, 'Apmekl?ts');
insert into attendance_status (id, name)
values (3, 'Kav?ts');
insert into attendance_status (id, name)
values (4, 'Attaisnots');

-- Testa dati

declare
    v_semester_id semester.id%type;
    v_lecturer_id "user".id%type;
    v_student_id "user".id%type;
    v_course_id course.id%type;
    v_lecture_id lecture.id%type;
    v_attendance_id attendance.id%type;
    
   v_clob        clob;
   v_blob        blob;
   v_dest_offset integer := 1;
   v_src_offset  integer := 1;
   v_warn        integer;
   v_ctx         integer := dbms_lob.default_lang_ctx;
begin 

    insert into semester (id, year, season)
    values (SEMESTER_SQ.nextval, 2024, 1);
    
    insert into semester (id, year, season)
    values (SEMESTER_SQ.nextval, 2024, 2)
    returning id into v_semester_id;

    insert into "user" (id, username, password, email, first_name, last_name, student_code, warn_unattended, send_end_statistic, send_lecture_statistic, user_type, first_login)
    values (USER_SQ.nextval, 'kupitis', 'asf32rwrgdsfqeag2ewfwerf', 'student@uni.lv', 'K?rlis', 'Up?tis', 'ku24152', 0, 0, 0, 1, 0)
    returning id into v_student_id;
    
    insert into "user" (id, username, password, email, first_name, last_name, student_code, warn_unattended, send_end_statistic, send_lecture_statistic, user_type, first_login)
    values (USER_SQ.nextval, 'aliepa', 'asfSDawhgnsadhghgerf', 'professor@uni.lv', 'Anna', 'Liepa', 'ku24152', 0, 0, 0, 1, 0)
    returning id into v_lecturer_id;
    
    insert into course (id, name, register_minutes, minimum_attendance, lecturer_id)
    values (course_sq.nextval, '??mija 101', 15, 80, v_lecturer_id)
    returning id into v_course_id;
    
    insert into lecture (id, starttime, endtime, course_id, mandatory, attendancecode, name, semester_id)
    values (lecture_sq.nextval, to_date('05.02.2024', 'dd.mm.yyyy'), to_date('30.06.2024', 'dd.mm.yyyy'), v_course_id, 1, 'gsf2f2', '1. lekcija - ievads', v_semester_id)
    returning id into v_lecture_id;
    
    insert into student_course (id, user_id, ATTENDANCE_STATISTICS_FILE, course_id)
    values (student_course_sq.nextval, v_student_id, null, v_course_id);
    
    insert into attendance (id, skipreason, student_id, lecture_id, attendance_status)
    values (attendance_sq.nextval, 'Nebiju slim?bas d??. Pielikum? ?rsta z?me.', v_student_id, v_lecture_id, 4)
    returning id into v_attendance_id;
    
    for idx in 1..5
   loop
     v_clob := v_clob || dbms_random.string('x', 2000);
   end loop;
   dbms_lob.createtemporary( v_blob, false );
   dbms_lob.converttoblob(v_blob,
                          v_clob,
                          dbms_lob.lobmaxsize,
                          v_dest_offset,
                          v_src_offset,
                          dbms_lob.default_csid,
                          v_ctx,
                          v_warn);
    
    insert into attendance_file (id, file_name, file_data, attendance_id)
    values (attendance_file_sq.nextval, 'scan.jpg', v_blob, v_attendance_id);
    
    insert into error_log (id, timestamp, procedure, stacktrace, user_id)
    values (error_log_sq.nextval, sysdate, 'APP_USER_PCK.LOG_IN', 'No data found line: 123', v_student_id);
end;
/
