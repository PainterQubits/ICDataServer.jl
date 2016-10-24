
<a id='Instruments-1'></a>

## Instruments

<a id='ICDataServer.newinstrument' href='#ICDataServer.newinstrument'>#</a>
**`ICDataServer.newinstrument`** &mdash; *Function*.



```
newinstrument(dsn, alias; make="", model="", serialnum="", kind="",
    hw_server="", protocol="", ins_addr="")
```

Create a new instrument named `alias` in the `instruments` table.


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/514403a46b775984394168023f072cf132e1384b/src/instruments.jl#L1-L8' class='documenter-source'>source</a><br>

<a id='ICDataServer.updateinstrument' href='#ICDataServer.updateinstrument'>#</a>
**`ICDataServer.updateinstrument`** &mdash; *Function*.



```
updateinstrument(dsn, alias; kwargs...)
```

Update any of the fields for an instrument named `alias`. Possible keyword arguments listed in documentation for [`ICDataServer.newinstrument`](instruments.md#ICDataServer.newinstrument).


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/514403a46b775984394168023f072cf132e1384b/src/instruments.jl#L18-L25' class='documenter-source'>source</a><br>

<a id='ICDataServer.deleteinstrument' href='#ICDataServer.deleteinstrument'>#</a>
**`ICDataServer.deleteinstrument`** &mdash; *Function*.



```
deleteinstrument(dsn, alias)
```

Delete instrument named `alias` from the `instruments` table.


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/514403a46b775984394168023f072cf132e1384b/src/instruments.jl#L32-L38' class='documenter-source'>source</a><br>

<a id='ICDataServer.listinstruments' href='#ICDataServer.listinstruments'>#</a>
**`ICDataServer.listinstruments`** &mdash; *Function*.



```
listinstruments(dsn)
```

List instruments in the `instruments` table.


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/514403a46b775984394168023f072cf132e1384b/src/instruments.jl#L44-L50' class='documenter-source'>source</a><br>


<a id='Constraints-on-the-instruments-table-1'></a>

## Constraints on the `instruments` table


To enforce consistent conventions in the `instruments` table, there are some supporting tables that list the allowed values for an associated column in the `instruments` table.


<a id='instrumentkinds-table-1'></a>

### `instrumentkinds` table


This table, consisting of one column `kind`, lists the different kinds of instruments that may be used in a measurement. More values can be added manually via a database query or via the `instrumentkinds.json` setup file to accommodate new instrument types.

