-- ([A-Za-z]+) has died!

--local bodyMatch= getColourString( matches[2] )

if not chatCapture then
  chatCapture=true
  demonnic.chat:append("SKILL", bodyMatch)
end