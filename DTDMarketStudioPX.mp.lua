std:newcmd({
  token = "help",
  func = function()
    for i,v in ipairs(std.cmd) do
      print("\27[96m"..i.." \27[92m"..v.token.."\n  \27[93m"..v.desc.."\27[0m\n")
    end
  end,
  desc = "it helps you bro... JUST!"
})
std:newcmd({
    token = "clear",
    func = function()
        os.execute("clear")
    end,
    desc = "clear the screen"
})
std:newcmd({
    token = "deploy",
    func = function()
    end,
    desc = "deploy a file to the market"
})
std:newcmd({
    token = "view",
    func = function()
        local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Market")
        local handle = ss:read("*a")
        ss:close() local pkgs = {}
        for i,v in handle:gmatch("%s*\"name\"%s*:%s*\"(.-)@(.-)\"") do
            local obj = { name = i, owner = v }
            table.insert(pkgs, obj)
        end for i,v in ipairs(pkgs) do
            if v.owner == _G.DTDUser.name then
                print("\27[92m [ \27[96m"..v.name.."\27[92m ]\27[0m")
            end
        end
    end,
    desc = "view your deployed files"
})
std:newcmd({
    token = "ls",
    func = function()
        local pip = io.popen("ls")
        print("\27[96mcurrent files:\n\27[0m  "..pip:read("*a"))
        pip:close()
    end,
    desc = "list your local files"
})