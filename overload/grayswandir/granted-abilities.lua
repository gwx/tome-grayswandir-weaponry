local hook = function(self, data)
	local class = require 'engine.class'
	local actor = require 'mod.class.Actor'
	local object = require 'mod.class.Object'

	local _M = {}

	----------------------------------------------------------------
	-- Actor Interface

	_M.granted_ability_defs = {}

	function _M:define_granted_ability(t)
		if type(t) ~= 'table' then t = {t} end
		if not t.id then t.id = t[1] end
		assert(t.id, 'Granted Ability: No id.')
		t.is_granted_ability = true
		_M.granted_ability_defs[t.id] = t
		return t
	end

	function _M:get_granted_ability_def(ability_id, no_define)
		if type(ability_id) == 'table' and ability_id.is_granted_ability then
			return ability_id
		end
		local ability = _M.granted_ability_defs[ability_id]
		if not ability and not no_define then
			ability = self:define_granted_ability(ability_id)
		end
		return ability
	end

	function _M:knows_granted_ability(ability_id)
		return next(table.get(self, 'granted_ability_sources', ability_id) or {})
	end

	function _M:grant_ability(ability_id, source)
		local ability = self:get_granted_ability_def(ability_id)
		assert(ability, 'Granted Ability: Unknown id')
		if not self:knows_granted_ability(ability_id) then
			for _, x in ipairs(ability) do
				if type(x) == 'string' and x:sub(1, 2) == 'T_' then
					self:learnTalent(x, true)
					self:startTalentCooldown(x)
				end
			end
		end
		table.set(self, 'granted_ability_sources', ability_id, source, true)
	end

	function _M:ungrant_ability(ability_id, source)
		if not self:knows_granted_ability(ability_id) then return end

		local ability = self:get_granted_ability_def(ability_id)
		assert(ability, 'Granted Ability: Unknown id')
		local sources = table.get(self, 'granted_ability_sources', ability_id)
		sources[source] = nil
		if not self:knows_granted_ability(ability_id) then
			for _, x in ipairs(ability) do
				if type(x) == 'string' and x:sub(1, 2) == 'T_' then
					self:unlearnTalent(x)
				end
			end
		end
	end

	function _M:granted_ability_name(ability)
		ability = self:get_granted_ability_def(ability)
		if ability.name then return name end
		local first = ability[1]
		if not first then return 'Unknown Ability' end
		if type(first) == 'string' and first:sub(1, 2) == 'T_' then
			return ('[%s] Talent'):format(self:getTalentFromId(first).name)
		end
		return 'Unknown Ability'
	end

	actor:importInterface(_M)
	object:importInterface(table.clone(_M))

	----------------------------------------------------------------
	-- Actor Superloads

	local actor_onWear = actor.onWear
	actor.onWear = function(self, o, inven_id, bypass_set)
		local granted_abilities = o.granted_abilities
		if granted_abilities then
			for ability_id, value in pairs(granted_abilities) do
				if value then self:grant_ability(ability_id, o) end
			end
		end

		return actor_onWear(self, o, inven_id, bypass_set)
	end

	local actor_onTakeoff = actor.onTakeoff
	actor.onTakeoff = function(self, o, inven_id, bypass_set)
		local granted_abilities = o.granted_abilities
		if granted_abilities then
			for ability_id, value in pairs(granted_abilities) do
				if value then self:ungrant_ability(ability_id, o) end
			end
		end

		return actor_onTakeoff(self, o, inven_id, bypass_set)
	end

	----------------------------------------------------------------
	-- Object Hooks

	hook = function(self, data)
		local granted_abilities = data.object.granted_abilities
		--local compare = table.get(data, 'compare_with', 1, 'granted_abilities')
		if granted_abilities then
			for ability_id, value in pairs(granted_abilities) do
				if value then
					data.desc:add({'color', 'WHITE',}, '* Grants ', {'color', 'ORANGE',},
												self:granted_ability_name(ability_id), {'color', 'WHITE'}, true)
				end
			end
		end
	end
	class:bindHook('Object:descMisc', hook)

	----------------------------------------------------------------
end
class:bindHook('ToME:load', hook)
