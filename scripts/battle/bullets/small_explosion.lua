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

local icon_textures = {
    "bullets/tesco_icons/air_frier",
    "bullets/tesco_icons/banana_icon_pixel",
    "bullets/tesco_icons/cereal_box",
    "bullets/tesco_icons/sandwich_icon",
    "bullets/tesco_icons/shop_box",
    "bullets/tesco_icons/roundel",
    "bullets/tesco_icons/fries",
    "bullets/tesco_icons/tesco_beer",
}


---@param x number
---@param y number
---@param bullet_count number
---@param bullet_speed number
function BLT:init(x, y, bullet_count, bullet_speed)
    -- Last argument = sprite path
    super.init(self, x, y)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self:setSprite("bullets/extras/kaboom/kaboom", 1/15, true)
    self.timer = Timer()
    self:addChild(self.timer)
    self.bullet_speed = bullet_speed or 10
    self.bullet_count = bullet_count or 3
    self:setScale(1,1)
end

---@param count number
function BLT:spread_bullets(count)
    if count >= 1 then
        for i = 1, count do 
            local bullet_no = rander(1, #icon_textures, 1)
            local bullet_to_spawn = icon_textures[bullet_no]
            local angle_offset = (i-1)*(360/count)
            local spawned = self.wave:spawnBullet("basic_bullet",
                self.x,
                self.y,
                math.rad(angle_offset),
                self.bullet_speed,
                bullet_to_spawn
            )
            spawned:setScale(1.6, 1.6)
        end    
    end
end

function BLT:onAdd()
    self.timer:script(function(wait)
        wait(0.05)
        self:spread_bullets(self.bullet_count)
        wait(0.05)
        self:remove()
    end)
end

function BLT:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return BLT