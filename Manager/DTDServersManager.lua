
os.execute("clear")
print("\27[0m\27[44m[DTD::SM]:\27[0m \27[93minitializing...")

exit = false

local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDServers.txt")
local ssc = ss:read("*a") ss:close()

header = "TYPE ANY KEY TO SHOW\ntype \27[93mexit\27[0m to finish session"

::s:: print("\27[44m[DTD::SERVERS]:\27[0m\n\n"..header.."\n\n\27[44m[===========================]\27[0m\n> \27[1A\27[1C")
header = ""
inp = io.read()

for i,v in ssc:gmatch("([%w_%-]+)%s*<<%s*(https?://.-)>>") do
  header = header .. "\27[44m[SS:HOST]:\27[0m \27[93m"..i.."\27[0m\n\27[44m[SS:HURL]:\27[0m \27[92m"..v.."\n\27[0m\n"
end

if inp == "exit" then
  exit = true
end

os.execute("clear")
if exit == false then
  goto s
end