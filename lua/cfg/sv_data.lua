gLib.SQL = gLib.SQL or {}
gLib.SQL.Config = gLib.SQL.Config or {}
local cfg = gLib.SQL.Config

cfg.DEBUG = false
cfg.DataStore = 'mysql' -- mysql || sqlite

cfg.srv = {
    host = 'localhost',
    user = 'data',
    pwd = '123451',
    db = 'data',
    port = 3306,
    socket = ''
}