local x,y,z = getRoomCoordinates( map:getRoom() )

y=y-1

local newroomid = createRoomID(startroom or 10000)
echo("Adding room: " .. newroomid .. "\n")
addRoom(newroomid)

setExit( map:getRoom(), newroomid, "s")
setExit( newroomid, map:getRoom(), "n")

setRoomCoordinates(newroomid, x, y, z)

setRoomArea(newroomid, getRoomArea(map:getRoom()))