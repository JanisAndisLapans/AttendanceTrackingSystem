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

insert into semester (id, year, season)
values (SEMESTER_SQ.nextval, 2024, 1);

insert into semester (id, year, season)
values (SEMESTER_SQ.nextval, 2024, 2);