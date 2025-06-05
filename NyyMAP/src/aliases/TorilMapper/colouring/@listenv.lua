local env= tonumber(matches[2])
local roomTable= getRooms()

--hecho(string.format("\n#%02x%02x%02x Color entry: %d { %d %d %d }", v[1], v[2], v[3], k, v[1], v[2], v[3]) )

for k,v in pairs(roomTable) do
  if getRoomEnv(k) == env then
    cecho(string.format("<green>%30s Room ID: %6d  %s\n", getRoomAreaName(getRoomArea(k)), k, v))
  end
end


