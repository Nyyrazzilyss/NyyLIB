if map:getRoom() ~= nil then
  if getRoomArea(map:getRoom()) ~= -1 then
    echo("[Room set]\n")
    map:setRoom(matches[2])
    centerview(map:getRoom())
  end
end