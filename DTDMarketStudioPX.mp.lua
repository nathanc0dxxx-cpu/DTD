std:newcmd({
  token = "help",
  func = function()
    for i,v in ipairs(std.cmd) do
      print("\27[96m"..i.." \27[92m"..v.token.."\n  \27[93m"..v.desc.."\27[0m\n")
    end
  end,
  desc = "it helps you bro... JUST!"
})