forceFind=nil

-- empty movement queue

map:clearQueue()

-- pattern provided, locate rooms in map
if matches[2] ~= nil and matches[2] ~= "" then
  local fullmap = getRooms()

  cecho("\n<red>[Matching Rooms in the Known World]\n\n")

  if tonumber(matches[2]) then
    local roomid=tonumber(matches[2])
    local roomname=getRoomName(roomid)

    if getRoomArea(roomid) ~= -1 then
      local pathlength=0

      if roomLocked(roomid) == false then
        if map:getRoom() ~= nil then
          if getPath( map:getRoom(), roomid) then
            pathlength=#speedWalkPath
          end
        end
      end

      cecho(string.format("<green>%31s Room ID: %6d [%3d]  %s\n", getRoomAreaName(getRoomArea(roomid)), roomid, pathlength, roomname))
    end

    return
  end

  -- match room name
  local roomCount=0
  
  if matches[2] == [[""]] then
    matches[2] = ""
  end
  
  
  for roomid, roomname in pairs(fullmap) do
    if matches[2] == "*" then
      if getRoomArea(roomid) ~= -1 and roomid ~= 1 then
        echo(string.format("%31s Room ID: %6d  %s\n", getRoomAreaName(getRoomArea(roomid)), roomid, roomname))
      end
    elseif matches[2] == "" then
      if roomname == "" then
        if getRoomArea(roomid) ~= -1 then
          local pathlength=0

          roomCount=roomCount+1
          
          if roomLocked(roomid) == false then
            if map:getRoom() ~= nil then
              if getPath( map:getRoom(), roomid) then
                pathlength=#speedWalkPath
              end
            end
          end

          cecho(string.format("<green>%31s Room ID: %6d [%3d]  %s\n", getRoomAreaName(getRoomArea(roomid)), roomid, pathlength, roomname))
        end    
      end
    else
      -- need to plain match
      -- string.find(s, pattern [, index [, plain]])
      --   if string.find(previousline, newline, 1, true) ~= nil then
      
      --if string.findPattern(roomname:lower(), matches[2]:lower()) then
      if string.find(roomname:lower(), matches[2]:lower(), 1, true) ~= nil then
        if getRoomArea(roomid) ~= -1 then
          local pathlength=0

          roomCount=roomCount+1
          
          if roomLocked(roomid) == false then
            if map:getRoom() ~= nil then
              if getPath( map:getRoom(), roomid) then
                pathlength=#speedWalkPath
              end
            end
          end

          cecho(string.format("<green>%31s Room ID: %6d [%3d]  %s\n", getRoomAreaName(getRoomArea(roomid)), roomid, pathlength, roomname))
        end
      end
    end
  end

  cecho(string.format("\n<red>Matching rooms: %5d\n", roomCount) )

  return
end

-------

-- no pattern provided, locate current room
local current=map:getRoom()

cecho("\n<red>[Searching... ")

-- use scanned info if present

if table.size(scanned) > 0 then
  local scanroom = solveScan()
  
  if scanroom ~= nil then
    map:setRoom( scanroom )
  end
else
  if map:getRoomname() ~= nil and map:getExits() ~= nil then
    map:setRoom( map:findRoomID( map:getRoomname(), map:getExits() ) )
  end
end

if map:getRoom() ~= nil then
  unhideRoom( map:getRoom() )
  map:update(nil)
else
  NyyLIB.lastRoomID = nil
  centerview(1) -- blank room number
end
