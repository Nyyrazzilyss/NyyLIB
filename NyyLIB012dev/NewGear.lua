-------------------------------------------------
--         Put your Lua functions here.        --
--                                             --
-- Note that you can also use external scripts --
-------------------------------------------------

NewGear = NewGear or {}

NewGear.items = {}
  
NewGear.spreadsheet = {
  Bahamut = {
    {"a silver ring with mirrored finish", "finger", "75 hp, -4 svsp, Priest only", "Powers: Csan, all attackers stop attacking you, 3 min cd"},
    {"a heavy flail of meteoric iron", "wield", "3d6, 3% cr, 2x cb, sonic/sonic burst/keen/thundering/force 100%, 5 hit 5 sf heal", "Powers: Proc curse on every hit"},
    {"platinum scalemail of the faithful", "body", "30 hp, sf 5 healing, 5% pierce, good war/priest only", "Powers: cshroud, 3 dam -5 sv spell, 3 min buff, 12 min cd"},
    {"a crown of the death dragon", "head", "30 hp, 6 dam, 5% elements, !good, warrior only", "Powers: Aotdd, increases threat"},
    {"a woven mithril mantle of the Battlerager", "about", "ac 21, 4 dam, -5 svbr, 5% blud/fire/cold, !evil, warrior/priest only", "Powers: Battlerage command, berserk, +2/+2"},
    {"the blood-soaked bastion of defense", "shield", "ac 25, 25 hp, -5 svsp, Warrior only", "Powers: Bog, 5 hp vamp per melee hit, 10% damage reduction"},
    {"the hollowed claw of a balor demon", "finger", "ac4 4 dam, !good thief only", "Powers: Wings of the Balor, fly"},
    {"an adamantium cloak of elvenkind", "about", "ac 15 2% unarmed 4 dam 50 mv, !evil, thief only", "Powers: Camo"},
    {"a rune etched dragonscale of incarnadine hue", "eyes", "ac8 5% fire 3dam 4 maxagi, !cleric/mage , Di/sense", ""},
    {"a belt of black dragon scales", "waist", "ac 10 5% cold 25 hp 5 sf necro mage only", ""},
    {"the crystallized tear of an astral deva", "ear", "20 hp, -5 svsp, mage only", "Powers: Remove silence/major para/stuff"},
    {"a staff of radiance", "weapon", "4d4 3 cr 2 cb, keen, brilliant, 30 hp 5 hitroll, proc radiant pattern mage only", "Powers: 75 hp 10 hitroll for 3 min, 12 min cd"},
    {"a icy white dragon mask", "face", "ac 10 10% cold 20 hp 8 sf spirit, priest only", ""},
    {"a stygian black dragon mask", "face", "ac 10 5% slash 10% acid 12 hp 6 maxagi, warrior only", ""},
    {"a vibrant green dragon mask", "face", "ac 10 10% poison 20 hp 8 sf nature, priest only", ""},
    {"a brilliant blue dragon mask", "face", "ac 10 10% elect 20 hp 8 sf heal, priest only", ""},
    {"a fiery red dragon mask", "face", "ac 10 10% fire 4 dam 8 maxstr, rogue only", ""},
    {"a ring of wizardry", "finger", "80 hp, 10 AC, proc mem, mage only", ""},
    {"a star-metal chainmail hood of boundless thought", "head", "AC 12 50 hp/mana", "Powers: proc mana in combat"},
    {"a strand of nine pearls", "neck", "ac 10 20 hp 15 maxwis priest only", "Powers: proc mem"},
    {"a celestial longbow of carved yew wood", "ranged", "4d6 3% cr 3x cb 100% holy/holy burst, 6/6", "", {"magic", "bless", "float", "two_hand"}},
    {"a crimson-edged obsidian blade", "weapon", "6d6 6% cr 5cb keen/vampiric/unholy/axiomatic 6/6", "Powers: proc blind", {"magic", "two_hand"}},
    {"a golden-edged moonstone blade", "weapon", "6d6 6% cr 5cb keen/holy/anarchic/brilliant", "Powers: proc heal", {"magic", "two_hand"}},
    {"snow-white boots of speed", "feet", "ac12 20hp -6 ss perm haste, priest/bchanter only", ""},
    {"the paws of the cheetah", "feet", "ac 8 3/3 warrior/thief only", "Powers: haste for 54 seconds, 60s cd, eats up power cd"},
    {"a dragontooth of Lareth", "weapon", "4d4 9% cr 2 cb flaming/flaming burst/keen 100%, 5/5", "Powers: fear, -84 str, I forget the last one"},
    {"a dragonhide component bag", "component bag", "ac 5 5 agi", ""},
    {"a dragonhide ammo belt", "bandolier", "ac 5 1 dam", ""},
    {"a fine silk haversack stitched with platinum thread", "component bag", "ac 5 25 mv", ""},
    {"a crown of the north wind", "head", "ac 10 5% prot elements 40 hp 7 hitroll priest/warrior only !evil", "Powers: break procs, powers: minor para, fear, slow, flee, sleep"},
    {"a bracelet of brainstealer scales", "wrist", "Illithid only, ac 10 5% prot elements, 25 hp, 50 mana", "Powers: eats a sub 500 hp pet for mana I think"},
    {"a belt of mercury dragon scales", "waist", "ac 15 5% poison 25 hp 5 maxagi priest/mage only", "Powers: power invis, cd 15s"},
    {"a thrumming deep crystal on an adamantine chain", "ear", "20 hp, 5 maxagi, !female !male", "Powers: 20 normal all stats, 2 min duration, 12 min cd"},
    {"a torque of aquatic dragon scales", "neck", "ac 10 5% acid 20 hp 5 sf illu mage only", ""},
    {"some sleeves of gold dragon scales", "arms", "ac 10 5% poison, 20 hp 5 sf elem, mage only", ""},
    {"a bracelet of silver dragon scales", "wrist", "ac 10 5% elect 20 hp 5 sf ench, mage only", ""},
    {"some boots of brass dragon scales", "feet", "ac 10 5% fire 20 hp 5 sf focus, mage only", ""},
    {"an orb of green dragonkind", "shield", "ac15 35hp 8sf_ill", ""},
    {"an orb of white dragonkind", "shield", "ac15 35hp 8sf_ele 10%pfc power:dogow mage-only", ""},
    {"a laminated harp strung with sirine hair", "instrument", "5% breaths 35 hp", ""},
    {"a mithril flute with silver inlays", "instrument", "35hp 50mana bard/bchanter-only", ""},
    {"a vial of Bahamut's cleansing", "potion", "L59 divine purification, dispel magic, remove curse", ""},
    {"a vial of feculent pustulence", "drink", "large unholy water container", ""},
    {"a badge of the Bronze Knights", "badge", "1 mana", ""}


  },
  Ashstone = {
    {"an iron vambrace studded with bloodstones", "arms", "ac10 15hp -5bre pff farsee pr-evil pr-good, anyone can wear except good aligned", "", {}, "(Q)"},
    {"a sharpened rapier studded with rubies", "weapon", "dam:4 Hit:2 * (Weapon) Crit:9% Multi:2x (Class: Martial, Type: Rapier) * MAGIC !Cleric !Mage * Flaming 100% 100% 0 0 - Flaming Burst 100% 100% 0 0 - Keen 100% 100% 0 0", "", {}, "(Q)"},
  },
  Baphomet = {
    {"a spiked iron choker 2", "waist", "ac9 2 hit 2 dam 4% unarmed resist", ""},
    {"a helm of Clangeddin''s might", "head", "ac15 20hp 5maxcon", ""},
    {"a dismal ring of the under-realms", "finger", "dismal is 65hp4maxagi !warrior", ""},
    {"a white-gold ring of the heirlooms", "finger", "ac6 10maxstr, nobits", ""},
    {"glowing geometrical designs tattooed on the hands", "hands", "ac7 5%spells 5%pff 4sf_ill 5maxint", ""},
  }
}

