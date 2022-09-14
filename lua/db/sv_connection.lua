gLib.DB = gLib.DB or {}

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

    --gLib.DB.YourName = self:NewConnetion(provider, nil, connect)
end)

---- YOLO DONATE CONNECTION ----
local yoloConnect = 'config/yolo_connect.lua'
if file.Exists(yoloConnect, 'LUA') then
    include(yoloConnect)
end