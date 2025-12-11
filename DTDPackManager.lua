
print("\27[0m\27[44m[DTD::PM]:\27[0m \27[93minitializing...\27[0m")

_G.DTDPackManager = {
  pack = "PlaceHolder",
  store = [[
  PlaceHolder.txt>>prate=5 owner=Dougla037p<<>>c
  PLACEHOLDER TEXT
  c<<
  ]],
  install = function(self)
    print("\27[44m[DTD::PM]:\27[0m \27[93mparsing pack...\27[0m")
    local mainpack = ""
    for v in self.store:gmatch("(.-)%s*>>p%s*.-%s*p<<") do
      if v:match(self.pack) then
        v = v:gsub(">>p%s*(.-)%s*p<<","")
        v = v:gsub(">>c%s*(.-)%s*c<<","")
        v = v:gsub(">>d%s*(.-)%s*d<<","")
        v = v:gsub("\n","")
        mainpack = v
        print("\27[44m[DTD::PM]:\27[0m \27[92mfound:\n\27[0m"..v)
      end
    end
    
    print("MAINPACK RAW = [" .. mainpack .. "]")
    local packcont = ""
    for v in self.store:gmatch("(.-%s*>>p%s*.-%s*p<<>>c%s*.-%s*c<<)") do
      local packmatch = v:match("(.-)%s*>>p%s*.-%s*p<<")
      if packmatch:match(self.pack) then
        local get = v:match(".-%s*>>p%s*.-%s*p<<>>c%s*(.-)%s*c<<")
        print("\27[44m[DTD::PM]:\27[0m \27[92mcontent:\n\27[0m"..get)
        packcont = get
      end
    end
    print("\27[44m[DTD::PM]:\27[0m \27[93minstalling...\27[0m")
    if mainpack then
      if packcont then
        local package = io.open(mainpack, "r+") or nil
        if package then
          package:write(packcont)
          print("\27[44m[DTD::PM]:\27[0m \27[93mupdated pack: \n"..mainpack.."\n\27[92m at: ")
          os.execute("pwd")
          package:close()
        else
          local package = io.open(mainpack, "w")
          if package then
            package:write(packcont)
            print("\27[44m[DTD::PM]:\27[0m \27[92minstalled pack: \n"..mainpack.."\n\27[92m at: ")
            os.execute("pwd")
            package:close()
          else
            print("\27[44m[DTD::PM]:\27[0m \27[91mfailed to install pack "..DTDPackManager.pack.." retrying...\27[0m")
            local package = io.open(mainpack, "w")
            os.execute("sleep 0.3")
            if package then
              package:write(packcont)
              print("\27[44m[DTD::PM]:\27[0m \27[92mdone!")
              os.execute("pwd")
              package:close()
            else
              print("\27[44m[DTD::PM]:\27[0m \27[91mFATAL FAIL\27[0m")
            end
          end
        end
      end
    else
      print("\27[44m[DTD::PM]:\27[0m \27[91mnot found!")
    end
    os.execute("sleep 2")
    print("\27[0m\27[44m[DTD::PM]:\27[0m \27[93mfinishing session...\27[0m")
    if self then
      for i in ipairs(self) do
        self[i] = nil
      end
      _G.DTDPackManager = nil
    end
    print("\27[44m[DTD::PM]:\27[0m \27[96mfinished")
  end,
}