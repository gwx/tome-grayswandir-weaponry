local _M = loadPrevious(...)
local g = require 'grayswandir'

-- New Weapon Masteries
_M:addCombatTraining('spear', 'T_EXOTIC_WEAPONS_MASTERY')

if 'Awesome' == config.settings.tome.nulltweaks_mastery then
  _M:addCombatTraining('spear', 'T_GREATWEAPON_MASTERY')
  _M:addCombatTraining('spear', 'T_WEAPONS_MASTERY')
end

-- If a thrust weapon is equipped.
function _M:has_thrust_weapon(combat_keys)
  local weapons
  combat_keys = combat_keys or {'combat'}
  if _G.type(combat_keys) ~= 'table' then combat_keys = {combat_keys} end

  weapons = self:getInven('MAINHAND')
  if weapons then
    for i, o in ipairs(weapons) do
      for _, combat in pairs(combat_keys) do
        if o[combat] and o[combat].thrust_range and o[combat].thrust_range > 0 then return true end
      end
    end
  end

  weapons = self:getInven('OFFHAND')
  if weapons then
    for i, o in ipairs(weapons) do
      for _, combat in pairs(combat_keys) do
        if o[combat] and o[combat].thrust_range and o[combat].thrust_range > 0 then return true end
      end
    end
  end

  return false
end

-- Get the maximum thrust range.
function _M:get_thrust_range(combat_keys)
  local range = 1
  combat_keys = combat_keys or {'combat'}
  if _G.type(combat_keys) ~= 'table' then combat_keys = {combat_keys} end

  weapons = self:getInven('MAINHAND')
  if weapons then
    for i, o in ipairs(weapons) do
      for _, combat in pairs(combat_keys) do
        if o[combat] and o[combat].thrust_range then
          range = math.max(range, o[combat].thrust_range + 1)
        end
      end
    end
  end

  weapons = self:getInven('OFFHAND')
  if weapons then
    for i, o in ipairs(weapons) do
      for _, combat in pairs(combat_keys) do
        if o[combat] and o[combat].thrust_range then
          range = math.max(range, o[combat].thrust_range + 1)
        end
      end
    end
  end

  return range
end

-- If we can do a normal melee hit with the given weapon's combat table.
function _M:combatCanMelee(combat, target)
  -- Check range if we have a target.
  if target and
    g.get(self, '__talent_running', '__disallow_ranged_melee') and
    core.fov.distance(self.x, self.y, target.x, target.y) > 1
  then return false end

  return true
end

-- If we can thrust with the given weapon's combat table.
function _M:combatCanThrust(combat, target)
  if target == self then return false end
  local range = g.get(combat, 'thrust_range')
  if not range or range <= 0 then return false end
  return not g.get(self, '__talent_running', '__thrust_disabled') and
    not combat.__thrust_disabled
end

-- Extend a single target to a beam attack.
function _M:extendTargetByBeam(x, y, range)
  if not x or not y then return end
  range = range or 10
  local original_target = game.level.map(x, y, game.level.map.ACTOR)

  -- If target is self, then just return self.
  if original_target == self then return {original_target} end

  -- Make a general actor grabber
  local actor_grabber = function(destination, filter_function)
    return function(x, y)
      local actor = game.level.map(x, y, game.level.map.ACTOR)
      if not actor then return end
      if filter_function and not filter_function(actor) then return end
      destination[actor.uid] = actor
    end
  end
  local can_see = function(actor) return self:canSee(actor) end

  -- Get potential targets
  local tg = {type = 'cone', range = 0, radius = range}
  local actors = {}
  self:project(tg, x, y, actor_grabber(actors, can_see))

  -- Sort into hostiles and friendlies.
  local hostiles = {}
  local friendlies = {}
  for uid, actor in pairs(actors) do
    if self:reactionToward(actor) < 0 then
      hostiles[uid] = actor
    else
      friendlies[uid] = actor
    end
  end
  actors = nil

  -- Further filter targets.
  local intermediate_targets = {}
  local valid_final_targets = {}
  tg = {type = 'beam', range = range}
  for uid, final_target in pairs(hostiles) do
    -- Collect actors we hit on the way to the target.
    local beam_actors = {}
    local ignore_target = function(actor)
      return actor.uid ~= final_target.uid and can_see(actor)
    end
    self:project(tg, final_target.x, final_target.y, actor_grabber(beam_actors, ignore_target))

    -- If we don't hit the original target, then ignore this target.
    if original_target and not beam_actors[original_target.uid] then goto invalid_target end

    -- If we hit any friendlies, ignore this target.
    for beam_uid, beam_actor in pairs(beam_actors) do
      if self:reactionToward(beam_actor) >= 0 and
        -- Faerie Mod: clones can't hurt summoners and vice-versa.
        not ((self.is_clone and self.summoner == beam_actor) or
               (beam_actor.is_clone and beam_actor.summoner == self) or
               (self.is_clone and beam_actor.is_clone and self.summoner == beam_actor.summoner))
      then goto invalid_target end
    end

    -- Mark all extra targets that we hit, so we don't target them individually.
    table.merge(intermediate_targets, beam_actors)

    valid_final_targets[uid] = final_target

    ::invalid_target::
  end

  -- Strip out targets that are hit when we aim for other targets.
  valid_final_targets = table.minus_keys(valid_final_targets, intermediate_targets)

  -- Pick the actual target, defaulting to the original target if necessary.
  local target = rng.table(table.values(valid_final_targets)) or original_target
  if not target then return end

  -- Return the final list of targets.
  local targets = {}
  self:project(tg, target.x, target.y, actor_grabber(targets))
  return table.values(targets), target
