os.execute("clear")
local exit = false
for i = 1,5 do
  print()
end

function loadpack()
  local http = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDMarketPacks.txt")
  packs = http:read("*a")
  http:close()
end

function esc(txt)
  txt = txt:gsub("%.","<point>")
  return txt
end function escc(txt)
  txt = txt:gsub("<point>", ".")
  return txt
end

local show = true
loadpack()
if packs == "" then
  packs = [[
  PlaceHolder.txt>>prate=5 owner=Dougla037p<<>>c
  Server Bad connection or no internet connection
  or server instable!
  c<<>>d try again later... d<<
  ]]
end

function s()
  local get = esc(packs)
  local f = get
  if show == true then
  f = f:gsub(">>c%s*(.-)%s*c<<","")
  f = f:gsub(">>p%s*(.-)%s*p<<","")
  f = f:gsub(">>d%s*(.-)%s*d<<","")
  
  f = escc(f)
  io.write("\27[93m\27[1m")
  string.format([[
  .----.____   
  ||<Market>|  %s
  ||        |  %s
  ||        |
  ||________|  %s
  ]], "\27[0mHere you install\27[93m\27[1m", "\27[0mANYTHING from\27[93m\27[1m", "\27[0mALL Devs!\27[93m\27[1m")print("\27[0m")
  
  print("\27[44m.Main Packs! :\27[0m")
  
  local i = 0
  for v in f:gmatch("%S+") do
    i = i + 1
    if i <= 3 then
      print("  \n  \27[92m[\27[93m"..i.."\27[92m] \27[1m\27[94m"..v.." \27[0m")
    end
  end
  
  print("\n\27[44m.DTD : \27[0m")
  i = 0
  for v in f:gmatch("%S+") do
    if i <= 3 then
    if v:match("^DTD") then
      i = i + 1
      print("\27[0m  \n \27[92m [\27[93m"..i.."\27[92m]\27[94m \27[1m"..v.." \27[0m")
    end
    end
  end
  print("\27[0m".. [[
  
  ]])
  
  print("\27[44m.Plug-Ins! : \27[0m")
  
  i = 0
  for v in f:gmatch("%S+") do
    if i <= 3 then
    if v:match(".dtdp.lua$") then
      i = i + 1
      print("\27[0m  \n  \27[92m[\27[93m"..i.."\27[92m] \27[94m\27[1m"..v.."\27[0m")
    end
    end
  end
  
  print("\n\27[44m|--------------------------|\27[0m\n")
  
  print("\n\n\27[93m[ type: search, exit or name ]\27[3A")
    show = false
  end
  
  io.write(" \27[92m=> \27[0m")
  
  inp = io.read()
  if inp:sub(1,6) == "search" then
    search()
  elseif inp:sub(1,4) == "exit" then
    exit = true
    for i = 1,1000 do io.write("\27[1B\27[")
    goto exit
 end
  else
    io.write("\27[2K\27[1A\27[2K")
    interface()
  end
end

function interface()
  os.execute("clear")
  local packname = "404 not found!"
  local getpack = esc(packs)
  getpack = getpack:gsub(">>p%s*(.-)%s*p<<","")
  getpack = getpack:gsub(">>c%s*(.-)%s*c<<","")
  getpack = getpack:gsub(">>d%s*(.-)%s*d<<","")
  for v in getpack:gmatch("%S+") do
    if v:match(inp) then
      packname = escc(v)
      break
    end
  end
  local packrate = 0
  for v in esc(packs):gmatch("(.-%s*>>p%s*rate=%d+%s*p<<)") do
    if packname then
      if v:match(esc(packname)) then
        v = v:gsub(">>c%s*(.-)%s*c<<","")
        v = v:gsub(">>d%s*(.-)%s*d<<","")
        packrate = tonumber(v:match(">>p%s*rate=(%d+)%s*p<<"))
      end
    end
  end
  local packowner = "404 not found!"
  for v in esc(packs):gmatch("(.-%s*>>p%s*.-%s*owner=.-%s*p<<)") do
    if v:match(esc(packname)) then
      v = v:gsub(">>c%s*(.-)%s*c<<","")
      v = v:gsub(">>d%s*(.-)%s*d<<","")
      packowner = v:match(">>p%s*.-%s*owner=(.-)%s*p<<")
    end
  end
  local packdesc = "404 not found!"
  for v in esc(packs):gmatch("(.-%s*>>p%s*.-%s*p<<>>c%s*.-%s*c<<>>d%s*.-%s*d<<)") do
    if v:match(esc(packname)) then
      v = v:gsub("(>>p%s*.-%s*p<<)","")
      v = v:gsub("(>>c%s*.-%s*c<<)","")
      packdesc = escc(v:match(">>d%s*(.-)%s*d<<"))
    end
  end
  
  if packname then
    print(string.format([[
    [X] <Q + Enter>
    .--.____
    |       | > %s
    |   ?   | by: %s
    |_______| rate: %s
    %s
    <desc>: ----------
    %s
    ------------------
    %s
    
    ]], packname, packowner, packrate, "\27[93m{RATE}\27[0m <R + Enter>\27[92m", "\27[0m"..packdesc.."\27[92m", "\27[96m{INSTALL} \27[93m<Enter>\27[0m"))
    
    ::back::
    io.write("\n\27[94m=> \27[0m")
    local key = io.read()
    if key == "q" or key == "Q" then
      os.execute("clear")
      show = true
      s()
    elseif key == "r" or key == "R" then
      print("in devlopment!")
      os.execute([[
      sleep 1
      clear
      ]])
      show = true
      s()
    elseif key == "" then 
      os.execute("clear")
      print("\27[44m[DTD::M]:\27[0m \27[93mconnecting to\ndtd packmanager...")
      local http = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDPackManager.lua")
      local httpcontent = http:read("*a") http:close()
      if httpcontent then
        pcall(function() load(httpcontent)() end)
        if DTDPackManager then
          DTDPackManager.pack = packname
          DTDPackManager.store = packs
          DTDPackManager:install()
        end
      end
      
      os.execute("clear")
      show = true
      s()
    end
    goto back
  end
  show = true
  s()
end
function search()
  local query = inp:sub(8)
  local f = esc(packs)
  
  f = f:gsub(">>c%s*(.-)%s*c<<","")
  f = f:gsub(">>p%s*(.-)%s*p<<","")
  f = f:gsub(">>d%s*(.-)%s*d<<","")
  
  if f:match(query) then
    os.execute("clear")
    print("\27[44m.Results! : \27[0m\n")
    
  else
    io.write("\27[2K\27[1A\27[C")
    s()
  end
  
  for v in f:gmatch("%S+") do
    if v:match(query) then
      print("\27[42m : \27[46m"..escc(v).."\27[0m\n")
    end
  end
  print("\n\n\27[93m[ type: back, or name ]\27[0m\27[3A \27[92m\27[0m")
  inp = io.read()
  if inp == "back" then
    os.execute("clear")
    show = true
    s()
  else
    interface()
  end
end

if exit == true then
  print("\n \n \n")
  goto exit
else
  s()
end
::exit::
print()