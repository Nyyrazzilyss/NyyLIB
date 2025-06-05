local roomID=tonumber(matches[2])
local exits= getExitTable ( map.farseeExits )

--map.farseeRoomname = teststring
--getExitTable ( map.farseeExits )


setRoomName(roomID, map.farseeRoomname)

setRoomUserData(roomID, "zoneid", 356 )

map:setDoNotEnter(roomID)

--map:getExits()
--setExitStub(roomID, direction, set/unset)

--lua getRoomExits(69)
--{
--  west = 85591
--}

if exits[1] == 1 then
  if getRoomExits(roomID)["north"] == nil then
    setExitStub(roomID, "n", true)
  end
end

if exits[2] == 1 then
  if getRoomExits(roomID)["south"] == nil then
    setExitStub(roomID, "s", true)
  end
end

if exits[3] == 1 then
  if getRoomExits(roomID)["east"] == nil then
    setExitStub(roomID, "e", true)
  end
end

if exits[4] == 1 then
  if getRoomExits(roomID)["west"] == nil then
    setExitStub(roomID, "w", true)
  end
end

if exits[5] == 1 then
  if getRoomExits(roomID)["up"] == nil then
    setExitStub(roomID, "u", true)
  end
end

if exits[6] == 1 then
  if getRoomExits(roomID)["down"] == nil then
    setExitStub(roomID, "d", true)
  end
end
