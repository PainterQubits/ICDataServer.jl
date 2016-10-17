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

const dsn = ODBC.DSN("juliatests", "ajkeller", "")
const where="tcp://127.0.0.1:50001"
const ctx = ZMQ.Context()
const s = ZMQ.Socket(ctx, ZMQ.SUB)
ZMQ.subscribe(s)
ZMQ.connect(s, where)
Plots.plotlyjs()

const context = Dict{Symbol,Any}()

function hear(context)
    while true
        msg = ZMQ.recv(s)
        out = convert(IOStream, msg)
        seekstart(out)
        d = deserialize(out)
        handle(d, context)
    end
end

function handle(x::PlotSetup, context)
    context[:setup] = x
    A = (x.arrtype)(x.size...)
    A[:] = zero(eltype(A))
    context[:array] = A
    context[:plot] = plot(A, show=true)
    yield()
end

function handle(pt::PlotPoint, context)
    A = context[:array]
    A[pt.inds...] = pt.v

    p = context[:plot]
    x = p[1][1][:x]
    p[1] = (x, A)
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