end

local attackTargetWith = _M.attackTargetWith
function _M:attackTargetWith(target, weapon, damtype, mult, force_dam)
  -- Expand this into a full set of thrust attacks.
  if self:combatCanThrust(weapon, target) then
    local range = weapon.thrust_range + 1

    -- Get targets list.
    local targets, end_target = self:extendTargetByBeam(target.x, target.y, range)
    -- No targets were found within range.
    if not targets or #targets == 0 then
      -- If we're the plain attack talent, then give up.
      if self.__talent_running and self.__talent_running.short_name == 'ATTACK' then
        return 0, false, {}
      end
      -- Otherwise just attack the original target
      goto normal_attack
    end

    -- Attack each target on the list.
    g.inc(weapon, '__thrust_disabled')
    local hit_original, hits = false, {}
    for i, thrust_target in pairs(targets) do
      local _, hit = attackTargetWith(self, thrust_target, weapon, damtype, mult, force_dam)
      if hit then
        table.insert(hits, thrust_target)
        if target == thrust_target then hit_original = true end
      end
    end
    g.dec(weapon, '__thrust_disabled')

    local color = weapon.thrust_color or {}
    game.level.map:particleEmitter(
      self.x, self.y, math.max(math.abs(end_target.x-self.x), math.abs(end_target.y-self.y)),
      'thrust', {
        tx = end_target.x - self.x,
        ty = end_target.y - self.y,
        rmax = color.rmax, gmax = color.gmax, bmax = color.bmax})

    return self:combatSpeed(weapon), hit_original, hits
  end

  -- If not thrusting, just make a normal attack.
  ::normal_attack::

  -- Try to do a normal attack.
  if self:combatCanMelee(weapon, target) then
    local speed, hit, hits = attackTargetWith(self, target, weapon, damtype, mult, force_dam)

    -- Do resource strikes.
    if hit and weapon.resource_strikes then
      local auto_melee = self.turn_procs.auto_melee_hit
      self.turn_procs.auto_melee_hit = true
      for id, strike in pairs(weapon.resourceActo_strikes) do
        local cost = strike.cost or {}
        if self:hasResources(cost) then
          self:attackTargetWith(target, strike, nil, 1)
          self:useResources(cost)
        end
      end
      self.turn_procs.auto_melee_hit = auto_melee
    end

    return speed, hit, hits
  end

  return 0, false, {}
end

-- Get the strength of an accuracy effect.
function _M:getAccuracyEffectStrength(weapon, kind)
  if not weapon then return false, 'none' end

  local effect = 0

  -- First check the plain accuracy effect.
  if (weapon.accuracy_effect or weapon.talented) == kind then
    effect = 1
  end

  -- The check for additional accuracy effects.
  local extra = weapon.extra_accuracy_effects and weapon.extra_accuracy_effects[kind]
  if extra then
    if _G.type(extra) == 'table' then
      effect = {power = effect}
      table.mergeAdd(effect, extra)
    else
      effect = effect + extra
    end
  end

  if effect == 0 then effect = false end
  return effect, kind
end

