procedure CreateUser (in_first_name   in  users.first_name%type,
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
    -- Validācija
    --
    --  TODO: Obligātie lauki
    --
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
    v_hashed_pass := I_USER_PCK.get_hashed(v_pass);
    
    -- Saglabā lietotāja datus

    v_id := user_sq.nextval;

    -- TODO: Izveidot SQ
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


exception
    when others then
        out_error := I_UTILITIES_PCK.c_default_error;
        I_UTILITIES_PCK.log_error(
            in_procedure  => 'APP_USER_PCK.CreateUser',
            in_stacktrace => substr(sqlerrm || chr(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE(), 1, 4000)
        );
        return;
end CreateUser;