"""
```
newnote(job_id, username, note)
```

Create a new note in the `notes` table. A note is associated with a particular
job and therefore a `job_id` is required, along with a `username` to indicate
who wrote the note.
"""
function newnote(job_id, username, note)
    ODBC.execute!(dsn, """
        INSERT INTO notes (job_id, username, dt, note) VALUES
            ($job_id, '$username', '$(now())', '$note');
    """)
end

"""
```
listnotes(; job_id=0, username="")
```

If keyword arguments `job_id` and/or `username` are provided, list the notes
in the `notes` table that are at the intersection of those conditions.
Otherwise, list all notes in the `notes` table.
"""
function listnotes(; job_id::Integer=0, username::String="")
    if job_id != 0 && username != ""
        wherestr = "WHERE "
        if job_id != 0
            wherestr *= "job_id = $job_id"
        end
        if username != ""
            wherestr *= ", username = '$username'"
        end
    else
        wherestr = ""
    end

    ODBC.query(dsn, """
        SELECT job_id, username, dt, note FROM notes $wherestr;
    """; weakrefstrings=false)
end
