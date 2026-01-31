os.execute("clear")
io.write("\27[0m")
if not (_VERSION:match("5.4") or _VERSION:match("5.5")) then
    print("\27[91mOld client detected!\27[93m\nto use Dnes you need to update your Lua Client to Lua 5.4 or Upper!\27[0m\nAbort.")
    os.exit()
end
function loadplugins() _G.plugins = {}
  local havepi = false
  print("\27[44m[DTD::PIL]:\27[0m\27[93m initializing...")
  local get = io.popen("ls")
  local files = get:read("*a")
  get:close()
  print("\27[0m\27[44m[DTD::PIL]:\27[0m\27[93m searching at ./any")
  for v in files:gmatch("%S+") do
    if v:match("%.dtdp%.lua$") then
      print("\27[0m\27[46m\27[94mLOADED:\27[0m\27[46m "..v)
      dofile(v)
      table.insert(_G.plugins, v)
      havepi = true
    end
  end
  if havepi == false then
    print("\27[0m\27[44m[DTD::PIL]:\27[0m\27[41mNO PLUGIN FOUND\27[0m")
  else
    print("\27[0m\27[44m[DTD::PIL]:\27[0m\27[92m finished!")
  end
  print()
  return havepi
end

--SYS--
_G.cmd = {}
_G.cmdf = {}
_G.cmdd = {}
_G.args = {}
----API----
_G.new = {}
-----------
function new.cmd(name, func, desc)
  for i,v in ipairs(_G.cmd) do
    if v == name then return end
  end

  if name then
    table.insert(_G.cmd, name)
    if func then
      table.insert(_G.cmdf, func)
      if desc then
        table.insert(_G.cmdd, desc)
      else
        table.insert(_G.cmdd, "no description provided!")
      end
    else
      table.insert(_G.cmdf, function() 
        print("\27[0m\27[44m[DTD::CMD]:\27[0m no function provided!\27[0m") 
      end)
    end
  end
end
local getpi = loadplugins()

if not cmd[1] then
  print("\27[0m\27[44m[DTD::SYS]:\27[0m\27[41mNO COMMAND REGISTED\27[0m")
end

if DTDUser.name == "User" then
    print("\n\27[93mUsing the Standart Account?\n\27[96mGet your own connecting to the \27[92maccounts\27[96m server!\n\27[0mType: \27[94mconnect accounts\27[0m and regist your DTDAccount\n")
else
    print("\n\27[95mHello "..DTDUser.name.."!\27[0m\n")
end
new.cmd("finish", os.exit, "finish the session")
new.cmd("version", function() print(_VERSION) print(tonumber(_VERSION)) end, "show your client Lua version")
::s::
args = {}

print("\27[92m") 
io.write("\27[2A")
os.execute("pwd")
io.write("\27[0m\27[96mcmd =>\27[0m ")
if cmd[1] then
  local placeholder = cmd[math.random(1, #cmd)]
  local plchldsize = 0
  for v in placeholder:gmatch("(.)") do
      plchldsize = plchldsize + 1
  end io.write("\27[90m"..placeholder.."\27["..plchldsize.."D\27[0m")
end
_G.input = io.read()
io.write("\27[3B")
for v in input:gmatch("%S+") do
  table.insert(args, v)
end

local executed = false

for i,v in ipairs(cmd) do
  if args[1] == v then
    if args[2] == "--help" then
      print("\27[2A\27[93m--desc: \27[0m"..cmdd[i].."\27[2B\27[0m")
    else
      cmdf[i]()
    end

    executed = true
  end
end

if executed == false then
  if input ~= "" then
    local get = os.execute(input)
  else
    for i = 1,4 do
      io.write("\27[1A\27[2K")
    end
  end
end

args = {}
goto s