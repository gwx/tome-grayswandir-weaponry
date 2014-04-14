local hook = function(self, data, force)
  local load_objects = function(name)
    local file = '/data-grayswandir-weaponry/objects/'..name..'.lua'
    if data.loaded[file] and not force then return end
    self:loadList(file, data.no_default, data.res, data.mod, data.loaded)
  end
  local load_egos = function(name)
    local file = '/data-grayswandir-weaponry/egos/'..name..'.lua'
    if data.loaded[file] then return end
    self:loadList(file, data.no_default, data.res, data.mod, data.loaded)
  end

  -- New Object Types
  if data.file == '/data/general/objects/objects.lua' then
    load_objects('spears')
    load_objects('2hspears')
    load_objects('aurastones')

    -- Hack things.
    load_objects('alt-dammods')
  end

  -- Existing Object Types
  for _, name in pairs {'swords', 'maces', 'axes', '2hswords', '2hmaces', '2haxes', 'knifes', 'whips', '2htridents', 'bows', 'slings', 'gloves', 'gauntlets',} do
    local file = '/data/general/objects/'..name..'.lua'
    if data.file == file then load_objects(name) end
  end

  -- Artifacts
  if data.file == '/data/general/objects/world-artifacts.lua' then
    load_objects('spears')
    load_objects('2hspears')
    load_objects('world-artifacts')
  end

  -- Existing Object Egos
  for _, name in pairs {'weapon'} do
    local file = '/data/general/objects/egos/'..name..'.lua'
    if data.file == file then load_egos(name) end
  end

  -- Add new objects to stores.
  if data.file == '/data/general/stores/basic.lua' then
    self:loadList('/data-grayswandir-weaponry/stores.lua',
                  data.no_default, data.res, data.mod, data.loaded)

  end

  -- Midnight hacking.
  if data.file == '/data-midnight/sceptres.lua' then
    load_objects('alt-sceptres', true)
  end
  if data.file == '/data-midnight/world-artifacts-far-east.lua' then
    load_objects('alt-sceptres', true)
  end

end
class:bindHook('Entity:loadList', hook)
