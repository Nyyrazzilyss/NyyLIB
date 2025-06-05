-------------------------------------------------
--         Put your Lua functions here.        --
--                                             --
-- Note that you can also use external Scripts --
-------------------------------------------------
function newRoomEvent(event, xroom)
  -- this event is called from map:update after every new room is entered

  --Example: snap after entering a particular room
  --if xroom == 79574 then
  --  send("snap")
  --end

  alreadyEnteredPortal=nil

  if xroom ~= nil then
    
    if _G["spell"] then
      spell:setMoving(true)
      spell:setMem(false)
    end
    
    memsent = false

    meleePowerUsed=false

    -- pet command couldn't have been sent
    petcommand = nil

    -- nomagic is a variable to stop casting (beholder, etc)
    nomagic=nil

  end

  if _G["spell"] then
    spell:setCast() -- reset
  end
end