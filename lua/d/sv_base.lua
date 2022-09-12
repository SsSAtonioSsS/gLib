include('sv_init.lua')

function gLib.SQL:Log(text, ServerLog, err)
    local dir = 'gLib'

    if not file.IsDir(dir, "DATA") then
        file.CreateDir(dir)
    end

    local filename = not err and self.Config.DataStore .. '_logs_' .. os.date('%d-%m-%Y') .. '.txt' or self.Config.DataStore .. '_logs_errors_' .. os.date('%d-%m-%Y') .. '.txt'

    if ServerLog then
        local s = '[gLib] ' .. text

        if err then
            ErrorNoHalt(s .. '\n')
        else
            print(s)
        end
    end

    if not file.Exists(dir .. '/' .. filename, 'DATA') then
        file.Write(dir .. '/' .. filename, '')
    end

    file.Append(dir .. '/' .. filename, os.date('[%X]') .. ' ' .. text .. '\r\n')
end

hook.Add('Initialize', 'LoadgLibProvider', function()
    gLib.SQL:Initialize()
end)
-- hook.Run('gLibProviderLoaded', self) << When data provider loaded
-- hook.Run('gLibProviderFailed', path) << When data provider failed
-- hook.Run('gLibProviderConnected', self)
-- hook.Run('gLibProviderDisConnected', self)