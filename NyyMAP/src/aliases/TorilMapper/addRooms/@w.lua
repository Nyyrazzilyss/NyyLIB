local x,y,z = getRoomCoordinates( map:getRoom() )

x=x-1

local newroomid = createRoomID(startroom or 10000)
echo("Adding room: " .. newroomid .. "\n")
addRoom(newroomid)

setExit( map:getRoom(), newroomid, "w")
setExit( newroomid, map:getRoom(), "e")

setRoomCoordinates(newroomid, x, y, z)

setRoomArea(newroomid, getRoomArea(map:getRoom()))