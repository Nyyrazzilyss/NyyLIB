--doesn't work // incomplete

if matches[2] == nil then
  cecho("<green>Renumber all rooms in an area\n")
  cecho("<red>Usage: @renumber zonenumber newstartingroomid\n")
  return
end

local area=tonumber(matches[2])
local range=tonumber(matches[3])

cecho("<green>Renumbering area: (" .. area .. ") " .. getAreaTableSwap()[area] .. "\n")
cecho("<green>New starting room " .. range .. "\n")

local roomList= getAreaRooms(area)

local roomTable= {}

for k,v in pairs(roomList) do
  local roomExistingNumber = v
  local roomName = getRoomName(v)
  local roomArea = getRoomArea(v)
  
  local roomChar = getRoomChar(v)
  local roomCharR, roomCharG, roomCharB = getRoomCharColor(v)
  
  local roomX, roomY, roomZ =getRoomCoordinates(v)
  local roomEnv= getRoomEnv(v)
  local roomExits= getRoomExits(v)
  local roomSpecialExits= getSpecialExits(v)
  local roomUserData= getAllRoomUserData(v)
  
  local roomWeight = getRoomWeight(v)
  local roomExitWeights= getExitWeights(v)
 
  local roomDoors= getDoors(v)
  local _roomLocked= roomLocked(v)
  
  
  roomTable[table.size(roomTable)+1] = { roomExistingNumber, roomName, roomArea, roomChar, roomCharR, roomCharG, roomCharB,
    roomX, roomY, roomZ, roomEnv, roomExits, roomSpecialExits, roomUserData, roomWeight, roomExitWeight, roomDoors, _roomLocked }
  
  echo (k .. " " .. v .. " " .. getRoomName(v) .. "\n")

  --local newroomid = createRoomID(range)
  --addRoom(newroomid)
  
  --setRoomCoordinates(newroomid, roomX, roomY, roomZ)

  --setRoomName(newroomid, roomName)
  --setRoomArea(newroomid, area)
  --setRoomChar(newroomid, roomChar)
end

--display(roomTable)

for k,v in pairs(roomTable) do
  display(v)
end