-- Accuracy Effects
function _M:isAccuracyEffect(weapon, kind)
  -- HACK HACK HACK
  -- Mark last requested accuracy effect so getAccuracyEffect knows how to scale it.
  -- This is so we don't have to completely override attacking.
  self.last_accuracy_kind = kind

  return self:getAccuracyEffectStrength(weapon, kind) and true, kind
end

local getAccuracyEffect = _M.getAccuracyEffect
function _M:getAccuracyEffect(weapon, atk, def, scale, max, kind)
  -- HACK HACK HACK
  -- last_accuracy_effect set in isAccuracyEffect
  if kind == nil then kind = self.last_accuracy_kind end

  if kind then
    local strength = self:getAccuracyEffectStrength(weapon, kind)
    if strength then scale = scale * strength end
  end

  return getAccuracyEffect(self, weapon, atk, def, scale, max)
end


-- Alternate Damage Modifiers

function _M:getDammod(weapon, display)
  -- List of stats we're substituting.
  local stat_subs, stat_kills = {}, {}

  -- Check psi combat.
  if self.use_psi_combat then
    stat_subs.str = 'wil'
    stat_subs.dex = 'cun'
    stat_kills.str = true
    stat_kills.dex = true
  end

  -- Lethality overrides psi combat.
  if self:knowTalent('T_LETHALITY') and
    weapon.talented and
    weapon.talented == 'knife'
  then
    stat_subs.str = 'cun'
    stat_kills.str = true
  end

  local substitute_stats = function(dammod)
    for from, to in pairs(stat_subs) do
      dammod[to] = (dammod[from] or 0) + (dammod[to] or 0)
      if dammod[to] == 0 then dammod[to] = nil end
      dammod[from] = nil
    end
  end

  -- If the option is turned off, or there is no alt dammod, default to normal behavior.
  if config.settings.tome.grayswandir_weaponry_dammod_swapping == false or
    not weapon.alt_dammod
  then
    local dammod = table.clone(weapon.dammod) or {str = 0.6}
    if display and weapon.display_add and weapon.display_add.dammod then
      table.mergeAdd(dammod, weapon.display_add.dammod)
    end
    substitute_stats(dammod)
    return dammod
  end

  -- Takes a dammod table and finds the highest bonus from among the table.
  -- returns stat, stat multiplier, actual score
  local highest_dammod = function(dammod)
    local stat, mod, highest = nil, nil, 0
    for key, value in pairs(dammod) do
      -- Substitute stats.
      if stat_subs[key] then key = stat_subs[key] end
      if stat_kills[key] then value = 0 end

      local score
      -- Integer keys are 'highest of' dammod
      if tonumber(key) then
        key, value, score = highest_dammod(value)
      else
        score = self:getStat(key) * value
      end

      if score > highest then
        highest = score
        stat = key
        mod = value
      end
    end
    return stat, mod, highest
  end

  local dammod = {}
  if display and weapon.display_add and weapon.display_add.dammod then
    dammod = table.clone(weapon.display_add.dammod)
  end
  for key, value in pairs(weapon.alt_dammod) do
    -- Integer keys are the 'highest of' dammod.
    if tonumber(key) then
      key, value = highest_dammod(value)
    end
    if stat_subs[key] then key = stat_subs[key] end
    if stat_kills[key] then value = 0 end
    dammod[key] = (dammod[key] or 0) + value
  end

  return dammod
end


local combatDamage = _M.combatDamage
function _M:combatDamage(weapon, adddammod)
  -- If the option is turned off, or there is no alt dammod, default to normal behavior.
  if config.settings.tome.grayswandir_weaponry_dammod_swapping == false or
    not g.get(weapon, 'alt_dammod')
  then
    return combatDamage(self, weapon, adddammod)
  end

  local old_dammod = weapon.dammod
  weapon.dammod = self:getDammod(weapon)
  local damage = {combatDamage(self, weapon, adddammod)}
  weapon.dammod = old_dammod

  return unpack(damage)
end


-- Check if actor is unarmed
local isUnarmed = _M.isUnarmed
function _M:isUnarmed()
  local main = g.get(self:getInven("MAINHAND"), 1)
	local off = g.get(self:getInven("OFFHAND"), 1)
  if (not main or main.allow_unarmed) and
    (not off or off.allow_unarmed)
  then return true end

  return isUnarmed(self)
end

-- Specially mark psi combat slots.
_M.psi_combat_slots = {'PSIONIC_FOCUS'}

return _M
