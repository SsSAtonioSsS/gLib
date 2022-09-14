function PROVIDER:Connected()
    return true
end

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
    return sql.SQLStr(str, b)
end

function PROVIDER:Query(str, cb)
    cb = cb or function() end

    if self.Config.DEBUG then
        self:Log('Starting query: ' .. str)
    end

    local r = sql.Query(str)

    if r == false then
        self:Log('[Error]: ' .. sql.LastError() .. '\n' .. str, true, true)

        cb({
            status = false
        })

        return
    end

    local ins = sql.Query('SELECT last_insert_rowid() as row;')
    ins = #ins > 0 and tonumber(ins[1].row) or nil
    cb({
        status = true,
        insertID = ins,
        data = r or {}
    })

    return
end

function PROVIDER:Transaction(SQLtbl, cb)
    cb = cb or function() end

    if self.Config.DEBUG then
        self:Log('Starting transaction:\n>>>>>>>>>>>>>>\n' .. table.concat(SQLtbl, ',\n') .. '\n<<<<<<<<<<<<<<')
    end

    local Trs = 'BEGIN;\n'

    for _, v in pairs(SQLtbl) do
        Trs = Trs .. (v:EndsWith(';') and v or v .. ';') .. '\n'
    end

    Trs = Trs .. 'COMMIT;'

    self:Query(Trs, function(r)
        if not r.status then
            self:Query('ROLLBACK;')

            cb({
                status = false
            })

            return
        else
            cb({
                status = true
            })

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

PROVIDER.duplicte = function(...)
    return 'ON CONFLICT(' .. table.concat({...}, ', ') .. ') DO UPDATE SET'
end