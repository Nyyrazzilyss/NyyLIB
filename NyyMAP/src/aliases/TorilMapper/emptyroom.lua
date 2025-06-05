local fullmap = getRooms()

for roomid, roomname in pairs(fullmap) do
  if string.findPattern(roomname:lower(), "unmapped") then
    echo("Empty room already exists: " .. roomid .. "\n")
    setRoomArea(1, map:findAreaID("The Great Unknown"))
    return
  end
end

map:addArea(6)

local newroomid = createRoomID()

addRoom(newroomid)

echo("\nCreated room number: " .. newroomid .. "\n")

setRoomArea(newroomid, map:findAreaID("The Great Unknown"))

setRoomName(newroomid, "Unmapped")


echo("Centering map.\n")
centerview(newroomid)