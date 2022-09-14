if not SERVER then return end
gLib = gLib or {}
gLib.SQL = gLib.SQL or {}
gLib.version = '0.0.3'
include('db/sv_connection.lua')
include('d/sv_base.lua')
