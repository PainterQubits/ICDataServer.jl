const confpath = joinpath(dirname(dirname(@__FILE__)), "deps", "config.json")
if isfile(confpath)
    const confd = JSON.parsefile(confpath)
    if !haskey(confd, "dbsock")
        error("set `dbsock` key in $(confpath) to have a valid ",
            "ZeroMQ connection string.")
    elseif !haskey(confd, "dsn")
        error("set `dsn` key in $(confpath) to the name of a valid ODBC DSN.")
    end

    if haskey(confd, "password") && !haskey(confd, "username")
        error("set `username` key in $(confpath) if providing a `password` key.")
    end

    if !haskey(confd, "username")
        confd["username"] = ""
    end
    if !haskey(confd, "password")
        confd["password"] = ""
    end
else
    error("configuration file not found at $(confpath).")
end
