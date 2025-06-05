display(matches[2])

--map.farseeRoomname = teststring
--getExitTable ( map.farseeExits )

local x,y,z = getRoomCoordinates( map:getRoom() )

  if matches[2] == "n" then
    y=y+1
  end

  if matches[2] == "s" then
    y=y-1
  end

  if matches[2] == "w" then
    x=x-1
  end

  if matches[2] == "e" then
    x=x+1
  end

  if matches[2] == "u" then
    z=z+1
  end

  if matches[2] == "d" then
    z=z-1
  end


  local newroomid = createRoomID()
  addRoom(newroomid)

  display(newroomid)

  if matches[2] == "e" then
    setExit( map:getRoom(), newroomid, "e")
    setExit( newroomid, map:getRoom(), "w")
  end

  if matches[2] == "w" then
    setExit( map:getRoom(), newroomid, "w")
    setExit( newroomid, map:getRoom(), "e")
  end

  if matches[2] == "n" then
    setExit( map:getRoom(), newroomid, "n")
    setExit( newroomid, map:getRoom(), "s")
  end

  if matches[2] == "s" then
    setExit( map:getRoom(), newroomid, "s")
    setExit( newroomid, map:getRoom(), "n")
  end

  if matches[2] == "u" then
    setExit( map:getRoom(), newroomid, "u")
    setExit( newroomid, map:getRoom(), "d")
  end

  if matches[2] == "d" then
    setExit( map:getRoom(), newroomid, "d")
    setExit( newroomid, map:getRoom(), "u")
  end

  setRoomCoordinates(newroomid, x, y, z)

  setRoomArea(newroomid, getRoomArea(map:getRoom()) )