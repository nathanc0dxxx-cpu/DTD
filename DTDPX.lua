
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

new.cmd("connect",function()
  if args[2] then
    local url = args[2]
    
    url = url:gsub("market","https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDMarketPacks.txt")
local get = io.popen("curl -s "..url)
local content = get:read("*a")
get:close()
if content then
  pcall(function() load(content)() end)
else
print("\27[0m\27[91mno content received!")
end
else
print("\27[0m\27[91mno url provided")
end, "load lua content from a url")
