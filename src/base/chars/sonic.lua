Sonic = {}

function Sonic:load()
  self.state="idle";
  self.animationTimer= 0.1;
  self.idleDelay = 5;
  self.iteration = 0;
  self.x = 0;
  self.y = 0;
  self.width = 30;
  self.heigth = 50;
  self.image = love.graphics.newImage("src/assets/img/normal_sonic_sprites.png");
  self.quads = {};
  self.quads["idle"]={}
  for i=0,8 do
    self.quads["idle"][i]=love.graphics.newQuad(i*33, 0, 31, 40, self.image:getDimensions());
  end
  
  
end

function Sonic:draw()
  if self.state == "idle" then
    love.graphics.draw(self.image, self.quads["idle"][self.iteration], self.x, self.y);
  end
  
end

function Sonic:update(dt)
  if self.state == "idle" then
    self.animationTimer = self.animationTimer + dt;
    if (self.animationTimer > (self.idleDelay+0.2)) then
      self.animationTimer = (self.idleDelay+0.1);
      self.iteration = self.iteration+1;
      if self.iteration > table.getn(self.quads["idle"]) then
				self.iteration = 0;
        self.animationTimer = 2;
      end
    end    
  end
  
end
