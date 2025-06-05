-- currently moving
spell:setMoving(true)

-- erase spellqueue if any spells present
spell:eraseQueue()


-- erase scanned table
scanned={}

local dir=matches[2]:sub(1,1):lower()

toGagLook=nil
gaglook=nil

map:processMovement("MOVEA " .. dir)