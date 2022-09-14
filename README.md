Simple sql lib for Garry's Mod.
MySQL based on MySQLOO FredyH.
SQLite based on native Garry's Mod SQLite v3.26.0.
-
After unpacking, configure the connection and provider in a file:

```
@addons/glib/cfg/sv_data.lua
```

Methods in providers:
| Name | Description |
| :--- | :--- |
| void gLib.SQL:config({host, user, pwd, db, port, socket}) | `Configure connection` |
| void gLib.SQL:connect() | `Connect to DataBase` |
| void gLib.SQL:Connected() | `Check connection status` |
| void gLib.SQL:disconnect() | `Disconnect...` |
| void gLib.SQL:SSL(key, cert, ca, capath, cipher) | `SSL` |
| void gLib.SQL:Escape(str, b)| `Escapes [String] str so that it is safe to use in a query` |
| void gLib.SQL:Query(str, cb)| `Base query with callback` |
| void gLib.SQL:Transaction({str1, str2, ...}, cb)| `Transactions with callback` |
| void gLib.SQL:TableExists(str, cb) | `Table exists` |


Others:
| Name | Description |
| :--- | :--- |
| string PROVIDER.time | `Return unix_timestamp in MySQL and date in SQLite` |
| string PROVIDER.inc | `Return AUTO_INCREMENT WITH UNSIGNED or Nothing` |
| string PROVIDER.size(size) | `Return (size) or Nothing` |
| string PROVIDER.ignore | `Return 'IGNORE' for Insert` |
| string PROVIDER.duplicate(...) | `Return ON DUPLICATE KEY UPDATE or ON CONFLICT(...)...` |

Shared methods:
| Name | Description |
| :--- | :--- |
| string gLib.SQL:where({id = 1, name = 'fff', ...}) | `Formated Where with space` |
| void gLib.SQL:Update(TableName, SetTbl, WhereTbl, cb) | `Update row and return true or false on mask in callback` |
| void gLib.SQL:Insert(TableName, SetTbl, cb) | `Insert into db, return only true or false in callback` |
| void gLib.SQL:Select(ColumnsToSelect, TableName, cb, WhereTbl) | `Base Query select, return result in callback` |
| void gLib.SQL:Delete(TableName, WhereTbl, cb) | `Delete row(s) from database` |
| table gLib.SQL.assoc(tbl) | `Replacing array keys with id records in the database, there must be an 'id' field` |

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
gLib:SQL:Log(str, bool, bool) -- Error, see in console, error flag
```
Logs are written to the `@data/glib/` directory by default.
