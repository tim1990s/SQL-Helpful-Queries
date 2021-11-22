-- To get all the executing query on the System

SELECT sqltext.text,
       req.session_id,
       req.status,
       req.command,
       req.cpu_time,
       req.total_elapsed_time
FROM sys.dm_exec_requests req
    CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext;

-- To kill the process is executing
KILL --[session_id]