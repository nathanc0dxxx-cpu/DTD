
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

loadpack()

function s()
  local get = esc(packs)
  local f = get
  
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
      print("\27[96m  \n  \27[92m [\27[0m"..i.."\27[92m]\27[94m \27[1m"..v.." \27[0m")
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
  
  print()
  
  print("\27[93m[ type: search, exit or name ]")
  io.write(" \27[92m=> \27[0m")
  
  inp = io.read()
  if inp == "search" then
    os.execute("clear")
    search()
  elseif inp == "exit" then
    exit = true
    os.execute("clear")
  else
    os.execute("clear")
    interface()
  end
  
end

function interface()
  s()
end

function search()
end

if exit == true then
  print("\n \n \n")
else
  s()
end

