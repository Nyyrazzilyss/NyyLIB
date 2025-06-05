local roomTable= getRooms()

colourtable = {}

colourtable.rooms={}

for k,v in pairs(roomTable) do
  colourtable.rooms[k]=getRoomEnv(k)
end

colourtable.env= getCustomEnvColorTable()

table.save(getMudletHomeDir().."/colours.lua", colourtable)
