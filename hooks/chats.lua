local chat = require 'engine.Chat'
local hook

-- Last Hope Merchant

chat.last_hope_merchant = chat.last_hope_merchant or {}
chat.last_hope_merchant.armours = {
  'elven-silk robe',
  'drakeskin leather armour',
  'voratun mail armour',
  'voratun plate armour',
  'elven-silk cloak',
  'drakeskin leather gloves',
  'voratun gauntlets',
  'elven-silk wizard hat',
  'drakeskin leather cap',
  'voratun helm',
  'pair of drakeskin leather boots',
  'pair of voratun boots',
  'drakeskin leather belt',
  'voratun shield',}
chat.last_hope_merchant.weapons = {
  'voratun battleaxe',
  'voratun greatmaul',
  'voratun greatsword',
  'voratun waraxe',
  'voratun mace',
  'voratun longsword',
  'voratun dagger',
  'living mindstar',
  'quiver of dragonbone arrows',
  'dragonbone longbow',
  'drakeskin leather sling',
  'dragonbone staff',
  'pouch of voratun shots',}
chat.last_hope_merchant.misc = {
  'voratun ring',
  'voratun amulet',
  'dwarven lantern',
  'voratun pickaxe',
  {'dragonbone wand', 'dragonbone wand'},
  {'dragonbone totem', 'dragonbone totem'},
  {'voratun torque', 'voratun torque'},}

-- Add Weapons Pack items based on options.

if config.settings.tome.grayswandir_weaponry_swordbreakers ~= false then
  table.insert(chat.last_hope_merchant.weapons, 'voratun swordbreaker')
end

if config.settings.tome.grayswandir_weaponry_rapiers ~= false then
  table.insert(chat.last_hope_merchant.weapons, 'voratun rapier')
end

if config.settings.tome.grayswandir_weaponry_spears ~= false then
  table.insert(chat.last_hope_merchant.weapons, 'voratun spear')
  table.insert(chat.last_hope_merchant.weapons, 'voratun greatspear')
end

if config.settings.tome.grayswandir_weaponry_whips ~= false then
  table.insert(chat.last_hope_merchant.weapons, 'drakeskin whip')
end

if config.settings.tome.grayswandir_weaponry_tridents ~= false then
  table.insert(chat.last_hope_merchant.weapons, 'orichalcum trident')
end

if config.settings.tome.grayswandir_weaponry_clubs ~= false then
  table.insert(chat.last_hope_merchant.weapons, 'dragonbone club')
  table.insert(chat.last_hope_merchant.weapons, 'dragonbone greatclub')
end

if config.settings.tome.grayswandir_weaponry_throwing_knives ~= false then
  table.insert(chat.last_hope_merchant.weapons, 'voratun throwing knives')
end

