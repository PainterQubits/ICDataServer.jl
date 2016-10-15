"""
```
function newuser(dsn, uname, name; email="", phone="", office="")
```

This function creates a new user in the `users` table of the database.
E-mail, phone, office are useful for contacting users about their measurements.
"""
function newuser(dsn, uname, name; email="", phone="", office="")
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
        '$uname', '$first', '$middle', '$last', '$email', '$phone', '$office'
    );
    """)
end

function listusers(dsn)
    ODBC.query(dsn, "SELECT * FROM users;")
end
