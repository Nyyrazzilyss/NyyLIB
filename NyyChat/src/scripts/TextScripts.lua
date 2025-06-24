-- return the current line in a table with hex encoded colours (in decimal)

-- formating: string, fg table {position, colour}

hextable = hextable or 
   {
  textLine = nil,
  colourTable = {}
    }

function nilFunction()
  return
end



-- colourString
-- this function should colour a string as it appeared in current line then return a hex encoded string or table? 

function getColourString(xstring)
  local table=getColourLine()
  local pos=string.find(table.textLine, xstring, 1, true) -- string.find is base 1

  local cr=0
  local cg=0
  local cb=0

  local retstring = ""
  
  if table==nil then
    return(false)
  end
  
  if pos==nil then
    return(false)
  end
  
  for nx=pos, pos+#xstring-1, 1 do
    if table.colourTable[nx][1] ~= cr or table.colourTable[nx][2] ~= cg or table.colourTable[nx][3] ~= cb then
      cr= table.colourTable[nx][1]
      cg= table.colourTable[nx][2]
      cb= table.colourTable[nx][3]

      retstring = retstring .. string.format("|c%02x%02x%02x", cr, cg, cb)
    end
  
    retstring = retstring .. string.sub(table.textLine, nx, nx)
  end

  return(retstring)
end


function getColourLine()
  local nx

  local r,g,b
  local lineCapture = {}
  
  local currentLine

  -- selectSection(from, how long) 0 based (0,1) = first character of line

  moveCursorEnd("main")
  hextable.textLine = getLines(getLineCount(), getLineCount()-1)[1]

  hextable.colourTable = {}

  for nx=0, #hextable.textLine-1, 1 do
    selectSection(nx, 1) -- selectSection is base 0
  
    r,g,b = getFgColor()
  
    hextable.colourTable[nx+1] = { r, g, b }
  end

  return(hextable)
end

function tableToHexColour(xtable)
  local retstring = ""
  
  local cr=0
  local cg=0
  local cb=0
  
  for nx=1,#xtable.textLine, 1 do
    if xtable.colourTable[nx][1] ~= cr or xtable.colourTable[nx][2] ~= cg or xtable.colourTable[nx][3] ~= cb then
      cr= xtable.colourTable[nx][1]
      cg= xtable.colourTable[nx][2]
      cb= xtable.colourTable[nx][3]

      retstring = retstring .. string.format("|c%02x%02x%02x", cr, cg, cb)
    end
  
    retstring = retstring .. string.sub(xtable.textLine, nx, nx)
  end

  --display(xtable)

  return(retstring)
end

function nilFunction()

end