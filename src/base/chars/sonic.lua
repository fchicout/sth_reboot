Sonic = {}

function Sonic:load()
  self.state="idle";
  self.orientation = "right";
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
  self.quads["walk"]={}
  self.quads["walk"][0]=love.graphics.newQuad(420, 0, 40, 40, self.image:getDimensions());
  self.quads["walk"][1]=love.graphics.newQuad(460, 0, 40, 40, self.image:getDimensions());
  self.quads["walk"][2]=love.graphics.newQuad(500, 0, 25, 40, self.image:getDimensions());
  self.quads["walk"][3]=love.graphics.newQuad(525, 0, 30, 40, self.image:getDimensions());
  self.quads["walk"][4]=love.graphics.newQuad(555, 0, 43, 40, self.image:getDimensions());
end


function Sonic:draw()
  if self.state == "idle" then
    love.graphics.draw(self.image, self.quads["idle"][self.iteration], self.x, self.y);
  end
  if self.state == "walk" then
    if self.orientation == "right" then
      love.graphics.draw(self.image, self.quads["walk"][self.iteration], self.x, self.y);
    end
    if self.orientation == "left" then
      love.graphics.draw(self.image, self.quads["walk"][self.iteration], self.x, self.y, 0, -1, 1, self.width, 0);
    end
  end
  
  
end

function Sonic:update(dt)
  if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
    self.state = "walk";
  else
    self.state = "idle";
    self.iteration = 0;
  end
  
  
  if self.state == "idle" then
    self.animationTimer = self.animationTimer + dt;
    if (self.animationTimer > (self.idleDelay+0.2)) then
      self.animationTimer = (self.idleDelay+0.1);
      self.iteration = self.iteration+1;
      if self.iteration > table.getn(self.quads["idle"]) then
				self.iteration = 0;
        self.animationTimer = 2; --Time to wait for animation after the completion of the 1st cycle
      end
    end    
  else
    if self.state == "walk" then
      self.animationTimer = self.animationTimer + dt;
      if (self.animationTimer > 0.2) then
        self.animationTimer = 0.1;
        self.iteration=self.iteration+1;
        if (love.keyboard.isDown("right")) then
          self.x = self.x + 5;
        end
        if (love.keyboard.isDown("left")) then
          self.x = self.x - 5;
        end
        if self.iteration > table.getn(self.quads["walk"]) then
          self.iteration = 0;
          --TODO: Run animation!
        end
      end
    end
  end
  
end
