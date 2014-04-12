local hook

-- Accuracy Effects
local do_accuracy = function(self, weapon, target, atk, def)
  local strength

  strength = self:getAccuracyEffectStrength(weapon, 'whip')
  if strength and target.drain_energy then
    target:drain_energy(self:getAccuracyEffect(weapon, atk, def, 0.5 * strength), 100)
  end

  strength = self:getAccuracyEffectStrength(weapon, 'rapid')
  if strength and self.boost_energy then
    self:boost_energy(self:getAccuracyEffect(weapon, atk, def, 0.5 * strength), 100)
  end

  strength = self:getAccuracyEffectStrength(weapon, 'swordbreaker')
  if strength then
    if rng.percent(self:getAccuracyEffect(weapon, atk, def, strength)) and
      target:canBe('disarm')
    then
      game.logSeen(self, '%s tries to disarm %s!', self.name:capitalize(), target.name)
      local duration = 2 + (weapon.swordbreaker_disarm_duration or 0)
      target:setEffect('EFF_DISARMED', duration, {apply_power=self:combatAttack(weapon)})
    end
  end

  strength = self:getAccuracyEffectStrength(weapon, 'blind')
  if strength then
    if rng.percent(self:getAccuracyEffect(weapon, atk, def, strength)) and
      target:canBe('blind')
    then
      game.logSeen(self, '%s tries to blind %s!', self.name:capitalize(), target.name)
      target:setEffect('EFF_BLINDED', 2, {apply_power=self:combatAttack(weapon)})
    end
  end

  strength = self:getAccuracyEffectStrength(weapon, 'pull')
  if strength then
    if rng.percent(self:getAccuracyEffect(weapon, atk, def, strength)) and
      target:canBe('knockback')
    then
      game.logSeen(self, '%s pulls %s in!', self.name:capitalize(), target.name)
      target:pull(self.x, self.y, 1)
    end
  end

  strength = self:getAccuracyEffectStrength(weapon, 'duel')
  if strength then
    if rng.percent(self:getAccuracyEffect(weapon, atk, def, strength.power)) then
      self:setEffect('EFF_GRAYSWANDIR_DUEL', strength.dur, {
                       def = strength.def, max = strength.max})
    end
  end

  strength = self:getAccuracyEffectStrength(weapon, 'duel_disrupt')
  if strength then
    if rng.percent(self:getAccuracyEffect(weapon, atk, def, strength.power)) then
      target:setEffect('EFF_GRAYSWANDIR_DUEL_DISRUPTION', strength.dur, {
                              atk = strength.atk, max = strength.max})
    end
  end

  strength = self:getAccuracyEffectStrength(weapon, 'silence')
  if strength then
    local power, duration = strength, 2
    if _G.type(strength) == 'table' then
      power = strength.power
      duration = strength.dur
    end
    if rng.percent(self:getAccuracyEffect(weapon, atk, def, power)) then
      target:setEffect('EFF_GRAYSWANDIR_PHYSICAL_SILENCED', duration, {
                              apply_power = self:combatAttack(weapon),})
    end
  end
end

hook = function(self, data)
  -- This all calculates atk and def (again) because we don't have access to it.
  if not data.target then return end

  -- Get attack and defense.
  local atk, def = self:combatAttack(data.weapon), data.target:combatDefense()

  -- add stalker damage and attack bonus
  local effStalker = self:hasEffect(self.EFF_STALKER)
  if effStalker and effStalker.target == data.target then
    local t = self:getTalentFromId(self.T_STALK)
    atk = atk + t.getAttackChange(self, t, effStalker.bonus)
  end

  -- add marked prey damage and attack bonus
  local effPredator = self:hasEffect(self.EFF_PREDATOR)
  if effPredator and effPredator.type == data.target.type then
    if effPredator.subtype == data.target.subtype then
      atk = atk + effPredator.subtypeAttackChange
    else
      atk = atk + effPredator.typeAttackChange
    end
  end

  if data.hitted then
    do_accuracy(self, data.weapon, data.target, atk, def)
  end
end
class:bindHook('Combat:attackTargetWith', hook)


hook = function(self, data)
	local atk = self:combatAttackRanged(data.weapon, data.ammo)
  local def = data.target:combatDefenseRanged()

  if data.hitted then
    do_accuracy(self, data.ammo, data.target, atk, def)
  end

  return true
end
class:bindHook('Combat:archeryHit', hook)
