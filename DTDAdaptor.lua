print("\27[93minitializing adaptor...")
local changes = false

local function s(cmd, f, args)
    local test = os.execute(cmd)
    if test == false then
        f(args)
        changes = true
    else
        return false
    end
end
local try = 0

local function app(text)
    local found = false
    local var = os.getenv("HOME").."/.bashrc"
    local file = io.open(var, "r")
    if file then
        local c = file:read("*a")
        file:close()
        file = io.open(var,"a")
        if c:find(text, 1, true) then
            found = true
        end
        if found == false then
            file:write(text)
        end
        file:close()
    else
        if try > 2 then
            print("\27[91merror...\27[0m")
            return
        end
        try = try + 1
        file = io.open(var, "w")
        file:write("")
        file:close()
        app(text)
        return
    end
end

do
    s("clear", app, 'alias clear="cls"')
end

print("\27[30m[adaption test completed!]\27[0m")

if changes == true then
    print("\27[92m[the adaption process as changed some commands and services on your device... restart the app and the shell to a better experience...]")
    print("\27[93m[type: source ~/.bashrc to apply the changes]")
    print("\27[0m[Press ENTER to procced]:")
    io.read()
    os.exit()
end
return