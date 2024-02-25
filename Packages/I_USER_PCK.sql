procedure user_iu()

function get_hashed(in_text in varchar) returns varchar is
begin
    return DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(in_text, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH256);
end;
