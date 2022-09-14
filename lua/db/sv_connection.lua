--[[gLib.DB = gLib.DB or {}

hook.Add('gLibInitilize', 'addConnection', function(self)
    local provider = 'mysql' -- 'sqlite'

    local connect = {
        host = 'localhost',
        user = 'data',
        pwd = '123451',
        db = 'data',
        port = 3306,
        socket = ''
    }

    gLib.DB.YourName = self:NewConnetion(provider, nil, connect)
    gLib.DB.YourName:connect()
end)]]