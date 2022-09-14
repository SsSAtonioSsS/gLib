function PROVIDER:Log(text, ServerLog, err)
    local dir = 'gLib/' .. self.ConnectionName

    if not file.IsDir(dir, "DATA") then
        file.CreateDir(dir)
    end

    local filename = not err and self.ID .. '_logs_' .. os.date('%d-%m-%Y') .. '.txt' or self.ID .. '_logs_errors_' .. os.date('%d-%m-%Y') .. '.txt'

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

function PROVIDER:where(tbl)
    Where = ''
    first = false

    for k, v in pairs(tbl) do
        v = isnumber(v) and v or '\'' .. v .. '\''

        if not first then
            Where = ' WHERE ' .. k .. ' = ' .. v
            first = true
        else
            Where = Where .. ' AND ' .. k .. ' = ' .. v
        end
    end
    return Where
end

function PROVIDER:Update(Table, Set, Where, cb)
    if table.Count(Set) <= 0 then return end
    if table.Count(Where) <= 0 then return end
    uqr = ''
    first = false

    for k, v in pairs(Set) do
        v = isnumber(v) and v or '\'' .. v .. '\''

        if not first then
            uqr = k .. ' = ' .. v
            first = true
        else
            uqr = uqr .. ', ' .. k .. ' = ' .. v
        end
    end

    Where = self:where(Where)

    self:Query('UPDATE ' .. Table .. ' SET ' .. uqr .. Where .. ';', cb)
end

function PROVIDER:Insert(Table, Values, cb)
    if table.Count(Values) <= 0 then return end
    local colums, values, first = '', '', false

    for k, v in pairs(Values) do
        v = isnumber(v) and v or '\'' .. v .. '\''

        if not first then
            colums, values, first = '( ' .. k, '( ' .. v, true
        else
            colums, values = colums .. ', ' .. k, values .. ', ' .. v
        end
    end

    colums, values = colums .. ' )', values .. ' )'
    self:Query('INSERT INTO ' .. Table .. colums .. ' VALUES ' .. values .. ';', function(a)
        if not a.status then return cb(nil) else cb(a.insertID) end
    end)
end

function PROVIDER:Select(Columns, Table, cb, Where)
    Columns = table.Count(Columns) ~= 0 and table.concat(Columns, ', ') or '*'
    Where = self:where(Where or {})
    self:Query('SELECT ' .. Columns .. ' FROM ' .. Table .. Where .. ';', cb)
end

function PROVIDER:Delete(Table, Where, cb)
    if table.Count(Where) <= 0 then return end
    Where = self:where(Where)

    self:Query('DELETE FROM ' .. Table .. Where .. ';', cb)
end

function PROVIDER.assoc(tbl)
    local t = {}
    for _, v in pairs(tbl) do
        local id = v.id
        v.id = nil
        t[tonumber(id)] = v
    end
    return t
end