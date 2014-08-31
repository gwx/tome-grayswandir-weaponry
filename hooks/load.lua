local class = require 'engine.class'

local files = {'data', 'actors', 'combat', 'descriptions',
               'objects', 'chats', 'options', 'display', 'requires',}
for i, file in pairs(files) do
  dofile('hooks/grayswandir-weaponry/'..file..'.lua')
end
