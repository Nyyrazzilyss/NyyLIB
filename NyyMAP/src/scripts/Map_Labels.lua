function map:passwordLabel(xroomid, xpw)
 -- "10749 1 red black Northern Waterdeep Main City"

  local tmp=xroomid .. " 7 green black " .. xpw

  map:roomLabel(tmp)
end


-- room label the room I'm in
-- room label 342 this is a label in room 342
-- room label green this is a green label where I'm at
-- room label green black this is a green to black label where I'm at
-- room label 34 green black this is a green to black label at room 34
-- how it works: split input string into tokens by space, then determine
-- what to do by checking first few tokens, and finally call the local
-- function with the proper arguments
--taken from Vadi
--input is room number, fgcolor, bgcolor, message

function map:roomLabel(input)
  local tk = input:split(" ")
  local room, direction, fg, bg, message

  -- input always have to be something, so tk[1] at least always exists
  if tonumber(tk[1]) then
    room = tonumber(table.remove(tk, 1)) -- remove the number, so we're left with the direction, colors or msg
  end

  if tonumber(tk[1]) then
    direction = tonumber(table.remove(tk, 1)) -- remove the number, so we're left with the colors or msg
  end

  -- next: is this a foreground color?
  if tk[1] and color_table[tk[1]] then
    fg = table.remove(tk, 1)
  end

  -- next: is this a backround color?
  if tk[1] and color_table[tk[1]] then
    bg = table.remove(tk, 1)
  end

  -- the rest would be our message
  if tk[1] then
    message = table.concat(tk, " ")
  end

  -- if we haven't provided a room ID and we don't know where we are yet, we can't make a label
  if not room then
    echo("We don't know where we are to make a label here.") return
  end

  -- x,y,z = getRoomCoordinates(roomID) Returns the room coordinates of the given room ID.
  
  local x,y,z = getRoomCoordinates(room)
  local f1,f2,f3 = unpack(color_table[fg])
  local b1,b2,b3 = unpack(color_table[bg])

--  [1] = "north",
--  [2] = "northeast",
--  [3] = "northwest",
--  [4] = "east",
--  [5] = "west",
--  [6] = "south",
--  [7] = "southeast",
--  [8] = "southwest",
--  [9] = "up",
--  [10] = "down",
--  [11] = "in",
--  [12] = "out",

  local length = string.len(message)

  if direction == 1 then -- north
    y=y+4
    x=x-length/3.5
  end

  if direction == 4 then -- east
    y=y+1
    x=x+.5+1
  end

  if direction == 5 then -- west
    --y=y+.5
    y=y+1
    --x=x-(length/1.5)-.5-1
    x=x-(length)-.5-1
  end

  if direction == 6 then -- south
    y=y-2
    x=x-length/3.5
  end

  if direction == 7 then -- se password
    x=x+.25
    y=y+.25
  end

  -- finally: do it :)
  if (z) then
  -- fontsize: 15
  -- labelID = createMapLabel(areaID, text, posx, posy, posz, fgRed, fgGreen, fgBlue, bgRed, bgGreen, bgBlue, zoom, fontSize, showOnTop, noScaling)
    local lid = createMapLabel(getRoomArea(room), message, x, y, z, f1,f2,f3, b1,b2,b3, 15, 15, false, false)
  --echo(string.format("Created new label #%d '%s' in %s.", lid, message, getRoomAreaName(getRoomArea(room))))
  end
end
