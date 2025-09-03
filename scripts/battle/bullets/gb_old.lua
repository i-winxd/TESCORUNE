local GasterBlaster, super = Class(Bullet)

---@param x2 number x anchor of where it shows up
---@param y2 number y anchor of where it shows up
---@param rot number in radians, in what direction is it facing (math axis)
---@param show_time number how long it takes for the gaster blaster to show up
function GasterBlaster:init(x2, y2, rot, show_time)
    -- Last argument = sprite path
    self.pre_x = 0
    self.pre_y = 0
    self.pre_rotation = math.rad(270)
    super.init(self, self.pre_x, self.pre_y, "bullets/tesco_sprite_aa")
    self.rotation = self.pre_rotation
    self.x2 = x2
    self.y2 = y2
    self.rot2 = rot
    self.timer = Timer()
    self:addChild(self.timer) -- MUST DO THIS OR NO WORKY
    self.show_time = show_time    
end

function GasterBlaster:onAdd() 
    -- self.timer:everyInstant(0.33, function() 
    --     Kristal.Console:log("Bagging area expected unexpected");
    -- end, 2)
    Kristal.Console:log("Wave onAdd run");

    self.timer:script(function (wait) 
        self.timer:tween(self.show_time, self, {x = self.x2, y = self.y2, rotation = self.rot2}, "out-quint", function () 
            self.wave:spawnBullet("tesco_warning", 100, 100, 100)
            Kristal.Console:log("5 Tweening Complete");
        end)
        wait(1)
    end)
    
end

function GasterBlaster:update()
    -- For more complicated bullet behaviours, code here gets called every update
    super.update(self)
end

return GasterBlaster