function NewGear:getNextId()
	recs = assert(NyyLIB.conn:execute([[select max(item_id) as maxid from items]]))
	row = recs:fetch({})
	id = 0
	while row do
	  id = row[1] + 1
		row = recs:fetch({})
	end
  recs:close()
	return id
end

function NewGear:reset()
  for zone, litem in pairs(NewGear.spreadsheet) do
    for _, tbl in ipairs(litem) do
      NewGear:delete(tbl[1])
    end
  end
end

function NewGear:findByItem(item)
  return NewGear:findByName(item.item_name)
end

function NewGear:findByName(gear)
  local sql = string.format(
    [[select item_id from items where item_name = '%s']],
    NyyLIB.conn:escape(gear)
  )
  -- display(sql)
  local recs = assert(
    NyyLIB.conn:execute(sql)
  )
  local ids = {}
  local row = recs:fetch({})
  while row do
    table.insert(ids, row[1])
 		row = recs:fetch({})
  end
	recs:close()
  return ids
end

function NewGear:existsItem(item)
  return NewGear:exists(item.item_name)
end

function NewGear:exists(gear)
  local ids = NewGear:findByName(gear)
  return #ids > 0
end

function NewGear:deleteById(item_id)
  local sql = string.format([[DELETE FROM items where item_id = %d]], item_id)
	display(sql)
	local res = assert(NyyLIB.conn:execute(sql))
	display(res)
  sql = string.format([[DELETE FROM item_flags where item_id = %d]], item_id)
  display(sql)
	res = assert(NyyLIB.conn:execute(sql))
	display(res)
