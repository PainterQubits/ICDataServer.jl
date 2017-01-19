# would be good to submit a PR to ODBC.jl...
conv(::Type{DateTime}, dt::ODBC.API.SQLTimestamp) =
    DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second,
        round(dt.fraction/1e6))

"""
    newjob(; cryostat::String="", username::String="", device::String="",
        nmeas::Integer=1, jobstart::String="", jobstop::String="", jobstatus::Integer=0,
        dataserver::String="")
Create a new job in the `jobs` table. This function will return a `DataFrame`
containing the columns `job_id` and `jobsubmit` with the inserted job id
and job submission time.
"""
function newjob(; cryostat::String="", username::String="", device::String="",
    nmeas::Integer=1, jobstart::String="", jobstop::String="", jobstatus::Integer=0,
    dataserver::String="")

    dformat(x) = x == "" ? :NULL : "'$x'"
    df = ODBC.query(dsn, """
        INSERT INTO jobs (cryostat, username, device, nmeas, jobsubmit, jobstart,
            jobstop, jobstatus, dataserver) VALUES ('$cryostat', '$username',
            '$device', $nmeas, $(dformat(now())), $(dformat(jobstart)),
            $(dformat(jobstop)), $jobstatus, '$dataserver')
            RETURNING job_id, jobsubmit;
    """)
    df
end

"""
    updatejob(job_id; kwargs...)
Update an existing job in the `jobs` table based on its `job_id`. Specify
the fields to update with keyword arguments specified in
[`ICDataServer.newjob`](@ref).
"""
function updatejob(job_id; kwargs...)
    isempty(kwargs) && return
    pstr = reduce((a,b)->a*","*b, "$k = '$v'" for (k,v) in kwargs)
    for (k,v) in kwargs
        ODBC.execute!(dsn, "UPDATE jobs SET "*pstr*" WHERE job_id = $job_id;")
    end
end

precompile(newjob, ())
precompile(updatejob, (Int,))
