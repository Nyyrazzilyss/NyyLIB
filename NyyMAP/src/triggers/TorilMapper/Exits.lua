prompt = prompt or {}

function prompt:isStringPrompt(teststring)
  if string.find(teststring, "^< .* >") then
    return(true)
  end

  return(false)
end

local xexits=matches[2]
local roomPortal = false

-- last command entered was look direction - return
--display(command)
if string.find(command, "L ") == 1 and not string.find(command, "L in") then
  return
end

if string.find(command, "l ") == 1 and not string.find(command, "l in") then
  return
end

if string.find(command, "look ") == 1 and not string.find(command, "look in") then
  return
end


if string.find(command, "L ") == 1 and not string.find(command, "L in") and 1==2 then

  local lineindex=1

  while prompt:isStringPrompt( getLines(getLineNumber()-lineindex, getLineNumber())[1] ) == false do
    if getLines( getLineNumber()-lineindex, getLineNumber() )[1] == "               " then
      break
    end
        
    lineindex=lineindex+1

    if lineindex > 1500 then
      if _G["echoDebug"] then
        echoDebug("<red>[Searched more then 1500 lines unable to locate last prompt for roomname]\n")
      end
      return
    end
  end

  local teststring = getLines(getLineNumber()-lineindex, getLineNumber())[1]

  while map:isRoomName(teststring) == false do
    lineindex=lineindex-1
    teststring = getLines(getLineNumber()-lineindex, getLineNumber())[1]
  end

  map.farseeRoomname = teststring
  map.farseeExits = matches[2]

  return
end

-- TODO: correct room number in looking n/e/s/w/etc
-- You extend your sights northwards.
-- You extend your sights upwards.

-- clair - 'cast your sights far out' in the last 6 lines

for nx=1,6,1 do
  if string.find( getLines(getLineNumber()-nx, getLineNumber())[1], "cast your sights far out") then
    roomPortal="Clair"
  end
end

-- looking in wormhole - 'You peer into'
-- You peer into a blood-red portal
-- You peer into a rainbow colored portal and see...
-- You peer into a moonwell and see...

-- TODO/tofix: this segment can't be reached (it returns from 'L') 

for nx=1,6,1 do
  local portal=string.match( getLines(getLineNumber()-nx, getLineNumber())[1], "You peer into a (.*) and see" )

  if portal ~= nil then
    roomPortal=portal
  end
end

-- last command entered was scan
-- This block will also attempt to solve location from scan results

if command == "SCAN" or command == "scan" then
  local lineindex=1

  while ( string.find( getLines(getLineNumber()-lineindex, getLineNumber())[1], "^You scan ([A-Za-z]+)[.][.][.]") == nil) do
    lineindex=lineindex+1

    if lineindex > 150 then
      cecho("<red>[Scan error after 150 lines]\n")
      command = ""
      return
    end
  end

  local scandir= string.match(getLines(getLineNumber()-lineindex, getLineNumber())[1], "^You scan ([a-z]+).*")

  scanned[scandir]={}
  scanned[scandir]["roomname"]= getLines(getLineNumber()-lineindex+1, getLineNumber())[1]
  scanned[scandir]["exits"] = getExitTable(xexits)

  scanned[scandir]["roomids"] = map:findRoomIDTable( scanned[scandir]["roomname"], getExitTable(xexits), true)

  scanned["currentroomname"] = map:getRoomname()
  scanned["currentroomexits"] = map:getExits()

  filterScan(scandir) -- reverse checks all rooms

  if map:getRoom() == nil then
    local solveroom = solveScan(true)

    if solveroom ~= nil then
      map:setRoom(solveroom)
      centerview( map:getRoom() )
    end
  end

  return
end

-- was last command entry to special exit?
-- This is the block that echos the special exit usage message

if map:getRoom() ~= nil then
  local specialexit = getSpecialExitsSwap( map:getRoom() )

  local exitlist={}

  --display(specialexit)

  -- build list of special exits
  for k,v in pairs(specialexit) do
    -- key will be each special exit from this room example: "enter wave|dancer"
    local specialExit = string.split(k, " ")
    
    for k2,v2 in pairs(string.split(specialExit[2], "|")) do
      local testCommand = string.split(string.lower(command), " ")
      local testExit = string.lower(specialExit[1])
      
      -- Check for special command/partial command, exit
      if string.find(testExit, testCommand[1]) == 1 and testCommand[2] == string.lower(v2) then
        -- TODO - command2 causes problems with fwalk paths
        cecho("\n<green>[Using special exit '<cyan>" .. k .. "<green>' to room <cyan>" .. v .. " : " .. getRoomName(v) .. "<green>]\n")
        map:setRoom(v)
        centerview( map:getRoom() )

        -- remove first movement from queue
        map:removeMovement()

        return
      end
    end
  end
end

-- find last blank line received, room name is first following line of format title the doesn't end in period or start with [
-- OR minimap marker "     " \t\t\t\n
local lineindex=1

while prompt:isStringPrompt( getLines(getLineNumber()-lineindex, getLineNumber())[1] ) == false do
  if getLines( getLineNumber()-lineindex, getLineNumber() )[1] == "               " then
    break
  end
        
  lineindex=lineindex+1

  if lineindex > 1500 then
    if _G["echoDebug"] then
      echoDebug("<red>[Searched more then 1500 lines unable to locate last prompt for roomname]\n")
    end
    return
  end
