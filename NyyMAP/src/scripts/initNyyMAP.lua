-------------------------------------------------
--         Put your Lua functions here.        --
--                                             --
-- Note that you can also use external Scripts --
-------------------------------------------------

NyyLIB = NyyLIB or {}

showMap=true
displayVnum=true
displayMapErrors=true
autoOpen=true
moveBuffer= 10
 
function initNyyMAP()
  
  echo("\n\n\n")

  cecho([[<green>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO]])
  cecho("<green>THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE")
  cecho("<green>AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,")
  cecho("<green>TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN")
  cecho("<green>THE SOFTWARE.")

  echo("\n\n\n")

  --sysInstallPackage
  cecho("<red>[Initializing NyyMAP...]\n")

  -- remove generic_mapper

  if table.contains(getPackages(),"generic_mapper") then
    cecho("<red>[initNyyMAP: Removing generic_mapper...]\n")
    uninstallPackage("generic_mapper")
  end
  
  NyyLIB.version= "NyyLIB013dev"
  
  NyyLIB.homedir = getMudletHomeDir() .. "\\NyyMAP\\"

  NyyLIB.reversedirs   =   {
                     n   = "s",
                     e   = "w",
                     s   = "n",
                     w   = "e",
                     u   = "d",
                     d   = "u",
              north = "south",
              east = "west",
              south = "north",
              west = "east",
              up = "down",
              down = "up"
                     }

  NyyLIB.fulldirs = {
                  n = "north",
                  e = "east",
                  s = "south",
                  w = "west",
                  u = "up",
                  d = "down"
                }

  -- enable mapper

  mudlet = mudlet or {}; mudlet.mapper_script = true
  expandAlias("@map init", false)

  -- only load mapfile if loaded map is < 35000 rooms i.e. not mudlet loaded mapfile

  if map:countRooms() < 35000 then
    map:loadMap()
  end

  map:initAreatable()

  -- loading charData table
  charData:load()

  NyyLIB.initcompleted = true

  --registerAnonymousEventHandler("AdjustableContainerReposition", "AdjustableContainerReposition")

  registerAnonymousEventHandler("newRoomEvent", "newRoomEvent")

  -- load window locations
  loadWindowLayout()

  cecho ("<red>[NyyMAP initialized.]\n")
end