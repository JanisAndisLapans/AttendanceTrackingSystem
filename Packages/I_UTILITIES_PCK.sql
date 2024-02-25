c_default_error constant varchar(200) := 'Notikusi neparedzēta sistēmas kļūda!'; 

procedure log_error(in_procedure  in error_logs.procedure%type,
                    in_stacktrace in error_logs.stacktrace%type) as
begin
    -- TODO: Izveidot SQ
    insert into error_logs
    (
        id,
        user_id,
        "procedure",
        stacktrace
    )
    values
    (
        error_logs_sq.nextval,
        I_USER_PCK.get_context, -- TODO: Izveidot funkciju, kas atgriež šobrīdējo lietotāju
        in_procedure,
        in_stacktrace
    )
end;

function is_correct_email(in_email in nvarchar) returns number is
    c_email_regex constant varchar(200) := '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$';
begin
    return case when regexp_like (in_email, c_email_regex) then 1 else 0;
end is_correct_email;


--function get_required_field_error()