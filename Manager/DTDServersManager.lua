
os.execute("clear")
print("\27[0m\27[44m[DTD::SM]:\27[0m \27[93minitializing...")
if not DTDUser then _G.DTDUser = { name = "Dougla037" } end

local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
load(ss:read("*a"))()
ss:close()

exit = false

local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDServers.txt")
local ssc = ss:read("*a") ss:close()
header = "TYPE ANY KEY TO SHOW\ntype \27[93mcreate\27[0m to create a new server\ntype \27[93mexit\27[0m to finish session"

::s:: print("\27[44m[DTD::SERVERS]:\27[0m\n\n"..header.."\n\n\27[44m[===========================]\27[0m\n> \27[1A\27[1C")
header = ""
inp = io.read()

for i,v,c in ssc:gmatch("([%w_%-]+)%s*<<%s*(https?://.-)>><<%s*(.-)%s*>>") do
  header = header .. "\27[44m[SS:HOST]:\27[0m \27[93m"..i.."\27[0m\n\27[44m[SS:HURL]:\27[0m \27[92m"..v.."\n\27[0m\27[44m[SS::DEV]:\27[0m "..c.."\n\27[0m\n"
end

if inp == "exit" then
  exit = true
elseif inp == "create" then
  local create = true
  local doreq = true
  local ysc
  while create do
    os.execute("clear")
    if doreq == true then
      print("\27[93mgetting your servers...\27[0m")
       ys = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDServers.txt")
       ysc = ys:read("*a") ys:close()
      doreq = false
    end
    local servis = {}
    for i,v,c in ysc:gmatch("([%w_%-]+)%s*<<%s*(.-)>><<%s*(.-)%s*>>") do
      if c == _G.DTDUser.name then
        table.insert(servis, i)
      end
    end os.execute("clear")
    if servis[1] then
      print("\27[44m[ Look Your Colection!]:\27[0m")
    else
      print("\27[44m[ What are you will Create now? ]:\27[0m")
      print("\n\27[90m you dont have any server here...\n type 'new' to start a create a new!")
    end
    for i,v in ipairs(servis) do
      print("\n\27[92m\27[1m [ \27[0m\27[46m\27[1m"..v.."\27[0m\27[92m\27[1m ] \27[0m")
    end
    print("\n\27[0m\27[44m[================================]\27[0m")
    io.write(" > \27[90mback, new\27[0m\27[9D")
    local cinp = io.read()
    if cinp == "back" then
      create = false
    elseif cinp == "new" then
      os.execute("clear")
      print("\27[44m[NAME/HOST]:\27[0m\n> ")
      local sname = io.read()
      print("\27[44m[URL/HTTP]:\27[0m\n> ")
      local surl = io.read()
      if sname:gsub(" ","") ~= "" and surl:sub(1,1) ~= " " then
        local struc = "\n"..sname.."<<"..surl..">><<".._G.DTDUser.name..">>"
        local postmatch = ssc .. struc
        if postmatch then
          DTDPostService:servers(postmatch)
          os.execute("clear")
        else print("\27[91merror...\27[0m") end
      end
    end
  end
  
end

os.execute("clear")
if exit == false then
  goto s
end