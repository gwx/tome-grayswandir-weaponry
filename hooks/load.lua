-- Make grayswandir.lua findable
package.preload.grayswandir = loadfile '/data-grayswandir-weaponry/grayswandir.lua'

local class = require 'engine.class'

local files = {'data', 'actors', 'combat', 'descriptions',
               'objects', 'chats', 'options', 'display',}
for i, file in pairs(files) do
  dofile('hooks/grayswandir-weaponry/'..file..'.lua')
end
