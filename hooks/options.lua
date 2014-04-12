local hook = function(self, data)
  if data.kind == 'gameplay' then
    local textzone = require 'engine.ui.Textzone'
    local tome = config.settings.tome
    self.list = self.list or {}

    -- Option Creation function.
    local add_boolean_option = function(short_id, display_name, description)
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
          end,}
      table.insert(self.list, option)
    end

    -- Add misc. options.
    add_boolean_option(
      'dammod_swapping',
      'Alternate Damage Modifiers',
      'This allows certain weapons to use optional stats for damage modifiers when those stats are higher. For instance, daggers will now use the higher of your strength or cunning for their damage modifiers.')

    add_boolean_option(
      'alt_reload',
      'Alternate Reload',
      'This changes several aspects of reloading. Moving or waiting will now automatically reload. If you cannot reload your main quiver, your offset quiver will be reloaded instead. The reload talent is now instant use, costs 10 stamina, and refills your ammo directly instead of giving the reload buff.')

    -- Add options for each weapon type.
    local weapontypes = {'swordbreakers', 'rapiers', 'spears', 'whips', 'tridents', 'clubs', {'throwing_knives', 'Throwing Knives'},}
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
      add_boolean_option(weapontype, display_name:lower(), description)
    end
  end
end
class:bindHook('GameOptions:generateList', hook)
