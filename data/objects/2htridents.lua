if config.settings.tome.grayswandir_weaponry_tridents ~= false then

  local base = loading_list.BASE_TRIDENT
  base.rarity = 8
  base.exotic = true
  base.egos = '/data-grayswandir-weaponry/egos/2htridents.lua'

  for i, v in ipairs(loading_list) do
    if v.subtype == 'trident' and not v.unique then
      v.rarity = 8
      v.exotic = true
      v.egos = '/data-grayswandir-weaponry/egos/2htridents.lua'
    end
  end

end
