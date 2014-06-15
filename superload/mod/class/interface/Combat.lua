local _M = loadPrevious(...)
local g = require 'grayswandir.utils'

-- New Weapon Masteries
_M:addCombatTraining('spear', 'T_EXOTIC_WEAPONS_MASTERY')
_M:addCombatTraining('aurastone', 'T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY')
_M:addCombatTraining('staff', 'T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY')

-- Add combat training to midnight's weapons.
_M:addCombatTraining('sceptre', 'T_WEAPONS_MASTERY')
_M:addCombatTraining('sceptre', 'T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY')
_M:addCombatTraining('ritual-blade', 'T_KNIFE_MASTERY')
_M:addCombatTraining('ritual-blade', 'T_GRAYSWANDIR_MAGIC_WEAPONS_MASTERY')

if 'Awesome' == config.settings.tome.nulltweaks_mastery then
  _M:addCombatTraining('sceptre', 'T_EXOTIC_WEAPONS_MASTERY') -- nulltweaks greatweapon
	_M:addCombatTraining('ritual-blade', 'T_WEAPONS_MASTERY')
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

function _M:getBuckler(slot)
	if self:attr('disarmed') then return nil, 'disarmed' end
	local buckler = g.get(self:getInven(slot or 'OFFHAND'), 1)
	if g.get(buckler, 'special_combat', 'talented') == 'buckler' then
		return buckler
	end
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

-- If we can do a sweeping attack with the given weapon's combat table.
function _M:combatCanSweep(combat, target)
  return target ~= self and
		g.get(combat, 'sweep_attack') and
		not g.get(self, '__talent_running', '__sweep_disabled') and
    not combat.__sweep_disabled
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

local attackTarget = _M.attackTarget
function _M:attackTarget(target, damtype, mult, noenergy, force_unharmed)
	local uid = g.get(target, 'uid')
	if uid then g.set(self.turn_procs, 'melee_targets', uid, true) end

	local ret = {attackTarget(self, target, damtype, mult, noenergy, force_unharmed)}

	-- Vulnerable speed increase taken care of in attackTargetWith.
	-- We just need to take care of decrementing the counter here.
	if self.did_energy then
		-- First check if we only hit vulnerable targets.
		local all_vulnerable = true
		for uid, _ in pairs(self.turn_procs.melee_targets or {}) do
			local vulnerable = __uids[uid]:hasEffect('EFF_GUARD_VULNERABLE')
			if not g.get(vulnerable, 'src', self) then
				all_vulnerable = false
			end
		end
		-- If we have, then do all the vulnerable stuff.
		if all_vulnerable then
			for uid, _ in pairs(self.turn_procs.melee_targets or {}) do
				-- Do the countdown.
				local vulnerable = __uids[uid]:hasEffect('EFF_GUARD_VULNERABLE')
				vulnerable.count = vulnerable.count - 1
				if vulnerable.count <= 0 then
					target:removeEffect('EFF_GUARD_VULNERABLE')
				end
			end
		end
		-- Consume the targets.
		self.turn_procs.melee_targets = {}
	end

	return unpack(ret)
end

