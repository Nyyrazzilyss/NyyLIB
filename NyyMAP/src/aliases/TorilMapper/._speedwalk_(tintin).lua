-- paging mode needs to be fixed
--if pagingmode then
--  mud:send("")
--  return
--end

local dirString   =   matches[2]:lower()

for count, direction in string.gmatch(dirString, "([0-9]*)([neswud])") do      
  count = (count == "" and 1 or count)
   for i=1, count do
       expandAlias(direction)
   end
end