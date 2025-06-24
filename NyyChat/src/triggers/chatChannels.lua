--display(matches[2])
local whoMatch= getColourString( matches[2] )
--display(matches[3])
local channel = matches[3]
local channelMatch= getColourString( matches[3] )
--display(matches[4])
local bodyMatch= getColourString( matches[4] )

if not chatCapture then
  chatCapture=true
  
  --display(matches[3])
  
  local checkUrl = getUrl(matches[4])

  --display(checkUrl)
  
  --display("X")
  
  demonnic.chat:hechoLink(channel, whoMatch, [[nilFunction()]], getTime(true, "ddd hh:mm AP"), true )
  demonnic.chat:hechoLink("ALL", whoMatch, [[nilFunction()]], getTime(true, "ddd hh:mm AP"), true )
  
  if checkUrl then
    demonnic.chat:hechoLink(channel, bodyMatch .. "\n", [[openUrl("]] .. checkUrl .. [[")]], checkUrl, true )
    demonnic.chat:hechoLink("ALL", channelMatch .. ": " .. bodyMatch .. "\n", [[openUrl("]] .. checkUrl .. [[")]], checkUrl, true )
  else  
    demonnic.chat:hecho(channel, bodyMatch .. "\n", true)
    demonnic.chat:hecho("ALL", channelMatch .. ": " .. bodyMatch .. "\n", true)
  end
end

--display(whoMatch)
--display(bodyMatch)