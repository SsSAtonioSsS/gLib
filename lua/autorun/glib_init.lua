if not SERVER then return end
gLib = gLib or {}
gLib.SQL = gLib.SQL or {}
gLib.version = '0.0.4d'
include('db/sv_connection.lua')
include('d/sv_base.lua')
