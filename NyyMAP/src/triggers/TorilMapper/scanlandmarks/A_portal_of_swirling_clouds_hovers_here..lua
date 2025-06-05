-- set room on ethereal

--if map:getRoom() ~= nil then
--  return
--end

map:setRoom(88233)
centerview( map:getRoom() )

if command == "SCAN" then
  -- You scan north...
  local lineindex=1

  while string.match(getLines(getLineNumber()-lineindex, getLineNumber())[1], "^You scan ([a-z]+).*") == nil do
    lineindex=lineindex+1

    if lineindex > 150 then
      if _G["echoDebug"] then
        echoDebug("<red>[Unable to locate scan message]\n")
      end
      return
    end
  end

  local scandir = string.match(getLines(getLineNumber()-lineindex, getLineNumber())[1], "^You scan ([a-z]+).*") 

  local setroom = getRoomExits(88233)[NyyLIB.reversedirs[scandir]]

  --display(setroom)

  map:setRoom(setroom)
  centerview( map:getRoom() )

  --display("Found on scan in dir " .. scandir)
end

if string.match(command, "^[nsewud]$") then
  map:setRoom(88233)
  centerview( map:getRoom() )
end