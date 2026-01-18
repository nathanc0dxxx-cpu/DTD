print("\27[44m[DTD::AM]:\27[0m \27[93minitializing...\27[0m")

_G.DTDAccountsManager = {
  getaccounts = function(op)
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDAccounts.txt")
    local sc = ss:read("*a") ss:close()
    
    for v in sc:gmatch("%S+") do
      if v:sub(1,4) == "pass" and op == "iaop!!!" then
        sc = sc:gsub(v,"")
      end
    end
    
    return sc
  end,
  
  getusersname = function(self)
    local users = self:getaccounts()
    local usc = ""
    for v in users:gmatch("%S+") do
      if v:sub(1, 4) == "name" then
        usc = usc .. v:sub(6) .. " "
      end
    end
    return usc
  end,
  
  getpass = function(self, name, op)
    if op == "imaop!dud:p" then
      local users = self:getaccounts("iaop!!!")
      local tab = {}
      local pass = ""
      for v in users:gmatch("%S+") do
        table.insert(tab, v)
      end
      for i,v in ipairs(tab) do
        if v:sub(1,4) == "name" then
          if v:sub(6) == name then
            pass = tab[i+1]:sub(6)
            return pass
          end
        end
      end
    else
      return "invalcode!!!"
    end
  end,
  
  finish = function(self)
    for v in pairs(self) do
      v = nil
    end self = nil
  end,
}

print(DTDAccountsManager:getpass("Dougla037", "imaop!dud:p"))
