local BloonSeeker, super = Class(BloonBase, "BloonSeeker")
local function rander(a, b, c)
    local function roundToMultiple(value, to)
        if to == 0 then
            return 0
        end

        return math.floor((value + (to / 2)) / to) * to
    end

    if not a then
        return love.math.random()
    elseif not b then
        return love.math.random() * a
    else
        local n = love.math.random() * (b - a) + a
        if c then
            n = roundToMultiple(n, c)
        end
        return n
    end
end
function BloonSeeker:init(x, y, bloon_type, health, recoil)
    -- print("SPAWNING BLOONSEEKER: " .. bloon_type)
    self.object_path = "BloonSeeker"
    super.init(self, x, y, bloon_type, health)
    local velo = self:getSpeed() / 4
    self.base_speed = velo
    self.physics.speed = velo / 4
    self.object_path = "BloonSeeker"
    self.recoil = recoil or 0
    self.timer = Timer()
    self:addChild(self.timer)
end

function BloonSeeker:onAdd()
    self.timer:tween(rander(0.2, 0.7), self.physics, {speed = self.base_speed}, "in-quad")
    super.onAdd(self)
end

function BloonSeeker:update()
    ---@type number
    super.update(self)
    local soul = Game.battle.soul
    if soul ~= nil then 
        local sx, sy = soul.x, soul.y
        -- this is in radians~
        local angle = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.physics.direction = angle
    end
    
end


return BloonSeeker
