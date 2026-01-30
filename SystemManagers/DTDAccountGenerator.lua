function simple_hash(password, salt)
    local hash = 0
    local data = password .. salt

    for i = 1, #data do
        local c = data:byte(i)
        hash = (hash * 31 + c) % 4294967296
    end

    return string.format("%08x", hash)
end

function generate_salt(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local salt = ""
    for i = 1, length do
        local rand = math.random(1, #charset)
        salt = salt .. charset:sub(rand, rand)
    end
    return salt
end

function genuser(name, pass)
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
    if ss then load(ss:read("*a"))() ss:close() else return nil end
    local ssa = io.popen("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Accounts")
    local ssac = nil
    if ssa then ssac = ssa:read("*a") ssa:close() else return nil end
    local users = {} local id = 0
    for v in ssac:gmatch("%s*\"name\"%s*:%s*\"(.-)\"") do
        table.insert(users, v)
        id = id + 1
    end 
    local sse = io.popen("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Accounts/"..users[id])
    if sse then
        local tab = {} 
        for v in sse:read("*a"):gmatch("%S+") do
            table.insert(tab, v)
        end sse:close()
        id = tonumber(tab[2]) + 1
    else
        return nil
    end for i,v in ipairs(users) do
        if v == name then return nil end
    end

    math.randomseed(os.time())
    local salt = generate_salt(16)
    local hash = simple_hash(pass, salt)

    local content = hash .. "\n" .. id .. "\n" .. salt
    DTDPostService:accounts(content, name, "POST")

    return { un = name, ps = pass }
end