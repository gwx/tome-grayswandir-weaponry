local class = require 'engine.class'

local files = {'packages', 'data', 'actors', 'combat', 'descriptions',
               'objects', 'chats', 'options', 'display',}
for i, file in pairs(files) do
  dofile('hooks/grayswandir-weaponry/'..file..'.lua')
end
