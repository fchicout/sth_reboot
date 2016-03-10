require 'src/base/chars/sonic'

function love.load()
  Sonic:load();
end

function love.draw()
  Sonic:draw();
end

function love.update(dt)
  Sonic:update(dt)
end
