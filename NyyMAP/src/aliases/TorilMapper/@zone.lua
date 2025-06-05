--This alias will list all zones matching a pattern

for id, name in pairs(NyyLIB.areaTable) do
  if string.findPattern(name:lower(), matches[2]:lower()) then
    cecho("<red>(" .. id .. ") " .. name .. "\n")
  end
end