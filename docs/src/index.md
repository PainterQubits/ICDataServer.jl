# ICDataServer.jl

Automatic logging of measurement data and metadata.

## Installation

Estimated burden: twenty minutes.

+ Install the most recent version of [PostgreSQL](https://www.postgresql.org/download/).
  When setting up, a password for the default user (`postgres`) will be requested.
  Choose something secure.

+ Following the installation, Stack Builder will open. This lets you add
  components to the PostgreSQL installation. Install from Database Drivers
  (64-bit when there is an option):

  + ODBC driver (only one of the three that is currently utilized)
  + JDBC driver
  + Npgsql


+ Now we need to make a database. Open the pgAdmin application that was
  installed with PostgreSQL. In the Browser tab, open Servers, then open
  PostgreSQL 9.6 (or whatever version was installed). This will prompt a login
  using the password you provided during PostgreSQL installation. After login,
  right-click Databases and create a database. I suggest giving it the name
  `icdataserver` and leaving everything else as default. Close pgAdmin.

+ You need to configure a data source name (DSN) so that ICDataServer can
  connect to the database. Open ODBC Data Source Administrator (64-bit) which
  seems to be installed by default in Windows 10. Under the User DSN tab, add
  a new DSN with the PostgreSQL ODBC driver (Unicode if available). You'll want
  to enter the following details:

  + Data Source: `icdataserver` (this is the DSN name)
  + Database: `icdataserver` (name of the database you created in pgAdmin)
  + Server: `localhost`
  + Port: `5432` (or whatever you chose during PostgreSQL installation)
  + Username and password as installed. Ideally a different user would be created.


+ Install ICDataServer: `Pkg.clone("https://github.com/painterqubits/ICDataServer.jl.git")`

## Quick start

You need to provide some configuration files that contain the default entries
for the data server. This includes things like the users, servers and their
locations, and instrument details. This is detailed in the Configuration docs.

On the first run of ICDataServer, you'll need to setup tables in the database
to keep track of all the information you'll be submitting to it. Press enter/return
when prompted for a path to the setup files, or you can provide another path.

```
julia> using ICDataServer

julia> IC = ICDataServer; dsn = IC.dsn;

julia> IC.setuptables(dsn)
Path to directory with setup files? [defaults to ICDataServer/deps]:

C:\Users\Discord\.julia\v0.5\ICDataServer\deps
```

Now the data server can be started. It should be running before you start
using `InstrumentControl`.

```
julia> IC.serve() # or @async IC.serve() to have it run in the background.
```
