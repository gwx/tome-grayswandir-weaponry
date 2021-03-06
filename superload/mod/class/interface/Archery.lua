local _M = loadPrevious(...)
local g = require 'grayswandir.utils'
local talents = require 'engine.interface.ActorTalents'

-- Get the current reload rate.
function _M:reloadRate(ammo)
  local kind = ammo.archery_ammo
  local mastery
  if not self.ammo_mastery_reload then
    mastery = 0
  elseif kind then
    mastery = self.ammo_mastery_reload[kind] or 0
  else
    mastery = table.max(self.ammo_mastery_reload) or 0
  end

  return 1 + mastery + (ammo.reload_speed or 0) + (self.weapon_reload_speed or 0)
end

-- Increase ammo by reload amount. Returns true if actually reloaded.
function _M:reloadAmmo(ammo)
  if not ammo.combat or
    not ammo.combat.capacity or
    not ammo.archery_ammo
  then return false end

  if ammo.combat.shots_left >= ammo.combat.capacity then return end
  local reloads = self:reloadRate(ammo)
  ammo.combat.shots_left = math.min(ammo.combat.capacity, ammo.combat.shots_left + reloads)
  return true
end

-- The order to reload slots in. Picks the lowest ammo left in each grouping.
_M.reload_order = {
  {'QUIVER', 'MAINHAND', 'OFFHAND', 'PSIONIC_FOCUS'},
  {'QS_QUIVER', 'QS_MAINHAND', 'QS_OFFHAND', 'QS_PSIONIC_FOCUS',},}

-- Return the ammo that needs reloading.
function _M:needReload()
  for _, group in ipairs(_M.reload_order) do
    local lowest_ammo, lowest_count
    for _, inven in ipairs(group) do
      inven = self:getInven(inven)
      local ammo = inven and inven[1]

      if ammo and not ammo.infinite then
        local combat = ammo.combat
        if combat and combat.capacity and combat.shots_left and
          combat.shots_left < combat.capacity and
          (not lowest_ammo or combat.shots_left < lowest_count)
        then
          lowest_ammo = ammo
          lowest_count = combat.shots_left
        end
      end
    end
    if lowest_ammo then return lowest_ammo end
  end
  return false
end

-- Reload the first empty ammo on the reload list.
function _M:reload()
  local ammo = self:needReload()
  if ammo then return self:reloadAmmo(ammo) end
  return false
end

-- Changing around the actual shooting.
_M.shoot_order = {'MAINHAND', 'OFFHAND', 'PSIONIC_FOCUS', 'QUIVER', 'TOOL'}
_M.shoot_offhand_slots = {OFFHAND = true}
_M.shoot_psi_slots = {PSIONIC_FOCUS = true}

function _M:getArcheryWeapons()
	-- Check for archery weapon override.
	if self.archery_weapon_override then
		if not self.archery_weapon_override.ignore_disarm and self:attr('disarmed') then
			return {}, 'disarmed'
		end

		if self.archery_weapon_override.direct then
			return self.archery_weapon_override
		else
			return {{weapon = self.archery_weapon_override[1],
							 ammo = self.archery_weapon_override[2],
							 offhand = false,
							 use_psi_archery = false,}}
		end
	end

  if self:attr('disarmed') then return {}, 'disarmed' end

  -- Get the default ammo slot.
  local ammo = self:getInven('QUIVER')
  if ammo then ammo = ammo[1] end

	local cd
  local weapons = {}
  for _, inven in ipairs(_M.shoot_order) do
    local list = self:getInven(inven) or {}
    local offhand = _M.shoot_offhand_slots[inven]
    local psi = _M.shoot_psi_slots[inven]

		local single = self.inven_def[inven].single_archery

    for _, weapon in ipairs(list) do
			if not single or #weapons == 0 then
				if not weapon or not weapon.archery_kind then goto invalid_weapon end

				local ammo = ammo
				if weapon.is_own_ammo then ammo = weapon end
				if not ammo then goto invalid_weapon end
				local combat = ammo.combat
				if weapon.archery_kind ~= ammo.archery_ammo then goto invalid_weapon end

				if weapon.slot_talent_cooldown then
					local cooldown = self:isTalentCoolingDown(weapon.slot_talent_cooldown)
					if cooldown then
						if not cd or cd > cooldown then cd = cooldown end
						goto invalid_weapon
					end
				end

				local shots = combat and combat.shots_left
				if not ammo.infinite and (not shots or shots <= 0)
				then goto invalid_weapon end

				if combat.use_resource then
					local resource = self['get'..wcombat.use_resource.kind:capitalize()](self)
					if resource < wcombat.use_resource.value then goto invalid_weapon end
				end

				table.insert(weapons, {weapon = weapon, ammo = ammo,
															 offhand = offhand, use_psi_archery = psi})
			end

      ::invalid_weapon::
    end
  end

	if cd then
		self.talents_cd.T_SHOOT = cd
	end

  return weapons
end

-- Get the list of all equipped ammos.
function _M:getArcheryAmmos()
  local ammos = {}
  for _, inven in ipairs(_M.shoot_order) do
    inven = self:getInven(inven) or {}
    for _, ammo in ipairs(inven) do
      if not ammo or not ammo.archery_ammo then goto invalid_ammo end
      table.insert(ammos, ammo)
      ::invalid_ammo::
    end
  end
  return ammos
end

