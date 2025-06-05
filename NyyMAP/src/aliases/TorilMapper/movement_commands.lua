-- paging mode needs to be fixed
--if pagingmode then
--  mud:send("")
--  return
--end

-- Feyblade has a 'ea' command
if matches[2] == "ea" and subClass == "Feyblade" then return end

if _G["spell"] then
  -- currently moving
  spell:setMoving(true)

  -- erase spellqueue if any spells present
  spell:eraseQueue()
end

-- erase scanned table
scanned={}

local dir=matches[2]:sub(1,1):lower()

map:processMovement(dir)

toGagLook=nil
gaglook=nil