os.execute("clear")
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

show = true
loadpack()

function s()
  local get = esc(packs)
  local f = get
  if show == true then
  f = f:gsub(">>c%s*(.-)%s*c<<","")
  f = f:gsub(">>prate=.","")
  f = f:gsub("p<<","")
  
  f = escc(f)
  io.write("\27[93m\27[1m")
  print(string.format([[
  .----.______
  ||<Packs>    |  %s
  ||  <Market> |  %s
  ||    _______|_ %s
  ||  //        /
  || //        /
  ||//________/
  ]], "\27[0mHere you install\27[93m\27[1m", "\27[0mANYTHING from\27[93m\27[1m", "\27[0mALL Devs!\27[93m\27[1m"))print("\27[0m")
  
  print("\27[44m.Main Packs! :\27[0m")
  
  local i = 0
  for v in f:gmatch("%S+") do
    i = i + 1
    print("  \n  \27[92m[\27[93m"..i.."\27[92m] \27[1m\27[94m"..v.." \27[0m")
  end
  
  print("\n\27[44m.DTD : \27[0m")
  local i = 0
  for v in f:gmatch("%S+") do
    i = i + 1
    if v:match("dtd") then
      print("\27[0m  \n \27[92m [\27[93m"..i.."\27[92m]\27[94m \27[1m"..v.." \27[0m")
    end
  end
  print("\27[0m".. [[
  
  ]])
  
  print("\27[44m.Plug-Ins! : \27[0m")
  
  local i = 0
  for v in f:gmatch("%S+") do
    i = i + 1
    if v:match(".dtdp.lua$") then
      print("\27[0m  \n  \27[92m[\27[93m"..i.."\27[92m] \27[94m\27[1m"..v.."\27[0m")
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
  elseif inp == "exit" then
    exit = true
    for i = 1,1000 do io.write("\27[1B\27[") end
  else
    io.write("\27[2K\27[1A\27[2K")
    interface()
  end
  
end

function interface()
  s()
end

function search()
  local query = inp:sub(7)
  local f = esc(packs)
  
  f = f:gsub(">>c%s*(.-)%s*c<<","")
  f = f:gsub(">>prate=.","")
  f = f:gsub("p<<","")
  
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
  local useri = io.read()
  if useri == "back" then
    os.execute("clear")
    print("\n\n\n\n")
    show = true
    s()
  else
    interface()
  end
end

if exit == true then
  print("\n \n \n")
else
  s()
end

