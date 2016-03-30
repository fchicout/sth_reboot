bump = require 'lib/bump'
cron = require 'lib/cron'
sti = require 'lib/sti'

require 'src/base/stages/stage0'


function love.load()
  stage0:load();
end

function love.draw()
  stage0:draw();
end

function love.update(dt)
  stage0:update(dt);
end
