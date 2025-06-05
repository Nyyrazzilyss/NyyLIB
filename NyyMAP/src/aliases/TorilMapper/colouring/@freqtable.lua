local ftable={}
local targetzone=0

if matches[2] then
  targetzone=tonumber(matches[2])
end

for k,v in pairs(getRooms()) do
  local rzone=tonumber(getRoomUserData(k, "zoneid"))
    
  if targetzone==0 or targetzone==rzone then
    roomwords= string.split( string.lower(v), " ")

    for k2, v2 in pairs(roomwords) do
      if not table.contains({ "the", "a", "of", "in", "an", "at", "on" }, v2) then -- words to exclude
        ftable[v2]=ftable[v2] or 0
        ftable[v2]=ftable[v2]+1
      end
    end
  end
end


local arr = {}

for key, value in pairs(ftable) do
  arr[#arr + 1] = {key, value}
end


table.sort(arr, function(a,b) return a[2] > b[2] end )

display(#arr)


for nx=0,38,1 do  -- math.floor(#arr/7)
  for dx=1,7,1 do
    local entry=nx*7+dx
    
    if arr[entry] then
      echo( string.format("%d) %s (%d) ", entry, arr[entry][1], arr[entry][2]) )
    end
  end
    
  echo("\n")
end