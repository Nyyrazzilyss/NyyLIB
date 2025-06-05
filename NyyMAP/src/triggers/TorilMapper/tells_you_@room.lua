local roomid = map:getRoom()

if roomid ~= nil then
  local zoneid=tonumber(getRoomUserData(roomid, "zoneid") )

  if _G["mud"] then 
    mud:send("T " .. matches[2] .. " " .. roomid .. ", " .. getRoomName(roomid) .. " : " .. NyyLIB.areaTable[zoneid] .. "\n")
  else
    send("T " .. matches[2] .. " " .. roomid .. ", " .. getRoomName(roomid) .. " : " .. NyyLIB.areaTable[zoneid] .. "\n")
  end
else
  if _G["mud"] then 
    mud:send("T " .. matches[2] .. " Map not currently in sync")
  else
    send("T " .. matches[2] .. " Map not currently in sync")
  end
end