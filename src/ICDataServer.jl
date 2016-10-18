module ICDataServer

using ICCommon
using Plots
using JSON
import ZMQ
import ODBC

export newinstrument, updateinstrument, deleteinstrument, listinstruments
export newuser, updateuser, deleteuser, listusers
export newserver, updateserver, deleteserver, listservers
export newnote, listnotes
export newjob, updatejob

const ctx = ZMQ.Context()
const jobsock = ZMQ.Socket(ctx, ZMQ.REP)

confpath = joinpath(Pkg.dir("ICDataServer"), "deps", "config.json")
if isfile(confpath)
    confd = JSON.parsefile(confpath)
    if reduce(&, k in keys(confd) for k in
        ("jobsock", "dsn", "username", "password"))

        ZMQ.bind(jobsock, confd["jobsock"])
        const dsn = ODBC.DSN(confd["dsn"], confd["username"], confd["password"])
    else
        if !"jobsock" in keys(confd)
            error("set `jobsock` key in $(confpath) to have a valid ",
                "ZeroMQ connection string.")
        elseif !"dsn" in keys(confd)
            error("set `dsn` key in $(confpath) to have a valid DSN identifier.")
        elseif !"username" in keys(confd)
            error("set `username` key in $(confpath) to a valid username.")
        else
            error("set `password` key in $(confpath) for the given user.")
        end
    end
else
    error("config file not found at $(confpath).")
end

function serve(;debug=false)
    while true
        msg = ZMQ.recv(jobsock)
        out = convert(IOStream, msg)
        seekstart(out)
        d = deserialize(out)
        debug && println(STDOUT, d)
        handle(d)
    end
end

function handle(jr::NewJobRequest)
    job_id, jobsubmit = newjob(dsn; jr.args...)
    io = IOBuffer()
    serialize(io, (job_id, jobsubmit))
    ZMQ.send(jobsock, ZMQ.Message(io))
end

function handle(jr::UpdateJobRequest)
    response = try
        updatejob(dsn, jr.job_id; jr.args...)
        true
    catch y
        false   # catch errors so that we can issue a proper reply regardless
    end

    # reply with `true` or `false` for success
    # (a reply must be sent to avoid zmq errors with a REQ/REP pattern)
    # maybe in the future we'd actually pass the error back
    io = IOBuffer()
    serialize(io, response)
    ZMQ.send(jobsock, ZMQ.Message(io))
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
include("notes.jl")
include("setup.jl")

end
