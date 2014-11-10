local hook = function(self, data)
  if self.taunt_nearby then
    local range = table.get(self.taunt_nearby, 'range') or 1
    local tg = {type = 'ball', range = 0, radius = range, selffire = false}
    local taunt = function(x, y)
      if not rng.percent(table.get(self.taunt_nearby, 'chance') or 10) then return end
      local actor = game.level.map(x, y, game.level.map.ACTOR)
      if not actor then return end
      local _, _, target = actor:getTarget()
      if target ~= self and actor:reactionToward(self) < 0 then
        actor:setTarget(self)
        game.logSeen(actor, '%s is enraged by %s\'s taunting!',
                     actor.name:capitalize(), self.name)
      end
    end
    self:project(tg, self.x, self.y, taunt)
  end
end
class:bindHook('Actor:actBase:Effects', hook)
