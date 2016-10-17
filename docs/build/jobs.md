
<a id='Jobs-1'></a>

## Jobs

<a id='ICDataServer.newjob' href='#ICDataServer.newjob'>#</a>
**`ICDataServer.newjob`** &mdash; *Function*.



```
newjob(dsn, dataserver; cryostat="", uname="", device="",
    nmeas=1, jobstart="", jobstop="", jobstatus=0)
```

Create a new job in the `jobs` table. This function will return a `DataFrame` containing the columns `job_id` and `jobsubmit` with the inserted job id and job submission time.


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/9a39f602079c0f0ff1289692f15e7d5ecbb4976d/src/jobs.jl#L1-L10' class='documenter-source'>source</a><br>

<a id='ICDataServer.updatejob' href='#ICDataServer.updatejob'>#</a>
**`ICDataServer.updatejob`** &mdash; *Function*.



```
updatejob(dsn, job_id; kwargs...)
```

Update an existing job in the `jobs` table based on its `job_id`. Specify the fields to update with keyword arguments specified in [`ICDataServer.newjob`](jobs.md#ICDataServer.newjob).


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/9a39f602079c0f0ff1289692f15e7d5ecbb4976d/src/jobs.jl#L24-L32' class='documenter-source'>source</a><br>

