-- 7/7 added * as search pattern to return entire map (or rooms in zone if zonenumber include)

-- setCustomEnvColor(environmentID, r,g,b,a)

-- default room: 600 {47,79,79}
-- setCustomEnvColor(600, 47, 79, 79, 255)

--silverymoon: zone 237
-- @stylerooms park 258 237
-- @stylerooms silverglen 258 237

-- @stylerooms * 600 237

-- ashstone
-- @stylerooms dragonride 259 85
-- @stylerooms Caravansary Way 259 85
-- @stylerooms Caravansery Way 259 85
-- @stylerooms Dragon Plaza 259 85
-- @stylerooms garden 258 85

--jungle
-- Terrain: Roads/Trails, Color entry: 259 { 128 128 0 }'        road|street|avenue|path
-- park
-- greycloak hills 258
-- somewhere in the hills 258
-- lost in a hill 258
-- evermoor way 258
-- reaching woods 258
-- sylvan glades
-- ancient trees
-- the eastway
-- forest
-- trail
-- field
-- bridge
-- wastelands               (avernus)
-- wasteland 272
-- base of the pillar 272
-- alleyway 517
-- (water)

-- matches[2] search pattern 
-- matches[3] colour table entry
-- matches[4] optional zone number


local targetzone=0

if matches[4] ~= nil then
  targetzone=tonumber(matches[4])
end

local rooms

if matches[2] == "*" then
  rooms = getRooms()
else
  rooms = searchRoom(matches[2])
end

for roomID,v in pairs(rooms) do
  local rzone=tonumber(getRoomUserData(roomID, "zoneid"))
  
  if targetzone == 0 or targetzone == rzone then
    echo(v .. "\n")
    setRoomEnv(roomID, tonumber(matches[3]))
  end
end

--display(matches[2])
--display(matches[3])
--display(targetzone)