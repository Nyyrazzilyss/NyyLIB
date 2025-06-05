function mapUpdate(k, v)
  -- k is function name. v is filename
  
  --display(v)
    
  if v == "toril.map" then
    cecho("<green>Map download completed.\n")

    copyFile(v, mainpath(v))

    -- display( mainpath(v) )

    -- delete the downloaded file
    os.remove(v)
  end
end