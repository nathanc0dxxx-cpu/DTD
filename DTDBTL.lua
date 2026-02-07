print("\27[44m[DTD::BOOTLOADER]:\27[0m\27[93minitializing...")
local s=io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDBTS.lua")
if s then load(s:read("*a"))() s:close() else print("\37[91merror, server may be instable or bad wifi") end