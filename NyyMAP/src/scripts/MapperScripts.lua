-------------------------------------------------
--         Put your Lua functions here.        --
--                                             --
-- Note that you can also use external Scripts --
-------------------------------------------------
  
  NyyLIB = NyyLIB or {}
  
  map = map or {}

  map.movement = map.movement or {}
  map.movementIndex = 0

  scanned = scanned or {}

  exitMap = { n = 1, north = 1, e = 4, east = 4, w = 5, west = 5, s = 6, south = 6,
      u = 9, up = 9, d = 10, down = 10, ["in"] = 11, out = 12, [1] = "north", [4] = "east", [5] = "west",
      [6] = "south",  [9] = "up",  [10] = "down",  [11] = "in",  [12] = "out"}

  doorMap = { n = 1, north = 1, e = 4, east = 4, w = 5, west = 5, s = 6, south = 6,
      u = 9, up = 9, d = 10, down = 10, ["in"] = 11, out = 12, [1] = "n", [4] = "e", [5] = "w",
      [6] = "s",  [9] = "up",  [10] = "down",  [11] = "in",  [12] = "out"}

function printSorted(xlist)
  local sortedlist=xlist

  table.sort(sortedlist)

  for nx=1, #sortedlist, 1 do
    cecho("<green>" .. sortedlist[nx])
  end
end

function homepath(xname)
  if xname == nil then
    cecho("\n<red>[Homepath Error: xname is nil]\n")
    return
  end

  local path = getMudletHomeDir() .. "\\" .. xname

  path=string.gsub(path, "\\", "/")  

  return(path)
end

function mainpath(xname)
  local pathname= string.gsub(NyyLIB.homedir .. xname, "\\", "/")

  local is_file = io.open(pathname)

  if is_file == nil then
    cecho("<red>[Error: file " .. pathname .. " not found]\n")
  else
    io.close(is_file)
  end

  return(pathname)
end

function map:addArea(xarea)
  if xarea == nil then
    local count=0
    local line=""

    for areaid, areaname in pairs(NyyLIB.areaTable) do
      line = line .. string.format("%3d %-33s ", areaid, areaname)
      count=count+1

      if count == 3 then
        echo(line .. "\n")
        line="" 
        count=0
      end
    end

    if line ~= "" then
      echo(line .. "\n")
    end

    echo("\n")
  end

  if xarea ~= nil then
    local areaid = tonumber(xarea)
    local internalid = map:findAreaID( NyyLIB.areaTable[areaid] )

    if internalid ~= nil then
      echo("Map for " .. NyyLIB.areaTable[areaid] .. " already exists.\n")
    else
      cecho("\n<green>[Added area: (" .. areaid .. ") " .. NyyLIB.areaTable[areaid] .. "]\n")

      addAreaName(NyyLIB.areaTable[areaid])
    end
  end
end

-- pop and return last movement (if there was one)

function map:popMovement()
  if map:countMovement() > 0 then
    --display(self.movement)

    local retval=self.movement[1]
    
    map:removeMovement()

    if _G["echoDebug"] then
      echoDebug("<blue>\n[map:popMovement " .. retval .. "] ")
    end        
    return(retval)
  end
  
  return(false)
end

-- peek and return next movement (if there is one)

function map:peekFutureMovement()
  if map:countMovement() > 0 then
    local movement = self.movement[self.movementIndex+1]
        
    return(movement)
  end
  
  return(nil)
end

-- self.movement: List of all upcoming movements
-- self.movementIndex: Everything prior to this value has been sent/not receieved


