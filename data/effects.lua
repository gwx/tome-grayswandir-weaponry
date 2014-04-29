-- Get rid of reload effect if we turn off old style reloading.
local reloading = TemporaryEffects.tempeffect_def.EFF_RELOADING
local reloading_on_timeout = reloading.on_timeout
reloading.on_timeout = function(self, eff)
  if config.settings.tome.grayswandir_weaponry_alt_reload ~= 'normal' then
    self:breakReloading()
  else
    return reloading_on_timeout(self, eff)
  end
end



newEffect {
  name = 'GRAYSWANDIR_FALLEN_OVER',
  desc = 'Fallen Over',
  type = 'physical',
  subtype = {pin = true},
  status = 'detrimental',
  parameters = {power = 0.3},
  on_gain = function(self, eff) return '#Target# has fallen over.', 'Falls' end,
  on_lose = function(self, eff) return '#Target# stands up.', 'Stands' end,
  activate = function(self, eff)
    self:effectTemporaryValue(eff, 'never_move', 1)
    self:effectTemporaryValue(eff, 'combat_def', -1 * self:combatDefense() * eff.power)
  end,
  long_desc = function(self, eff)
    return ('The target has fallen over, immobilizing it and reducing it\'s defense by %d%%.')
      :format(eff.power * 100)
  end,
}

newEffect {
  name = 'GRAYSWANDIR_DUEL',
  desc = 'Duelist\'s Defense',
  type = 'physical',
  subtype = {stance = true, tactic = true},
  status = 'beneficial',
  parameters = {def = 3, max = 20},
	charges = function(self, eff) return eff.def end,
  on_gain = function(self, eff)
    return nil, '+Dueling'
  end,
  on_lose = function(self, eff)
    return '#Target# is no longer dueling.', '-Dueling'
  end,
  activate = function(self, eff)
    if eff.def > eff.max then eff.def = eff.max end
    self:effectTemporaryValue(eff, 'combat_def', eff.def)
    game.logSeen(self, '%s begins dueling! (%d def, %d dur)',
                 self.name:capitalize(), eff.def, eff.dur)
  end,
  on_merge = function(self, old_eff, new_eff)
    -- Remove old effects. See ActorTemporaryEffects:removeEffect and
    -- ActorTemporaryEffect:effectTemporaryValue.
		for i = 1, #old_eff.__tmpvals do
			self:removeTemporaryValue(old_eff.__tmpvals[i][1], old_eff.__tmpvals[i][2])
		end

    if old_eff.def >= new_eff.max then
      new_eff.def = old_eff.def
      game.logSeen(self, '%s continues dueling at max power! (%d def, %d dur)',
                   self.name:capitalize(), new_eff.def, new_eff.dur)
    else
      new_eff.def = math.min(old_eff.def + new_eff.def, new_eff.max)
      game.logSeen(self, '%s continues dueling! (%d def, %d dur)',
                   self.name:capitalize(), new_eff.def, new_eff.dur)
    end

    self:effectTemporaryValue(new_eff, 'combat_def', new_eff.def)
    return new_eff
  end,
  long_desc = function(self, eff)
    return ('The target is dueling, granting a +%d defense bonus.'):format(eff.def)
  end,
}

newEffect {
  name = 'GRAYSWANDIR_FLAT_FOOTED',
  desc = 'Flat Footed',
  type = 'physical',
  subtype = {stance = true},
  status = 'detrimental',
  parameters = {atk = 3, max = 20},
	charges = function(self, eff) return eff.atk end,
  on_gain = function(self, eff)
    return nil, '+Flat Footed'
  end,
  on_lose = function(self, eff)
    return '#Target# is no longer flat footed.', '-Flat Footed'
  end,
  activate = function(self, eff)
    if eff.atk > eff.max then eff.atk = eff.max end
    self:effectTemporaryValue(eff, 'combat_atk', eff.atk)
    game.logSeen(self, '%s is now flat footed! (%d atk, %d dur)',
                 self.name:capitalize(), eff.atk, eff.dur)
  end,
  on_merge = function(self, old_eff, new_eff)
    -- Remove old effects. See ActorTemporaryEffects:removeEffect and
    -- ActorTemporaryEffect:effectTemporaryValue.
		for i = 1, #old_eff.__tmpvals do
			self:removeTemporaryValue(old_eff.__tmpvals[i][1], old_eff.__tmpvals[i][2])
		end

    if old_eff.atk >= new_eff.max then
      new_eff.atk = old_eff.atk
      game.logSeen(self, '%s is completely flat footed! (%d atk, %d dur)',
                   self.name:capitalize(), new_eff.atk, new_eff.dur)
    else
      new_eff.atk = math.min(old_eff.atk + new_eff.atk, new_eff.max)
      game.logSeen(self, '%s is further flat footed! (%d atk, %d dur)',
                   self.name:capitalize(), new_eff.atk, new_eff.dur)
    end

    self:effectTemporaryValue(new_eff, 'combat_atk', new_eff.atk)
    return new_eff
  end,
  long_desc = function(self, eff)
    return ('The target is flat footed, giving a -%d accuracy penalty.'):format(eff.atk)
  end,
}

newEffect{
	name = "GRAYSWANDIR_PHYSICAL_SILENCED", image = "effects/silenced.png",
	desc = "Silenced (Physical)",
	long_desc = function(self, eff) return "The target is silenced, preventing it from casting spells and using some vocal talents." end,
	type = "physical",
	subtype = { silence=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is silenced!", "+Silenced" end,
	on_lose = function(self, err) return "#Target# is not silenced anymore.", "-Silenced" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("silence", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("silence", eff.tmpid)
	end,
}

newEffect {
	name = 'GUARDING', image = 'talents/block.png',
	desc = 'Guarding',
	long_desc = function(self, eff)
		return ('Target uses Accuracy instead of Defense if it is higher and gains %d%% critical chance reduction. Anything that misses the target in melee will be set up for a counterattack that takes half time.')
			:format(eff.crit)
	end,
	type = 'physical', subtype = {tactic = true,},
	status = 'beneficial',
	parameters = {count = 1, crit = 10, vuln_dur = 2,},
	on_gain = function(self, eff) return nil, "+Guarding" end,
	on_lose = function(self, eff) return nil, "-Guarding" end,
-- Broken, I believe. Superloaded in Combat:atackTargetWith instead.
--[[
	callbackOnMeleeMiss = function(self, eff, source, dam)
		self:setEffect('EFF_GUARD_COUNTERATTACKING', 3, {})
	end,
--]]
	activate = function(self, eff)
		self:effectTemporaryValue(eff, 'combat_melee_sub_accuracy_defense', 1)
		self:effectTemporaryValue(eff, 'ignore_direct_crits', eff.crit)
	end,}

newEffect {
	name = 'GUARD_VULNERABLE',
	desc = 'Vulnerable',
	long_desc = function(self, eff)
		local names = {}
		for source, _ in pairs(eff.src) do
			table.insert(names, source.name)
		end
		return ('You are vulnerable to counterattack from %s - they will attack you at doubled speed.')
			:format(table.concat(names, ', '))
	end,
	type = 'physical', subtype = {tactic = true,},
	status = 'detrimental',
	parameters = {count = 1},
	on_gain = function(self, eff) return nil, '+Vulnerable' end,
	on_lose = function(self, eff) return nil, '-Vulnerable' end,
	on_merge = function(self, old_eff, new_eff)
		table.merge(new_eff.src, old_eff.src)
		return new_eff
	end,
}
