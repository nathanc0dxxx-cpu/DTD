print("\27[44m[DTD::BOOTLOADER]:\27[0m \27[93minitializing...\27[0m")
local http = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDBTS.lua")
local content = http:read("*a") http:close()
if content then load(content)() else print("\27[44mDTD::BOOTLOADER]:\27[0m \27[91mfailed to load") end