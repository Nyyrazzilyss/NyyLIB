-- can't be moving TODO: trying to spam recline?

disableTrigger("minimap display")  

map:clearQueue()

if _G["spell"] then
  spell:stop() -- set spell.casting=nil
  spell:clear()

  spell:setMoving(false)
end

if _G["setHide"] then
  setHide(false)
end