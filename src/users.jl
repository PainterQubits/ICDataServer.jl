"""
```
newuser(username, name; email="", phone="", office="")
```

This function creates a new user in the `users` table of the database.
E-mail, phone, office are useful for contacting users about their measurements.
"""
function newuser(username, name; email="", phone="", office="")
    first, middle, last = "", "", ""
    names = split(name, " ")
    if length(names) == 1
        first = names[1]
    elseif length(names) == 2
        first, last == (names...)
    elseif length(names) == 3
        first, mid, last == (names...)
    else
        error("unexpected name convention.")
    end

    ph = replace(phone, r"[-\+\(\)\s]", "")
    ODBC.execute!(dsn, """
    INSERT INTO users VALUES (
        '$username', '$first', '$middle', '$last', '$email', '$phone', '$office'
    );
    """)
end

"""
```
updateuser(username; kwargs...)
```

Update an existing user in the `users` table, identified by `username`. Specify
the fields to update with keyword arguments specified in
[`ICDataServer.newuser`](@ref).
"""
function updateuser(username; kwargs...)
    isempty(kwargs) && return
    pstr = reduce((a,b)->a*","*b, "$k = '$v'" for (k,v) in kwargs)
    for (k,v) in kwargs
        ODBC.execute!(dsn, "UPDATE users SET "*pstr*" WHERE username = $username;")
    end
end

"""
```
deleteuser(username)
```

Delete a user from the `users` table by providing the username.
"""
function deleteuser(username)
    ODBC.execute!(dsn, "DELETE FROM users WHERE username = '$username';")
end

"""
```
listusers()
```

List all users in the `users` table.
"""
listusers() = Array{String}(ODBC.query(dsn, "SELECT * FROM users;";
    weakrefstrings=false)[:username])
