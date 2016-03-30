Sonic = {}

function Sonic:loadSounds()
  self.sounds["jump"] = love.audio.newSource("src/assets/sfx/sonic_jump.mp3");
end


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
  self.quads["run"]={};
  self.quads["run"][0]=love.graphics.newQuad(422, 50, 34, 38, self.image:getDimensions());
  self.quads["run"][1]=love.graphics.newQuad(455, 50, 34, 38, self.image:getDimensions());
  self.quads["run"][2]=love.graphics.newQuad(489, 50, 34, 38, self.image:getDimensions());
  self.quads["run"][3]=love.graphics.newQuad(523, 50, 34, 38, self.image:getDimensions());
end

function Sonic:loadJumpQuads()
  self.quads["jump"]={};
  self.quads["jump"][0]=love.graphics.newQuad(462, 87, 25, 46, self.image:getDimensions());
  self.quads["jump"][1]=love.graphics.newQuad(487, 102, 31, 31, self.image:getDimensions());
  self.quads["jump"][2]=love.graphics.newQuad(518, 102, 31, 31, self.image:getDimensions());
  self.quads["jump"][3]=love.graphics.newQuad(0, 144, 31, 31, self.image:getDimensions());
  self.quads["jump"][4]=love.graphics.newQuad(32, 144, 31, 31, self.image:getDimensions());
end

function Sonic:loadCrouchQuads()
  self.quads["crouch"]={}
  -- This first (quads["crouch"][0]) may be used to refine the movement.
  self.quads["crouch"][0]=love.graphics.newQuad(365, 4, 27, 46, self.image:getDimensions());
  self.quads["crouch"][1]=love.graphics.newQuad(392, 4, 28, 46, self.image:getDimensions());
end


function Sonic:load(world)
  self.debug=true;
  self.state="idle";
  self.orientation = "right";
  self.animationTimer= 0.1;
  self.idleDelay = 5;
  self.iteration = 0;
  self.x = 0;
  self.y = 400;
  self.vy = 0;
  self.gravity = 400;
  self.jump_height = 300;
  self.width = 30;
  self.heigth = 50;
  self.image = love.graphics.newImage("src/assets/img/normal_sonic_sprites.png");
  
  world:add(self, self.x, self.y, self.width, self.heigth);
  
  
  self:loadIdleQuads();

  self:loadWalkQuads();

  self:loadJumpQuads();

  self:loadCrouchQuads();

  self.sounds= {};
  self:loadSounds();
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

  if self.vy == 0  and (love.keyboard.isDown("d") or love.keyboard.isDown("D") ) then
    self.state = "jump";
    love.audio.play(self.sounds["jump"]);
    self.vy = self.jump_height;
    return;
  end
  if self.vy ~= 0 then 
    self.y = self.y - self.vy*dt;
    self.vy = self.vy - self.gravity*dt;
    
    self.iteration = self.iteration+1;
    if self.orientation == "left" then  
      self.x = self.x - 3;
    elseif self.orientation == "right" then
      self.x = self.x + 3;
    end
    if self.y < 0 then
      self.vy = 0;
      self.y = 0;
    end
    if (self.iteration > table.getn(self.quads["jump"])) then
      self.iteration = 1;
      self.idleTimer = 7; --Time to wait for animation after the completion of the 1st cycle
    end
  elseif love.keyboard.isDown("left") then
    -- Walk left
    self.state = "walk";
    self.orientation = "left";
  elseif love.keyboard.isDown("right") then
    -- Walk right
    self.state = "walk";
    self.orientation = "right";
  elseif love.keyboard.isDown("down") then
    -- Crouch
    self.state = "crouch";
  else 
    -- Stay idle
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
        if (self.iteration == table.getn(self.quads[self.state])) then
          self.state = "run";
        end
      end
      if (love.keyboard.isDown("left")) then
        self.x = self.x - 7;
        if (self.iteration == table.getn(self.quads[self.state])) then
          self.state = "run"
        end
      end

    end
  elseif self.state == "crouch" then
    self.animationTimer = self.animationTimer + dt;
    self.iteration = 1;
  elseif self.state == "run" then
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
      if self.iteration > table.getn(self.quads[self.state]) then
        self.iteration = 0;
        self.animationTime = 0.2; --TODO: Develop animation of sonic running!
      end
    end
  end
end
