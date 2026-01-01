print("\27[44m[DTD::SI]:\27[0m \27[93minitializing...\27[0m")
local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDSettings.html")
if ss then
local sc = ss:read("*a")
ss:close()

print("\27[44m[DTD::SI]:\27[0m \27[93mgenerating file...\27[0m")
local file = io.open("DTDSettings.html","w")
file:write(sc) file:close()
print("\27[44m[DTD::SI]:\27[0m \27[92mfinished!\27[0m")
print("\27[92mfile at:")
os.execute("pwd")
else
ss:close()
print("\27[91mfail")
end
os.execute("sleep 2")
os.execute("clear")