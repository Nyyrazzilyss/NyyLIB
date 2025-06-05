-- Walk reverse of path provided.
-- ..5ne will walk w5s

local reversePath = ""

local dirString   =   matches[2]:lower()

for count, direction in string.gmatch(dirString, "([0-9]*)([neswud])") do      
  reversePath = count .. NyyLIB.reversedirs[direction] .. reversePath
end

expandAlias("." .. reversePath, false)