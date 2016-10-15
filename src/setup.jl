"""
```
setuptables()
```

Initialize a database with the tables needed to run ICDataServer:
  - `users`
  - `servers`
  - `instrumentkinds`
  - `instruments`
  - `jobs`
  - `notes`

The creation of the tables can proceed without additional input, but in some
cases it may make sense for the tables to be automatically filled with data.

If new instrument kinds are added to `deps/inskinds.json`, they will be added
to `instrumentkinds` table. If kinds are encountered in the database that are
not in the file, they remain in the database and are not deleted.
"""
function setuptables(dsn, path="")
    if path == ""
        # request path from user
        println("Setup file directory path? [defaults to ICDataServer/deps]:")
        path = chomp(readline(STDIN))

        # default
        if path == ""
            path = joinpath(Pkg.dir("ICDataServer"), "deps")
        end
    end
    !ispath(path) && error("could not find path.")

    userstable(dsn)
    servertable(dsn)
    instrkindstable(dsn, path)
    instrtable(dsn)
    jobstable(dsn)
    notestable(dsn)
end

function jobstable(dsn)
    ODBC.execute!(dsn,
    """
    CREATE TABLE IF NOT EXISTS jobs(
        job_id      bigserial PRIMARY KEY,
        cryostat    character varying,
        uname       character varying REFERENCES users(uname),
        device      character varying,
        nmeas       integer,
        jobsubmit   timestamp NOT NULL,
        jobstart    timestamp,
        jobstop     timestamp,
        jobstatus   smallint,
        dataserver  character varying NOT NULL REFERENCES servers(alias)
    );
    """)
end

function instrtable(dsn)
    ODBC.execute!(dsn,
    """
    CREATE TABLE IF NOT EXISTS instruments(
        alias	    character varying PRIMARY KEY,
        make        character varying,
        model	    character varying,
        serialnum	character varying,
        kind	    character varying REFERENCES instrumentkinds(kind),
        hw_server	character varying REFERENCES servers(alias),
        protocol	character varying,
        address     character varying
    );
    """)
end

function instrkindstable(dsn, path)
    ODBC.execute!(dsn,
    """
    CREATE TABLE IF NOT EXISTS instrumentkinds(
        kind        character varying PRIMARY KEY
    );
    """)

    instrkindspath = joinpath(path, "inskinds.json")
    if isfile(instrkindspath)
        stmt = ODBC.prepare(dsn,
            "INSERT INTO instrumentkinds VALUES (?) ON CONFLICT DO NOTHING;")
        for t in JSON.parsefile(instrkindspath)["kind"]
            ODBC.execute!(stmt, (t,))
        end
    end
end

function userstable(dsn)
    ODBC.execute!(dsn,
    """
    CREATE TABLE IF NOT EXISTS users(
        uname   character varying PRIMARY KEY,
        first   character varying,
        middle  character varying,
        last    character varying,
        email   character varying,
        phone   character varying,
        office  character varying
    );
    """)
end

function servertable(dsn)
    ODBC.execute!(dsn,
    """
    CREATE TABLE IF NOT EXISTS servers(
        alias       character varying PRIMARY KEY,
        addr        character varying NOT NULL,
        port        integer
    );
    """)
end

function notestable(dsn)
    ODBC.execute!(dsn,
    """
    CREATE TABLE IF NOT EXISTS notes(
        note_id  serial PRIMARY KEY,
        job_id   bigint REFERENCES jobs(job_id) NOT NULL,
        uname    character varying REFERENCES users(uname) NOT NULL,
        dt       timestamp NOT NULL,
        notes    character varying NOT NULL
    );
    """)
end
