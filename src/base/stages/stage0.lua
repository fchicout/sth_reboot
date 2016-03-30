require 'src/base/chars/sonic'

stage0 = {}

function stage0:load()
  self.world = bump.newWorld(48);
  self.map = sti.new("src/assets/img/stage-0.lua", { 'bump' });
  self.map:bump_init(self.world);
  Sonic:load(self.world);
end

function stage0:draw()
  self.map:draw();
  self.map:bump_draw(self.world);
  Sonic:draw(self.map);
end

function stage0:update(dt)
  Sonic:update(dt);
end