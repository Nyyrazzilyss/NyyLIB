-- map:getRoom() = nil (unknown) throws error

-- ^fwalk( [0-9A-Za-z]+)?( [A-Za-z]+)?


-- fwalk roomnum
-- fwalk add/del bookmarkname
-- fwalk bookmarkname

local var1
local var2

local addfwalk
local action=0

local tmpvar=charData:get("fwalk", true)

local tmplist={}

function fastwalk(xroomid)
  fwalkQue=false
  
  if roomLocked(xroomid) then
    cecho("<red>[Error: Destination room " .. xroomid .. " is locked]\n")
    return
  end

  if map:getRoom() == nil then
    cecho("<red>[Error: source room id is nil]\n")
    return
  end

  if getPath( map:getRoom(), xroomid) then
    doSpeedWalk()
  else
    cecho("<red>[Unable to find path to room#" .. xroomid .. "]\n")
  end
end

if tonumber(matches[2]) ~= nil then
  
  if inCombat() then
    fwalkQue=false

    cecho("<red>[Can't fwalk while in combat]\n")
    return(false)
  end

  fastwalk(tonumber(matches[2]))
else
  var1=string.trim(matches[2])
  var2=string.trim(matches[3])
  var3=string.trim(matches[4])

  if var1 == "help" then
    cecho("<red>Usage: @fwalk roomnumber    - fastwalk to specified room number\n")
    cecho("<red>       @fwalk name          - fastwalk to room indicated by fwalk name\n")
    cecho("<red>       @fwalk add name      - adds a fastwalk to the currently occupied room using 'name' \n")
    cecho("<red>       @fwalk add name vnum - adds a fastwalk to vnum using 'name' \n")
    cecho("<red>       @fwalk del name      - deletes fastwalk 'name'\n")
    cecho("<red>       @fwalk all           - list all fwalks regardless of location\n")
    cecho("<red>       @fwalk area          - list all fwalks in current area\n")
    return
  end
  
  echo("\n")

  if var1 == "all" then

    for k,v in pairs(charData:get("fwalk", true)) do

      if roomExists(v) then
        local zoneid=tonumber(getRoomUserData(v, "zoneid") )
        local pathlength=0

        if roomLocked(v) == false then
          if getPath( map:getRoom(), v) then
            pathlength=#speedWalkPath
          end
        end

        if pathlength ~= 0 then
          tmplist[#tmplist+1] = string.format("[%-30s] [%6d %-15s] [%3d] %s\n", NyyLIB.areaTable[zoneid], v, k, pathlength, getRoomName(v))
        else
          tmplist[#tmplist+1] = string.format("[%-30s] [%6d %-15s] [%3d] %s\n", NyyLIB.areaTable[zoneid], v, k, pathlength, getRoomName(v))
        end
      else
        tmplist[#tmplist+1] = string.format("[%-30s] [%6d %-15s] [%3s] %s\n", "", v, k, "", "")
      end
    end

    cecho("<white>             Area                  Room#      fwalk     Distance          Room Name\n")
    printSorted(tmplist)

    return
  end

  if var1 == "area" then

    local roomid= map:getRoom()

    local internalid = getRoomArea( roomid )
    local zone=getRoomUserData(roomid, "zoneid")
    local currentareazoneid=tonumber(zone)

    for k,v in pairs(charData:get("fwalk", true)) do

      if roomExists(v) then
        local zoneid=tonumber(getRoomUserData(v, "zoneid") )
        local pathlength=0

        if roomLocked(v) == false then
          if getPath( map:getRoom(), v) then
            pathlength=#speedWalkPath
          end
        end

        if zoneid == currentareazoneid then
          if pathlength ~= 0 then
            tmplist[#tmplist+1] = string.format("[%-30s] [%6d %-15s] [%3d] %s\n", NyyLIB.areaTable[zoneid], v, k, pathlength, getRoomName(v))
          else
            tmplist[#tmplist+1] = string.format("[%-30s] [%6d %-15s] [%3d] %s\n", NyyLIB.areaTable[zoneid], v, k, pathlength, getRoomName(v))
          end
        end
      --else
      --  tmplist[#tmplist+1] = string.format("[%-30s] [%6d %-15s] [%3s] %s\n", "", v, k, "", "")
      end
    end

    cecho("<white>             Area                  Room#      fwalk     Distance          Room Name\n")
    printSorted(tmplist)

    return
  end


  if map:getRoom() == nil then
    cecho("<red>[Current room is unknown. Type @find or scan]\n")
    return
  end

  -- check if var1 is existing marker - if so, fastwalk and exit

  for k,v in pairs(charData:get("fwalk", true)) do
    if k == var1 then
      cecho("<green>[Issue speedwalk to " .. var1 .. " at " .. v .. "]\n")
  
      fastwalk(v)

      return
    end
  end

  if var1 == "add" and var2 ~= nil then
    local targetroom = tonumber(var3) or map:getRoom()
   
    cecho("<green>[Adding fwalk for (" .. var2 .. ") to destination " .. targetroom .. "]\n")

    tmpvar[var2] = targetroom
    charData:set("fwalk", tmpvar, true)

    return
  end

  if var1 == "del" and tmpvar[var2] ~= nil then
    cecho("<green>[Deleting fwalk for (" .. var2 .. ") at destination " .. tmpvar[var2] .. "]\n")

    tmpvar[var2] = nil
    charData:set("fwalk", tmpvar, true)

    return
  end

  for k,v in pairs(tmpvar) do

    if roomExists(v) then
      local zoneid=tonumber(getRoomUserData(v, "zoneid") )
      local pathlength=0

      if roomLocked(v) == false then
        if getPath( map:getRoom(), v) then
          pathlength=#speedWalkPath
        end
      end

      if pathlength ~= 0 or map:getRoom() == v then
        tmplist[#tmplist+1] = string.format("[%-30s] [%6d %-15s] [%3d] %s\n", NyyLIB.areaTable[zoneid], v, k, pathlength, getRoomName(v))
      end
    end
  end

  cecho("<white>             Area                  Room#      fwalk     Distance          Room Name\n")
  printSorted(tmplist)
end