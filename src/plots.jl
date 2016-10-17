const plotsock = ZMQ.Socket(ctx, ZMQ.SUB)
ZMQ.subscribe(plotsock)
ZMQ.connect(plotsock, "tcp://127.0.0.1:50002")
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
