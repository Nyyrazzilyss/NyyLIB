gaglook=nil

--display("X")

if _G["mud"] then mud:send("L" .. (matches[3] or "") ) else send("L" .. (matches[3] or ""), false ) end
