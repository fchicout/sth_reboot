Sonic = {}

function Sonic:loadIdleQuads()
  self.quads = {};
  self.quads["idle"]={}
  for i=0,8 do
    self.quads["idle"][i]=love.graphics.newQuad(i*33, 0, 31, 40, self.image:getDimensions());
  end
end

function Sonic:loadWalkQuads()
  self.quads["walk"]={};
  self.quads["walk"][0]=love.graphics.newQuad(420, 0, 40, 40, self.image:getDimensions());
  self.quads["walk"][1]=love.graphics.newQuad(460, 0, 40, 40, self.image:getDimensions());
  self.quads["walk"][2]=love.graphics.newQuad(500, 0, 25, 40, self.image:getDimensions());
  self.quads["walk"][3]=love.graphics.newQuad(525, 0, 30, 40, self.image:getDimensions());
  self.quads["walk"][4]=love.graphics.newQuad(555, 0, 43, 40, self.image:getDimensions());
end


function Sonic:loadRunQuads()
  -- TODO: load the quads of a sonic run
  self.quads["run"]={};
  self.quads["run"][0]=love.graphics.newQuad(555, 0, 43, 46, self.image:getDimensions());
end

function Sonic:loadJumpQuads()
  -- TODO: load the quads of a jump
  self.quads["jump"]={};
  self.quads["jump"][0]=love.graphics.newQuad(462, 87, 25, 46, self.image:getDimensions());
  self.quads["jump"][1]=love.graphics.newQuad(487, 102, 31, 31, self.image:getDimensions());
  self.quads["jump"][2]=love.graphics.newQuad(518, 102, 31, 31, self.image:getDimensions());
  self.quads["jump"][3]=love.graphics.newQuad(0, 144, 31, 31, self.image:getDimensions());
  self.quads["jump"][4]=love.graphics.newQuad(32, 144, 31, 31, self.image:getDimensions());
end

function Sonic:loadCrouchQuads()
  self.quads["crouch"]={}
  self.quads["crouch"][0]=love.graphics.newQuad(365, 4, 27, 46, self.image:getDimensions());
  self.quads["crouch"][1]=love.graphics.newQuad(392, 4, 28, 46, self.image:getDimensions());
end


function Sonic:load()
  self.debug=true;
  self.state="idle";
  self.orientation = "right";
  self.animationTimer= 0.1;
  self.idleDelay = 5;
  self.iteration = 0;
  self.x = 0;
  self.y = 0;
  self.vy = 0;
  self.gravity = 400;
  self.jump_height = 300;
  self.width = 30;
  self.heigth = 50;
  self.image = love.graphics.newImage("src/assets/img/normal_sonic_sprites.png");

  self:loadIdleQuads();

  self:loadWalkQuads();

  self:loadJumpQuads();

  self:loadCrouchQuads();
end


function Sonic:draw()

  if self.orientation == "right" then
    love.graphics.draw(self.image, self.quads[self.state][self.iteration], self.x, self.y);
  elseif self.orientation == "left" then
    love.graphics.draw(self.image, self.quads[self.state][self.iteration], self.x, self.y, 0, -1, 1, self.width, 0);
  end



  if self.debug == true then
    love.graphics.print(self.state, 100, 100)
    love.graphics.print(self.orientation, 100, 120)
    love.graphics.print(self.animationTimer, 100, 140)
  end


end

function Sonic:update(dt)
  if love.keyboard.isDown("left") then
    self.state = "walk";
    self.orientation = "left";
  elseif love.keyboard.isDown("right") then
    self.state = "walk";
    self.orientation = "right";
  elseif love.keyboard.isDown("d") or love.keyboard.isDown("D") then
    self.state = "jump";
  elseif love.keyboard.isDown("down") then
    self.state = "crouch";
  else 
    self.state = "idle";
  end

  if self.state == "idle" then
    self.animationTimer = self.animationTimer + dt;
    if (self.animationTimer > (self.idleDelay + 0.2)) then
      self.animationTimer = self.idleDelay + 0.01;
      self.iteration = self.iteration + 1;
      if (self.iteration > table.getn(self.quads["idle"])) then
        self.iteration = 0;
        self.idleTimer = 7; --Time to wait for animation after the completion of the 1st cycle
      end
    end
  elseif self.state == "walk" then
    self.animationTimer = self.animationTimer + dt;
    if (self.animationTimer > 0.2) then
      self.animationTimer = 0.1;
      self.iteration=self.iteration+1;
      if (love.keyboard.isDown("right")) then
        self.x = self.x + 7;
      end
      if (love.keyboard.isDown("left")) then
        self.x = self.x - 7;
      end
      if self.iteration > table.getn(self.quads["walk"]) then
        self.iteration = 0;
        --TODO: Develop animation of sonic running!
      end
    end
  elseif self.state == "crouch" then
    self.animationTimer = self.animationTimer + dt;
    self.iteration = 1;
  end
end

-- TODO: Jump is complex. Needs to activate over walking (no matter if its right or left),

--  elseif self.state == "jump" then
--    self.animationTimer = self.animationTimer + dt;
--    if (self.animationTimer > 0.2) then
--      self.animationTimer = 0.1;
--      self.iteration=self.iteration+1;
--      self.y = self.y + self.vy*dt;
--      self.vy = self.vy - self.gravity*dt;
--      if self.iteration > table.getn(self.quads["jump"]) then
--        self.iteration = 1;
--        --TODO: Develop animation of sonic running!
--      end
--    end
--  end
--end