"""
```
newinstrument(alias; make::String="", model::String="",
    serialnum::String="", kind::String="", hw_server::String="",
    protocol::String="", address::String="")
```

Create a new instrument named `alias` in the `instruments` table.
"""
function newinstrument(alias; make::String="", model::String="",
    serialnum::String="", kind::String="", hw_server::String="",
    protocol::String="", address::String="")

    ODBC.execute!(dsn, """
        INSERT INTO instruments VALUES ('$alias', '$make', '$model',
            '$serialnum', '$kind', '$hw_server', '$protocol', '$address');
    """)
end

"""
```
updateinstrument(alias; kwargs...)
```

Update any of the fields for an instrument named `alias`. Possible keyword
arguments listed in documentation for [`ICDataServer.newinstrument`](@ref).
"""
function updateinstrument(alias; kwargs...)
    isempty(kwargs) && return
    pstr = reduce((a,b)->a*","*b, "$k = '$v'" for (k,v) in kwargs)
    ODBC.execute!(dsn, "UPDATE instruments SET "*pstr*" WHERE alias = '$alias';")
end

"""
```
deleteinstrument(alias)
```

Delete instrument named `alias` from the `instruments` table.
"""
function deleteinstrument(alias)
    ODBC.execute!(dsn, "DELETE FROM instruments WHERE alias='$alias';")
end


"""
```
listinstruments()
```

List instruments in the `instruments` table.
"""
function listinstruments()
    ODBC.query(dsn, "SELECT * FROM instruments;"; weakrefstrings=false)
end
