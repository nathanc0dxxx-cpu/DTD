std:newcmd({
  token = "help",
  func = function()
    for i,v in ipairs(std.cmd) do
      print("\27[96m"..i.." \27[92m"..v.token.."\n  \27[93m"..v.desc.."\27[0m\n")
    end
  end,
  desc = "it helps you bro... JUST!"
})
std:newcmd({
    token = "clear",
    func = function()
        os.execute("clear")
    end,
    desc = "clear the screen"
})
std:newcmd({
    token = "deploy",
    func = function()
        local query = std.args[2]
        local pip = io.popen("ls")
        local pipc = pip:read("*a")
        pip:close()
        for v in pipc:gmatch("%S+") do
            if v:match(query) then
                print("\27[93mis "..v.." you want to deploy?\n\27[92m[Y]\27[0m/\27[91m[N]\27[0m: ")
                local answer = io.read()
                if answer == "y" or answer == "Y" then
                    print("\27[93mworking...\27[0m")
                    local file = io.open(v,"r")
                    if file then
                        local content = file:read("*a")
                        file:close()
                        local strucn = v.."@".._G.DTDUser.name
                        print("\27[93mloading postservice...")
                        local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
                        if ss then load(ss:read("*a"))() ss:close()
                            local test = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Market")
                            local testc = test:read("*a")
                            test:close() local packgs = {}
                            for g,j in testc:gmatch("%s*\"name\"%s*:%s*\"(.-)@(.-)\"") do
                                local obj = { name = g, owner = j }
                                table.insert(packgs, obj)
                            end local found = false
                            for j,k in ipairs(packgs) do
                                if v == k.name and _G.DTDUser.name ~= k.owner then 
                                    found = true
                                end
                            end local found2 = false
                            for j,k in ipairs(packgs) do
                                if k.owner == _G.DTDUser.name and k.name ~= v then
                                    found2 = true
                                end
                            end
                            if found == false and found2 == false then
                                DTDPostService:market(content, strucn, "POST")
                            elseif found == false and found2 == true then
                                DTDPostService:market(content, strucn, "PUT")
                            end
                        else
                            print("\27[91mfailed to load postservice, aborting...\27[0m")
                            return
                        end
                    else
                        print("\27[91mthe file got null\27[0m")
                    end
                else
                    print("\27[0m\n")
                end
            end
        end
    end,
    desc = "deploy a file to the market"
})
std:newcmd({
    token = "deorbit",
    func = function()
        local query = std.args[2]
        local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Market")
        local ssc = ss:read("*a")
        ss:close()
        local packgs = {}
        for i,v in ssc:gmatch("%s*\"name\"%s*:%s*\"(.-)@(.-)\"") do
            local obj =
    end,
    desc = "delete an market file in who you deployed"
})
std:newcmd({
    token = "view",
    func = function()
        local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Market")
        local handle = ss:read("*a")
        ss:close() local pkgs = {}
        for i,v in handle:gmatch("%s*\"name\"%s*:%s*\"(.-)@(.-)\"") do
            local obj = { name = i, owner = v }
            table.insert(pkgs, obj)
        end for i,v in ipairs(pkgs) do
            if v.owner == _G.DTDUser.name then
                print("\27[92m [ \27[96m"..v.name.."\27[92m ]\27[0m")
            end
        end
    end,
    desc = "view your deployed files"
})
std:newcmd({
    token = "ls",
    func = function()
        local pip = io.popen("ls")
        print("\27[96mcurrent files:\n\27[0m  "..pip:read("*a"))
        pip:close()
    end,
    desc = "list your local files"
})