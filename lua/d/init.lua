function gLib:IncludeProvider(provider, c)
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
    local p = PROVIDER
    PROVIDER = nil

    print('[gLib] PROVIDER LOADED (' .. provider:upper() .. ')!')

    return p
end