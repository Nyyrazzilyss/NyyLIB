local x,y,z = getRoomCoordinates( map:getRoom() )

z=z+1

local newroomid = createRoomID(startroom or 10000)
echo("Adding room: " .. newroomid .. "\n")
addRoom(newroomid)

setExit( map:getRoom(), newroomid, "u")
setExit( newroomid, map:getRoom(), "d")

setRoomCoordinates(newroomid, x, y, z)

setRoomArea(newroomid, getRoomArea(map:getRoom()))