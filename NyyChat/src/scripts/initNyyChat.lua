chat = chat or {}

function initNyyChat(event, packageName)

  if packageName ~= "NyyChat" then return end
    
  -- copy EMCO data files
  copyNyyEmco()
  
  -- Install mpkg if not present

  if not table.contains(getPackages(),"mpkg") then
    installPackage("https://github.com/Mudlet/mudlet-package-repository/raw/refs/heads/main/packages/mpkg.mpackage")
  end

  -- Install emco if not present
  
  if not table.contains(getPackages(),"EMCOChat") then
    tempTimer(1, [[installPackage("https://github.com/Mudlet/mudlet-package-repository/raw/refs/heads/main/packages/EMCOChat.mpackage")]] )
    tempTimer(3, [[resetProfile()]])
  end
end

function copyNyyEmco()
  
  lfs.mkdir( getMudletHomeDir() .. "//EMCO" )

  copyFile( getMudletHomeDir() .. "//NyyChat//EMCO//EMCOPrebuiltChat.lua",
            getMudletHomeDir() .. "//EMCO//EMCOPrebuiltChat.lua"  )


  copyFile( getMudletHomeDir() .. "//NyyChat//EMCO//EMCOPrebuiltExtraOptions.lua",
            getMudletHomeDir() .. "//EMCO//EMCOPrebuiltExtraOptions.lua"  )

end

-- Toggle the chat window on/off

function chat:toggle()
  if not EMCO.auto_hidden then
    cecho("<red>[Chat display is OFF.]\n")
    
    expandAlias("emco hide", false)   
  else
    cecho("<red>[Chat display is ON.]\n")

    expandAlias("emco show", false)    
  end
end

function copyFile(ifile, ofile)
  local inp = assert(io.open(ifile, "rb"))
   local out = assert(io.open(ofile, "wb"))
    
   local data = inp:read("*all")
   out:write(data)
    
   assert(out:close())
  assert(inp:close())
end