local maker_list = function(chat)
	local mainbases = {
    armours = chat.last_hope_merchant.armours,
		weapons = chat.last_hope_merchant.weapons,
    misc = chat.last_hope_merchant.misc}
	local l = {{'I\'ve changed my mind.', jump = 'welcome'}}
	for kind, bases in pairs(mainbases) do
		l[#l+1] = {kind:capitalize(), action=function(npc, player)
			local l = {{'I\'ve changed my mind.', jump = 'welcome'}}
			chat:addChat{ id='makereal',
				text = [[Which kind of item would you like ?]],
				answers = l,
			}

			for i, name in ipairs(bases) do
				local dname = nil
				if type(name) == 'table' then name, dname = name[1], name[2] end
				local not_ps, force_themes
				if player:attr('forbid_arcane') then -- no magic gear for antimatic characters
					not_ps = {arcane=true}
					force_themes = {'antimagic'}
				else -- no antimagic gear for characters with arcane-powered classes
					if player:attr('has_arcane_knowledge') then not_ps = {antimagic=true} end
				end

				local o, ok
				local tries = 100
				repeat
					o = game.zone:makeEntity(game.level, 'object', {name=name, ignore_material_restriction=true, no_tome_drops=true, ego_filter={keep_egos=true, ego_chance=-1000}}, nil, true)
					if o then ok = true end
					if o and o.power_source and player:attr('forbid_arcane') and o.power_source.arcane then ok = false o = nil end
					tries = tries - 1
				until ok or tries < 0
				if o then
					if not dname then dname = o:getName{force_id=true, do_color=true, no_count=true}
					else dname = '#B4B4B4#'..o:getDisplayString()..dname..'#LAST#' end
					l[#l+1] = {dname, action=function(npc, player)
						local art, ok
						local nb = 0
						repeat
							art = game.state:generateRandart{base=o, lev=70, egos=4, force_themes=force_themes, forbid_power_source=not_ps}
							if art then ok = true end
							if art and art.power_source and player:attr('forbid_arcane') and art.power_source.arcane then ok = false end
							nb = nb + 1
							if nb == 40 then break end
						until ok
						if art and nb < 40 then
							art:identify(true)
							player:addObject(player.INVEN_INVEN, art)
							player:incMoney(-4000)
							-- clear chrono worlds and their various effects
							if game._chronoworlds then
								game.log('#CRIMSON#Your timetravel has no effect on pre-determined outcomes such as this.')
								game._chronoworlds = nil
							end
							game:saveGame()

							chat:addChat{ id='naming',
								text = 'Do you want to name your item?\n'..tostring(art:getTextualDesc()),
								answers = {
									{'Yes, please.', action=function(npc, player)
										local d = require('engine.dialogs.GetText').new('Name your item', 'Name', 2, 40, function(txt)
											art.name = txt:removeColorCodes():gsub('#', ' ')
											game.log('#LIGHT_BLUE#The merchant carefully hands you: %s', art:getName{do_color=true})
										end, function() game.log('#LIGHT_BLUE#The merchant carefully hands you: %s', art:getName{do_color=true}) end)
										game:registerDialog(d)
									end},
									{'No thanks.', action=function() game.log('#LIGHT_BLUE#The merchant carefully hands you: %s', art:getName{do_color=true}) end},
								},
							}
							return 'naming'
						else
							chat:addChat{ id='oups',
								text = 'Oh I am sorry, it seems we could not make the item your require.',
								answers = {
									{'Oh, let\'s try something else then.', jump='make'},
									{'Oh well, maybe later then.'},
								},
							}
							return 'oups'
						end
					end}
				end
			end

			return 'makereal'
		end}
	end
	return l
end

hook = function(self, data)
  if data.c.id ~= 'make' then return end
  data.c.answers = maker_list(self)
end
class:bindHook('Chat:add', hook)

-- Angolwen Staff Trainer
local add_magic_weapon_training = function(chat, c)
  -- Make the training chat.
  chat:addChat {
    id = 'magic-weapon',
    text = [[I can teach you the basics of channeling magic through weapons (unhides Magic Weapon Mastery in the Combat Training tree) for 100 gold. This gives you basic proficiency with staves, sceptres, and aurastones.]],
    answers = {
      {cond = function(npc, player)
         return player.money >= 100 and
           player:knowTalentType('technique/combat-training')
       end,
       'Yes, teach me.',
       action = function(npc, player)
         game.logPlayer(player, 'The staff carver teaches you the basics of channelling magical energy.')
         player:incMoney(-100)
         player:revealTalent('T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY')
         player.changed = true
       end,},
      {cond = function(npc, player)
         return player.money >= 100 and
           not player:knowTalentType('technique/combat-training')
      end,
       'Yes, teach me. (You do not currently know the Combat Training tree, so you will not be able to put points into this talent until you also learn that.)',
       action = function(npc, player)
         game.logPlayer(player, 'The staff carver teaches you the basics of channelling magical energy.')
         player:incMoney(-100)
         player:revealTalent('T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY')
         player.changed = true
       end,},
      {'No thanks'},},}


  -- Modify the current chat to let you learn.
  table.insert(c.answers, 3,
               {'I wish to learn magical weapon combat.', jump = 'magic-weapon',})
end

hook = function(self, data)
  if data.c.id ~= 'welcome' then return end
  -- Don't need to do this if the player can already use it.
  if game.player:isTalentRevealed('T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY') then return end
  -- Look for the staff training option.
  for _, reply in pairs(data.c.answers) do
    if reply[1] == 'I am looking for staff training.' then
      add_magic_weapon_training(self, data.c)
      break
    end
  end
end
class:bindHook('Chat:add', hook)
