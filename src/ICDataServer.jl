module ICDataServer

using ICCommon
# using Plots
using JSON
import ZMQ, ODBC
using Base.Cartesian, JLD
using AxisArrays

import AxisArrays: axes
import Base.Cartesian.inlineanonymous
import Base: show, isless, getindex, push!, length, eta
import Base.Collections: PriorityQueue, enqueue!, dequeue!, peek

export newinstrument, updateinstrument, deleteinstrument, listinstruments
export newuser, updateuser, deleteuser, listusers
export newserver, updateserver, deleteserver, listservers
export newnote, listnotes
export newjob, updatejob

const ctx = ZMQ.Context()
const dbsock = ZMQ.Socket(ctx, ZMQ.REP)

include("config.jl")

const dsn = ODBC.DSN(confd["dsn"], confd["username"], confd["password"])
ZMQ.bind(dbsock, confd["dbsock"])

function serve(;debug=false)
    while true
        msg = ZMQ.recv(dbsock)
        out = convert(IOStream, msg)
        seekstart(out)
        d = deserialize(out)
        debug && println(STDOUT, d)
        handle(d)
    end
end

function handle(jr::ICCommon.NewJobRequest)
    job_id, jobsubmit = newjob(dsn; jr.args...)
    ICCommon.ssend(dbsock, (job_id, jobsubmit))
end

function handle(jr::ICCommon.UpdateJobRequest)
    response = try
        updatejob(dsn, jr.job_id; jr.args...)
        true
    catch y
        false   # catch errors so that we can issue a proper reply regardless
    end

    # reply with `true` or `false` for success
    # (a reply must be sent to avoid zmq errors with a REQ/REP pattern)
    # maybe in the future we'd actually pass the error back
    ICCommon.ssend(dbsock, response)
end

handle(r::ICCommon.ListUsersRequest) =
    ICCommon.ssend(dbsock, deserialize, Array{String}(listusers(dsn)[:username]))

handle(r::ICCommon.ListInstrumentsRequest) =
    ICCommon.ssend(dbsock, deserialize, listinstruments(dsn))

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
