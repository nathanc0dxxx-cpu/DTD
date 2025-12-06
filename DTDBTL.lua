
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

function loadpacks()
  local test = io.open("DTDPX.dtdp.lua", "r") or nil
  if test then
    test:close()
    print("\27[91mresource already installed\27[0m")
    return
  else
    print("\27[44m[DTD::BOOTSTRAP]:\27[0m getting pack...")
    local exp = io.open("DTDPX.dtdp.lua", "w")
    local server = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDPX.lua")
    local content = server:read("*a")
    server:close()
    if content then
      exp:write(content)
      exp:close()
    else
      exp:close()
      os.remove("DTDPX.dtdp.lua")
      print("\27[44m[DTD::BOOTSTRAP]:\27[91m failed to get content\27[0m")
      return
    end
    print("\27[44m[DTD::BOOTSTRAP]:\27[0m\27[92m plugin installed!\27[0m")
  end
end

::s::
print("\27[44m[DTD::BOOTSTRAP]:\27[0mtype a option\nof bootstrap\n\n\27[93m[1]: start\n[2]: loadpack\n[3]: removepack\n\27[0m")
local cmd = io.read()
if cmd == "start" then
  os.execute("clear")
  start()
elseif cmd == "loadpack" then
  os.execute("clear")
  loadpacks()
elseif cmd == "removepack" then
  os.execute("clear")
  os.remove("DTDPX.dtdp.lua")
else
  os.execute("clear")
end

goto s
