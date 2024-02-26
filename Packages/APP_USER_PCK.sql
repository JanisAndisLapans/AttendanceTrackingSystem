procedure create_user (in_first_name   in  users.first_name%type,
                      in_last_name    in  users.last_name%type
                      in_email        in  users.email%type
                      in_student_code in  users.student_code%type
                      in_user_type    in  users.user_type%type,
                      out_id          out users.id%type,
                      out_error       out nvarchar) as
    v_username      users.username%type,
    v_pass          varchar(10);
    v_hashed_pass   users.password%type;
    v_id            users.id%type;
begin
    savepoint create_user_sp;

    -- Validācija
   
    if in_first_name

    if I_UTILITIES_PCK.is_correct_email(in_email) = 0 then
        out_error := 'Ievadīts nepareizs e-pasts!'
        return;
    end if;

    -- Ģenerē lietotājvārdu un paroli
    v_username := CONVERT(substr(in_first_name, 1, 1) || replace(in_last_name, ' ', '') , 'US7ASCII');

    v_pass := '';
    for i in 1 .. 10
    loop
        -- burts
        if dbms_random.value(1, 2) = 1 then
        --skaitlis
            v_pass := v_pass || chr(dbms_random.value(97, 122));
        else
            v_pass := v_pass to_char(dbms_random.value(0, 9));
        end if;
    end loop;

    -- Izveido kriptēto paroli, ko glabās DB
    v_id := user_sq.nextval;     -- TODO: Izveidot SQ

    v_hashed_pass := I_USER_PCK.get_hashed(v_pass, in_username, v_id);
    
    -- Saglabā lietotāja datus

    I_USER_PCK.user_iu(
        in_id           => v_id,
        in_first_name   => in_first_name,
        in_last_name    => in_last_name,
        in_username     => v_username,
        in_password     => v_hashed_pass,
        in_email        => in_email,
        in_student_code => in_student_code,
        in_user_type    => in_user_type
    );

    out_id := v_id;

    -- Izsūta lietotājam informāciju par piereģistrēšanu ar paroli un lietotājvārdu

    I_EMAIL_PCK.send_mail(
        in_to => in_email,
        in_message => ''
    );
exception
    when others then
        out_error := I_UTILITIES_PCK.c_default_error;
        I_UTILITIES_PCK.log_error(
            in_procedure  => 'APP_USER_PCK.create_user',
            in_stacktrace => substr(sqlerrm || chr(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE(), 1, 4000);
        );
        rollback to create_user_sp;
end create_user;

procedure log_in (in_username in users.username%type,
                 in_password in varchar2,
                 out_user_id out number,
                 out_error   out nvarchar) as
    v_user_id users.id%type := -1;
begin
    begin
        select u.id
        into v_user_id
        from users u
        where u.username = in_username
        and u.password = I_USER_PCK.get_hashed(in_password, in_username, u.id);

        I_USER_PCK.set_context(v_user_id);
    exception
        when no_data_found then
            out_error := 'Nepareizs lietotājvārds vai parole!';
        when others then
            out_error := I_UTILITIES_PCK.c_default_error;
            I_UTILITIES_PCK.log_error(
                in_procedure  => 'APP_USER_PCK.log_in',
                in_stacktrace => substr(sqlerrm || chr(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE(), 1, 4000);
            );
    end;
    --finaly
    out_user_id := v_user_id;
end log_in;

procedure log_off as
begin
    I_USER_PCK.remove_context;
end;