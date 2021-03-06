Several configuration files should be generated and put into the `deps` directory
of the ICDataServer package. These are not tracked by git as they may contain
sensitive information and in any case are specific to the particular installation.
These are used by [`ICDataServer.setuptables`](@ref) to add default information.

```@docs
ICDataServer.setuptables
```

### deps/config.json

This JSON file consists of up to four keys and largely exists to provide
connection information between the database and InstrumentControl clients.
Typical example:

```
{
    "jobsock":"tcp://*:50001",
    "dsn":"icdataserver",
}
```

Additional fields not shown in the example may include:

- "username": A username to connect to the database, if not provided when the
  DSN was configured.
- "password": A password to connect to the database, if not provided when the
  DSN was configured.

### deps/instrumentkinds.json

This JSON file declares the various kinds of instruments. Its purpose is to
standardize such declarations in the database. Typical example:

```
{
	"kind": [
		"awg",
		"dcsource",
		"rfsource",
		"vna"
	]
}
```

### deps/servers.json

Declaration of servers. Typical example:

```
{
    "servers": [
        {
            "alias":"local_data",
            "address":"127.0.0.1",
            "port":"50002"
        },
        {
            "alias":"local_hw",
            "address":"127.0.0.1",
            "port":"50003"
        }
    ]
}
```

### deps/users.json

Declaration of users, including contact information which may be used by
the software to send alerts and notifications. Typical example:

```
{
    "users": [
        {
            "username":"default",
            "first":"No",
            "last":"Name"
        }, {
            "username":"anotheruser",
            "first":"Really",
            "middle":"No",
            "last":"Name",
            "email":"someaddress@caltech.edu",
            "phone":"15555551212",
            "office":"Watson 5th floor"
        }
    ]
}
```

The only required fields for each dictionary are `username`, `first`, `last`.
