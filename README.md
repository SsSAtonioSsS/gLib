Simple sql lib for Garry's Mod.
MySQL based on MySQLOO FredyH.
SQLite based on native Garry's Mod SQLite v3.26.0.
-
For creating new connection use method:
```
  gLib:NewConnection(provider, debug, {host = 'localhost', user = 'root', pwd = '123', db = 'local', port = 3306, socket = ''}
```

Create new DBconnect
```lua
SOMENAME = {}
  hook.Add('gLibInitilize', somenameHook, function(self)
    local provider = 'mysql' -- 'sqlite'

    local connect = {
        host = 'localhost',
        user = 'data',
        pwd = '123451',
        db = 'data',
        port = 3306,
        socket = ''
    }

    SOMENAME = self:NewConnetion(provider, nil, connect)
    SOMENAME:connect()
end)
```

Listening new connetion on success:
```
  hook.Add('gLibProviderConnected', randomname, function(self)
    if self.ConnectionName == SOMENAME.ConnectionName then
        -- Your code
    end
  end)
```


Methods in providers:
| Name | Description |
| :--- | :--- |
| void Connection:config({host, user, pwd, db, port, socket}) | `Configure connection` |
| void Connection:connect() | `Connect to DataBase` |
| void Connection:Connected() | `Check connection status` |
| void Connection:disconnect() | `Disconnect...` |
| void Connection:SSL(key, cert, ca, capath, cipher) | `SSL` |
| void ConnectionL:Escape(str, b)| `Escapes [String] str so that it is safe to use in a query` |
| void Connection:Query(str, cb)| `Base query with callback` |
| void Connection:Transaction({str1, str2, ...}, cb)| `Transactions with callback` |
| void Connection:TableExists(str, cb) | `Table exists` |


Others:
| Name | Description |
| :--- | :--- |
| string Connection.time | `Return unix_timestamp in MySQL and date in SQLite` |
| string Connection.inc | `Return AUTO_INCREMENT WITH UNSIGNED or Nothing` |
| string Connection.size(size) | `Return (size) or Nothing` |
| string Connection.ignore | `Return 'IGNORE' for Insert` |
| string Connection.duplicate(...) | `Return ON DUPLICATE KEY UPDATE or ON CONFLICT(...)...` |

Shared methods:
| Name | Description |
| :--- | :--- |
| string Connection:where({id = 1, name = 'fff', ...}) | `Formated Where with space` |
| void Connection:Update(TableName, SetTbl, WhereTbl, cb) | `Update row and return true or false on mask in callback` |
| void Connection:Insert(TableName, SetTbl, cb) | `Insert into db, return only true or false in callback` |
| void Connection:Select(ColumnsToSelect, TableName, cb, WhereTbl) | `Base Query select, return result in callback` |
| void Connection:Delete(TableName, WhereTbl, cb) | `Delete row(s) from database` |
| table Connection.assoc(tbl) | `Replacing array keys with id records in the database, there must be an 'id' field` |

Result mask in callbacks:

```lua
{
  status,   =>> bool
  insertID, =>> int
  result    =>> table
}
```

Some hooks:

| Name | Return | Description |
| :--- | :--- | :--- |
| `gLibProviderConnected` | gLib.SQL | `Successful connectig to DB` |
| `gLibProviderFailed` | pathToProvider | `Load provider fails bcs not exists` |
| `gLibProviderLoaded` | gLib.SQL | `Successful load cur provider` |

Logs:

```lua
Connection:Log(str, bool, bool) -- Error, see in console, error flag
```
Logs are written to the `@data/glib/` directory by default.
