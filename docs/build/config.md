
Several configuration files should be generated and put into the `deps` directory of the ICDataServer package. These are not tracked by git as they may contain sensitive information and in any case are specific to the particular installation. These are used by [`ICDataServer.setuptables`](config.md#ICDataServer.setuptables) to add default information.

<a id='ICDataServer.setuptables' href='#ICDataServer.setuptables'>#</a>
**`ICDataServer.setuptables`** &mdash; *Function*.



```
setuptables()
```

Initialize a database with the tables needed to run ICDataServer:

  * `users`
  * `servers`
  * `instrumentkinds`
  * `instruments`
  * `jobs`
  * `notes`

The creation of the tables can proceed without additional input, but in some cases it may make sense for the tables to be automatically filled with data.

If new instrument kinds are added to `deps/instrumentkinds.json`, they will be added to `instrumentkinds` table. If kinds are encountered in the database that are not in the file, they remain in the database and are not deleted.

If new users are added to `deps/users.json`, they will be "upserted" into the `users` table (users are created if necessary; if an existing user name is attempted to be inserted into the table, then that user has their info updated from the json file). Existing users not found in users.json remain in the table.


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/514403a46b775984394168023f072cf132e1384b/src/setup.jl#L1-L25' class='documenter-source'>source</a><br>


<a id='deps/config.json-1'></a>

### deps/config.json


This JSON file consists of up to four keys and largely exists to provide connection information between the database and InstrumentControl clients. Typical example:


```
{
    "jobsock":"tcp://*:50001",
    "dsn":"icdataserver",
}
```


Additional fields not shown in the example may include:


  * "username": A username to connect to the database, if not provided when the DSN was configured.
  * "password": A password to connect to the database, if not provided when the DSN was configured.


<a id='deps/instrumentkinds.json-1'></a>

### deps/instrumentkinds.json


This JSON file declares the various kinds of instruments. Its purpose is to standardize such declarations in the database. Typical example:


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


<a id='deps/servers.json-1'></a>

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


<a id='deps/users.json-1'></a>

### deps/users.json


Declaration of users, including contact information which may be used by the software to send alerts and notifications. Typical example:


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

