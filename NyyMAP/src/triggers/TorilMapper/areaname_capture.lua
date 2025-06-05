local ZoneId
local ZoneName

ZoneId=tonumber(matches[2])
ZoneName=matches[3]:trim()

mudAreaTable[ZoneName] = ZoneId

--display(ZoneId)
