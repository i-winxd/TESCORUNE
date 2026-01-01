local BLT, super = Class(Bullet)
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
---@param x number
---@param y number
---@param dir number
---@param speed number
---@param rot_vel number OPTIONAL rotational velocity
function BLT:init(x, y, dir, speed, texture, gravity, rot_vel, fuse, frags, frag_speed)
    texture = texture or "bullets/tesco_icons/banana_icon"
    -- Last argument = sprite path
    super.init(self, x, y, texture)
    self.physics.direction = math.rad(dir)
    self.physics.speed = speed
    self.physics.gravity = gravity or 10
    self.scale_x = 1
    self.scale_y = 1
    self.remove_offscreen = false
    self.rot_vel = rot_vel or 0
    self.fuse = fuse or 1
    self.timer = Timer()
    self.frags = frags
    self.frag_speed = frag_speed
    self.remove_offscreen = false
    self:addChild(self.timer)
end

function BLT:onAdd(parent)
    self.timer:script(function(wait) 
        wait(self.fuse)
        self.wave:spawnBullet("small_explosion", self.x, self.y, self.frags, self.frag_speed)
        Assets.playSound("snd_bomb", 0.6*rander(0.85,1), 2^(rander(-2, 2)/12))
        self:remove()
    end)
end

function BLT:update()
    -- For more complicated bullet behaviours, code here gets called every update
    if self.rot_vel ~= 0 then
        self.rotation = self.rotation + (math.rad(self.rot_vel) * DT)
    end
    if self.y > SCREEN_HEIGHT + 100 then
        self:remove()
    end
    super.update(self)
end


function BLT:onCollide(soul)
    -- grenades are intangible
end

return BLT