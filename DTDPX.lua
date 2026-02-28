
print("\27[44m[DTD::PIP]:\27[0m \27[92mLOADED PLUGIN PACK")

new.cmd("pi", function()
  if args[2] == "init" then
    if not args[3] then
      loadplugins()
      return
    elseif args[3]:match("%.dtdp%.lua$") then
      local sucess, err = pcall(function() dofile(args[3]) end)
      if err then
        print("\27[44m[DTD::PIL]:\27[0m\27[91m ERROR WHILE LOADING:\nno plugin found!")
      end
    else
      print("\27[44m[DTD::PIL]:\27[0m\27[91m no .dtdp.lua file provided!")
    end
  elseif args[2] == "ls" then
    local get = 0
    for i,v in ipairs(_G.plugins) do
      get = i
      print("\27[44m[\27[92m"..i.."\27[0m\27[44m]: "..v)
    end
    if get == 0 then
      print("\27[44m[DTD::PIL]:\27[0m\27[91m no plugin loaded!\27[0m")
    end
  end
end, "manage plugins session")

new.cmd("open", function()
  if args[2] then
    local url = args[2]
    if url:sub(1, 8) ~= "https://" then 
        print("\27[0m\27[44m[DTD::SM]:\27[0m \27[93mfetching servers...\27[0m")
        local ssf = io.popen("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Servers")
        local ssfc = ssf:read("*a")
        ssf:close()
        print("\27[93mformating objects...\27[0m")
        local servers = {}
        for i,v in ssfc:gmatch("%s*\"name\"%s*:%s*\"%s*(.-)@(.-)\"") do
            local obj = { name = i, owner = v }
            table.insert(servers, obj)
        end for i,v in ipairs(servers) do
            if url == v.name then
                print("\27[92mloading server...\27[0m")
                url = v.name.."@"..v.owner
                break
            end
        end
        print("\27[93mconnecting server host...\27[0m")
        local urlh = io.popen("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Servers/"..url)
        local urlfetch = urlh:read("*a")
        urlh:close()
        print("\27[93mconnecting to url...\27[0m")
        print(urlfetch)
        url = urlfetch
    end

    local get = io.popen("curl -s "..url)
    local content = get:read("*a")
    get:close()
    if content then
      local fn, err = load(content)
      if not fn then print(tostring(err)) else fn() end
    else
      print("\27[0m\27[91mno content received!")
    end
  else
    print("\27[0m\27[91mno url provided\27[0m")
    print("\27[90mtype \27[94mopen servers\27[90m to view avaliable servers...")
  end
end, "load lua content from a url")

new.cmd("help",function()
  for i,v in ipairs(cmd) do
    print("\27[92m"..i.."- [ \27[0m"..v.."\27[92m ]\n\27[93m\27[1m--desc: \27[0m"..cmdd[i].."\n\n")
  end
end, "literally helps you... :|")

new.cmd("out",function()
  print(input:sub(5, 100))
end, "prints a text in terminal")