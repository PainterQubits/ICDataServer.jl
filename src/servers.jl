"""
```
newserver(dsn, name, addr, port::Integer=-1)
```

Create a new server in the `servers` table.
"""
function newserver(dsn, name, address, port::Integer=-1)
    if port > -1
        ODBC.execute!(dsn, """
            INSERT INTO servers VALUES ('$name', '$address', '$port');
        """)
    else
        ODBC.execute!(dsn, """
            INSERT INTO servers VALUES ('$name', '$address');
        """)
    end
end

"""
```
updateserver(dsn, name; kwargs...)
```

Update a server in the `servers` table using keyword arguments (`name`, `address`,
`port`).
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

Remove a server from the `servers` table by passing its `name`.
"""
function deleteserver(dsn, name)
    ODBC.execute!(dsn, "DELETE FROM servers WHERE name='$name';")
end

"""
```
listservers(dsn, name)
```

List all servers in the `servers` table.
"""
function listservers(dsn)
    ODBC.query(dsn, "SELECT * FROM servers;")
end
