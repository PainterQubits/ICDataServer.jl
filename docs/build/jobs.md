<a id='ICDataServer.newjob' href='#ICDataServer.newjob'>#</a>
**`ICDataServer.newjob`** &mdash; *Function*.



```
newjob(dsn; cryostat="", username="", device="",
    nmeas=1, jobstart="", jobstop="", jobstatus=0, dataserver="")
```

Create a new job in the `jobs` table. This function will return a `DataFrame` containing the columns `job_id` and `jobsubmit` with the inserted job id and job submission time.


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/11903b0154a7a722d12cec3a524d64803928adfe/src/jobs.jl#L7-L16' class='documenter-source'>source</a><br>

<a id='ICDataServer.updatejob' href='#ICDataServer.updatejob'>#</a>
**`ICDataServer.updatejob`** &mdash; *Function*.



```
updatejob(dsn, job_id; kwargs...)
```

Update an existing job in the `jobs` table based on its `job_id`. Specify the fields to update with keyword arguments specified in [`ICDataServer.newjob`](jobs.md#ICDataServer.newjob).


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/11903b0154a7a722d12cec3a524d64803928adfe/src/jobs.jl#L31-L39' class='documenter-source'>source</a><br>

