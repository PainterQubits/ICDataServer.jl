"""
```
newinstrument(dsn, alias; make="", model="", serialnum="", kind="",
    hw_server="", protocol="", ins_addr="")
```

Create a new instrument named `alias` in the `instruments` table.
"""
function newinstrument(dsn, alias; make="", model="", serialnum="", kind="",
    hw_server="", protocol="", address="")

    ODBC.execute!(dsn, """
        INSERT INTO instruments VALUES ('$alias', '$make', '$model',
            '$serialnum', '$kind', '$hw_server', '$protocol', '$address');
    """)
end

"""
```
updateinstrument(dsn, alias; kwargs...)
```

Update any of the fields for an instrument named `alias`. Possible keyword
arguments listed in documentation for [`ICDataServer.newinstrument`](@ref).
"""
function updateinstrument(dsn, alias; kwargs...)
    isempty(kwargs) && return
    pstr = reduce((a,b)->a*","*b, "$k = '$v'" for (k,v) in kwargs)
    ODBC.execute!(dsn, "UPDATE instruments SET "*pstr*" WHERE alias = '$alias';")
end

"""
```
deleteinstrument(dsn, alias)
```

Delete instrument named `alias` from the `instruments` table.
"""
function deleteinstrument(dsn, alias)
    ODBC.execute!(dsn, "DELETE FROM instruments WHERE alias='$alias';")
end


"""
```
listinstruments(dsn)
```

List instruments in the `instruments` table.
"""
function listinstruments(dsn)
    ODBC.query(dsn, "SELECT * FROM instruments;")
end
