const confpath = joinpath(dirname(dirname(@__FILE__)), "deps", "config.json")
if isfile(confpath)
    const confd = JSON.parsefile(confpath)
    if !haskey(confd, "serialsocket")
        error("set `serialsocket` key in $(confpath) to have a valid ",
            "ZeroMQ connection string.")
    elseif !haskey(confd, "jsonsocket")
        error("set `jsonsocket` key in $(confpath) to have a valid ",
            "ZeroMQ connection string.")
    elseif !haskey(confd, "dsn")
        error("set `dsn` key in $(confpath) to a valid ODBC connection string. See ",
            "connectionstrings.com for examples of valid connection strings, which ",
            "will depend on the database and ODBC driver.")
    end
else
    error("configuration file not found at $(confpath).")
end
