function gLib:IncludeProvider(provider, c)
    local self = gLib.SQL
    if self[provider] then return self[provider] end
    local path = 'd/providers/' .. provider .. '.lua'
    local path2 = 'd/shared/misc.lua'

    if not file.Exists(path, 'LUA') then
        error('Provider not found. ' .. path)
        hook.Run('gLibProviderFailed', path)

        return
    end

    PROVIDER = {}
    PROVIDER.__index = {}
    PROVIDER.ID = provider
    include(path2)
    include(path)
    self[provider] = PROVIDER
    PROVIDER = nil

    print('[gLib] PROVIDER LOADED (' .. provider:upper() .. ')!')

    return self[provider]
end