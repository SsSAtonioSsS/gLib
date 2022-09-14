require('mysqloo')

function PROVIDER:Connected()
    return self.db:status() == mysqloo.DATABASE_CONNECTED
end

function PROVIDER:SSL(key, cert, ca, capath, cipher)
    return self.db:setSSLSettings(key, cert, ca, capath, cipher)
end

function PROVIDER:config(sqConf)
    sqConf.port = sqConf.port or 3306
    sqConf.socket = sqConf.socket or ''
    local sf = self
    self.db = mysqloo.connect(sqConf.host, sqConf.user, sqConf.pwd, sqConf.db, sqConf.port, sqConf.socket)

    function self.db:onConnected()
        self:setCharacterSet('UTF8')
        sf:Log('[MySQL]: Successful connected to (' .. sqConf.host .. ':' .. sqConf.port .. ') at ' .. sqConf.connection .. '!', true)
        hook.Run('gLibProviderConnected', sf)
    end

    function self.db:onConnectionFailed(er)
        sf:Log('[MySQL]: Connection Failed, error: ' .. er, true, true)
    end
end

function PROVIDER:connect()
    self.db:connect()
end

function PROVIDER:disconnect()
    self.db:disconnect(true)
end

function PROVIDER:Escape(str, b)
    return self.db:escape(str)
end

function PROVIDER:Query(str, cb)
    cb = cb or function() end
    local sf = self

    if self.DEBUG then
        self:Log('Starting query: ' .. str)
    end

    local r = self.db:query(str)

    function r:onSuccess(result)
        cb({
            status = true,
            insertID = self:lastInsert(),
            data = result or {}
        })
    end

    function r:onError(err, str)
        sf:Log('[Error]: ' .. err .. '\n\t' .. str, true, true)

        if not sf:Connected() then
            sf.db:connect()
            sf.db:wait()

            if not sf:Connected() then
                sf:Log('[Error]: Re-connection to database server failed.', true, true)

                return
            end

            self:start()
        end
        cb({status = false})
        sf:Log('[MySQL]: Query Failed: ' .. err .. ' (' .. str .. ')', false, true)
    end

    r:start()
end

function PROVIDER:Transaction(SQLtbl, cb)
    cb = cb or function() end
    local sf = self

    if self.DEBUG then
        self:Log('Starting transaction:\n>>>>>>>>>>>>>>\n' .. table.concat(SQLtbl, ',\n') .. '\n<<<<<<<<<<<<<<')
    end

    local Trs = self.db:createTransaction()

    for _, v in pairs(SQLtbl) do
        local q = self.db:query(v)
        Trs:addQuery(q)
    end

    function Trs:onSuccess()
        cb({
            status = true
        })
    end

    function Trs:onError(err)
        sf:Log('[Error]: ' .. err .. '\n\t' .. table.concat(SQLtbl, ',\n\t'), true, true)

        if not sf:Connected() then
            sf.db:connect()
            sf.db:wait()

            if not sf:Connected() then
                sf:Log('[Error]: Re-connection to database server failed.', true, true)

                return
            end

            self:start()
        end
    end

    Trs:start()
end

function PROVIDER:TableExists(str, cb)
    self:Query('SHOW TABLES LIKE \'' .. str .. '\';', function(a)
        if #a.data > 0 then
            cb(true)
        else
            cb(false)
        end
    end)
end

PROVIDER.time = 'UNIX_TIMESTAMP()'
PROVIDER.inc = ' UNSIGNED AUTO_INCREMENT'
PROVIDER.size = function(a) return '(' .. a .. ')' end
PROVIDER.ignore = 'IGNORE'
PROVIDER.duplicte = function(...) return 'ON DUPLICATE KEY UPDATE' end