SET pagesize 0
SET head off
SET feed off
SET linesize 1000
COLUMN SQL_TEXT FORMAT A50 WORD_WRAP
SELECT
    /*+ ORDERED */
    s.sql_id,
    q.sql_text,
    q.EXECUTIONS,
    q.cpu_time / 1000000 / executions AS cpu_sec,
    q.elapsed_time / 1000000 / executions AS ela_sec,
    q.last_load_time
FROM
    V$SESSION s,
    v$sql q
WHERE
    s.sql_id = q.sql_id(+)
AND
    s.username not in('SYS','SYSTEM')
AND
    s.STATUS =  'ACTIVE'
AND
    s.last_call_et >= 3;
EXIT
