if mapAdjCon.isUserWindow then
  mapAdjCon:onDoubleClick()
  convertAdj.sendToPosition(nil, nil, "63.6%", 0, "main")
  mapAdjCon:resize("36.2%", "30.9%")
else
  mapAdjCon:move("63.6%", 0)
  mapAdjCon:resize("36.2%", "30.9%")
  mapAdjCon:show()
end
