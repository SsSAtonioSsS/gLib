include('init.lua')

function gLib:NewConnetion(provider, debug, tb)
    tb = tb or {}
    tb.host = tb.host or 'localhost'
    tb.user = tb.user or 'root'
    tb.pwd = tb.pwd or ''
    tb.db = tb.db or ''
    tb.port = tb.port or 3306
    tb.socket = tb.socket or ''
    tb.connection = tb.connection or (tb.host .. '_' .. tb.user .. '_' .. tb.db)
    local Pvtbl = self:IncludeProvider(provider)
    local new = table.Copy(Pvtbl)
    new.ConnectionName = tb.connection
    new.DEBUG = debug or false
    hook.Run('gLibCreateNewConnection', new)
    new:config(tb)

    return new
end

local function CheckVersion()
    http.Fetch(gLib.branch .. 'data/build.json', function(a, _, _, c)
        if c ~= 200 then return end
        a = util.JSONToTable(a)
        local remote = a.glib.version
        if remote > gLib.version then
            print([[
                -----------------------------------------
                [gLib] Version is outdated.
                Download the new version from:
                https://github.com/SsSAtonioSsS/glib!
                -----------------------------------------
            ]])
        end
    end)
end
hook.Add('Initialize', 'loadGlibFiles', function()
    CheckVersion()
    hook.Run('gLibInitilize', gLib)
end)