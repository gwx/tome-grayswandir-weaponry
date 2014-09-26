-- Remove sweeping from various talents.

local talents = {
  'WINDBLADE',
	'DEATH_DANCE',
	'SWEEP',
	'WHIRLWIND',
	'FEARLESS_CLEAVE',
}

for k, name in pairs(talents) do
  local talent = Talents.talents_def['T_'..name]
  if talent then
		talent.__sweep_disabled = true
  end
end
