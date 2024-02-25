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

v_mail_conn UTL_SMTP.connection;

procedure send_mail (in_to              in varchar2,
                     in_message         in varchar2,
                     in_keep_conn_open  in boolean default false) as
  c_username  constant  varchar(200) := 'ApmeklejumaSistema',
  c_password  constant  varchar(200) := ''; -- TODO: izveidot sistemu ka padot paroli
  c_from      constant  varchar(200) := 'ApmeklejumaSistema@inbox.lv',
  c_smtp_host constant  varchar(200) := 'mail.inbox.lv';
  c_smtp_port constant  number       := '587'; -- inbox TLS ports

  v_mail_conn           UTL_SMTP.connection;
begin
  if v_mail_conn is null then
    v_mail_conn := UTL_SMTP.open_connection(c_smtp_host, c_smtp_port);
    UTL_SMTP.helo(v_mail_conn, c_smtp_host);
    UTL_SMTP.auth(v_mail_conn, )
  end if;

  UTL_SMTP.mail(v_mail_conn, c_from); 
  UTL_SMTP.rcpt(v_mail_conn, v_to);
  UTL_SMTP.data(v_mail_conn, in_message || UTL_TCP.crlf || UTL_TCP.crlf);

  if not in_keep_conn_open then
    UTL_SMTP.quit(v_mail_conn);
    v_mail_conn := null;
  end if;
end;

function is_correct_email(in_email in nvarchar) returns number is
    c_email_regex constant varchar(200) := '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$';
begin
    return case when regexp_like (in_email, c_email_regex) then 1 else 0;
end is_correct_email;


--function get_required_field_error()