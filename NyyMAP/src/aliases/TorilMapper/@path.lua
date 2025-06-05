-- findpath either to room number or fwalk name

function tt(s)
   local t={}

   for p in s:gmatch("..?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?") do
       t[#t+1]=p
   end

   for i,v in ipairs(t) do
       print("." .. v)
   end

  echo("\n")
end


function showfastwalk(xroomid)
  if roomLocked(xroomid) then
    cecho("<red>[Error: Destination room is locked]\n")
    return
  end

  assert(map:getRoom(), "[Error: source room id is nil]")

  if getPath(map:getRoom(), xroomid) then
    local path= compressSpeedwalk()

    if #speedWalkPath > 100 then
      cecho("<red>Path length: <green>" .. #speedWalkPath .. " <red>rooms 100th room <green> " .. speedWalkPath[100] .. "\n\n")
    else
      cecho("<red>Path length: <green>" .. #speedWalkPath .. " <red>rooms\n\n")
    end

    cecho("<red>Path from current room (" .. map:getRoom() .. ") to " .. xroomid .. " (" .. getRoomName(xroomid) .. ")\n")


    --echo("Rooms we'll pass through: " .. table.concat(speedWalkPath, ", ") .. "\n\n")

    cecho("<green>Speedwalk: ." .. compressSpeedwalk() .. "\n\n")

    if string.len(path) > 100 then
      tt(path)
    end

    cecho("<red>Reverse path from " .. xroomid ..  " (" .. getRoomName(xroomid) .. ") to current room: " .. map:getRoom() .. " (" .. getRoomName(map:getRoom()) .. ")\n")

    getPath(xroomid, map:getRoom())

    cecho("<green>Speedwalk: ." .. compressSpeedwalk() .. "\n\n")

  else
    cecho("<red>[Unable to find path to room vnum " .. xroomid .. "]\n")
  end
end

if tonumber(matches[2]) ~= nil then
  showfastwalk(tonumber(matches[2]))
else
  for k,v in pairs(charData:get("fwalk", true)) do
    if k == matches[2] then
      showfastwalk(v)
      return
    end
  end
end
