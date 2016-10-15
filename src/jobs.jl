"""
```
newjob(dsn, jobsubmit, dataserver; cryostat="", uname="", device="",
    nmeas=1, jobstart="", jobstop="", jobstatus=0)
```

Create a new job in the `jobs` table.
"""
function newjob(dsn, jobsubmit, dataserver; cryostat="", uname="", device="",
    nmeas=1, jobstart="", jobstop="", jobstatus=0)

    dformat(x) = x == "" ? :NULL : "'$x'"
    ODBC.execute!(dsn, """
        INSERT INTO jobs (cryostat, uname, device, nmeas, jobsubmit, jobstart,
            jobstop, jobstatus, dataserver) VALUES ('$cryostat', '$uname',
            '$device', $nmeas, $(dformat(jobsubmit)), $(dformat(jobstart)),
            $(dformat(jobstop)), $jobstatus, '$dataserver');
    """)
end

"""
```
updatejob(dsn, job_id; kwargs...)
```

Update an existing job in the `jobs` table based on its `job_id`. Specify
the fields to update with keyword arguments specified in
[`ICDataServer.newjob`](@ref).
"""
function updatejob(dsn, job_id; kwargs...)
    isempty(kwargs) && return
    pstr = reduce((a,b)->a*","*b, "$k = '$v'" for (k,v) in kwargs)
    for (k,v) in kwargs
        ODBC.execute!(dsn, "UPDATE jobs SET "*pstr*" WHERE job_id = $job_id;")
    end
end
