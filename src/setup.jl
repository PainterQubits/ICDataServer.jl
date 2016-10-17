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

If new users are added to `deps/users.json`, they will be "upserted" into the
`users` table (users are created if necessary; if an existing user name is
attempted to be inserted into the table, then that user has their info updated
from the json file). Existing users not found in users.json remain in the table.
"""
function setuptables(dsn, path="")
    if path == ""
        # request path from user
        println("Path to directory with setup files? [defaults to ICDataServer/deps]:")
        path = chomp(readline(STDIN))

        # default
        if path == ""
            path = joinpath(Pkg.dir("ICDataServer"), "deps")
        end
    end
    !ispath(path) && error("could not find path.")
    println(path)

    userstable(dsn, path; filename = "users.json")
    servertable(dsn, path; filename = "servers.json")
    restrictiontable(dsn, path; filename = "instrumentkinds.json",
        tablename = "instrumentkinds", colname = "kind")
    # restrictiontable(dsn, path; filename = "instrumentmakes.json",
    #     tablename = "instrumentmakes", colname = "make")
    # restrictiontable(dsn, path; filename = "instrumentmodels.json",
    #     tablename = "instrumentmodels", colname = "model")
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

function restrictiontable(dsn, path; filename="", tablename="", colname="")
    ODBC.execute!(dsn,
    """
    CREATE TABLE IF NOT EXISTS $tablename(
        $colname    character varying PRIMARY KEY
    );
    """)

    ipath = joinpath(path, filename)
    if isfile(ipath)
        stmt = ODBC.prepare(dsn,
            "INSERT INTO $tablename VALUES (?) ON CONFLICT DO NOTHING;")
        for t in JSON.parsefile(ipath)[colname]
            ODBC.execute!(stmt, (t,))
        end
    end
end

function userstable(dsn, path; filename="")

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

    ipath = joinpath(path, filename)
    if isfile(ipath)
        for d in JSON.parsefile(ipath)["users"]
            k = keys(d)
            kstr = reduce((a,b)->a*","*b, "$ki" for ki in k)
            vstr = reduce((a,b)->a*","*b, "'$(d[ki])'" for ki in k)
            pstr = reduce((a,b)->a*","*b, "$ki = '$(d[ki])'" for ki in k)
            query = """
            INSERT INTO users ($kstr) VALUES ($vstr) ON CONFLICT (uname)
            DO UPDATE SET $pstr
            """
            ODBC.execute!(dsn, query)
        end
    end
end

function servertable(dsn, path; filename="")
    ODBC.execute!(dsn,
    """
    CREATE TABLE IF NOT EXISTS servers(
        alias       character varying PRIMARY KEY,
        addr        character varying NOT NULL,
        port        integer
    );
    """)

    ipath = joinpath(path, filename)
    if isfile(ipath)
        for d in JSON.parsefile(ipath)["servers"]
            k = keys(d)
            kstr = reduce((a,b)->a*","*b, "$ki" for ki in k)
            vstr = reduce((a,b)->a*","*b, "'$(d[ki])'" for ki in k)
            pstr = reduce((a,b)->a*","*b, "$ki = '$(d[ki])'" for ki in k)
            query = """
            INSERT INTO users ($kstr) VALUES ($vstr) ON CONFLICT (name)
            DO UPDATE SET $pstr
            """
            ODBC.execute!(dsn, query)
        end
    end
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
