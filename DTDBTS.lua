do
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDAdaptor.lua")
    if ss then load(ss:read("*a"))() ss:close() else print("\27[91mfailed to load adaptor...\27[0m") return end
end

function start()
    print("\27[44m[DTD::BOOTSTRAP]:\27[0m\27[93m initializing...\27[0m")
    local get = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDOS.lua")
    local content = get:read("*a")
    get:close()
    if content:match("::s::") then
        print("\27[44m[DTD::BOOTSTRAP]:\27[0m\27[92mcontent loaded\n\27[91mRUNNING...")
        load(content)()
    else
        print("\27[44m[DTD::BOOTSTRAP]:\27[0m\27[41mno content found")
    end
end

local function clear()
    io.write("\27[3J\27[2J\27[H")
    io.flush()
end

function loadpacks()
    clear()
    print("fetching installer code...")
    local s = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDPX.lua")
    if s then
        local c = s:read("*a")
        s:close()
        load(c)()
    end
end

do
    local ssl = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDAccountLogger.lua")
    local ssc = ssl:read("*a")
    ssl:close()
    if ssc then load(ssc)() end
end

while true do
    print("\27[44m[DTD::BOOTSTRAP]:\27[0mtype a option\n\n\27[93m[1]: start\n[2]: loadpack\n[3]: removepack\n\27[0m")
    local cmd = io.read()
    if cmd == "start" or cmd == "1" then
        clear()
        start()
        break
    elseif cmd == "loadpack" or cmd == "2" then
        clear()
        loadpacks()
    elseif cmd == "removepack" or cmd == "3" then
        clear()
    else
        clear()
    end
end