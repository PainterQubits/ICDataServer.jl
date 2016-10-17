module ICDataServer

using ICCommon
using Plots
using JSON
import ZMQ
import ODBC

export newinstrument, updateinstrument, deleteinstrument, listinstruments
export newuser, updateuser, deleteuser, listusers
export newserver, updateserver, deleteserver, listservers
export newjob, updatejob

const ctx = ZMQ.Context()
const jobsock = ZMQ.Socket(ctx, ZMQ.REP)

confpath = joinpath(Pkg.dir("ICDataServer"), "deps", "config.json")
if isfile(confpath)
    confd = JSON.parsefile(confpath)
    if reduce(&, k in keys(confd) for k in
        ("jobsock", "dsn", "username", "password"))

        ZMQ.bind(jobsock, d["jobsock"])
        const dsn = ODBC.DSN(d["db"], d["username"], d["password"])
    else
        error("set `dbserver` key in $(confpath) to have a valid ",
            "ZeroMQ connection string.")
    end
else
    error("config file not found at $(confpath).")
end

function listtables(dsn)
    ODBC.query(dsn,
        """
        SELECT table_name FROM information_schema.tables
            WHERE table_type = 'BASE TABLE'
                AND table_schema NOT IN ('pg_catalog', 'information_schema');
        """
    )[:table_name]
end

"""
```
the_nuclear_option(dsn)
```

Delete all tables associated with `ICDataServer`. Probably not a good idea.
"""
function the_nuclear_option(dsn)
    ODBC.execute!(dsn, """DROP TABLE IF EXISTS users, jobs, servers,
        instruments, instrumentkinds, notes CASCADE;""")
end

include("users.jl")
include("servers.jl")
include("instruments.jl")
include("jobs.jl")
include("setup.jl")


end
