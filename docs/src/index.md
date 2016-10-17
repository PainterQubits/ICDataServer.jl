# ICDataServer.jl

Automatic logging of measurement data and metadata.

## Installation

If you plan to run a database:
+ Install the most recent version of [PostgreSQL](https://www.postgresql.org/download/)
+ Install the 64-bit ODBC driver for PostgreSQL
  (on Windows, it is an optional installation prompted automatically).

Whether you plan to run a database or not:
+ `Pkg.clone("https://github.com/painterqubits/ICDataServer.jl.git")`

## Quick start

```
julia> using ICDataServer

julia> ICDataServer.setuptables()

```
