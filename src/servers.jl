"""
```
newserver(dsn, name, addr, port::Integer=-1)
```

Create a new server in the `servers` table.
"""
function newserver(dsn, name, addr, port::Integer=-1)
    if port > -1
        ODBC.execute!(dsn, """
            INSERT INTO servers VALUES ('$name', '$addr', '$port');
        """)
    else
        ODBC.execute!(dsn, """
            INSERT INTO servers VALUES ('$name', '$addr');
        """)
    end
end

"""
```
updateserver(dsn, name; kwargs...)
```

Update a server in the `servers` table using keyword arguments (`name`, `addr`,
`port`). If you don't want or need to specify a port, specify `-1`.
"""
function updateserver(dsn, name; kwargs...)
    isempty(kwargs) && return
    pstr = reduce((a,b)->a*","*b, "$k = '$v'" for (k,v) in kwargs)
    for (k,v) in kwargs
        ODBC.execute!(dsn, "UPDATE servers SET "*pstr*" WHERE name = '$name';")
    end
end

"""
```
deleteserver(dsn, name)
```

Remove a server from the `servers` table.
"""
function deleteserver(dsn, name)
    ODBC.execute!(dsn, "DELETE FROM servers WHERE name='$name';")
end