function map:countMovement()
  return(#self.movement)
end

-- add a desired movement to the end of the queue

function map:addMovement(xdir)
  if _G["echoDebug"] then
    echoDebug("<blue>[map:addMovement queueing: " .. xdir .. "]")
  end
  self.movement[#self.movement+1] = xdir
end

-- insert movement into queue at 1 before end

function map:insertMovement(xmove)
  local index=map:countMovement()
  
  if index == 0 then
    index=1
  end
  
  if _G["echoDebug"] then
    echoDebug("<green>[map:insertMovement at " .. index .. " " .. xmove .. "]\n")
  end
  table.insert(self.movement, index, xmove)
end

-- return the next movement to send (and increment the index)
-- self.movementIndex : index of last movement sent

function map:nextMovement()
  --if self.movementIndex == 1 then
  --  echo("setting to 0")
  --  self.movementIndex=0
  --end
  
  
  if self.movement[self.movementIndex+1] == nil then
    echoDebug("<green>[map:nextMovement() all queued movements already sent]\n")
    --display(self.movementIndex)
    --display(self.movement)
    return(nil)
  end

  return( self.movement[self.movementIndex+1] )
end

-- send next queued movement

function map:sendNextMovement()
  -- Don't send any movements if more then "movebuffer" have been sent/not yet recieved.
  
  if self.movementIndex > moveBuffer then
      return(nil)
  end

  local movement = map:nextMovement()
  
  if movement ~= nil then
    if _G["echoDebug"] then
      echoDebug("<blue>[map:sendNextMovement() self.movementIndex+1 " .. self.movementIndex+1 .. "]\n")
    end
    self.movementIndex=self.movementIndex+1


    -- mud:send deletes duplicates
    send(movement, false)

    -- if movement was 'unlock', send following movement also (open)
    if string.find(movement, "unlock ") == 1 then
      send( map:nextMovement(), false)
      self.movementIndex=self.movementIndex+1
    end
  end
end

-- remove first movement from queue (exits: line has arrived)

function map:removeMovement()
  table.remove(self.movement, 1)
  
  self.movementIndex = self.movementIndex - 1
  
  if self.movementIndex < 0 then
    self.movementIndex = 0
  end
end

-- remove all unsent movements from queue

function map:trimMovement()
  while map:countMovement() > self.movementIndex do
    table.remove(self.movement, self.movementIndex+1)
  end
end

-- erase entire movement queue

function map:clearQueue()
  --display(self.movement)
  --display(self.movementIndex)
  --display(map:getFutureRoom())
  
  
  
  self.movement = {}

  self.movementIndex = 0

  map:setFutureRoom(nil)
end

-- before sending/queuing, need to check for doors in need of being opened

-- start from current room, and iterate queue with expectation of success

function map:processMovement(xdir)

  if _G["echoDebug"] then
    echoDebug("<blue>[map:processMovement : " .. tostring(xdir) .. "]")
  end
  -- illithid - break hide

  if _G["checkMask"] then
    if checkMask("psi") then
      setHide(false)
    end
  end

  -- buffer movements if needed
  map:addMovement(xdir)

  -- send movement  mud:send eats duplicate commands
  
   -- map:queueMovement returns true a special exit was inserted
  if map:queueMovement(xdir) then
    map:sendNextMovement()
  end
  
  map:sendNextMovement()
end

function sendBufferedMovements()
  if map.movementIndex > 5 then
    return
  end
    
  local sendCount = map:countMovement() - map.movementIndex
  local nx
  
  if sendCount > 5 then
    sendCount=5
  end
  
  for nx=1,sendCount,1 do
    local movement= map:nextMovement()
    
    if movement ~= nil then
      -- -- if map:queueMovement returns true a special exit was inserted
      -- if map:queueMovement(movement) then
      --   --display("X")
      --   map:sendNextMovement()
      -- end
      
      map:sendNextMovement()
    end
  end
end

function map:queueMovement(xmove)
  if map:getFutureRoom() == nil or map:countMovement() == 0 then
    map:setFutureRoom( map:getRoom() )
  end

  if map:getFutureRoom() ~= nil then
    exits = getRoomExits( map:getFutureRoom() )

    if exits == nil then
      cecho("<red>[nil exits from " .. map:getFutureRoom() .. "]")
    end

    -- If this room has a special exit to pass, use it

    local specialexit = getSpecialExitsSwap( map:getFutureRoom() )

    if specialexit then
      for k,v in pairs(specialexit) do
        if v == exits[NyyLIB.fulldirs[xmove]] then
          echoDebug("MapperScripts: map:getRoom(): " .. map:getRoom() .. "\n")
          echoDebug("MapperScripts: map:getFutureRoom(): " .. map:getFutureRoom() .. "\n")
          
          -- insert special exit command - TODO: this is looping?
          map:insertMovement(k)
          return(true)
        end
      end
    end

    -- if there's a door in the way, open it
    local retval = map:autoOpen(xmove)

    if retval then
      --display(map:getFutureRoom())
    end

    if xmove == "n" then
      map:setFutureRoom( exits["north"] )
    elseif xmove == "s" then
      map:setFutureRoom( exits["south"] )
    elseif xmove == "e" then
      map:setFutureRoom( exits["east"] )
    elseif xmove == "w" then
      map:setFutureRoom( exits["west"] )
    elseif xmove == "u" then
      map:setFutureRoom( exits["up"] )
    elseif xmove == "d" then
      map:setFutureRoom( exits["down"] )
    end
  
    -- a command to open a door was inserted
    if retval then
      --display(map:getFutureRoom())
      return(true)
    end
  end
end

--open door (if there is one)

function map:autoOpen(xdir)
  
  -- TODO: Should doors be opened with fwalk regardless of autoopen?
  
  if autoOpen then
    local doors = getDoors( map:getFutureRoom() )

    if xdir == "n" and doors["n"] then
      if doors["n"] == 3 then
        map:insertMovement("unlock " .. map:getDoorName(map:getFutureRoom(), "n") .. " north")
      end
      
      map:insertMovement("open " .. map:getDoorName(map:getFutureRoom(), "n") .. " north")
      return(true)
    elseif xdir == "s" and doors["s"] then
      if doors["s"] == 3 then
        map:insertMovement("unlock " .. map:getDoorName(map:getFutureRoom(), "s") .. " south")
      end

      map:insertMovement("open " .. map:getDoorName(map:getFutureRoom(), "s") .. " south")
      return(true)
    elseif xdir == "e" and doors["e"] then
      if doors["e"] == 3 then
        map:insertMovement("unlock " .. map:getDoorName(map:getFutureRoom(), "e") .. " east")
      end

      map:insertMovement("open " .. map:getDoorName(map:getFutureRoom(), "e") .. " east")
      return(true)
    elseif xdir == "w" and doors["w"] then
      if doors["w"] == 3 then
        map:insertMovement("unlock " .. map:getDoorName(map:getFutureRoom(), "w") .. " west")
      end

      map:insertMovement("open " .. map:getDoorName(map:getFutureRoom(), "w") .. " west")
      return(true)
    elseif xdir == "u" and doors["up"] then
      if doors["u"] == 3 then
        map:insertMovement("unlock " .. map:getDoorName(map:getFutureRoom(), "up") .. " up")
      end

      map:insertMovement("open " .. map:getDoorName(map:getFutureRoom(), "up") .. " up")
      return(true)
    elseif xdir == "d" and doors["down"] then
      if doors["d"] == 3 then
        map:insertMovement("unlock " .. map:getDoorName(map:getFutureRoom(), "down") .. " down")
      end

      map:insertMovement("open " .. map:getDoorName(map:getFutureRoom(), "down") .. " down")
      return(true)
    end
  end
end

function compressSpeedwalk()
  local t=speedWalkDir
  local ret = {}
  local nx

  for k,v in pairs(t) do
    if v == "down" then
      t[k] = "d"
    end
    if v == "up" then
      t[k] = "u"
    end
  end

   for i, v in ipairs(t) do
    if #v > 4 then
      -- TODO: command seperator
      
      local seperator= getCommandSeparator()
      
      ret[#ret+1] = seperator .. string.split(v, "|")[1] .. seperator
    else
         if t[i-1] and v == t[i-1] then
             ret[#ret - 1] = ret[#ret - 1] + 1
        else
            ret[#ret + 1] = 1
             ret[#ret + 1] = v
         end
    end
   end

  for nx=1, #ret, 1 do
    if ret[nx] == 1 then
      ret[nx] = ""
    end
  end

   return table.concat(ret)
end

function doSpeedWalk()
  if #speedWalkDir > 0 then
    cecho("<green>[Path: ." .. compressSpeedwalk() .. "]\n")
    
    if #speedWalkPath > 1000 then
      cecho("<red>[Path in excess of 1000 rooms: " .. #speedWalkPath .. "]\n")
      cecho("<red>[1000th room: <green>" .. speedWalkPath[1000] .. "<red> ]\n")
      return
    end

    for k,v in pairs(speedWalkDir) do
      if v == "down" then
        speedWalkDir[k] = "d"
      end
      if v == "up" then
        speedWalkDir[k] = "u"
      end
    end
    
    --display(speedWalkDir)
    
    for k,v in ipairs(speedWalkDir) do
      if not string.find(v, "^[nwesud]$") then
        -- special entrance
        
        local testRoom = map:getFutureRoom()
        
        if testRoom == nil then
          testRoom = map:getRoom()
        end
        
        if testRoom == nil then
          -- first room in path, futureroom hasn't been set yet
          -- first room is using a special exit
          echo("Error: testRoom is nil\n")
        end
        
        local specialexit = getSpecialExitsSwap( testRoom )[v]
        v = string.split(v, "|")[1]
        
        testRoom = map:getFutureRoom()
        map:setFutureRoom(specialexit)
      
        echoDebug("speedwalk: adding movement " .. v .. "\n")
        map:addMovement(v)
        
        if testRoom == nil then
          -- first room in path
          expandAlias(v)
        end
      else
        expandAlias(v)
      end
    end
  
    echo("\n")
  end
end

function unhideRoom(xroomid)
  local zone=getRoomUserData(xroomid, "zoneid")

  if zone == "" then
    echo("Error xroomid: " .. xroomid .. "\n")
    return
  end

  local zoneid=tonumber(zone)

  local edgelabel=getRoomUserData(xroomid, "edge")

  local   internalid= map:findAreaID(NyyLIB.areaTable[zoneid])
  
  if xroomid == 1 then
    return
  end

  -- zone doesn't exist in arealist - add it
  if zoneid ~= nil and internalid == nil then
    map:addArea(zoneid)
    
    internalid= map:findAreaID(NyyLIB.areaTable[zoneid]:trim())

    if internalid == nil then
      cecho("[internalid error in room: " .. xroomid .. "]\n")
      display(zoneid)
      display( NyyLIB.areaTable[zoneid] )
      display( map:findAreaID(NyyLIB.areaTable[zoneid]) )
      display("X")
    end
  end

  -- echo("\n[Room: " .. xroomid .. " " .. NyyLIB.areaTable[zoneid] .. "]\n")

  if map:getDoNotEnter(xroomid) == false then
    lockRoom( xroomid, false) -- unlocks the room, adding it back to possible rooms that can be walked through.
  end

  if roomExists(xroomid) == false then
    cecho("<red>[<green>" .. xroomid .. " <red>does not exist]\n")
    return
  end

  if internalid == nil then
    -- will crash this run room has been removed
    display("Likely to crash")
    display("xroomid: " .. xroomid)
    display(zoneid)
    display(getRoomUserData(xroomid, "zoneid"))
    display(NyyLIB.areaTable[zoneid])
    display( map:findAreaID(NyyLIB.areaTable[zoneid]) )
  end

  setRoomArea( xroomid, internalid)

  -- add label indicating zone edges
  if edgelabel ~= "" and edgelabel ~= nil then
    map:roomLabel(edgelabel)
  end

  -- add label indicating password
  local pw=getRoomUserData(xroomid, "password")

  if pw ~= "" and pw ~= nil then
    map:passwordLabel(xroomid, pw)
  end
end

function map:update(xdir)
  local roomid
  local exits

  if xdir ~= nil then
    if _G["echoDebug"] then
      echoDebug("<blue>[map:update : " .. xdir .. "] ")
    end
  
    -- command was movealone
    if string.match(xdir, "^MOVEA ([neswud]).*") then
      xdir=string.match(xdir, "^MOVEA ([neswud]).*")
    end
  else
    if _G["echoDebug"] then
      echoDebug("<blue>[map:update : nil] ")
    end
  end

  if map:getRoom() ~= nil then
    NyyLIB.lastRoomID = map:getRoom()

    local specialexit = getSpecialExitsSwap( map:getRoom() )

    local exitlist={}

    -- build list of special exits
    for k,v in pairs(specialexit) do
      for k2,v2 in pairs(string.split(k, "|")) do
        if _G["echoDebug"] then
          echoDebug("<green>[Previous room has special exit: " .. k .. "]\n")
        end
        exitlist[v2]=v
      end
    end

    if exitlist[xdir] ~= nil then
      roomid = exitlist[xdir]
    else
      exits = getRoomExits( map:getRoom() )

      if exits == nil and xdir ~= nil then
        echo("\n[No recorded exits: Room " .. map:getRoom() .. "]\n")
        map:setRoom(nil)
        return
      end

      if xdir == "n" then
        roomid  = exits["north"]
      elseif xdir == "s" then
        roomid  = exits["south"]
      elseif xdir == "e" then
        roomid  = exits["east"]
      elseif xdir == "w" then
        roomid  = exits["west"]
      elseif xdir == "u" then
        roomid  = exits["up"]
      elseif xdir == "d" then
        roomid  = exits["down"]
      else
        roomid=map:getRoom()
      end
    
      -- attempt to move a direction with no know exit
    
      if roomid == nil then
        roomid=map:getRoom()
      end
    end

    if roomid ~= nil then
      if getRoomArea(roomid) == -1 then
        unhideRoom(roomid)
      else
        -- already found
      end

      centerview(roomid)
    else
      centerview(1)
    end
    
    map:setRoom(roomid)
  else
    centerview(1) -- blank room number
  end
end

-- return a table built from mud exit string

function getExitTable(xmudstr)
  local exitsarray = {0,0,0,0,0,0}
  
  if string.find(xmudstr, "-N") ~= nil or string.find(xmudstr, "- N") ~= nil then
    exitsarray[1] = 1
  end

  if string.find(xmudstr, "-S") ~= nil or string.find(xmudstr, "- S") ~= nil then
    exitsarray[2] = 1
  end

  if string.find(xmudstr, "-E") ~= nil or string.find(xmudstr, "- E") ~= nil then
    exitsarray[3] = 1
  end

  if string.find(xmudstr, "-W") ~= nil or string.find(xmudstr, "- W") ~= nil then
    exitsarray[4] = 1
  end

  if string.find(xmudstr, "-U") ~= nil or string.find(xmudstr, "- U") ~= nil then
    exitsarray[5] = 1
  end

  if string.find(xmudstr, "-D") ~= nil or string.find(xmudstr, "- D") ~= nil then
    exitsarray[6] = 1  
  end

  return( exitsarray )
end

-- [Searching... Match found: Silverymoon, Gem of the North : At the End of Bowshot Ride : 48908]

function solveScan(xsuppress)
  if table.size(scanned) == 0 then
    --if xsuppress == nil then
    --  echo("<red>No scan results to attempt solving]\n")
    --end
    return(nil)
  end

  local scanresults = {}

  for k,v in pairs(scanned) do
    if type(v) == "table" and k ~= "currentroomexits" then
      if #scanresults == 0 then
        scanresults= v.filtered
      end
      
      scanresults = table.n_intersection(scanresults, v.filtered)

      -- no intersect
      if scanresults == false then
        scanresults = {}
      end
    end
  end

  if #scanresults == 1 then
    local match= scanresults[1]

    if xsuppress == nil then
      cecho("<red>Match found: <blue>" .. getRoomAreaName(getRoomArea(match)) .. " : " .. getRoomName(match) .. " : " .. match .. "<red>]\n")
    end

    return( match )
  end

  if xsuppress == nil then
    display(scanresults)
    cecho("<red>Solve scan failed. <green>Multiple (<red>" .. #scanresults .. "<green>) matches found]\n")
  end

  map:setRoom(nil)
  centerview(1)

  return(nil)
end

function filterScan(xkey)
  -- remove roomids from table if reversematch to current location is false

  if scanned[xkey].roomids ~= nil then
    scanned[xkey].filtered = {}

    for k,v in pairs(scanned[xkey].roomids) do
      local match= getRoomExits(v)[NyyLIB.reversedirs[xkey]]

      if match ~= nil then
        -- need to verify match identical to current room

        table.insert(scanned[xkey].filtered, match)
      end
    end

    scanned[xkey].roomids = nil
  end
end

-- map:setFutureRoom is the room number that will be occupied when the current movement queue is completed

function map:getFutureRoom()
  return ( self.futureRoom )
end

function map:setFutureRoom(xroom)
  self.futureRoom = xroom
end

function map:getExits()
  return ( self.exits )
end

function map:setExits(xexits)
  self.exits=xexits
end

function map:getRoomname()
  return ( self.roomname )
end

function map:setRoomname(xname)
  self.roomname = xname
end

function map:getRoom()
  return ( self.roomid )
end

function map:setRoom(xid)
  if xid ~= nil then
    if getRoomArea(xid) == -1 then
      unhideRoom(xid)
    end
  end

  self.roomid = xid

  if map:getFutureRoom() == nil or map:countMovement() == 0 then
    if xid ~= nil then
      if _G["echoDebug"] then
        echoDebug("<blue>[map:setRoom (setFutureRoom) : " .. xid .. "]\n")
      end
      map:setFutureRoom( xid )
    end
  end

  raiseEvent("newRoomEvent", map:getRoom() )
end

function map:getZone(roomid)
  local areaID
  local areaname

  if roomid == nil then
    return( "" )
  end

  areaID = getRoomArea( roomid )

  if areaID ~= nil then
    if areaID == -1 then
      local zone=getRoomUserData(roomid, "zoneid")
      local zoneid=tonumber(zone)

      areaname = NyyLIB.areaTable[zoneid]
    else
      areaname=getRoomAreaName(areaID)
    end
  end

  return (areaname)
end

function map:toggle()
  if showMap then
    showMap=false
    
    mapButtonCon:setStyleSheet("QLabel{background-color: rgba(0,0,0,0%)}")
    
    map:hide()
  else
    showMap=true
    
    mapButtonCon:setStyleSheet("QLabel{border: 2px solid red;}")
    
    map:show()
  end
end

function map:hide()
  
  if mapAdjCon ~= nil then
    mapAdjCon:hide()
  end
  
  --if NyyLIB.mapwindow ~= nil then
  --  NyyLIB.mapwindow:show()
  --  NyyLIB.mapwindow:hide()
  --end
end

function map:show()
  
  if mapAdjCon ~= nil then
    mapAdjCon:show()
  end
  
  --if NyyLIB.mapwindow ~= nil then
  --  NyyLIB.mapwindow:hide()
  --  NyyLIB.mapwindow:show()
  --end
end

function map:countRooms()
  if self.roomcount == nil then
    self.roomcount=0

    for k,v in pairs(getRooms()) do
      self.roomcount=self.roomcount+1
    end
  end

  return(self.roomcount)
end

function map:loadMap()
  -- create mapper window if not yet present

  mudlet = mudlet or {}; mudlet.mapper_script = true

  if NyyLIB.mapwindow == nil then
  
    display("map created from map:loadMap()")
  
    mapAdjCon = mapAdjCon or Adjustable.Container:new({name="mapAdjCon" })
    mapAdjCon:disableAutoDock()
  
    NyyLIB.mapwindow = Geyser.Mapper:new({name="NyyMapper",x=0,y=0,width="100%",height="100%"}, mapAdjCon)
    
  end

  if setDefaultAreaVisible ~= nil then
    setDefaultAreaVisible(false)
  end

  -- top level map will be loaded if exists, otherwise the default
  local is_file = io.open(homepath("toril.map"))
  local loadok  

  if is_file ~= nil then
    loadok = loadMap(homepath("toril.map"))

    if loadok then
      cecho("<red>[Loaded map: " .. homepath("toril.map") .. "]\n")
    end
  else
    loadok = loadMap(mainpath("toril.map"))

    if not loadok then
        cecho("<red>[Failed map load: " .. mainpath("toril.map") .. "]\n")
    else
        cecho("<red>[Loaded map: " .. mainpath("toril.map") .. "]\n")

      -- initial map load - save file
      saveMap( "" )
    end
  end

  expandAlias("@find", false)
end

function map:initAreatable()

  local tmp=getRoomUserData(1, "areatable")
  
  if tmp ~= "" then
      NyyLIB.areaTable={}
      
      for id, name in string.gmatch(tmp, "%[(%d+)%]([a-zA-Z0-9',_/ -]+)") do
        NyyLIB.areaTable[tonumber(id)] = name
      end

  --   NyyLIB.areaTable[0] = "God Rooms"
      return
  end

  NyyLIB.areaTable = NyyLIB.areaTable or
  {
    [1] = "Misc Code Items/Mobs",
    [2] = "The Day/Night Load Zone",
    [3] = "The Quests Zone",
    [4] = "Misc Code Items/Mobs 2",
    [5] = "Kobold Settlement",
    [6] = "None of Your Business",
    [7] = "Ako Village",
    [8] = "The High Road",
    [9] = "The Troll Hills",
    [10] = "Valley of Crushk",
    [11] = "RP ZONE - Annam",
    [12] = "The Day/Night Load Zone 2",
    [13] = "The Conquered Village",
    [14] = "The Long Delay Zone",
    [15] = "the Deep Jungle",
    [16] = "Southern Waterdeep Main City",
    [17] = "Northern Waterdeep Main City",
    [18] = "Central Waterdeep Main City",
    [19] = "Wilderness Roads",
    [20] = "Waterdeep Trails",
    [21] = "The Scardale Sewers",
    [22] = "The Elemental Groves",
    [23] = "Caves of Mt. Skelenak",
    [24] = "The Underworld",
    [25] = "Alterian Region - Wilderness",
    [26] = "Alterian Region - Mountains",
    [27] = "Labyrinth of No Return",
    [28] = "The Great Harbor of Waterdeep",
    [29] = "The Guilds of Waterdeep",
    [30] = "The Ashstone Trail",
    [31] = "The Western Realms",
    [32] = "The Chionthar Ferry",
    [33] = "Scornubel",
    [34] = "Mithril Hall - City of Dwarves",
    [35] = "The Tunnel to Ardn'ir",
    [36] = "Bloodstone Keep",
    [37] = "Distro Rooms/Generic Objects",
    [38] = "Leuthilspar - City of Elves",
    [39] = "Ribcage: Gate Town to Baator",
    [40] = "Keprum Vhai'rels Design",
    [41] = "The Dark Gate",
    [42] = "Keprum Vhai'rels Test",
    [43] = "Keprum - Captain Quest",
    [44] = "The Lost Treasure of Zaor",
    [45] = "Klauthen Vale",
    [46] = "Great Northern Road",
    [47] = "Village of Split Shield",
    [48] = "Griffon's Nest",
    [49] = "The Valley of Graydawn",
    [50] = "The Realms Master - Ship",
    [51] = "The Silver Lady - Ship",
    [52] = "IX Curtain",
    [53] = "Ghore - City of Trolls",
    [54] = "Lava Tubes One",
    [55] = "Lava Tubes Two",
    [56] = "Herd Island Chasm",
    [57] = "Ixarkon Prison",
    [58] = "The Temple of Baphomet",
    [59] = "Lake Skeldrach Island",
    [60] = "Lake Skeldrach Shore",
    [61] = "Lake Skeldrach",
    [62] = "The Citadel",
    [63] = "The Adamantite Mine",
    [64] = "The Lurkwood",
    [65] = "The Evermoors",
    [66] = "Talthalra Haszakkin",
    [67] = "Faerie Realm",
    [68] = "Wilderness Near Waterdeep",
    [69] = "The Waterdeep Coast Road",
    [70] = "Evermeet Bay",
    [71] = "The_Wildland_Trails",
    [72] = "Southern Forest",
    [73] = "Tower of High Sorcery One",
    [74] = "New Cavecity",
    [75] = "Faang - City of Ogres",
    [76] = "The Ice Prison",
    [77] = "Beluir - City of Halflings",
    [78] = "The Keep of Finn McCumhail",
    [79] = "The Sunken Slave City",
    [80] = "The Ant Farm",
    [81] = "The Blood Bayou",
    [82] = "Earth Plane",
    [83] = "The Dread Mist",
    [84] = "Ashstone Keep Road",
    [85] = "Ashstone",
    [86] = "The Nightwood",
    [87] = "Nightwood Border",
    [88] = "Ashstone Refugee Camp",
    [89] = "The Astral Plane - Main Grid",
    [90] = "The Astral Plane - Side Areas",
    [91] = "The Astral Plane - Tiamat",
    [92] = "Pirate Isles",
    [93] = "Stronghold of Trahern Oakvale",
    [94] = "New Nhavan Island",
    [95] = "The Calimshan Desert",
    [96] = "Viperstongue Outpost",
    [97] = "The Roads of the Heartland",
    [98] = "The Roads of the Heartland 2",
    [99] = "Shaman Quest/Spirit World",
    [100] = "Dobluth Kyor - Main City",
    [101] = "The Forest of Mir",
    [102] = "Rimi Greatoath dagger quest",
    [103] = "Barnabas dagger quest",
    [104] = "Conquest Armor Quest",
    [105] = "The Marching Mountains",
    [106] = "The Zone of Many Invasions",
    [107] = "Bloodstone Keep II",
    [108] = "Bloodstone Keep III",
    [109] = "The Ethereal Plane",
    [110] = "Deep Within the Toadsquat Mnts",
    [111] = "Tiamat - The Pillar of Skulls",
    [112] = "Tiamat - The Lair",
    [113] = "Beneath the Ancient Pyramid",
    [114] = "The Plane of Air Part One",
    [115] = "The Plane of Fire Part One",
    [116] = "The Plane of Fire Part Two",
    [117] = "The Plane of Fire -Planar Grid-",
    [118] = "Cityguard's Armoury",
    [119] = "The Pit of Souls",
    [120] = "The Shadow Swamp",
    [121] = "Troll King",
    [122] = "New Moonshae Island I",
    [123] = "The Ancient Oak",
    [124] = "Myrloch Vale",
    [125] = "The Headquarters of the Twisted Rune",
    [126] = "The New Trackless Sea",
    [127] = "The Nine Hells - Avernus",
    [128] = "The Nine Hells - Avernus - Bronze Citadel",
    [129] = "Bryn Shander",
    [130] = "The Eastway",
    [131] = "The Elemental Plane of Magma",
    [132] = "The Basin Wastes",
    [133] = "Gloomhaven",
    [134] = "The Derro Pit",
    [135] = "The Tunnel of Dread",
    [136] = "The Gloomhaven Barge",
    [137] = "Ruins of Yath Oloth",
    [138] = "The Jungle City of Hyssk",
    [139] = "The River Trail to Hyssk",
    [140] = "The Necromancer's Laboratory",
    [141] = "Randars Hideout",
    [142] = "The Orcish Hall of Plunder",
    [143] = "Rurrgr T'ohrr",
    [144] = "The Sylvan Glades",
    [145] = "The Shining Sea One",
    [146] = "Desert City of Nizari",
    [147] = "The Sedawi Mountain Village",
    [148] = "The Elder Anthology",
    [149] = "The High Road - Side Areas",
    [150] = "Dark Forest",
    [151] = "Rogath Swamp",
    [152] = "The Comarian Mines",
    [153] = "The Temple of Blipdoolpoolp",
    [154] = "The Temple of the Moon",
    [155] = "The Elder Forest",
    [156] = "Demiplane of Artimus Nevarlith",
    [157] = "Ophidian Jungle",
    [158] = "Hive of the Manscorpions",
    [159] = "Lost Library of the Seer Kings",
    [160] = "The Temple of Twisted Flesh",
    [161] = "Mosswood Village",
    [162] = "Calimport, the City",
    [163] = "Calimport, the Sewers",
    [164] = "Calimport, the Docks",
    [165] = "Calimport, the Palace",
    [166] = "Calimport, The Sea Sprite",
    [167] = "Pirate Ship, Captain's Fancy",
    [168] = "Calimport, The Barracuda",
    [169] = "Hyssk Ship/Dragon Turtle Path",
    [170] = "Hyssk Ship/Dragon Turtle Stuff",
    [171] = "Thunderhead Peak",
    [172] = "The Darktree",
    [173] = "Caravan Trail to the Ten Towns",
    [174] = "Calimport Palace Vault",
    [175] = "Acheron 1, Avalas",
    [176] = "Acheron 2, Thuldanin",
    [177] = "Acheron 3, Tintibulus",
    [178] = "Acheron 4, Ocanthus",
    [179] = "Arnd'ir",
    [181] = "Neshkal - The Dragon Trail",
    [182] = "Hulburg Trail",
    [183] = "The Onyx Tower of Illusion",
    [184] = "Druids Grove",
    [185] = "The Curse of Newhaven",
    [186] = "The Curse of Newhaven_II",
    [187] = "The Llyrath Forest",
    [188] = "Choking Palace",
    [189] = "The Swamps of Meilech",
    [190] = "The Jungles of Ssrynss",
    [191] = "Trollbark",
    [192] = "A Halruaan Airship 1",
    [193] = "A Halruaan Airship 2",
    [194] = "The Floating Fortress of Izan Frosteyes",
    [195] = "The Lost Pyramid",
    [196] = "The Sewers of Waterdeep",
    [197] = "The Blackwood",
    [198] = "Cursed Cemetery",
    [199] = "The Seven Heavens - Lunia",
    [200] = "Bahamut's Palace",
    [201] = "The Plane of Smoke",
    [202] = "Cloud Realms of Arlurrium",
    [203] = "Muspelhiem",
    [204] = "Hulburg",
    [205] = "The Minotaur Outpost",
    [206] = "A'Quarthus Velg'Larn",
    [207] = "The Para-Elemental Plane of Ice",
    [208] = "Ashgorrock, the Gargoyle City",
    [209] = "Tower of the Elementalist",
    [210] = "The Druid Forest",
    [211] = "Seelie Faerie Court",
    [212] = "Yggdrasil",
    [213] = "Scardale",
    [214] = "Abandoned Temple",
    [215] = "Soulprison of Bhaal",
    [216] = "The Golem Forge",
    [217] = "Ashrumite_Village",
    [218] = "The Neverwinter Wood Beta",
    [219] = "Jungle Village of the Batiri",
    [220] = "The Drider Cavern",
    [221] = "Unseelie Faerie Court",
    [222] = "Skullport, Port of Shadows",
    [223] = "Skullport Helper Zonelet",
    [224] = "Wyllowwood",
    [225] = "The Dwarven Mining Settlement",
    [226] = "Spiderhaunt Woods",
    [227] = "Farm of the Undead",
    [228] = "Fire Giants Village",
    [229] = "Temple of Dumathoin",
    [230] = "Zhentil Keep",
    [231] = "Lair of the Deep Dragon",
    [232] = "UnderDark River Ruins",
    [233] = "Myth Drannor-Eastern City",
    [234] = "Roads of Cormanthor",
    [235] = "Myth Drannor-Central City",
    [236] = "Myth Drannor-Western City",
    [237] = "Silverymoon, Gem of the North",
    [238] = "Veldrin Z'har",
    [239] = "Dragonsfall Forest",
    [240] = "Menden-on-the-Deep",
    [241] = "The Defense of Longhollow",
    [242] = "The Cursed City of West Falls",
    [243] = "The Bandit Hideout",
    [244] = "Scornubel Ferry",
    [245] = "Calimshan Beach",
    [246] = "The Tarsellian Forest",
    [247] = "The Dusk Road",
    [248] = "The Fog Enshrouded Wood",
    [249] = "The Northern High Road",
    [250] = "The Northern High Road-2",
    [251] = "The Northern Caravan Trail",
    [252] = "The Mirar Ferry",
    [253] = "The Abandoned Monastery",
    [254] = "Baldur's Gate - Main City",
    [255] = "Baldur's Gate - Docks",
    [256] = "Baldur's Gate - Harbor",
    [257] = "Baldur's Gate - Wave Dancer",
    [258] = "The Ruins of Undermountain I",
    [259] = "Myth Unnohyr",
    [260] = "The Ruins of Undermountain II",
    [261] = "The Trader's Road",
    [262] = "The Reaching Woods - Part I",
    [263] = "Darkhold Castle",
    [264] = "Bloodtusk",
    [265] = "Mistywood",
    [266] = "Castle Drulak",
    [267] = "Jotunheim",
    [268] = "Talenrock",
    [269] = "Ixarkon - City of Mindflayers",
    [270] = "The Greycloak Hills",
    [271] = "The Brain Stem Tunnel",
    [272] = "IceCrag Castle",
    [273] = "IceCrag Castle - Lower Level",
    [274] = "Swift-Steel Company",
    [275] = "Havenport",
    [276] = "The Spirit Raven",
    [277] = "Skerttd-Gul",
    [278] = "Trade",
    [279] = "Shadow Dimension Rooms",
    [280] = "Guildhalls-Triterium",
    [281] = "Imphras Guild Hall",
    [282] = "Tooth and Maw - Grilled Grawl",
    [283] = "Pride of the Sabertooth Guildhall",
    [284] = "Valkurian Blades Guildhall",
    [285] = "Guildhalls - Warder's Vault",
    [286] = "Kingdoms and Houses",
    [287] = "The Questbuilding Zone",
    [288] = "Lizard Marsh",
    [289] = "The Ruined Keep",
    [290] = "The Stag Forest",
    [291] = "The Stump Bog",
    [292] = "The Way Inn",
    [293] = "Evermeet- Elven Settlement",
    [294] = "The Evermoor Way",
    [295] = "The Rauvin Ride",
    [296] = "Ogre Lair",
    [297] = "Fire Giant Lair",
    [298] = "Ancient Mines",
    [299] = "Evermeet- Rogue's Lair",
    [300] = "Kobold Caverns",
    [301] = "Evermeet- Hidden Mine",
    [302] = "Dragonspear Castle",
    [303] = "Alabaster Caverns",
    [304] = "Crystal Caverns",
    [305] = "Seaweed Tribe",
    [306] = "The Dark Dominion",
    [307] = "Underdark Tunnels",
    [308] = "The Luskan Outpost",
    [309] = "The Dragonspine Mountains Trail",
    [310] = "Darklake",
    [311] = "The Trade Way",
    [312] = "Illithid Enclave",
    [313] = "The Labyrinth",
    [314] = "The Tower of Kenjin",
    [315] = "Settlestone",
    [316] = "Wormwrithings",
    [317] = "Menzoberranzan",
    [318] = "Water Plane",
    [319] = "The Temple of Ghaunadaur",
    [320] = "The Fortress of the Dragon Cult",
    [321] = "Evermeet- Scorched Forest",
    [322] = "Evermeet- Serene Forest",
    [323] = "Amenth'G'narr",
    [324] = "Elg'cahl Niar",
    [325] = "The Rat Hills",
    [326] = "Mithril Hall Palace",
    [327] = "Barbarian Encampment",
    [328] = "Evermeet- Main Road",
    [329] = "Evermeet- East Coast Road North",
    [330] = "Evermeet- West Coast Road North",
    [331] = "Evermeet- Ancient Forest-1",
    [332] = "Evermeet- Misc. Rooms/Mobs",
    [333] = "Evermeet- Road to Elven Settlement",
    [334] = "The Underdark Trade Route",
    [335] = "Grid-Desert-Calimport1",
    [336] = "Grid-Desert-Calimport2",
    [337] = "Grid-Forest-Bloodtusk",
    [338] = "Grid-Hills-Bloodtusk",
    [339] = "Grid-Hills-Bloodtusk2",
    [340] = "Grid-Arctic-MH",
    [341] = "Grid-Arctic-MH2",
    [342] = "Grid-Arctic-GN",
    [343] = "Grid-Hills-WD",
    [344] = "Grid-Hills-Ashrumite",
    [345] = "Grid-Hills-GN",
    [346] = "Grid-Jungle-Hyssk",
    [347] = "Grid-Jungle-Hyssk2",
    [348] = "Grid-UD-Ixarkon",
    [349] = "Grid-UD-GH",
    [350] = "Grid-UD-Mir",
    [351] = "Grid-Forest-WD",
    [352] = "Grid-Forest-Faang",
    [353] = "Grid-Forest-Leuthilspar",
    [354] = "Grid-Forest-Leuthilspar2",
    [355] = "The End of the World",
    [356] = "Westgate",
    [357] = "Crypt of Dragons",
    [358] = "Nine Hells - Dis",
  }

  NyyLIB.areaTable[0] = "God Rooms"

  tmp=""
  local count=0
  for k,v in pairs(NyyLIB.areaTable) do
    tmp=tmp .. "[" .. k .. "]" .. v
    count=count+1
  end
  
  --display(tmp)
  --display(count)
  setRoomUserData( 1, "areatable", tmp)
end

function map:setDoNotEnter(xroomid)

  if roomExists(xroomid) then
    setRoomUserData(xroomid, "DoNotEnter", "X")
  else
    echo("[Error: Attempt to set DNE in non-existent room: " .. xroomid .. "]\n")
  end
end

function map:getDoNotEnter(xroomid)
  local str=getRoomUserData(xroomid, "DoNotEnter")

  if str == "X" then
    return(true)
  end

  return(false)
end

-- iterate over the list of areas, matching them with substring match. 
-- if we get match a single area, then return it's ID, otherwise return
-- 'false' and a message that there are more than one area matches

function map:findAreaID(areaname)
  local nx
  local list = getAreaTable()
 
  local returnid, fullareaname

  if areaname == nil then
    cecho("<red>[Warning: map:findAreaId(areaname) - nil areaname]\n")
    return nil
  end

  for area, id in pairs(list) do
    if area == areaname then
      if returnid then 
      echo("[more then one area matches]\n")
      return nil
    end
      returnid = id; 
    end
  end

  return returnid
end

function map:findRoomArea(xname, xexits)
  local partmap = searchRoom(xname)
  local match = {}
  local filteredmatch = {}

  local matchedarea=nil

  for roomid, roomname in pairs(partmap) do
    if roomname == xname then
      table.insert(match, roomid)
    end
  end

  if #match == 0 then
    return(nil)
  end

  if #match == 1 then
    matchedarea= map:getZone( match[1] )
    return(matchedarea)
  end

  for k, v in pairs(match) do
    local roomexits = getRoomExits(v)
    local matchtable = {0,0,0,0,0,0}

    if roomexits["north"] then
      matchtable[1] = 1
    end

    if roomexits["south"] then
      matchtable[2] = 1
    end
  
    if roomexits["east"] then
      matchtable[3] = 1
    end

    if roomexits["west"] then
      matchtable[4] = 1
    end
  
    if roomexits["up"] then
      matchtable[5] = 1
    end
  
    if roomexits["down"] then
      matchtable[6] = 1
    end
  
    if table.concat(xexits) == table.concat(matchtable) then
      table.insert(filteredmatch, v)
    end
  end

  matchedarea= map:getZone( filteredmatch[1] )

  -- multiple rooms matches, but all in the same area

  for k,v in pairs(filteredmatch) do
    if map:getZone(v) ~= matchedarea then
      matchedarea=nil
    end
  end

  return(matchedarea)
end

function map:findRoomID(xname, xexits, xsuppress)
  local partmap = searchRoom(xname)
  local match = {}
  local filteredmatch = {}

  for roomid, roomname in pairs(partmap) do
    if roomname == xname then
      table.insert(match, roomid)
    end
  end

  if #match == 0 then
    map:setRoom(nil)
    
    if xsuppress == nil then
      cecho("<red>No matches found: <blue>" .. xname .. "<red>]\n")
    end
    return(nil)
  end

  if #match == 1 then
    if xsuppress == nil then
      cecho("<red>Match found: <forest_green>" .. getRoomAreaName(getRoomArea(match[1])) .. " : ".. xname .. " : " .. match[1] .. "<red>]\n")
    end

    return(match[1])
  end

  for k, v in pairs(match) do
    local roomexits = getRoomExits(v)
    local matchtable = {0,0,0,0,0,0}

    if roomexits["north"] then
      matchtable[1] = 1
    end

    if roomexits["south"] then
      matchtable[2] = 1
    end
  
    if roomexits["east"] then
      matchtable[3] = 1
    end

    if roomexits["west"] then
      matchtable[4] = 1
    end
  
    if roomexits["up"] then
      matchtable[5] = 1
    end
  
    if roomexits["down"] then
      matchtable[6] = 1
    end
  
    if table.concat(xexits) == table.concat(matchtable) then
      table.insert(filteredmatch, v)
    end
  end

  if #filteredmatch == 0 then
    if xsuppress == nil then
      cecho("<red>No matching exits found]\n")
    end
    return(nil)
  end

  if #filteredmatch == 1 then
    if xsuppress == nil then
      cecho("<green>Exits matched room#: " .. filteredmatch[1] .. " : " .. xname .. "<red>]\n")
    end
    return(filteredmatch[1])
  end

  if xsuppress == nil then
    cecho("<green>Multiple (<red>" .. #filteredmatch .. "<green>) matches found: <blue>" .. xname .. "]\n")

    -- send scan if multiple matches/scan has not been already sent
    if table.size(scanned) == 0 then
      if _G["mud"] then mud:send("SCAN") else send("SCAN") end
    end
  end

  return(nil)
end

function map:findRoomIDTable(xname, xexits, xsuppress)
  local partmap = searchRoom(xname)
  local match = {}
  local filteredmatch = {}

  for roomid, roomname in pairs(partmap) do
    if roomname == xname then
      table.insert(match, roomid)
    end
  end

  if #match == 0 then
    if xsuppress == nil then
      echo("No matches found: " .. xname .. "]\n")
    end
    return(nil)
  end

  if #match == 1 then
    if xsuppress == nil then
      cecho("<red>Match found: <blue>" .. xname .. " : " .. match[1] .. "<red>]\n")
    end
    return(match)
  end

  for k, v in pairs(match) do
    local roomexits = getRoomExits(v)
    local matchtable = {0,0,0,0,0,0}

    if roomexits["north"] then
      matchtable[1] = 1
    end

    if roomexits["south"] then
      matchtable[2] = 1
    end
  
    if roomexits["east"] then
      matchtable[3] = 1
    end

    if roomexits["west"] then
      matchtable[4] = 1
    end
  
    if roomexits["up"] then
      matchtable[5] = 1
    end
  
    if roomexits["down"] then
      matchtable[6] = 1
    end
  
    if table.concat(xexits) == table.concat(matchtable) then
      table.insert(filteredmatch, v)
    end
  end

  if #filteredmatch == 0 then
    if xsuppress == nil then
      cecho("<red>No matching exits found]\n")
    end
    return(nil)
  end

  return(filteredmatch)
end

function map:getCurrentZone()
  local areaID
  local areaname

  if map:getRoom() ~= nil then
    areaID = getRoomArea( map:getRoom() )
  end

  if areaID ~= nil then
    areaname=getRoomAreaName(areaID)
  end

  return (areaname)
end

function map:isRoomName(teststring)
  if teststring == nil then
    return
  end

  -- if first character not a capital letter can't be room name  

  if not string.find(teststring, "^[A-Z]") then
    return(false)
  end

  -- if final character is period, !, or ' can't be room name
  -- final character must be [a-z]

  -- if string.find(teststring, "[!.']$") then
  -- for now, allow for whitespace character at end
  if not string.find(teststring, "[a-z \)]$") then
    return(false)
  end

  -- if (x2) can't be room
  if string.find(teststring, "(x2)") then
    return(false)
  end
  
  -- Your rage subsides considerably as the blade on your a black longsword of destruction
  if string.find(teststring, "Your rage subsides") then
    return(false)
  end
  
  
  -- As the magic of Vomicopol's bracers overwhelm his body, they
  if string.find(teststring, "bracers overwhelm") then
    return(false)
  end


  -- 'All of a sudden, your a set of frozen ice shard greaves explode'

  if string.find(teststring, "All of a sudden") then
    return(false)
  end

  -- The mighty scepter of valhalla growls angrily, 'This is no time to be cautious! Press this weak

  if string.find(teststring, "The mighty scepter of") then
    return(false)
  end

  -- Bard song isn't roomname
  
  -- As your voice lifts in a sweet rendition of an ancient bardic verse, the nearby air
  -- erupts with myriad echoes.  A beautiful voice rises above the din, singing along

  if string.find(teststring, "As your voice") then
    return(false)
  end
  
  if string.find(teststring, "erupts with myriad") then
    return(false)
  end

  if string.find(teststring, "Usage:") then
    return(false)
  end
  
  if string.find(teststring, "Account name:") then
    return(false)
  end

  if map:getRoom() ~= nil then
    if string.find(teststring, " $") then
      if displayMapErrors then
        cecho(" <red>[Error: trailing whitespace: (<green>" .. teststring .. "<red>)]")
      end
    end
  end

  return(true)
end

function map:getDoorName(xroomid, xdir)
  local dirname={  ["n"]="north",
             ["s"]="south",
             ["u"]="up",
             ["d"]="down",
             ["e"]="east",
             ["w"]="west" }
  local exitNames
  local checkdir=xdir

  exitNames = getDoors(xroomid)

  if exitNames[xdir] then
    exitNames = getRoomUserData(xroomid, "exitNames")

    if exitNames ~= "" and exitNames ~= nil then
      exitNames = yajl.to_value(exitNames)
    else
      exitNames = {}
    end

    if dirname[xdir] ~= nil then
      checkdir=dirname[xdir]
    end

    if exitNames[checkdir] then
      return(exitNames[checkdir])
    end

    return("door")
  end

  return(nil)
end


function map:setDoorName(xroomid, xdir, xdoorname)

  if roomExists(xroomid) then
    local exitNames = getRoomUserData(xroomid, "exitNames")

    if exitNames == "" or exitNames == nil then
      exitNames = {}
    else
      exitNames = yajl.to_value(exitNames)
    end
      
    if xdir == nil then
      cecho("<RED>Import Error:\n")
      display(xroomid)
      display(xdir)
      display(xdoorname)
      return
    end

    exitNames[exitMap[xdir]] = xdoorname

    setRoomUserData(xroomid, "exitNames", yajl.to_string(exitNames))
  else
    echo("[Error: Attempt to set door in non-existent room: " .. xroomid .. " : " .. xdir .. " : " .. xdoorname .. "]\n")
  end
end

function map:lockMap()
local fullmap = getRooms()
local areatable = getAreaTable()

  
  -- erase labels
  
  for k,_ in pairs(getAreaTableSwap()) do 
    for l,_ in pairs(getMapLabels(k)) do 
      deleteMapLabel(k,l) 
    end
  end
 
  -- unassign all rooms
  for roomid, roomname in pairs(fullmap) do
    if getRoomArea(roomid) ~= -1 then
      resetRoomArea(roomid)
      echo("Unassigning " .. roomid .. "\n")
    end
    
    if roomLocked(roomid) == false then
      lockRoom( roomid, true)
      echo("Locking " .. roomid .. "\n")
    end
  end

  -- delete all areas
  for i,v in pairs(areatable) do
    deleteArea(v)
  end

  -- create great unknown
  map:addArea(6)
  
  setAreaName(6, "The Great Unknown")
  
  setRoomArea(1, map:findAreaID("The Great Unknown"))

  setRoomName(1, "Unmapped")
   
  -- need to check if already exists
  --expandAlias("emptyroom", false)

  echo("Map locked\n")
end
