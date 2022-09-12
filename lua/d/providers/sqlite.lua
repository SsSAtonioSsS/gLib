function PROVIDER:Connected() return true end

function PROVIDER.config(_)
    return true
end

function PROVIDER:connect()
    hook.Run('gLibProviderConnected', self)
    return true
end

function PROVIDER:disconnect()
    return true
end

function PROVIDER:Escape(str, b)
    return sql.SQLStr( str, b )
end

function PROVIDER:Query(str, cb, t)
    cb = cb or function() end

    if self.Config.DEBUG then
        self:Log('Starting query: ' .. str)
    end

    local stype = str:lower():match'select'
    local r = sql.Query(str)

    if r == false then
        self:Log('[Error]: ' .. sql.LastError() .. '\n' .. str, true, true)

        cb(false)
        return
    end

    if t and str:lower():match'insert' then
        self:Query('SELECT last_insert_rowid() as row;', function(rs)
            cb(tonumber(rs[1].row))
        end)
        return
    end

    cb(stype and (r or {}) or true)
    return
end

function PROVIDER:Transaction(SQLtbl, cb)
    cb = cb or function() end

    if self.Config.DEBUG then
        self:Log('Starting transaction:\n>>>>>>>>>>>>>>\n' .. table.concat(SQLtbl, ',\n') .. '\n<<<<<<<<<<<<<<')
    end

    local Trs = 'BEGIN;\n'

    for _,v in pairs(SQLtbl) do
        Trs = Trs .. (v:EndsWith(';') and v or v .. ';') .. '\n'
    end

    Trs = Trs .. 'COMMIT;'

    self:Query(Trs, function(r)
        if r == false then
            self:Query('ROLLBACK;')
            cb(false)
            return
        else
            cb(true)
            return
        end
    end)
end

function PROVIDER:TableExists(str, cb)
    cb(sql.TableExists(str))
end

PROVIDER.time = '\'\''
PROVIDER.inc = ''
PROVIDER.size = function(_) return '' end
PROVIDER.ignore = 'OR IGNORE'
PROVIDER.duplicte = function(...) return 'ON CONFLICT(' .. table.concat({...}, ', ') .. ') DO UPDATE SET' end