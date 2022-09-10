function gLib.SQL:Initialize()
    self:IncludeProvider()
end

function gLib.SQL:IncludeProvider()
    local path = 'd/providers/' .. self.Config.DataStore .. '.lua'
    local path2 = 'd/shared/misc.lua'

    if not file.Exists(path, 'LUA') then
        error('Provider not found. ' .. path)
        hook.Run('gLibProviderFailed', path)

        return
    end

    PROVIDER = {}
    PROVIDER.__index = {}
    PROVIDER.ID = self.Config.DataStore
    include(path)
    include(path2)
    table.Merge(self, PROVIDER)
    PROVIDER = nil

    self:Log('[gLib] PROVIDER LOADED (' .. gLib.SQL.Config.DataStore:upper() .. ')!')

    self:config(self.Config.srv)
    self:connect()

    hook.Run('gLibProviderLoaded', self)
end