end

local teststring = getLines(getLineNumber()-lineindex, getLineNumber())[1]

while map:isRoomName(teststring) == false do
  lineindex=lineindex-1
  teststring = getLines(getLineNumber()-lineindex, getLineNumber())[1]
end

-- if claired decrease index by 1
local checkline= getLines(getLineNumber()-lineindex, getLineNumber())[1]

if checkline ~= nil then
  if string.find( checkline, "cast your sights far out") then
    lineindex=lineindex-1
  end

  if string.find( checkline, "You peer into") then
    lineindex=lineindex-1
  end
end

-- TODO: clair/portal shouldn't be setting roomname

local roomName = getLines(getLineNumber()-lineindex, getLineNumber())[1]

map:setRoomname( roomName )

if roomName == nil then
  return
end

-- Remove all (word) patterns: (Shadowed), (Airy), except: (Water), (Fogged) (No Ground), (burning)
local buildName = string.gsub(roomName, " %(.+%)", "")

if string.find( roomName, "%(burning%)" ) then
  buildName = buildName .. " (burning)"
end

if string.find( roomName, "%(Water%)" ) then
  buildName = buildName .. " (Water)"
end

if string.find( roomName, "%(Fogged%)" ) then
  buildName = buildName .. " (Fogged)"
end

if string.find( roomName, "%(No Ground%)" ) then
  buildName = buildName .. " (No Ground)"
end

roomName = buildName

-- in case roomname was on same line as prompt (it happens!)
if string.find( roomName, "> ") ~= nil then
  roomName = string.sub(roomName, string.find(roomName, "> ")+2) 
end

-- if not a portal, can set name/exits
if not roomPortal then
  map:setExits( getExitTable(xexits) )
  
  -- clear trailing whitespace
  roomName = roomName:trim()
  
  map:setRoomname(roomName)
end

-- pop last movement (if there was one)

local lastMovement = map:popMovement()

local testMovement = string.match( tostring(lastMovement), "^DRAG .* ([nsewud]).*")

if testMovement then
  if _G["echoDebug"] then
    echoDebug("<green>[testMovement: " .. tostring(testMovement) .. "]\n")
  end
  lastMovement=testMovement
end

-- if lastMovement was to unlock a door, pop again
if string.find(tostring(lastMovement), "^unlock ") then
  lastMovement = map:popMovement()
end

-- if lastMovement was to open a door, pop again

if string.find(tostring(lastMovement), "^open ") then
  lastMovement = map:popMovement()
end


-- this function is called twice (because of potential inserts)
sendBufferedMovements()
sendBufferedMovements()


if lastMovement then
  if lastMovement == "enter" then
    expandAlias("@find", false)
  else
    map:update(lastMovement)
  end
end

if not roomPortal then
  if map:getRoom() == nil then
    map:setRoom( map:findRoomID( map:getRoomname(), map:getExits(), true) )
  
    --map:update( map:getRoom() )
    map:update(nil)
  end
end

if xexits == nil then
  cecho("<red>[Error: nil match on exits]\n")
end

-- Does the mapper think I am where the mud thinks I am?

local id= map:getRoom()
    
if not roomPortal and id ~= nil and not forceFind then
  local mapRoomName = string.gsub(tostring( getRoomName( id )) , " %(.+%)", "")
  
  -- remove (airy), (water), etc before comparing
  
  if mapRoomName ~= string.gsub(tostring( map:getRoomname() ) , " %(.+%)", "")   then
    if displayMapErrors then
      cecho(string.format(" <red>[Error: mud '<cyan>%s<red>' doesn't match mapper '<cyan>%s<red>' at '<cyan>%d<red>'] ", map:getRoomname(), mapRoomName, id ) )
    end
  end
end

-- forceFind=nil

-- display vnum at the end of exits line
if displayVnum then
  if not roomPortal then
    if map:getRoom() ~= nil then
      cecho("<forest_green>" .. string.format("%" .. (15-string.len(xexits)) .. "s [%s] ", " ", map:getRoom() ))
    else
      cecho("<red>" .. string.format("%" .. (20-string.len(xexits)) .. "s [%s] ", " ", "Map not in sync, type <green>@find <red>or <green>scan<red> to attempt resync"))
    end
  else
    local clairedroomid = map:findRoomID( roomName, getExitTable(xexits), true)
    local clairzone = map:findRoomArea( roomName, getExitTable(xexits) )

    if clairzone == nil then
      cecho("<red>" .. string.format("%" .. (15-string.len(xexits)) .. "s [%s] ", " ", roomPortal))
    else
      if clairedroomid == nil then
        cecho("<red>" .. string.format("%" .. (15-string.len(xexits)) .. "s [%s: <green>%s<red>] ", " ", roomPortal, clairzone))
      else
        cecho("<red>" .. string.format("%" .. (15-string.len(xexits)) .. "s [%s: %d <green>%s<red>] ", " ", roomPortal, clairedroomid, clairzone))
      end
    end
  end
end

if _G["getHide"] then
  if getHide() then
    cecho("<blue> [Hidden]")
  end
end

echo("\n")

if map:countMovement() == 0 then
  if NyyLIB.tosend ~= nil then
    send(NyyLIB.tosend)
  end

   NyyLIB.tosend=nil 
end