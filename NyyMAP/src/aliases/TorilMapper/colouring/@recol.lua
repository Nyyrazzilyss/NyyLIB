-- westgate

expandAlias("@stylerooms * 600 356") -- set all rooms in westgate to 600

expandAlias("@stylerooms (water) 268 356") -- water

for _,x in ipairs({"way", "lane", "ride", "walk", "march", 
                   "spur", "street", "loop"}) do
  expandAlias("@stylerooms " .. x .. " 85 356")
end





-- setRoomEnv

-- setCustomEnvColor(environmentID, r,g,b,a)

-- default room: 600 {47,79,79}
-- setCustomEnvColor(600, 47, 79, 79, 255)

setCustomEnvColor(600, 47, 79, 79, 255)

expandAlias("@stylerooms * 600 237") -- set all rooms in silverymoon to 600

expandAlias("@stylerooms park 258 237")
expandAlias("@stylerooms silverglen 258 237")

expandAlias("@stylerooms road 527 237")
expandAlias("@stylerooms approaching 527 237")

-- inner roads

for _,x in ipairs({"ghostwalk", "wallrun", "ride", "lane", "avenue", 
                   "helmer", "moonway", "druinwood", "street"}) do
  expandAlias("@stylerooms " .. x .. " 272 237")
end

-- silverymoon guildmasters

setRoomEnv(48586, 269) -- Ersenas
setRoomEnv(49036, 269) -- Dragor
setRoomEnv(49025, 269) -- Voundeld
setRoomEnv(49021, 269) -- Paol
setRoomEnv(49135, 269) -- Ultruum
setRoomEnv(49032, 269) -- Arkhen
setRoomEnv(48882, 269) -- Willa
setRoomEnv(49054, 269) -- Tathshandra
setRoomEnv(48934, 269) -- Atenman
setRoomEnv(48863, 269) -- Baerim

-- Ashstone

expandAlias("@stylerooms Caravansary Way 259 85")
expandAlias("@stylerooms road 259 85")
expandAlias("@stylerooms Caravansery Way 259 85")
expandAlias("@stylerooms Dragon Plaza 259 85")
expandAlias("@stylerooms garden 258 85")
expandAlias("@stylerooms dragonride 259 85")

-- Scardale
expandAlias("@stylerooms lane 272 213")
expandAlias("@stylerooms street 272 213")
expandAlias("@stylerooms park 258 213")
expandAlias("@stylerooms Bazaar 600 213")
expandAlias("@stylerooms Arena 600 213")
expandAlias("@stylerooms Cemetery 600 213")

-- banks
setRoomChar(44, "$")    -- The Banker Of Mithril Hall
setRoomChar(4644, "$")  -- First Merchantile Bank of Scornubel
setRoomChar(4901, "$")  -- The Bank
setRoomChar(7307, "$")  -- The Royal Bank of Leuthilspar
setRoomChar(8386, "$")  -- United Luiren Bank of Faerun
setRoomChar(9017, "$")  -- The Bank of Zhentil Keep
setRoomChar(10703, "$") -- The Bank of Northern Waterdeep
setRoomChar(10894, "$") -- The Bank of Southern Waterdeep
setRoomChar(11602, "$") -- The Bank of Faang
setRoomChar(11967, "$") -- The Bank of Ghore
setRoomChar(15459, "$") -- The Northern Bank of Bryn Shander
setRoomChar(15505, "$") -- The Eastern Bank of Bryn Shander
setRoomChar(73057, "$") -- The Gloomhaven First Trust Bank
setRoomChar(90028, "$") -- The Bank of Bloodtusk
setRoomChar(74573, "$") -- A Dark Hidden Bank
setRoomChar(84203, "$") -- The Bank of Silverymoon
setRoomChar(80637, "$") -- Skullport Bank
setRoomChar(45963, "$") -- The Scardale Common Bank
