
<a id='ICDataServer.jl-1'></a>

# ICDataServer.jl


Automatic logging of measurement data and metadata.


<a id='Installation-1'></a>

## Installation


  * Install the most recent version of [PostgreSQL](https://www.postgresql.org/download/)
  * Install the 64-bit ODBC driver for PostgreSQL (on Windows, it is an optional installation prompted automatically).
  * `Pkg.clone("https://github.com/painterqubits/ICDataServer.jl.git")`


<a id='Quick-start-1'></a>

## Quick start


```
julia> using ICDataServer

julia> ICDataServer.setuptables()

```

