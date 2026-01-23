
os.execute("clear")
local exit = false
local packs = {}
local function loadpacks()
    local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Market")
    local sst = ss:read("*a")
    ss:close()
    packs = {}
    for i,v in sst:gmatch("%s*\"name\"%s*:%s*\"%s*(.-)@(.-)\"") do
        local obj = { name = i, owner = v }
        table.insert(packs, obj)
    end
end loadpacks()

local inp = nil

local function market()
    os.execute("clear")
    
    print("\27[0m\27[44m[Market]:\27[41m[=============]\27[0m\n")
    local maxi = 3
    for i = 1,9 do
        if packs[i] then
        io.write("\27[92m [\27[93m"..packs[i].name.."\27[92m]\27[0m")
        if i > maxi then
            maxi = maxi + 3
            print("\n")
        end end
    end
    print("\n\n\27[44m[======================]\27[0m")
    io.write(" > \27[90m<pack>, search, exit, reset\27[27D\27[92m")
    inp = io.read()
    if inp == "exit" then
        os.execute("clear")
        print("\27[91mlogout\27[0m")
    elseif inp == "reset" then
        loadpacks()
        market()
    elseif inp:sub(1,7) == "search " then
        search(inp:sub(8))
    else
        hub(inp)
    end
end

function search(query)
    os.execute("clear")
    print("\27[0m\27[44m[Results]:\27[41m[============]\27[0m\n")
    for i,v in ipairs(packs) do
        if v.name:match(query) then
            print("\27[92m [ \27[93m"..i.."\27[92m ]: \27[0m\27[42m"..v.name.."\27[0m \27[90m"..v.owner.."\n")
        end
    end print("\27[0m\27[44m[======================]\27[0m")
    io.write(" > \27[90m<pack>, back\27[12D\27[92m")
    inp = io.read()
    if inp == "back" then
        market()
    else
        hub(inp)
    end
end

function hub(query)
    os.execute("clear")
    local obj = {}
    for i,v in ipairs(packs) do
        if v.name:match(query) then
            obj = v
            break
        end
    end obj.desc = "\27[0m no description provided!"
    print("\27[0m\27[44m[HUB]:\27[41m[==========]\27[0m")
    print(string.format([[
  .--_____
  |       | %s
  |---?---| %s %s
  |       |
  |_______|
  %s
    ]], "\27[96m"..obj.name.."\27[0m", "\27[90mby ", obj.owner.."\27[0m", obj.desc))
    print("\27[0m\27[44m[================]\27[0m")
    io.write(" > \27[90mback, install\27[13D\27[92m")
    local uinp = io.read()
    if uinp == "back" then
        market()
    elseif uinp == "install" then
        os.execute("clear")
        print("\27[93mdownloading...\27[0m")
        local ssi = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/Market/"..obj.name.."@"..obj.owner)
        local ssic = ssi:read("*a")
        ssi:close()
        if ssic then
            print("\27[93minstalling...\27[0m")
            local file = io.open(obj.name, "w")
            if file then
                file:write(ssic)
                file:close()
                print("\27[92minstalled!\n\27[0mpath: ")
                os.execute("pwd")
                os.execute("sleep 3")
                hub(query)
            else
                print("\27[91merror while downloading...\27[0m")
            end
        end
        market()
    else
        hub(query)
    end
end

market()