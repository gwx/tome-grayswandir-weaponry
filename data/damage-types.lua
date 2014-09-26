newDamageType {
  type = 'GRAYSWANDIR_TRIP',
  name = '% trip chance',
  text_color = '#SLATE#',
  projector = function(src, x, y, type, params)
		local target = game.level.map(x, y, Map.ACTOR)
    if not target then return end

    if 'table' ~= _G.type(params) then params = {chance = params or 30} end
    if rng.percent(params.chance) and target:canBe(params.resist_type or 'pin') then
      target:crossTierEffect(target.EFF_OFFBALANCE, src:combatAttack(params.weapon))
      target:setEffect('EFF_GRAYSWANDIR_FALLEN_OVER', 1, {
                         apply_power = params.apply_power or src:combatAttack(params.weapon)})
    else
      game.logSeen(target, "%s resists!", target.name:capitalize())
    end
  end,
}

newDamageType {
  type = 'GRAYSWANDIR_KNOCKBACK',
  name = '% knockback chance',
  text_color = '#SLATE#',
  projector = function(src, x, y, type, params)
    if not src then return end -- src needed for knockback direction.
		local target = game.level.map(x, y, Map.ACTOR)
    if not target then return end

    if 'table' ~= _G.type(params) then params = {chance = params or 30} end
    if rng.percent(params.chance) and target:canBe(params.resist_type or 'knockback') then
      -- Get distance by repeatedly checking against physsave with weakening power.
      local base_power = params.power or src:combatPhysicalpower()
      local power = base_power
      local power_loss = params.power_loss or 10 + (100 / params.chance)
      local distance = 0
      while true do
        if target:checkHit(power, target:combatPhysicalResist(), 0, 95, 15) then
          distance = distance + 1
          power = power - power_loss
        else
          break
        end
      end

      -- Actually perform knockback.
      if distance > 0 then
        target:knockback(src.x, src.y, distance)
        target:crossTierEffect('EFF_OFFBALANCE', base_power)
        game.logSeen(target, '%s is knocked back!', target.name:capitalize())
      else
        game.logSeen(target, '%s resists being knocked back!', target.name:capitalize())
      end
    else
      game.logSeen(target, "%s resists being knocked back!", target.name:capitalize())
    end
  end,
}

newDamageType {
  type = 'GRAYSWANDIR_BLIND',
  name = '% blind chance',
  text_color = '#SLATE#',
  projector = function(src, x, y, type, params)
		local target = game.level.map(x, y, Map.ACTOR)
    if not target then return end

    if 'table' ~= _G.type(params) then params = {chance = params or 30} end
    if rng.percent(params.chance) and target:canBe(params.resist_type or 'blind') then
      target:setEffect('EFF_BLINDED', params.dur or 3, {
                         apply_power = params.apply_power or src:combatAttack(params.weapon)})
    else
      game.logSeen(target, "%s resists being blinded!", target.name:capitalize())
    end
  end,
}

newDamageType {
  type = 'GRAYSWANDIR_SILENCE',
  name = '% silence chance',
  text_color = '#SLATE#',
  projector = function(src, x, y, type, params)
		local target = game.level.map(x, y, Map.ACTOR)
    if not target then return end

    if 'table' ~= _G.type(params) then params = {chance = params or 30} end
    if rng.percent(params.chance) and target:canBe(params.resist_type or 'silence') then
      target:setEffect('EFF_GRAYSWANDIR_PHYSICAL_SILENCED', params.dur or 3, {
                         apply_power = params.apply_power or src:combatAttack(params.weapon)})
    else
      game.logSeen(target, "%s resists being silenced!", target.name:capitalize())
    end
  end,
}

newDamageType {
  type = 'GRAYSWANDIR_BINDING',
  name = '% bind chance',
  text_color = '#DARK_GREEN#',
	tdesc = function(dam, oldDam)
		parens = ""
		dam = dam or 0
		if 'table' == _G.type(dam) then dam = dam.chance or 30 end
		if oldDam then
			if 'table' == _G.type(oldDam) then oldDam = oldDam.chance or 30 end
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to #GREEN#bind#LAST#%s")
			:format(dam, parens)
	end,
  projector = function(src, x, y, type, params)
		local target = game.level.map(x, y, Map.ACTOR)
    if not target then return end

    if 'table' ~= _G.type(params) then params = {chance = params or 30} end
    if rng.percent(params.chance) and target:canBe(params.resist_type or 'pin') then
      target:setEffect('EFF_GRAYSWANDIR_BOUND', params.dur or 3, {
                         apply_power = params.apply_power or src:combatAttack(params.weapon)})
    else
      game.logSeen(target, "%s resists being bound!", target.name:capitalize())
    end
  end,
}
