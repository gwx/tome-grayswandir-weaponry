local hook = function(self, data)
  local load_data = function(loader, name)
    require(loader):loadDefinition('/data-grayswandir-weaponry/'..name..'.lua')
  end

  load_data('engine.interface.ActorTalents', 'talents')
  load_data('engine.interface.ActorTemporaryEffects', 'effects')
  load_data('engine.DamageType', 'damage-types')
end
class:bindHook('ToME:load', hook)
