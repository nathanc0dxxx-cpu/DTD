print("\27[44m[DTD::BOOTLOADER]:\27[0m \27[93minitializing...\27[92m")
local h=io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDBTS.lua")
local c=h:read("*a")h:close()
if c~="" then load(c)()else print("\27[0m\27[44m[DTD::BOOTLOADER]:\27[0m \27[91mfailed to load\nserver could be instable or no \ninternet connection")end