local attackTargetWith = _M.attackTargetWith
function _M:attackTargetWith(target, weapon, damtype, mult, force_dam)
	local final_speed, final_hit, all_hits = nil, nil, {}

	local uid = g.get(target, 'uid')
	if uid then g.set(self.turn_procs, 'melee_targets', uid, true) end

	-- Expand this into a full sweep attack.
	if self:combatCanSweep(weapon, target) and target then
		local dir = util.getDir(target.x, target.y, self.x, self.y)
		if dir == 5 then return nil end
		local lx, ly = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).left)
		local rx, ry = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).right)
		local lt = game.level.map(lx, ly, game.level.map.ACTOR)
		local rt = game.level.map(rx, ry, game.level.map.ACTOR)

		g.inc(weapon, '__sweep_disabled')
		if lt then self:attackTargetWith(lt, weapon, damtype, mult, force_dam) end
		final_speed, final_hit, all_hits =
			self:attackTargetWith(target, weapon, damtype, mult, force_dam)
		if rt then self:attackTargetWith(rt, weapon, damtype, mult, force_dam) end
		g.dec(weapon, '__sweep_disabled')

  -- Expand this into a full set of thrust attacks.
  elseif self:combatCanThrust(weapon, target) then
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
    for i, thrust_target in pairs(targets) do
      local speed, hit = attackTargetWith(self, thrust_target, weapon, damtype, mult, force_dam)
      if hit then
        table.insert(all_hits, thrust_target)
      end
			if target == thrust_target then
				final_speed = speed
				final_hit = hit
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
  end

  -- All other cases eventually condense down to this one.
  ::normal_attack::

  -- Try to do a normal attack.
  if not final_speed and self:combatCanMelee(weapon, target) then

		local vulnerable = target:hasEffect('EFF_GUARD_VULNERABLE')
		-- Gimmick speed if we're hitting a vulnerable target.
		local vulnerable_mod
		if g.get(vulnerable, 'src', self) then
			vulnerable_mod = self:addTemporaryValue('combat_physspeed_multiplier', 2)
		end

		-- The only actual call to the original attackTargetWith.
    final_speed, final_hit, all_hits =
			attackTargetWith(self, target, weapon, damtype, mult, force_dam)

		-- Ungimmick the speed.
		if vulnerable_mod then
			self:removeTemporaryValue('combat_physspeed_multiplier', vulnerable_mod)
		end

    -- Do resource strikes.
    if final_hit and g.get(weapon, 'resource_strikes') then

			-- Weapon strikes are still buggy, so put some checks in here.
			local strikes_to_remove = {}

      local auto_melee = self.turn_procs.auto_melee_hit
      self.turn_procs.auto_melee_hit = true
      for id, strike in pairs(weapon.resource_strikes) do
				if strike.damtype == 0 then
					table.insert(strikes_to_remove, id)
				else
					local cost = strike.cost or {}
					if self:hasResources(cost) then
						self:attackTargetWith(target, strike, nil, 1)
						self:useResources(cost)
					end
				end
      end
      self.turn_procs.auto_melee_hit = auto_melee

			-- Remove the marked strikes.
			for _, id in pairs(strikes_to_remove) do
				weapon.resource_strikes[id] = nil
			end
    end

		-- I think callbackOnMeleeMiss is broken, so do buckler stuff here.
		if not final_hit and target:knowTalent('T_LIGHTNING_BASH') then
			local cd = target.talents_cd.T_LIGHTNING_BASH
			if cd then target.talents_cd.T_LIGHTNING_BASH = cd - 1 end
		end

		-- Give self the vulnerable effect if we miss a guarding opponent.
		local guarding = target:hasEffect('EFF_GUARDING')
		if not final_hit and guarding then
			self:setEffect('EFF_GUARD_VULNERABLE', guarding.vuln_dur, {
											 count = guarding.count,
											 crit = guarding.vuln_crit,
											 src = {[target] = true,},})
		end

		-- Buckler Focus attack.
		if final_hit and
			weapon and weapon.talented == 'buckler' and
			self:knowTalent('T_BUCKLER_FOCUS')
		then
			self:attackTarget(
				target, damtype, self:callTalent('T_BUCKLER_FOCUS', 'damage'), true)
		end
  end

  return final_speed, final_hit, all_hits
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

-- Make combat training show up properly in the tooltip
function _M:combatGetTraining(weapon)
	if not weapon then return nil end
	if not weapon.talented then return nil end
	if not _M.weapon_talents[weapon.talented] then return nil end
	if type(_M.weapon_talents[weapon.talented]) == "table" then
    local max, ktid = nil, nil
    for i, tid in ipairs(_M.weapon_talents[weapon.talented]) do
      if self:knowTalent(tid) then
        local t = self:getTalentFromId(tid)
				-- Workaround for addons that don't implement getDamage
				local strength = self:getTalentLevel(t) * 10
				if t.getDamage then
					strength = t.getDamage(self, t, weapon)
				end
        if not max or strength > max then
          max = strength
          ktid = tid
        end
      end
    end
		return self:getTalentFromId(ktid)
	else
		return self:getTalentFromId(_M.weapon_talents[weapon.talented])
	end
end

function _M:getBuckler()
	if self:attr('disarmed') then return nil, 'disarmed' end
	local buckler = g.get(self:getInven('OFFHAND'), 1)
	if buckler and buckler.subtype == 'buckler' then return buckler end
end

local combatDefense = _M.combatDefense
function _M:combatDefense(fake, add)
	local def = combatDefense(self, fake, add)
	local sub = self.combat_melee_sub_accuracy_defense
	if sub and sub > 0 then
		def = math.max(def, self:combatAttack())
	end
	return def
end

local combatSpeed = _M.combatSpeed
function _M:combatSpeed(weapon)
	local mult = self.combat_physspeed_multiplier or 1
	return combatSpeed(self, weapon) / mult
end

return _M
