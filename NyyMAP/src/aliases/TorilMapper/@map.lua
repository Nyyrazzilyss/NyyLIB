if matches[2] == nil then
  -- toggle map on/off

  if showMap then
    expandAlias("@map off", false)
    cecho("<red>[NyyMap display is OFF.]\n")
  else
    expandAlias("@map on", false)
    cecho("<red>[NyyMap display is ON.]\n")
  end
end

if matches[2] == "score" then
  local list = getAreaTable()
  local fullmap = getRooms()

  local totalmap=0
  local totalfound=0

  local totalcoloured=0

  local totalarea=0
  local areasfound=0

  local maprooms = {}

  for roomid, roomname in pairs(fullmap) do
    local internalid = getRoomArea(roomid)

    local zone=getRoomUserData(roomid, "zoneid")
    local zoneid=tonumber(zone)

    local env=getRoomEnv(roomid)

    if zoneid ~= nil then
      -- first appearance of room in area
      if maprooms[NyyLIB.areaTable[zoneid]] == nil then
        maprooms[NyyLIB.areaTable[zoneid]] = {0,0,0}
      end

      if internalid == -1 then
        -- undiscovered room
        maprooms[NyyLIB.areaTable[zoneid]][2] = maprooms[NyyLIB.areaTable[zoneid]][2] + 1
      else
        -- discovered room
        maprooms[NyyLIB.areaTable[zoneid]][1] = maprooms[NyyLIB.areaTable[zoneid]][1] + 1
      
        -- room is coloured
        if env ~= 271 then
          maprooms[NyyLIB.areaTable[zoneid]][3] = maprooms[NyyLIB.areaTable[zoneid]][3] + 1
        end
      end
    else
      -- echo("nil room " .. roomid .. "\n")
    end
  end

  for k,v in pairs(maprooms) do
    if v[1] ~= 0 then
     
      echo ( string.format("%45s %4d/%4d  rooms, ( %5.2f%% )  Coloured: ( %5.2f%% )\n", k, v[1], v[1]+v[2], v[1]*100/(v[1]+v[2]), v[3]*100/(v[1]) ) )
      
      totalfound=totalfound+v[1]
      areasfound=areasfound+1
      
      totalcoloured=totalcoloured+v[3]
    end
    totalmap=totalmap+v[1]+v[2]
  end

  echo( string.format("\n             found %3d/%-3d included areas      %d/%d rooms  ( %5.2f%% ) Coloured: ( %5.2f%% )\n\n", 
    areasfound, table.size(maprooms), totalfound, totalmap, totalfound*100/totalmap, totalcoloured*100/totalfound) )
end

if matches[2] == "undiscovered" then
  local list = getAreaTable()
  local fullmap = getRooms()

  local totalmap=0
  local totalfound=0

  local totalarea=0
  local areasfound=0

  local maprooms = {}

  for roomid, roomname in pairs(fullmap) do
    local internalid = getRoomArea(roomid)

    local zone=getRoomUserData(roomid, "zoneid")
    local zoneid=tonumber(zone)

    if zoneid ~= nil then
      -- first appearance of room in area
      if maprooms[NyyLIB.areaTable[zoneid]] == nil then
        maprooms[NyyLIB.areaTable[zoneid]] = {0,0}
      end

      if internalid == -1 then
        -- undiscovered room
        maprooms[NyyLIB.areaTable[zoneid]][2] = maprooms[NyyLIB.areaTable[zoneid]][2] + 1
      else
        -- discovered room
        maprooms[NyyLIB.areaTable[zoneid]][1] = maprooms[NyyLIB.areaTable[zoneid]][1] + 1
      end
    else
      -- echo("nil room " .. roomid .. "\n")
    end
  end

  for k,v in pairs(maprooms) do
    if v[1] == 0 then
      echo ( string.format("%45s %4d  rooms\n", k, v[1]+v[2] ) )

      totalfound=totalfound+v[1]
      areasfound=areasfound+1
    end
    totalmap=totalmap+v[1]+v[2]
  end

  echo( string.format("\n             unfound %3d/%-3d included areas      %d/%d rooms  ( %5.2f%% )\n\n", 
    areasfound, table.size(maprooms), totalfound, totalmap, totalfound*100/totalmap) )
end

if matches[2] == "help" then
  cecho("<red>Usage: @map              - turn on/off the mapper display\n")
  cecho("<red>       @map update       - update the map after a new NyyLIB is installed\n")
  cecho("<red>       @map score        - list size/name of found areas in the map\n")
  cecho("<red>       @map info         - list size/name of all areas in the map\n")
  cecho("<red>       @map undiscovered - lists all zones not discovered by user - Go here to explore something new!\n")
  cecho("<red>       @find             - attempt to locate the currently occupied room on the map\n")
  cecho("<red>       @find roomname    - list of previously located rooms\n")
  cecho("<red>       @fwalk roomnum    - fastwalk from the current room to roomnum\n")
