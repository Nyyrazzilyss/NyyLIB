local fullmap = getRooms()

cecho("\n<red>[Matching discovered rooms in current area]\n")

if matches[2] ~= nil and matches[2] ~= "" then
  local fullmap = getRooms()

  local zoneid
  local internalid

  if map:getRoom() ~= nil then
    zoneid=tonumber(getRoomUserData( map:getRoom(), "zoneid") )
    internalid= map:findAreaID(NyyLIB.areaTable[zoneid])
  end

  if internalid == nil then
    return
  end

  for roomid, roomname in pairs(fullmap) do
    if getRoomArea(roomid) == internalid then
      if string.findPattern(roomname:lower(), matches[2]:lower()) then

        local pathlength=0

        if roomLocked(roomid) == false then
          if map:getRoom() ~= nil then
            if getPath( map:getRoom(), roomid) then
              pathlength=#speedWalkPath
            end
          end
        end

        cecho(string.format("<green>%30s Room ID: %6d [%3d]  %s\n", getRoomAreaName(getRoomArea(roomid)), roomid, pathlength, roomname))
      end
    end
  end

  return
end