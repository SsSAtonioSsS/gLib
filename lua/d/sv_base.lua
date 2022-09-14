include('init.lua')

function gLib:NewConnetion(provider, debug, tb)

    tb = tb or {}
    tb.host = tb.host or 'localhost'
    tb.user = tb.user or 'root'
    tb.pwd = tb.pwd or ''
    tb.db = tb.db or ''
    tb.port = tb.port or 3306
    tb.socket = tb.socket or ''
    tb.connection = tb.connection or (tb.host .. '_' .. tb.user  .. '_' .. tb.db)

    local Pvtbl = self:IncludeProvider(provider)
    local new = table.Copy(Pvtbl)
    new.ConnectionName = tb.connection
    new.DEBUG = debug or false
    hook.Run('gLibCreateNewConnection', new)
    new:config(tb)
    return new
end

hook.Add('Initialize', 'loadGlibFiles', function()
    hook.Run('gLibInitilize', gLib)
end)