end

function NewGear:delete(gear)
  local ids = NewGear:findByName(gear)
  if #ids == 0 then
    return false -- Nothing to delete
  end
  if #ids > 1 then
    cecho(string.format(
      [[<red>[TOO MANY IDS] "%s": {%s}\n]],
      gear, table.concat(ids, ", ")
    ))
    return false -- Too many IDs returned
  end
  NewGear:deleteById(ids[1])
  return true
end

function NewGear:insert(item)
	new_id = NewGear:getNextId()
	sql = string.format([[INSERT INTO items
VALUES (%d, '%s', '%s',
 %d, %d, '%s',
 '%s', '%s', '%s',
 '%s', '%s', '%s',
 '%s')]],
			new_id, NyyLIB.conn:escape(item.item_name), item.keywords,
			item.weight, item.c_value, item.item_type,
			item.from_zone, item.from_mob, NyyLIB.conn:escape(item.short_stats),
			NyyLIB.conn:escape(item.long_stats), 
      NyyLIB.conn:escape(item.full_stats), item.comments,
			item.last_id)
	display(sql)
	res = assert(NyyLIB.conn:execute(sql))
	display(res)
	for _, iflag in ipairs(item.flags) do
		sql = string.format([[INSERT INTO item_flags
VALUES (%d, '%s')]],
			new_id, iflag)
		display(sql)
		res = assert(NyyLIB.conn:execute(sql))
		display(res)
	end
end

function NewGear:init()
  local gearItems = {}

  for zone, ilist in pairs(NewGear.spreadsheet) do
    for _, tbl in ipairs(ilist) do
      display(tbl)
      local fl = tbl[5]
      local R = tbl[6]
      if fl == nil then
        fl = {}
      end
      if R == nil then
        R = " (R)"
      else
        if R ~= "" then
          R = " " .. R
        end
      end
      -- remove this variable to have it debug via display()
      local IGNORE=[[
      display(
        {
          tbl1 = tbl[1],
          tbl2 = tbl[2],
          tbl3 = tbl[3],
          tbl4 = tbl[4],
          zone = zone,
          R = R
        }
      )
      ]]
      local it = {
  			item_id = -1,
  			item_name = tbl[1],
  			keywords = "",
  			weight = 1,
  			c_value = 77700,
  			item_type = tbl[2],
  			from_zone = zone,
  			from_mob = '',
        short_stats = string.format("%s (%s) %s * %s * Flags? * Wt:? Val:? * Zone: %s%s * Last ID: 2019-08-27", tbl[1], tbl[2], tbl[3], tbl[4], zone, R),
  			long_stats = "",
  			full_stats = '',
  			comments = '',
  			last_id = '2019-08-27',
  			flags = fl,
  		}
      table.insert(gearItems, it)
    end
  end
  
	for _,item in ipairs(gearItems) do
		if not NewGear:existsItem(item) then
			-- display(item)
			NewGear:insert(item)
		end
	end
  
end

