-- Your ship sails ([nswe]).*ward[.]

if _G["spell"] then
  -- currently moving
  spell:setMoving(true)

  -- erase spellqueue if any spells present
  spell:eraseQueue()
end

scanned={}

map:update(matches[2])