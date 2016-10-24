<a id='ICDataServer.newuser' href='#ICDataServer.newuser'>#</a>
**`ICDataServer.newuser`** &mdash; *Function*.



```
newuser(dsn, username, name; email="", phone="", office="")
```

This function creates a new user in the `users` table of the database. E-mail, phone, office are useful for contacting users about their measurements.


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/11903b0154a7a722d12cec3a524d64803928adfe/src/users.jl#L1-L8' class='documenter-source'>source</a><br>

<a id='ICDataServer.updateuser' href='#ICDataServer.updateuser'>#</a>
**`ICDataServer.updateuser`** &mdash; *Function*.



```
updateuser(dsn, username; kwargs...)
```

Update an existing user in the `users` table, identified by `username`. Specify the fields to update with keyword arguments specified in [`ICDataServer.newuser`](users.md#ICDataServer.newuser).


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/11903b0154a7a722d12cec3a524d64803928adfe/src/users.jl#L30-L38' class='documenter-source'>source</a><br>

<a id='ICDataServer.deleteuser' href='#ICDataServer.deleteuser'>#</a>
**`ICDataServer.deleteuser`** &mdash; *Function*.



```
deleteuser(dsn, username)
```

Delete a user from the `users` table by providing the username.


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/11903b0154a7a722d12cec3a524d64803928adfe/src/users.jl#L47-L53' class='documenter-source'>source</a><br>

<a id='ICDataServer.listusers' href='#ICDataServer.listusers'>#</a>
**`ICDataServer.listusers`** &mdash; *Function*.



```
listusers(dsn)
```

List all users in the `users` table.


<a target='_blank' href='https://github.com/PainterQubits/ICDataServer.jl/tree/11903b0154a7a722d12cec3a524d64803928adfe/src/users.jl#L58-L64' class='documenter-source'>source</a><br>