function _M:archeryAcquireTargets(tg, params)
  params = params or {}
  local weapons = self:getArcheryWeapons()
  if #weapons == 0 then
    game.logPlayer(self, 'You do not have any ranged weapons equipped!')
    return
  end

  -- Get aiming target params.
  local aim_tg = tg or {}

  if not aim_tg.range then
    aim_tg.range = 0
    for _, data in pairs(weapons) do
      local wcombat = data.weapon.combat
      if wcombat.range and wcombat.range > aim_tg.range then
        aim_tg.range = wcombat.range
      end
    end
    if aim_tg.range == 0 then aim_tg.range = 6 end
  end

  if not aim_tg.type then
    for _, data in pairs(weapons) do
      local wcombat = data.weapon.combat
      local acombat = data.ammo.combat
      local new_type = data.weapon.combat.tg_type or data.ammo.combat.tg_type
      if new_type then
        -- Add the type if we don't already have one.
        if not aim_tg.type then
          aim_tg.type = new_type

        -- If we ended up with conflicting types, revert to bolt.
        elseif aim_tg.type ~= new_type then
          aim_tg.typee = 'bolt'
          break
        end
      end
    end
    aim_tg.type = aim_tg.type or 'bolt'
  end

  self:triggerHook {
    'Combat:archeryTargetKind', tg = aim_tg, params = params, mode = 'target'}

  -- Do the actual aiming.
  local x, y = params.x, params.y
  if not x or not y then x, y = self:getTarget(aim_tg) end
  if not x or not y then return end

  local targets = {}
  local speed, sound = 0, nil
  for _, data in pairs(weapons) do
    local p = table.clone(params)
    p.offhand = data.offhand
    p.use_psi_archery = data.use_psi_archery
    local new_targets = self:archeryAcquireTargetsWith(
      data.weapon, data.ammo, x, y, table.clone(tg), p)
    if new_targets and #new_targets > 0 then
      table.append(targets, new_targets)
      speed = math.max(self:combatSpeed(weapon), speed)
      if not sound then sound = data.weapon.combat.sound end
    end
  end

  if #targets > 0 then
    if not params.no_energy then
      self:useEnergy(game.energy_to_act * speed)
    end
    if sound then game:playSoundNear(self, sound) end
    return targets
  end
end


-- Get archery targets list for a specific weapon.
function _M:archeryAcquireTargetsWith(weapon, ammo, x, y, tg, params)
  local targets = {}
  local wcombat = weapon.combat
  local acombat = ammo.combat

  -- Setup targeting.
  tg = tg or {}
  if not tg.range then tg.range = wcombat.range end
  if not tg.type then tg.type = wcombat.tg_type or acombat.tg_type or 'bolt' end

  local infinite = ammo.infinite or self:attr 'infinite_ammo' or params.infinite

  local targets = {}
  local grab_target = function(x, y)
    local target = game.level.map(x, y, game.level.map.ACTOR)
    -- If we're doing one_shot, allow spaces with no targets to be
    -- chosen. Otherwise, force a target that isn't friendly.
    if not params.one_shot and (
        not target or
        self:reactionToward(target) >= 0 or
        (x == self.x and y == self.y))
    then return end

    -- Shot limit.
    if limit_shots then
      if limit_shots <= 0 then return true end
      limit_shots = limit_shots - 1
    end

    -- Consume ammo.
    if not infinite then
      if acombat.shots_left > 0 then
        acombat.shots_left = acombat.shots_left - 1
      else return true end
    end

    -- Consume resource.
    if weapon.use_resource then
      local cap = weapon.use_resource.kind:capitalize()
      if self['get'..cap](self) < weapon.use_resource.value then
        return true
      else
        self['inc'..cap](self, -weapon.use_resource.value)
      end
    end

    self:triggerHook {
      'Combat:archeryAcquire', tg = tg, params, infinite = infinite,
      weapon = weapon, ammo = ammo, x = x, y = y,}

    local t = {x = x, y = y, target = target, weapon = weapon, ammo = ammo,
			range = weapon.range or self:attr 'archery_range_override' or 6,
			offhand = params.offhand, use_psi_archery = params.use_psi_archery}
    table.insert(targets, t)
  end

  local limit_shots = params.limit_shots
  for i = 1, params.multishots or 1 do
		if params.one_shot then
			self:project({type = 'hit'}, x, y, grab_target)
		else
			self:project(tg, x, y, grab_target)
		end
  end

  if #targets > 0 then return targets end
end

function _M:archeryShoot(targets, talent, tg, params)
  local base_tg = tg or {}
  base_tg.talent = base_tg.talent or talent
  params = params and table.clone(params) or {}
  self:triggerHook {
    'Combat:archeryTargetKind', tg = tg, params = params, targets = targets, mode = 'fire'}

  for _, data in ipairs(targets) do
    local weapon, ammo = data.weapon, data.ammo
    local wcombat, acombat = weapon.combat, data.acombat or ammo.combat
    local tg = table.clone(base_tg)
    tg.type = tg.type or wcombat.tg_type or acombat.tg_type
    tg.display = tg.display or self:archeryDefaultProjectileVisual(weapon, ammo)
    tg.speed = (tg.speed or 10) + (wcombat.travel_speed or 0) + (acombat.travel_speed or 0)
		tg.range = tg.range or data.range
    tg.archery = params and table.clone(params) or {}
    tg.archery.weapon = wcombat
    tg.archery.ammo = acombat
    tg.archery.mult = (tg.archery.mult or 1) * (data.mult or 1)
    if data.offhand and not wcombat.no_offhand_penalty then
      tg.archery.mult = self:getOffHandMult(wcombat, tg.archery.mult)
			end
    if data.use_psi_archery then tg.archery.use_psi_archery = true end
		if self:attr 'archery_pass_friendly' then
			tg.friendlyfire = false
			tg.friendlyblock = false
			end

    if weapon.on_archery_trigger then
      weapon.on_archery_trigger(weapon, self, tg, params, data, talent)
			end
		print('YYYYY')
		table.print(tg)
    self:projectile(tg, data.x, data.y, _M.archery_projectile)
		end
	end

return _M