end

if matches[2] == "info" then
  local list = getAreaTable()
  local fullmap = getRooms()

  local totalmap=0
  local totalfound=0

  local totalarea=0
  local areasfound=0

  local maprooms = {}

  for roomid, roomname in pairs(fullmap) do
    local internalid = getRoomArea(roomid)
    local zone=getRoomUserData(roomid, "zoneid")
    local zoneid=tonumber(zone)


    if zoneid ~= nil then
      -- first appearance of room in area
      if maprooms[NyyLIB.areaTable[zoneid]] == nil then
        maprooms[NyyLIB.areaTable[zoneid]] = {0,0}
      end

      if internalid == -1 then
        -- undiscovered room
        maprooms[NyyLIB.areaTable[zoneid]][2] = maprooms[NyyLIB.areaTable[zoneid]][2] + 1
      else
        -- discovered room
        maprooms[NyyLIB.areaTable[zoneid]][1] = maprooms[NyyLIB.areaTable[zoneid]][1] + 1
      end
    else
      -- echo("nil room " .. roomid .. "\n")
    end
  end

  for k,v in pairs(maprooms) do
    echo ( string.format("%45s %4d/%4d  rooms, ( %5.2f%% )\n", k, v[1], v[1]+v[2], v[1]*100/(v[1]+v[2])) )

    totalfound=totalfound+v[1]
    areasfound=areasfound+1

    totalmap=totalmap+v[1]+v[2]
  end

  echo( string.format("\n             found %3d/%-3d included areas      %d/%d rooms  ( %5.2f%% )\n\n", 
    areasfound, table.size(maprooms), totalfound, totalmap, totalfound*100/totalmap) )
end

if matches[2] == "update" then
  cecho("<green>[Running the map update will take 5-10 minutes.]\n")
  cecho("<green>[Mudlet will appear to be frozen while running. Don't close it.]\n")
  cecho("\n<red>[Use the '<green>@backup<red>' command to make a backup of data files before updating!]\n\n")
  cecho("<green>[Type '<red>@map updateok<green>' to start update]\n")
end

if matches[2] == "updateok" then
  local fullmap = getRooms()
  local nx

  local mapdata={}

  -- check existing toril.map file
  for roomid, roomname in pairs(fullmap) do
    local internalid = getRoomArea(roomid)

    if internalid ~= -1 and internalid ~= nil then
      mapdata[#mapdata+1]=roomid
    end
  end

  loadMap(mainpath("toril.map"))

  for nx=1,#mapdata,1 do
    if mapdata[nx] ~= 1 then
      unhideRoom(mapdata[nx])
    end
  end

  expandAlias("@map save", false)

  cecho("<red>[Done]\n")
end

if matches[2] == "reset" then
  loadMap(mainpath("toril.map"))

  expandAlias("@find", false)

  cecho("<red>[Default map loaded]\n")
end

if matches[2] == "on" then
  showMap=true

  if map:getRoom() == nil then
    tempTimer(3, [[expandAlias("@find", false)]])
  end
  map:show()
  mapAdjCon:show()
elseif matches[2] == "off" then
  showMap=false

  mapAdjCon:hide()
  map:hide()
elseif matches[2] == "save" then
  local mapname = homepath("toril.map")
  local savedok = saveMap(mapname)

  if not savedok then
      cecho("\n<red>[Failed map save: " .. mapname .. "]\n")
  else
      cecho("\n<red>[Saved map: " .. mapname .. "]\n")
  end

elseif matches[2] == "init" then
  -- mapfile is also loaded from mudlet saved data by the creation command

  cecho("<red>[Map loaded from @map init]\n")

  cecho("<red>[Creating mapper window and loading mudlet saved data]\n")

  mudlet = mudlet or {}; mudlet.mapper_script = true

  mapAdjCon = mapAdjCon or Adjustable.Container:new({name="mapAdjCon" })
  mapAdjCon:setTitle("NyyMap")
  
  if 1==2 then -- charData:get("mapAdjCon", true)
    mapAdjCon:onDoubleClick()
  else
    if mapAdjCon.x == "10px" and mapAdjCon.y == "10px" then
      mapAdjCon:move("63.6%", 0)
      mapAdjCon:resize("36.2%", "30.9%")
    end
  end
   
  NyyLIB.mapwindow = Geyser.Mapper:new({name="NyyMapper",x=0,y=10,width="100%",height="100%-10px"}, mapAdjCon)

  if setDefaultAreaVisible ~= nil then
    setDefaultAreaVisible(false)
  end
end