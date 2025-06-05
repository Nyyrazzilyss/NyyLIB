-- room entry into a pitch black room

-- last command entered was look or scan - return
if string.find(command, "l ") == 1 or string.find(command, "look ") == 1 or command == "SCAN" then
  return
end

-- pop last movement (if there was one)

local lastMovement = map:popMovement()

if lastMovement then
  if lastMovement == "enter" then
    expandAlias("@find", false)
  else
    map:update(lastMovement)
  end
end