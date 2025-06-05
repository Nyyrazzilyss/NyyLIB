-- add special exit: lua addSpecialExit(src, dst, "enter portal|liquid|iron")



local roomID=map:getRoom()
local x,y,z = getRoomCoordinates(roomID)
local mudletArea= getRoomArea(roomID)

display("Updating room: " .. roomID)


setRoomName(roomID, map:getRoomname() )

-- currentArea= mudletArea
setRoomUserData(roomID, "zoneid", 358 )

--358 dis

echo("Settings zoneid to 358 [dis]\n")

--map:getExits()
--setExitStub(roomID, direction, set/unset)

--lua getRoomExits(69)
--{
--  west = 85591
--}



-- should link stubs



if map:getExits()[1] == 1 then
  
  if getRoomsByPosition(mudletArea, x,y+1,z)[0] then
    connectExitStub(roomID, "n")
  else
    if getRoomExits(roomID)["north"] == nil then
      setExitStub(roomID, "n", true)
    end
  end
end

if map:getExits()[2] == 1 then
  if getRoomsByPosition(mudletArea, x,y-1,z)[0] then
    connectExitStub(roomID, "s")
  else
    if getRoomExits(roomID)["south"] == nil then
      setExitStub(roomID, "s", true)
    end
  end
end

if map:getExits()[3] == 1 then
  if getRoomsByPosition(mudletArea, x+1,y,z)[0] then
    connectExitStub(roomID, "e")
  else
    if getRoomExits(roomID)["east"] == nil then
      setExitStub(roomID, "e", true)
    end
  end
end

if map:getExits()[4] == 1 then
  if getRoomsByPosition(mudletArea, x-1,y,z)[0] then
    connectExitStub(roomID, "w")
  else
    if getRoomExits(roomID)["west"] == nil then
      setExitStub(roomID, "w", true)
    end
  end
end

if map:getExits()[5] == 1 then
  if getRoomExits(roomID)["up"] == nil then
    setExitStub(roomID, "u", true)
  end
end
