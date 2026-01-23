std:newcmd({
  token = "help",
  func = function()
    for i,v in ipairs(std.cmd) do
      print(i.." "..v.token.."\n  "..v.desc)
    end
  end,
  desc = "it helps you bro... JUST!"
})