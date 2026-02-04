os.execute("clear")
if not DTDUser then DTDUser = { name = "Dougla037" } end
do
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDIssueService.lua")
    if ss then load(ss:read("*a"))() else print("\27[91merror while loading issue service...\27[0") return end
end
local messages = {}
local function loadinbox()
    print("\27[93mloading inbox...\27[0m")
    local issues = DTDIssueService.get()
    local found = false
    local inboxid = nil
    for i,v in ipairs(issues) do
        if v.content == "inbox" then
            inboxid = v.id
            found = true
        end
    end
    if found == false then
        print("\27[93minbox not found... generating new...\27[0m")
        DTDIssueService.new("inbox")
        print("\27[92mgenerated! please reload")
        os.execute("sleep 4")
    else
        print("\27[93mloading mails...\27[0m")
        messages = DTDIssueService.comment.read(inboxid)
    end local m = messages
    messages = {}
    for i,v in ipairs(m) do
        local a,b,c = v.body:match("^%s*(.-)%s*@%s*(.-)%s*@%s*(.*)%s*$")
        local obj = { owner = a, to = b, content = c }
        table.insert(messages, obj)
    end
end loadinbox()

local inboxsession = true

while inboxsession do
    os.execute("clear")
    print("\27[44m[Your Mails]:\27[0m\n\27[0m\n\27[44m[---]:\27[0m")
    do
        local max = 2
        for i,v in ipairs(messages) do
            if v.to == DTDUser.name or v.to == "all" then
                io.write("  \27[94m@"..v.owner.."\27[0m:\n   "..v.content.."\n--------------")
            end
            if i >= max then
                print("\n")
                max = max + 2
            end
        end
    end
    print("\27[0m\27[44m[==========]:\27[0m")
    io.write("\27[2;0H-> \27[90mexit, reset, write\27[18D\27[92m")
    local inp = io.read()
    io.write("\27[0m")
    if inp == "exit" then
        os.execute("clear")
        print("\27[91mlogout\27[0m")
        inboxsession = false
    elseif inp == "reset" then
        loadinbox()
    elseif inp == "write" then
        
    end
end