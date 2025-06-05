local dir=matches[3]:sub(1,1):lower()

NyyLIB.doorbash = dir

if _G["mud"] then mud:send("DOORBASH " .. dir, false) else send("DOORBASH " .. dir) end