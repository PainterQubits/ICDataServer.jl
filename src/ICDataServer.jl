module ICDataServer

using ICCommon
using JSON
import ZMQ, ODBC
using Base.Cartesian, JLD
using AxisArrays
using JuliaWebAPI

import AxisArrays: axes
import Base.Cartesian.inlineanonymous
import Base: show, isless, getindex, push!, length, eta
import Base.Collections: PriorityQueue, enqueue!, dequeue!, peek

export newinstrument, updateinstrument, deleteinstrument, listinstruments
export newuser, updateuser, deleteuser, listusers
export newserver, updateserver, deleteserver, listservers
export newnote, listnotes
export newjob, updatejob

include("config.jl")

const dsn = ODBC.DSN(confd["dsn"])

include("users.jl")
include("servers.jl")
include("instruments.jl")
include("jobs.jl")
include("notes.jl")
include("setup.jl")

# Initialization

const global ctx = Ref{ZMQ.Context}()

const global apiserial = Ref{APIResponder{ZMQTransport,SerializedMsgFormat}}()
const global apijson = Ref{APIResponder{ZMQTransport,JSONMsgFormat}}()
const global apihttp = Ref{APIInvoker{ZMQTransport,JSONMsgFormat}}()

const global apiserialopened = Ref{Bool}(false)
const global apijsonopened = Ref{Bool}(false)
const global apihttpopened = Ref{Bool}(false)

"""
    apiserialresponder()
If needed, opens a JuliaWebAPI.APIResponder with ZMQTransport and SerializedMsgFormat
to service requests to the ICDataServer. Returns the APIResponder.
"""
function apiserialresponder()
    if !apiserialopened[]
        apiserial[] = APIResponder(
            ZMQTransport(confd["serialsocket"], ZMQ.REP, true, ctx[]),
            SerializedMsgFormat(), "", false)
        apiserialopened[] = true
    end
    return apiserial[]
end

"""
    apijsonresponder()
If needed, opens a JuliaWebAPI.APIResponder with ZMQTransport and JSONMsgFormat
to service requests to the ICDataServer. Returns the APIResponder.
"""
function apijsonresponder()
    if !apijsonopened[]
        apijson[] = APIResponder(
            ZMQTransport(confd["jsonsocket"], ZMQ.REP, true, ctx[]),
            JSONMsgFormat(), "", false)
        apijsonopened[] = true
    end
    return apijson[]
end

"""
    apihttpresponder()
If needed, opens a JuliaWebAPI.APIInvoker with ZMQTransport and JSONMsgFormat
to serve HTTP for interacting with the ICDataServer. Returns the APIInvoker.
"""
function apihttpinvoker()
    if !apihttpopened[]
        apihttp[] = APIInvoker(
            ZMQTransport(confd["jsonsocket"], ZMQ.REQ, false, ctx[]),
            JSONMsgFormat())
        apihttpopened[] = true
    end
    return apihttp[]
end

const _ipcapi = (:newjob, :updatejob, :listusers, :listinstruments, :ipcapi)
const _webapi = (:listusers, :listinstruments, :webapi)

ipcapi() = _ipcapi
webapi() = _webapi

function __init__()
    ctx[] = ZMQ.Context()
    if !haskey(ENV, "ICTESTMODE")
        for f in ipcapi()
            @eval JuliaWebAPI.register(apiserialresponder(), $f)
        end
        for f in webapi()
            @eval JuliaWebAPI.register(apijsonresponder(), $f, resp_json=true,
                resp_headers=Dict{String,String}(
                    "Content-Type" => "application/json; charset=utf-8",
                    "Access-Control-Allow-Origin" => "http://localhost",
                    "Access-Control-Allow-Methods" => "GET"))
        end
        JuliaWebAPI.process(apiserialresponder(); async=true)
        JuliaWebAPI.process(apijsonresponder(); async=true)
        @async JuliaWebAPI.run_http(apihttpinvoker(), 8889)
    end
end



end
