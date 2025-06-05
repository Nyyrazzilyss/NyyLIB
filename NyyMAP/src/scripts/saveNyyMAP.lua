-------------------------------------------------
--         Put your Lua functions here.        --
--                                             --
-- Note that you can also use external Scripts --
-------------------------------------------------
function saveNyyMAP()
  saveWindowLayout()
  
  charData:save()

  -- save to map folder
  saveMap( "" )

  expandAlias("@map save", false)
end