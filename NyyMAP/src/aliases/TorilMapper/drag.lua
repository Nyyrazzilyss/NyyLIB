-- drag corpse in direction

if _G["spell"] then
  -- set as currently moving
  spell:setMoving(true)

  if checkMask("caster") then
    -- erase spellqueue if any spells present
    spell:eraseQueue()

    -- disable autocast
    buttons:change("autocast", false, "SpellsButton")
  end
end

-- erase scanned table
scanned={}

local dir=matches[3]:sub(1,1):lower()

if _G["echoDebug"] then
  echoDebug("Drag: " .. matches[1] .. "\n")
end

toGagLook=nil
gaglook=nil

map:processMovement("DRAG " .. matches[2] .. " " .. matches[3])