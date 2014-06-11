local g = require 'grayswandir.utils'
local GetQuantity = require "engine.dialogs.GetQuantity"

local hook = function(self, data)
  if data.kind == 'gameplay' then
    local textzone = require 'engine.ui.Textzone'
    local tome = config.settings.tome
    self.list = self.list or {}

    -- Option Creation function.
    local add_boolean_option = function(short_id, display_name, description, action)
      local id = 'grayswandir_weaponry_'..short_id
      -- Make options default to on.
      if tome[id] == nil then tome[id] = true end
      -- Create new option.
      local option = {
          name = string.toTString(
            ('#GOLD##{bold}#Weapons Pack: %s#WHITE##{normal}#')
              :format(display_name)),
          zone = textzone.new {
            width = self.c_desc.w,
            height = self.c_desc.h,
            text = string.toTString(description),},
          status = function(item)
            return tostring(tome[id] and 'enabled' or 'disabled')
          end,
          fct = function(item)
            tome[id] = not tome[id]
            local name = 'tome.'..id
            game:saveSettings(
              name, ('%s = %s\n'):format(name, tostring(tome[id])))
            self.c_list:drawItem(item)
						if action then action(tome[id]) end
          end,}
      table.insert(self.list, option)
    end

    -- Option Creation function.
    local add_cycling_option = function(short_id, values, display_name, description, action)
      local id = 'grayswandir_weaponry_'..short_id
			-- Get table of next values.
			local next_value = {}
			for i = 1, #values-1 do
				next_value[values[i]] = values[i+1]
			end
			next_value[values[#values]] = values[1]
      -- Make options default to on.
      if tome[id] == nil or not next_value[tome[id]] then
				tome[id] = values[1]
			end
      -- Create new option.
      local option = {
          name = string.toTString(
            ('#GOLD##{bold}#Weapons Pack: %s#WHITE##{normal}#')
              :format(display_name)),
          zone = textzone.new {
            width = self.c_desc.w,
            height = self.c_desc.h,
            text = string.toTString(description),},
          status = function(item)
            return tostring(tome[id])
          end,
          fct = function(item)
            tome[id] = next_value[tome[id]]
            local name = 'tome.'..id
            game:saveSettings(
              name, ('%s = "%s"\n'):format(name, tostring(tome[id])))
            self.c_list:drawItem(item)
						if action then action(tome[id]) end
          end,}
      table.insert(self.list, option)
    end

    -- Numeric Option creation function.
    local add_numeric_option = function(short_id, default, min, max, display_name, description)
      local id = 'grayswandir_weaponry_'..short_id
      -- Set option default.
      if tome[id] == nil then tome[id] = default end
      -- Create the new option.
      local option = {
        name = string.toTString(
          ('#GOLD##{bold}#Weapons Pack: %s#WHITE##{normal}#')
            :format(display_name)),
        zone = textzone.new {
          width = self.c_desc.w,
          height = self.c_desc.h,
          text = string.toTString(description),},
        status = function(item)
          return tostring(tome[id])
        end,
        fct = function(item)
          local assign = function(value)
            tome[id] = util.bound(value, min, max)
            local name = 'tome.'..id
            game:saveSettings(
              name, ('%s = %s\n'):format(name, tostring(tome[id])))
            self.c_list:drawItem(item)
          end
          game:registerDialog(
            GetQuantity.new(
              display_name,
              ('[%d-%d]'):format(min, max),
              tome[id], max, assign, min))
        end,}
      table.insert(self.list, option)
    end

    -- Add misc. options.
    add_boolean_option(
      'dammod_swapping',
      'Alternate Damage Modifiers',
      'This allows certain weapons to use optional stats for damage modifiers when those stats are higher. For instance, daggers will now use the higher of your strength or cunning for their damage modifiers.')

    add_numeric_option(
      'exotic_rarity', 0, 0, 1000,
      'Exotic Item Rarity',
      'This value is added to the rarity of all the Weapons Pack items, forcing them to generate less often.')

		add_boolean_option(
			'generic_masteries',
			'Generic Masteries',
			'This makes Riposte a generic talent under combat training, and replaces it with a new talent.',
			function (value)
				local talents = require 'engine.interface.ActorTalents'
				talents.talents_def.T_RIPOSTE:do_generic_option()
				talents.talents_def.T_GRAYSWANDIR_COUNTER_BASH:do_generic_option()
				talents.talents_def.T_GRAYSWANDIR_BUCKLER_MASTERY:do_generic_option()
				talents.talents_def.T_DISORIENTING_BASH:do_generic_option()
			end
		)

		add_boolean_option(
			'new_egos',
			'New Egos',
			'This enables the new weapon egos.')

		add_boolean_option(
			'bucklers',
			'Bucklers',
			'Allows bucklers to be generated. You must reload the game for this to take effect, and it will not change any already generated zones.',
			function(value)
				local talents = require 'engine.interface.ActorTalents'
				talents.talents_def.T_GRAYSWANDIR_BUCKLER_MASTERY.hide = not value
				-- Learn
				if value then
					if game.player.learn_bucklers then
						game.player:learnTalentType('technique/buckler-offense', game.player.learn_bucklers[1])
						game.player.talents_types_mastery['technique/buckler-offense'] =
							game.player.learn_bucklers[2]
						game.player.learn_bucklers = nil
					end
				else
					game.player.learn_bucklers = {
						game.player:knowTalentType('technique/buckler-offense'),
						game.player.talents_types_mastery['technique/buckler-offense'],}
					game.player.talents_types['technique/buckler-offense'] = nil
				end
			end
		)

    -- Add options for each weapon type.
    local weapontypes = {'swordbreakers', 'rapiers', 'spears', 'whips', 'tridents', 'clubs', {'throwing_knives', 'Throwing Knives'}, 'aurastones',}
    for _, weapontype in pairs(weapontypes) do
      local display_name
      if _G.type(weapontype) == 'table' then
        display_name = weapontype[2]
        weapontype = weapontype[1]
      else
        display_name = weapontype:capitalize()
      end
      local description = ('Allows %s to be generated. You must reload the game for this to take effect, and it will not change any already generated zones.')
        :format(display_name)
      add_boolean_option(weapontype, display_name, description)
    end
  end
end
class:bindHook('GameOptions:generateList', hook)
