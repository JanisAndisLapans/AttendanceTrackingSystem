v_mail_conn UTL_SMTP.connection;
 c_username  constant  varchar(200) := 'ApmeklejumaSistema',
c_password  constant  varchar(200) := ''; -- TODO: izveidot sistemu ka padot paroli
c_from      constant  varchar(200) := 'ApmeklejumaSistema@inbox.lv',
c_smtp_host constant  varchar(200) := 'mail.inbox.lv';
c_smtp_port constant  number       := '587'; -- inbox TLS ports

procedure send_mail (in_to              in varchar2,
                     in_message         in varchar2) as
begin
  if v_mail_conn is null then
    open_conn;
  end if;

  UTL_SMTP.mail(v_mail_conn, c_from); 
  UTL_SMTP.rcpt(v_mail_conn, v_to);
  UTL_SMTP.data(v_mail_conn, in_message || UTL_TCP.crlf || UTL_TCP.crlf);
end;

procedure open_conn
as 
begin
    v_mail_conn := UTL_SMTP.open_connection(c_smtp_host, c_smtp_port);
    UTL_SMTP.helo(v_mail_conn, c_smtp_host);
    UTL_SMTP.auth(v_mail_conn, c_password);
end;

procedure close_conn as -- TODO: izveidot trigeri, kas izsauc procedūru ON LOGOFF
begin
    if v_mail_conn is not null then
        UTL_SMTP.quit(v_mail_conn);
        v_mail_conn := null;
    end if;
end;
