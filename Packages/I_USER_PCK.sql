procedure user_iu()

c_user_namespace constant varchar2(100) := 'users';
c_user_id_attr constant varchar2(100)   := 'user_id';

procedure create_context(in_user_id in users.id%type) as
begin
    dbms_session.set_context(c_user_namespace, c_user_id_attr, in_user_id);
end;

procedure remove_context as
begin
    dbms_session.set_context(c_user_namespace, c_user_id_attr, null);
end;


function current_user returns number is
begin
    return sys_context(c_user_namespace, c_user_id_attr);
end;

function get_hashed(in_password in varchar2,
                    in_username in users.username%type,
                    in_user_id  in users.id%type) returns varchar deterministic is
    c_salt constant varchar2(10) := 'g$a2hw4&21';
begin
    return DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(in_password || c_salt || in_username || to_char(in_user_id), 'AL32UTF8'), DBMS_CRYPTO.HASH_SH256);
end get_hashed;