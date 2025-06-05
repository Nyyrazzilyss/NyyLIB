-------------------------------------------------
--         Put your Lua functions here.        --
--                                             --
-- Note that you can also use external Scripts --
-------------------------------------------------
charData = charData or {}

-- xkey - the variable to initialize
-- xval - value of the variable
-- xtop - true - This variable is for all profiles, not a single character

-- Limited charData functions for fwalk

function charData:set(xkey, xval, xtop)
  if xtop ~= nil then
    self[xkey] = xval
  else
    echo("charData script error: 38\n")
  end
end

-- should return initial value if key doesn't exist

function charData:get(xkey, xtop)
  if xtop ~= nil then
    -- key is top level

    if self[xkey] ~= nil then
      return(self[xkey])
    end
  else
    echo("charData script error: 52\n")
  end

  -- doesn't exit, should return initial value from setvar table
  -- tables (i.e. condensed) always exist
  
  if xkey == nil then
    echo("\n<red>[nil xkey value]\n")
  else
    echo("\n<red>[Warning: key " .. xkey .. " does not exist]\n")
  end

  return(nil)
end

function charData:save()
  table.save(homepath("chardata.dat"), self )
  cecho("\n<red>[Saved CharData table]\n")
end

function charData:load()
  local is_file = io.open(homepath("chardata.dat"))

  cecho("<red>[Loaded charData]\n")
  
  if is_file ~= nil then
    table.load(homepath("chardata.dat"), self)
  end

  self.fwalk = self.fwalk or {}
  
  return
end
